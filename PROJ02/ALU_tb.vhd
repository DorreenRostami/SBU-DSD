LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY ALU_tb IS
END ALU_tb;
ARCHITECTURE test OF ALU_tb IS 
	COMPONENT ALU IS
		GENERIC (
			data_wid : integer := 32
		);
		PORT(
		A			: IN std_logic_vector(data_wid-1 DOWNTO 0);
        B			: IN std_logic_vector(data_wid-1 DOWNTO 0);
        cin         : IN std_logic;
		sin         : IN std_logic;
        funct		: IN std_logic_vector(3 DOWNTO 0);
        Z			: OUT std_logic_vector(data_wid-1 DOWNTO 0);
        cout        : OUT std_logic;
        sout        : OUT std_logic;
        Ov          : OUT std_logic
	);
	END COMPONENT;
	SIGNAL A_t		: std_logic_vector(3 DOWNTO 0);
	SIGNAL B_t		: std_logic_vector(3 DOWNTO 0);
	SIGNAL cin_t	: std_logic;
	SIGNAL sin_t	: std_logic;
	SIGNAL funct_t	: std_logic_vector(3 DOWNTO 0);
	SIGNAL Z_t 		: std_logic_vector(3 DOWNTO 0);
	SIGNAL cout_t	: std_logic;
	SIGNAL sout_t	: std_logic;
	SIGNAL Ov_t 	: std_logic;
	
BEGIN
	-------------------------
	--  CUT Instantiation
	-------------------------
	CUT: ALU 	GENERIC MAP (4) 
				PORT MAP (A_t, B_t, cin_t, sin_t, funct_t, Z_t, cout_t, sout_t, Ov_t); -- Entity Instantiation
	
	------------------------------
	--  Input Stimuli Assignment
	------------------------------
	
	--test order (every 5ns) starting at 0: add+Ov, add+cout, add, -B, add+cin, sub, 2's comp B, ~B, 
	-- at 40ns: and, or, xor, lls, lls+sin=1, lrs, cls, crs, (3 last rows output:) Z=1,0,0,1,0,1
	
	
	
		-- Ov 		cout 
	A_t <= "0111", "1111" AFTER 5 ns, "0010" AFTER 10 ns, "0010" AFTER 85 ns, "0001" AFTER 95 ns, "0001" AFTER 105 ns;
	
	B_t <= "0010", 					  "0100" AFTER 10 ns, "0001" AFTER 85 ns, "0010" AFTER 95 ns, "0001" AFTER 105 ns;
	
	cin_t <= '1';
				--to input '1' in lls
	sin_t <= '0', '1' AFTER 60 ns, '0' AFTER 65 ns;
	
	funct_t <= "0001", "0000" AFTER 15 ns, "0010" AFTER 20 ns, "0011" AFTER 25 ns, "0100" AFTER 30 ns, 
				"0101" AFTER 35 ns, "0110" AFTER 40 ns, "0111" AFTER 45 ns, "1000" AFTER 50 ns, 
				"1001" AFTER 55 ns, "1010" AFTER 65 ns, "1011" AFTER 70 ns, "1100" AFTER 75 ns, 
				"1101" AFTER 80 ns, "1110" AFTER 90 ns, "1111" AFTER 100 ns;
END test;
