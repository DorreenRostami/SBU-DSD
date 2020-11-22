--group 17
--Dorreen Rostami - 97243034
--Shahriar Morabi - 97243064
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY bshifter_tb IS
END bshifter_tb;
ARCHITECTURE test OF bshifter_tb IS 
	COMPONENT bshifter IS
    PORT(
		clk			: IN std_logic;
        nrst	    : IN std_logic;
        sham        : IN std_logic_vector(4 DOWNTO 0);
        shty        : IN std_logic_vector(1 DOWNTO 0);
        dir         : IN std_logic;
        din         : IN std_logic_vector(31 DOWNTO 0);
        sin         : IN std_logic;
        dout	    : OUT std_logic_vector(31 DOWNTO 0);
        sout        : OUT std_logic
    );
    END COMPONENT;
    SIGNAL clk_t        : std_logic := '0';
    SIGNAL nrst_t	    : std_logic;
    SIGNAL sham_t       : std_logic_vector(4 DOWNTO 0);
    SIGNAL shty_t       : std_logic_vector(1 DOWNTO 0);
    SIGNAL dir_t        : std_logic;
    SIGNAL din_t        : std_logic_vector(31 DOWNTO 0);
    SIGNAL sin_t        : std_logic;
    SIGNAL dout_t	    : std_logic_vector(31 DOWNTO 0);
    SIGNAL sout_t       : std_logic;
	
BEGIN
	-------------------------
	--  CUT I nstantiation
	-------------------------
	CUT: bshifter PORT MAP (clk_t,nrst_t,sham_t,shty_t,dir_t,din_t,sin_t,dout_t,sout_t); -- Entity I nstantiation
	
	------------------------------
	--  Input Stimuli Assignment 
    ------------------------------
    clk_t <= NOT clk_t AFTER 2 ns;
    nrst_t <= '0', '1' AFTER 4 ns;
    shty_t <= "11", "00" AFTER 8 ns, "11" AFTER 20 ns, "01" AFTER 24 ns, "10" AFTER 28 ns;
    dir_t <= '0', '1' AFTER 12 ns, '0' AFTER 35 ns;
    sham_t <= "00001", "11111" AFTER 16 ns, "10000" AFTER 20 ns, "00010" AFTER 28 ns;
    sin_t <= '0', '1' AFTER 15 ns, '0' AFTER 20 ns;
    din_t <= "11111111111111101111111111111111";
    
END test;
