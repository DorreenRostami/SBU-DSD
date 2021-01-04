--group 17
--Dorreen Rostami - 97243034
--Shahriar Morabi - 97243064
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY UART_tb IS
END UART_tb;

ARCHITECTURE test of UART_tb IS
    COMPONENT UART IS
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
    END COMPONENT;
    SIGNAL clk_t        : std_logic := '1';
    SIGNAL nrst_t       : std_logic;     
    SIGNAL start_t      : std_logic;    
    SIGNAL data_in_t    : std_logic_vector(7 DOWNTO 0);   
    SIGNAL rx_t         : std_logic;          
    SIGNAL baud_t       : std_logic_vector(7 DOWNTO 0);       
    SIGNAL tx_t         : std_logic;        
    SIGNAL data_out_t   : std_logic_vector(7 DOWNTO 0);   
    SIGNAL data_ready_t : std_logic;  
BEGIN 
    UUT : UART PORT MAP(clk_t, nrst_t, start_t, data_in_t, rx_t, baud_t, tx_t, data_out_t, data_ready_t);

    nrst_t      <= '0' , '1' AFTER 18 ns;
    clk_t       <= NOT clk_t AFTER 5 ns;
    start_t     <= '1' AFTER 22 ns, '0' AFTER 32 ns;
    data_in_t   <= "00100011";
    baud_t      <= "00000010";
    --                                                       start s2p         bit 0              bit 1             bit 2             bit 3             bit 4             bit 5             bit 6 & 7        parity (ok = 1)
    rx_t        <= '1', '0' AFTER 236 ns, '1' AFTER 256 ns, '0' AFTER 486 ns, '1' AFTER 506 ns, '0' AFTER 526 ns, '1' AFTER 546 ns, '0' AFTER 566 ns, '1' AFTER 586 ns, '0' AFTER 606 ns, '1' AFTER 626 ns, '0' AFTER 666 ns, '1' AFTER 686 ns;
END test;