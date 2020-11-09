LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY universal_counter IS 
Port (
	nrst	: IN  std_logic;
	clk		: IN  std_logic;
	mode	: IN  integer RANGE 0 TO 7;
	din		: IN  std_logic_vector(7 DOWNTO 0);
	dout	: OUT std_logic_vector(7 DOWNTO 0)
	);
END universal_counter;

ARCHITECTURE behavioral OF universal_counter IS
	SIGNAL temp : std_logic_vector(7 DOWNTO 0);
BEGIN
	PROCESS(clk)
	BEGIN
		IF clk = '1' THEN
			IF nrst = '0' THEN
				temp <= (OTHERS => '0');
			ELSE
				IF mode = 0 THEN						-- register (parallel load)
					temp <= din;
				ELSIF mode = 1 THEN 					-- logical right shift
					temp <= '0' & temp(7 DOWNTO 1);
				ELSIF mode = 2 THEN 					-- logical left shift
					temp <= temp(6 DOWNTO 0) & '0';
				ELSIF mode = 3 THEN 					-- arith right shift
					temp <= temp(7) & temp(7 DOWNTO 1);
				ELSIF mode = 4 THEN 					-- circular right shift
					temp <= temp(0) & temp(7 DOWNTO 1);
				ELSIF mode = 5 THEN 					-- circular left shift
					temp <= temp(6 DOWNTO 0) & temp(7);
				ELSIF mode = 6 THEN 					-- up count
					temp <= temp + '1';
				ELSE									-- down count
					temp <= temp - '1';
				END IF;
			END IF;
		END IF;
	END PROCESS;
	dout <= temp;
END behavioral;