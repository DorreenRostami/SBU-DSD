--group 17
--Dorreen Rostami - 97243034
--Shahriar Morabi - 97243064
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY UART IS
    PORT(
        clk         : IN  std_logic;
		nrst        : IN  std_logic;
		start       : IN  std_logic;
		data_in     : IN  std_logic_vector(7 DOWNTO 0);
        rx          : IN  std_logic;
		baud        : IN  std_logic_vector(7 DOWNTO 0);
        tx          : OUT  std_logic;
		data_out    : OUT  std_logic_vector(7 DOWNTO 0);
		data_ready  : OUT  std_logic
        
    );
END UART;

ARCHITECTURE T0 of UART IS
	TYPE state IS(idle, P2S, S2P);
	SIGNAL curr_state 	: state := idle;
	SIGNAL baud_counter : std_logic_vector(7 DOWNTO 0);
	SIGNAL bit_counter 	: INTEGER := 0;

	--signals for s2p
	SIGNAL parity_in 	: std_logic;
BEGIN 
	PROCESS(nrst, clk)
	BEGIN 
		IF nrst = '0' THEN 
			tx <= '1';
			data_ready <= '0';
			data_out <= "00000000";
			curr_state <= idle;
		ELSIF RISING_EDGE(clk) THEN
			IF curr_state = idle THEN
				tx <= '1';
				data_ready <= '0';
				IF start = '1' THEN
					baud_counter <= baud - 1;
					tx <= '0';
					curr_state <= P2S;
					bit_counter <= 0;
				ELSIF rx = '0' THEN
					baud_counter <= baud - 1;
					curr_state <= S2P;
					bit_counter <= 0;
					data_out <= "00000000";
				END IF;

			ELSIF curr_state = P2S THEN
				IF baud_counter = "00000000" THEN
					IF bit_counter = 8 THEN --baud 9om: parity tolid o ersal shavad
						tx <= XOR data_in; --parity (compiler needs to be 2008)
						bit_counter <= bit_counter + 1;
					ELSIF bit_counter = 9 THEN
						bit_counter <= bit_counter + 1;
					ELSIF bit_counter = 10 THEN --baud 11om: check rx
						IF rx = '0' THEN
							tx <= '0';
							bit_counter <= 0;
						ELSE
							curr_state <= idle;
						END IF;
					ELSE
						tx <= data_in(bit_counter);
						bit_counter <= bit_counter + 1;
					END IF;
					baud_counter <= baud - 1;
				ELSE 
					baud_counter <= baud_counter - 1;
				END IF;

			ELSE --S2P
				IF baud_counter = "00000000" THEN
					IF bit_counter = 8 THEN --baud 9om: parity daryaft shavad
						parity_in <= rx;
						bit_counter <= bit_counter + 1;
					ELSIF bit_counter = 9 THEN
						bit_counter <= bit_counter + 1;
					ELSIF bit_counter = 10 THEN --baud 11om: khode girande parity ra mohasebe konad
						IF parity_in /= XOR data_out THEN
							tx <= '0';
						ELSE 
							data_ready <= '1';
						END IF;
							curr_state <= idle;
					ELSE 
						data_out(bit_counter) <= rx;
						bit_counter <= bit_counter + 1;
					END IF;
					baud_counter <= baud - 1;
				ELSE 
					baud_counter <= baud_counter - 1;
				END IF;
			END IF;

		END IF;
	END PROCESS;
END T0;