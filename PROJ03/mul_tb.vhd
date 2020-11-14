--Dorreen Rostami - 97243034
--Shahriar Morabi - 97243064
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mul_tb IS
END mul_tb;
ARCHITECTURE test OF mul_tb IS 
	COMPONENT mul IS
		GENERIC(
			n : INTEGER := 4
		);
		PORT(
			Yi			: IN std_logic_vector(n-1 DOWNTO 0);
			Xi			: IN std_logic_vector(n-1 DOWNTO 0);
			Zo			: OUT std_logic_vector(2*n-1 DOWNTO 0)
		);
	END COMPONENT;
	SIGNAL Y_t		: std_logic_vector(3 DOWNTO 0);
	SIGNAL X_t		: std_logic_vector(3 DOWNTO 0);
	SIGNAL Z_t		: std_logic_vector(7 DOWNTO 0);
	
BEGIN
	-------------------------
	--  CUT Instantiation
	-------------------------
	CUT: mul 	GENERIC MAP (4) 
				PORT MAP (X_t, Y_t, Z_t); -- Entity Instantiation
	
	------------------------------
	--  Input Stimuli Assignment
	------------------------------
    
    X_t <= "0001", "0000" AFTER 20 ns, "1111" AFTER 30 ns;
    Y_t <= "0001", "0010" AFTER 10 ns, "1111" AFTER 30 ns;
END test;
