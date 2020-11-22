--group 17
--Dorreen Rostami - 97243034
--Shahriar Morabi - 97243064
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
package bus_multiplexer_pkg is
    type ARR2 IS ARRAY(INTEGER RANGE <>) of std_logic_vector(31 DOWNTO 0);
end package;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.STD_LOGIC_ARITH.ALL;
USE work.bus_multiplexer_pkg.ALL;
ENTITY mux is
    PORT(
        inp         : IN ARR2(7 DOWNTO 0);
        sel         : IN std_logic_vector(2 DOWNTO 0);
        outp        : OUT std_logic_vector(31 DOWNTO 0)
    );
END mux;
ARCHITECTURE behavioral OF mux IS
BEGIN
    outp <= inp(conv_integer(unsigned(sel)));
END behavioral;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.STD_LOGIC_ARITH.ALL;
ENTITY compressed_mux is
    PORT(
        inp         : IN std_logic_vector(31 DOWNTO 0);
        sel         : IN std_logic_vector(4 DOWNTO 0);
        outp	    : OUT std_logic
	);
END compressed_mux;
ARCHITECTURE behavioral OF compressed_mux IS
BEGIN
    outp <= inp(conv_integer(unsigned(sel)));
END behavioral;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.bus_multiplexer_pkg.ALL;
USE ieee.STD_LOGIC_ARITH.ALL;
ENTITY bshifter is
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
END bshifter;
ARCHITECTURE behavioral OF bshifter IS
    COMPONENT compressed_mux IS
    PORT(
            inp         : IN std_logic_vector(31 DOWNTO 0);
            sel         : IN std_logic_vector(4 DOWNTO 0);
            outp	    : OUT std_logic
        );
    END COMPONENT;
    COMPONENT mux is
        PORT(
            inp         : IN ARR2;
            sel         : IN std_logic_vector(2 DOWNTO 0);
            outp        : OUT std_logic_vector(31 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL mem : std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');
    --TYPE ARR2 IS ARRAY(31 DOWNTO 0) OF std_logic_vector(31 DOWNTO 0);
    TYPE ARR3 IS ARRAY(5 DOWNTO 0) OF ARR2(31 DOWNTO 0);
    SIGNAL mux_inp : ARR3;
    SIGNAL mux_outp : ARR2(7 DOWNTO 0);
    SIGNAL write_data : std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL final_sel : std_logic_vector(2 DOWNTO 0);
    type INT_ARRAY IS ARRAY(INTEGER RANGE <>) OF INTEGER;
    SIGNAL sout_index : INT_ARRAY(1 DOWNTO 0) := (OTHERS => 0); --mem(sout_index) will be our sout in each mode
    --SIGNAL 
BEGIN
    PROCESS(clk, nrst)
    BEGIN
        IF(nrst = '0') THEN
            mem <= (OTHERS => '0');
            sout <= '0';
        ELSIF (clk'EVENT AND clk = '1') THEN
            sout <= mem(sout_index(0)) WHEN (dir = '0') ELSE mem(sout_index(1));
            mem <= write_data;
        END IF;
    END PROCESS;
    
    sout_index(0) <= (32 - conv_integer(unsigned(sham))) WHEN (sham > "00000") ELSE 0;
    sout_index(1) <= (conv_integer(unsigned(sham))- 1) WHEN (sham > "00000") ELSE 0;

    --LLS
    L1_0: FOR i IN 0 TO 31 GENERATE
        L2_0: FOR j IN 0 TO i GENERATE
            mux_inp(0)(i)(i-j) <= mem(j); --mux1, bite 1 ta 0 ro mirize 0 ta 1
        END GENERATE L2_0;
        L3_0: FOR j IN i + 1 TO 31 GENERATE
            mux_inp(0)(i)(j) <= sin;
        END GENERATE L3_0;
        muxes : compressed_mux PORT MAP(mux_inp(0)(i),sham,mux_outp(0)(i));   
    END GENERATE L1_0;
        
        
    --LRS
    L1_1: FOR i IN 0 TO 31 GENERATE
        L2_1: FOR j IN i TO 31 GENERATE
            mux_inp(1)(i)(j-i) <= mem(j); --mux1, bite 1 ta 31 ro mirize tu 0 ta 30
        END GENERATE L2_1;
        L3_1: FOR j IN 32 TO 31 + i GENERATE
            mux_inp(1)(i)(j-i) <= sin; --mux1, sin tu bite 31 
        END GENERATE L3_1;
        muxes : compressed_mux PORT MAP(mux_inp(1)(i),sham,mux_outp(1)(i));
    END GENERATE L1_1;
        
    
    --ALS
    L1_2: FOR i IN 0 TO 31 GENERATE
        L2_2: FOR j IN 0 TO i GENERATE
            mux_inp(2)(i)(i-j) <= mem(j);
        END GENERATE L2_2;
        L3_2: FOR j IN i + 1 TO 31 GENERATE
            mux_inp(2)(i)(j) <= '0';
        END GENERATE L3_2;
        muxes : compressed_mux PORT MAP(mux_inp(2)(i),sham,mux_outp(2)(i));
    END GENERATE L1_2;
    
    --ARS
    L1_3: FOR i IN 0 TO 31 GENERATE
        L2_3: FOR j IN i TO 31 GENERATE
            mux_inp(3)(i)(j-i) <= mem(j);
        END GENERATE L2_3;
        L3_3: FOR j IN 32 TO 31 + i GENERATE
            mux_inp(3)(i)(j-i) <= mem(31);
        END GENERATE L3_3;
        muxes : compressed_mux PORT MAP(mux_inp(3)(i),sham,mux_outp(3)(i));
    END GENERATE L1_3;

    --ROL
    L1_4: FOR i IN 0 TO 31 GENERATE
        L2_4: FOR j IN 0 TO i GENERATE
            mux_inp(4)(i)(i-j) <= mem(j);
        END GENERATE L2_4;
        L3_4: FOR j IN i + 1 TO 31 GENERATE
            mux_inp(4)(i)(j) <= mem(31 - (j - (i+1))); 
        END GENERATE L3_4;
        muxes : compressed_mux PORT MAP(mux_inp(4)(i),sham,mux_outp(4)(i));
    END GENERATE L1_4;
    
    --ROR
    L1_5: FOR i IN 0 TO 31 GENERATE
        L2_5: FOR j IN i TO 31 GENERATE
            mux_inp(5)(i)(j-i) <= mem(j);
        END GENERATE L2_5;
        L3_5: FOR j IN 0 TO i-1 GENERATE        
            mux_inp(5)(i)(32 - i + j) <= mem(j);
        END GENERATE L3_5;
        muxes : compressed_mux PORT MAP(mux_inp(5)(i),sham,mux_outp(5)(i));
    END GENERATE L1_5;

    mux_outp(6) <= din;
    mux_outp(7) <= din;

    final_sel <= shty & dir;
    final_mux : mux PORT MAP(mux_outp, final_sel, write_data);
    
    dout <= mem;
END behavioral;