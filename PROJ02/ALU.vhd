--Dorreen Rostami - 97243034
--Shahriar Morabi - 97243064
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY ALU IS
	GENERIC (
        data_wid : integer := 32
	);
	PORT(
		A			: IN std_logic_vectOR(data_wid-1 DOWNTO 0);
        B			: IN std_logic_vectOR(data_wid-1 DOWNTO 0);
        cin         : IN std_logic;
		sin         : IN std_logic;
        funct		: IN std_logic_vectOR(3 DOWNTO 0);
        Z			: OUT std_logic_vectOR(data_wid-1 DOWNTO 0);
        cout        : OUT std_logic;
        sout        : OUT std_logic;
        Ov          : OUT std_logic
	);
END ALU;

ARCHITECTURE behavioral OF ALU IS 
	SIGNAL ALU_res 	: std_logic_vectOR(data_wid DOWNTO 0);
	SIGNAL A2 		: std_logic_vectOR(data_wid DOWNTO 0);
	SIGNAL B2 		: std_logic_vectOR(data_wid DOWNTO 0);
BEGIN
	A2 <= '0' & A;
	B2 <= '0' & B;
	PROCESS (funct, A2, B2, sin, cin)
    BEGIN	
        CASE (funct) IS 
			WHEN "0000" => --change sign
                ALU_res <= '0' & (NOT B2(data_wid-1)) & B2(data_wid-2 DOWNTO 0);
			WHEN "0001" => --2's comp add without carry
                ALU_res <= A2 + B2;
			WHEN "0010" => --2's comp add with carry
                ALU_res <= A2 + B2 + cin;
			WHEN "0011" => --2's comp sub without carry
                ALU_res <= A2 - B2;
			WHEN "0100" => --2's comp
                ALU_res <= NOT B2 + 1;
			WHEN "0101" => --bitwise NOT
                ALU_res <= NOT B2;	
			WHEN "0110" => --AND
                ALU_res <= A2 AND B2;
			WHEN "0111" => --OR
                ALU_res <= A2 OR B2;
            WHEN "1000" => --XOR
                ALU_res <= A2 XOR B2;
			WHEN "1001" => --lls
                ALU_res <= A2(data_wid-1 DOWNTO 0) & sin; 
			WHEN "1010" => --lrs
                ALU_res <= '0' & sin & A2(data_wid-1 DOWNTO 1);
			WHEN "1011" => --cls = A(data_wid-2 DOWNTO 0) & A(data_wid-1) | A(data_wid-2 DOWNTO 0) & sin
                ALU_res <= A2(data_wid-1 DOWNTO 0) & A2(data_wid-1);
			WHEN "1100" => --crs = A(0) & A(data_wid-1 DOWNTO 1) | sin & A(data_wid-1 DOWNTO 1)
				ALU_res <= '0' & A2(0) & A2(data_wid-1 DOWNTO 1);
            WHEN "1101" =>
                IF(A>B) THEN
                    ALU_res <= (data_wid DOWNTO 1 => '0') & '1'; --(0 => '1', OTHERS => '0')
                ELSE
                    ALU_res <= (OTHERS => '0');
                END IF;
			WHEN "1110" =>
                IF(A<B) THEN
                    ALU_res <= (data_wid DOWNTO 1 => '0') & '1';
                ELSE
                    ALU_res <= (OTHERS => '0');
                END IF;
			WHEN "1111"=>
                IF(A=B) THEN
                    ALU_res <= (data_wid DOWNTO 1 => '0') & '1';
                ELSE
                   ALU_res <= (OTHERS => '0');
                END IF;
            WHEN OTHERS =>
                ALU_res <= (OTHERS => 'Z');
        END CASE;
    END PROCESS;
	
	WITH funct SELECT
		cout <= ALU_res(data_wid) WHEN "0001" | "0010" | "0011",
				'Z' WHEN OTHERS;
		
	WITH funct SELECT
		Ov <= 	( (ALU_res(data_wid-1) XOR A(data_wid-1)) AND (NOT(A(data_wid-1) XOR B(data_wid-1))) ) WHEN "0001" | "0010" | "0011",
				'Z' WHEN OTHERS;
				
	WITH funct SELECT
		sout <= ALU_res(data_wid-1) WHEN "1001" | "1011", --A(data_wid-2)		
				ALU_res(0) WHEN "1010" | "1100", --A(1)
				'Z' WHEN OTHERS;
				
	
    Z <= ALU_res(data_wid-1 DOWNTO 0);
     
END behavioral;
