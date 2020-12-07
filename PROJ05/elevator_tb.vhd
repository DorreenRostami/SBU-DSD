--group 17
--Dorreen Rostami - 97243034
--Shahriar Morabi - 97243064
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY elevator_tb IS 
END elevator_tb;

ARCHITECTURE test of elevator_tb IS 
    COMPONENT elevator IS
		PORT(
			clk        : IN  std_logic;
			nrst       : IN  std_logic;
			come       : IN  std_logic_vector(3 DOWNTO 0);
			go         : IN  std_logic_vector(3 DOWNTO 0);
			switch     : IN  std_logic_vector(3 DOWNTO 0);
			motor_up   : OUT std_logic;
			motor_down : OUT std_logic;
			curr_floor : OUT std_logic_vector(1 DOWNTO 0):= "00";
			move_state : OUT std_logic_vector(1 DOWNTO 0) -- 00: still, 01: up, 10: down
		);
END COMPONENT;
	SIGNAL clk_t        :  std_logic := '1';
	SIGNAL nrst_t       :  std_logic;
	SIGNAL come_t       :  std_logic_vector(3 DOWNTO 0);
	SIGNAL go_t         :  std_logic_vector(3 DOWNTO 0);
	SIGNAL switch_t     :  std_logic_vector(3 DOWNTO 0);
	SIGNAL motor_up_t   :  std_logic;
	SIGNAL motor_down_t :  std_logic;
	SIGNAL curr_floor_t :  std_logic_vector(1 DOWNTO 0);
	SIGNAL move_state_t :  std_logic_vector(1 DOWNTO 0);
BEGIN 

	UUT : elevator PORT MAP(clk_t, nrst_t, come_t, go_t, switch_t, motor_up_t, motor_down_t, curr_floor_t, move_state_t);

	nrst_t     <= '0' , '1' AFTER 2 ns;
	clk_t      <= NOT clk_t AFTER 2 ns; 
	go_t       <= "0000", "0100" AFTER 20 ns, "0000" AFTER 24 ns, "0010" AFTER 30 ns, "0000" AFTER 34 ns;
	come_t     <= "0000", "0001" AFTER 3 ns, "0000" AFTER 7 ns, "0010" AFTER 10 ns, "0000" AFTER 14 ns, "0100" AFTER 48 ns, "0000" AFTER 52 ns, "0001" AFTER 85 ns, "0000" AFTER 89 ns;
	switch_t   <= "0010", "0000" AFTER 4 ns, "0001" AFTER 20 ns, "0000" AFTER 24 ns, "0010" AFTER 48 ns, "0000" AFTER 52 ns, "0100" AFTER 70 ns, "0000" AFTER 86 ns, "0001" AFTER 115 ns;

END test;


-- start: 1
-- 0 3ns
-- 1 10ns
-- 2 20ns
-- 1 30ns
-- 2 48ns
-- 0 85ns