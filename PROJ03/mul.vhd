--Dorreen Rostami - 97243034
--Shahriar Morabi - 97243064
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY FA IS
	PORT(
		A			: IN std_logic;
        B			: IN std_logic;
        ci          : IN std_logic;
        sum			: OUT std_logic;
        co          : OUT std_logic
	);
END FA;
ARCHITECTURE behavioral OF FA IS
    SIGNAL W1 : std_logic;
    SIGNAL W2 : std_logic;
    SIGNAL W3 : std_logic;
BEGIN
    W1 <= A xor B;
    W2 <= W1 and ci;
    W3 <= A and B;
    sum <= W1 xor ci;
    co <= W2 or W3;
END behavioral;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY block1 IS
    PORT(
        A1			: IN std_logic;
        B1			: IN std_logic;
        C1			: IN std_logic;
        cin1        : IN std_logic;
        Z1			: OUT std_logic;
        cout1       : OUT std_logic
    );
END block1;
ARCHITECTURE behavioral OF block1 IS
    COMPONENT FA IS
    PORT(
		A			: IN std_logic;
        B			: IN std_logic;
        ci          : IN std_logic;
        sum			: OUT std_logic;
        co          : OUT std_logic
	);
    END COMPONENT;
    SIGNAL and1 : std_logic;
BEGIN
    and1 <= A1 AND B1;
    u1 : FA PORT MAP (C1, and1, cin1, Z1, cout1);
END behavioral;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY blockn IS
    GENERIC(
        n : INTEGER := 4
    );
    PORT(
        Y			: IN std_logic;
        X			: IN std_logic_vector(n-1 DOWNTO 0);
        W			: IN std_logic_vector(n-1 DOWNTO 0);
        Z			: OUT std_logic_vector(n DOWNTO 0)
    );
END blockn;
ARCHITECTURE behavioral OF blockn IS
    COMPONENT block1 IS
    PORT(
        A1			: IN std_logic;
        B1			: IN std_logic;
        C1			: IN std_logic;
        cin1        : IN std_logic;
        Z1			: OUT std_logic;
        cout1       : OUT std_logic
    );
    END COMPONENT;
    SIGNAL Cs : std_logic_vector(n DOWNTO 0) := (OTHERS => '0');
BEGIN
    gen: FOR i IN 0 TO n-1 GENERATE
        b1 : block1 PORT MAP (X(i), Y, W(i), Cs(i), Z(i), Cs(i+1));
    END GENERATE gen;
    Z(n) <= Cs(n);
END behavioral;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY mul is
    GENERIC(
        n : INTEGER := 4
    );
    PORT(
        Yi			: IN std_logic_vector(n-1 DOWNTO 0);
        Xi			: IN std_logic_vector(n-1 DOWNTO 0);
        Zo			: OUT std_logic_vector(2*n-1 DOWNTO 0)
    );
END mul;

ARCHITECTURE behavioral OF mul is
    COMPONENT blockn IS
    GENERIC(
        n : INTEGER := 4
    );
    PORT(
        Y			: IN std_logic;
        X			: IN std_logic_vector(n-1 DOWNTO 0);
        W			: IN std_logic_vector(n-1 DOWNTO 0);
        Z			: OUT std_logic_vector(n DOWNTO 0)
    );
    END COMPONENT;
    TYPE r_type IS ARRAY (n DOWNTO 0) OF std_logic_vector(n DOWNTO 0);
    SIGNAL rows : r_type;
    SIGNAL Y0 : std_logic_vector(n DOWNTO 0);
BEGIN
    Y0 <= (OTHERS => Yi(0));
    rows(0) <= '0' & Xi;
    rows(1) <= Y0 AND rows(0);
    Zo(0) <= rows(1)(0);

    L1: FOR i IN 1 TO n-1 GENERATE
        mul : blockn GENERIC MAP(n) PORT MAP(Yi(i), Xi, rows(i)(n DOWNTO 1), rows(i+1));
        Zo(i) <= rows(i+1)(0);
    END GENERATE L1;
    
    Zo(2*n-1 DOWNTO n) <= rows(n)(n DOWNTO 1);
END behavioral;