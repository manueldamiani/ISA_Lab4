library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use WORK.constants.all;
use WORK.all;

ENTITY Dadda IS

   PORT(PP0  : IN    std_logic_vector (36 DOWNTO 0);
	PP1  : IN    std_logic_vector (36 DOWNTO 0);
	PP2  : IN    std_logic_vector (36 DOWNTO 0);
      	PP3  : IN    std_logic_vector (36 DOWNTO 0);
	PP4  : IN    std_logic_vector (36 DOWNTO 0);
	PP5  : IN    std_logic_vector (36 DOWNTO 0);
     	PP6  : IN    std_logic_vector (36 DOWNTO 0);
	PP7  : IN    std_logic_vector (36 DOWNTO 0);
	PP8  : IN    std_logic_vector (36 DOWNTO 0);
     	PP9  : IN    std_logic_vector (36 DOWNTO 0);
	PP10 : IN    std_logic_vector (36 DOWNTO 0);
	PP11 : IN    std_logic_vector (36 DOWNTO 0);
      	PP12 : IN    std_logic_vector (36 DOWNTO 0);
	PP13 : IN    std_logic_vector (36 DOWNTO 0);
	PP14 : IN    std_logic_vector (36 DOWNTO 0);
      	PP15 : IN    std_logic_vector (36 DOWNTO 0);
	PP16 : IN    std_logic_vector (36 DOWNTO 0);
	OP1 : OUT    std_logic_vector (63 DOWNTO 0);
	OP2 : OUT    std_logic_vector (63 DOWNTO 0)
   );

END Dadda ;

architecture structural of Dadda is

constant N5 : integer := 13;
constant N4 : integer := 9;
constant N3 : integer := 6;
constant N2 : integer := 4;
constant N1 : integer := 3;
constant N0 : integer := 2;

type PParray is array (0 to (N/2)) of std_logic_vector(N+4 downto 0); --array containing the input partial products
type Level6 is array (0 to (N/2)) of std_logic_vector(2*N-1 downto 0); -- array representing the level 6 of the dadda tree
type Level5 is array (0 to (N5-1)) of std_logic_vector(2*N-1 downto 0); -- array representing the level 5 of the dadda tree
type Level4 is array (0 to (N4-1)) of std_logic_vector(2*N-1 downto 0); -- array representing the level 4 of the dadda tree
type Level3 is array (0 to (N3-1)) of std_logic_vector(2*N-1 downto 0); -- array representing the level 3 of the dadda tree
type Level2 is array (0 to (N2-1)) of std_logic_vector(2*N-1 downto 0); -- array representing the level 2 of the dadda tree
type Level1 is array (0 to (N1-1)) of std_logic_vector(2*N-1 downto 0); -- array representing the level 1 of the dadda tree
type Level0 is array (0 to (N0-1)) of std_logic_vector(2*N-1 downto 0); -- array representing the level 0 of the dadda tree

signal PPa : PParray;
signal L6 : Level6 := (others=>(others=>'0'));
signal L5 : Level5 := (others=>(others=>'0'));
signal L4 : Level4 := (others=>(others=>'0'));
signal L3 : Level3 := (others=>(others=>'0'));
signal L2 : Level2 := (others=>(others=>'0'));
signal L1 : Level1 := (others=>(others=>'0'));
signal L0 : Level0 := (others=>(others=>'0'));

signal Cout : std_logic; -- Final output carry

component HA is
  port (in1  : in std_logic;
    	in2  : in std_logic;
   	sum   : out std_logic;
    	carry_out : out std_logic);
end component;

component FA is
  port (in1  : in std_logic;
    	in2  : in std_logic;
	carry_in : in std_logic;
   	sum   : out std_logic;
    	carry_out : out std_logic);
end component;

begin

-- Put the input partial prdocuts in the array PPa
PPa <= (PP0,PP1,PP2,PP3,PP4,PP5,PP6,PP7,PP8,PP9,PP10,PP11,PP12,PP13,PP14,PP15,PP16);

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ LEVEL 6 of the DADDA TREE ------
-- Generation of the matrix L6 (dimension 17x64)
-- All input partial products are shifted and put in the L6 matrix
-- This is the preliminary step useful for the following levels,
-- so no compression is made.
Level6Gen : for j in 0 to N/2 generate
	
	Gen0: if(j=0) generate
		L6(j)(PPa(j)'length-1 downto 0) <= PPa(j);
	end generate Gen0;

	Gen15: if(j=15) generate
		L6(j)(PPa(j)'length+26 downto (2*j-2)) <= PPa(j)(35 downto 0);
	end generate Gen15;

	Gen16: if(j=16) generate
		L6(j)(PPa(j)'length+26 downto (2*j-2)) <= PPa(j)(33 downto 0);
	end generate Gen16;

	Gen: if(j/=0 AND j/= 15 AND j/=16) generate
		L6(j)(PPa(j)'length+(2*j-3) downto (2*j-2)) <= PPa(j);
	end generate Gen;

end generate Level6Gen;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ LEVEL 5 of the DADDA TREE ------
-- Generation of the matrix L5 (dimension 13x64)

--Compression from column 24 to 30 and from column 36 to 42
Comp24_30_36_42: for i in 24 to 30 generate 
	G24 : if (i=24) generate
		HA6_1: HA port map(in1 => L6(0)(i), in2 => L6(1)(i), sum => L5(0)(i), carry_out => L5(0)(i+1)); -- Column 24 
		HA6_8: HA port map(in1 => L6(4)(66-i), in2 => L6(5)(66-i), sum => L5(1)(66-i), carry_out => L5(0)(66-i+1)); -- Column 42
	end generate G24;

	G25 : if (i=25) generate
		FA6_1: FA port map(in1 => L6(0)(i), in2 => L6(1)(i), carry_in => L6(2)(i), sum => L5(1)(i), carry_out => L5(0)(i+1)); -- Column 25
		FA6_24: FA port map(in1 => L6(4)(66-i), in2 => L6(5)(66-i), carry_in => L6(6)(66-i), sum => L5(2)(66-i), carry_out => L5(0)(66-i+1)); -- Column 41
	end generate G25;

	G26 : if (i=26) generate
		FA6_2: FA port map(in1 => L6(0)(i), in2 => L6(1)(i), carry_in => L6(2)(i), sum => L5(1)(i), carry_out => L5(0)(i+1)); -- Column 26
		HA6_2: HA port map(in1 => L6(3)(i), in2 => L6(4)(i), sum => L5(2)(i), carry_out => L5(1)(i+1));

		FA6_23: FA port map(in1 => L6(3)(66-i), in2 => L6(4)(66-i), carry_in => L6(5)(66-i), sum => L5(2)(66-i), carry_out => L5(0)(66-i+1)); -- Column 40
		HA6_7: HA port map(in1 => L6(6)(66-i), in2 => L6(7)(66-i), sum => L5(3)(66-i), carry_out => L5(1)(66-i+1));
	end generate G26;
	
	G27 : if (i=27) generate
		FA6_3: FA port map(in1 => L6(0)(i), in2 => L6(1)(i), carry_in => L6(2)(i), sum => L5(2)(i), carry_out => L5(0)(i+1)); -- Column 27
		FA6_4: FA port map(in1 => L6(3)(i), in2 => L6(4)(i), carry_in => L6(5)(i), sum => L5(3)(i), carry_out => L5(1)(i+1));

		FA6_21: FA port map(in1 => L6(3)(66-i), in2 => L6(4)(66-i), carry_in => L6(5)(66-i), sum => L5(3)(66-i), carry_out => L5(0)(66-i+1)); -- Column 39
		FA6_22: FA port map(in1 => L6(6)(66-i), in2 => L6(7)(66-i), carry_in => L6(8)(66-i), sum => L5(4)(66-i), carry_out => L5(1)(66-i+1));
	end generate G27;
	
	G28 : if (i=28) generate
		FA6_5: FA port map(in1 => L6(0)(i), in2 => L6(1)(i), carry_in => L6(2)(i), sum => L5(2)(i), carry_out => L5(0)(i+1)); -- Column 28
		FA6_6: FA port map(in1 => L6(3)(i), in2 => L6(4)(i), carry_in => L6(5)(i), sum => L5(3)(i), carry_out => L5(1)(i+1));
		HA6_3: HA port map(in1 => L6(6)(i), in2 => L6(7)(i), sum => L5(4)(i), carry_out => L5(2)(i+1));

		FA6_19: FA port map(in1 => L6(2)(66-i), in2 => L6(3)(66-i), carry_in => L6(4)(66-i), sum => L5(3)(66-i), carry_out => L5(0)(66-i+1)); -- Column 38
		FA6_20: FA port map(in1 => L6(5)(66-i), in2 => L6(6)(66-i), carry_in => L6(7)(66-i), sum => L5(4)(66-i), carry_out => L5(1)(66-i+1));
		HA6_6: HA port map(in1 => L6(8)(66-i), in2 => L6(9)(66-i), sum => L5(5)(66-i), carry_out => L5(2)(66-i+1));
	end generate G28;

	G29 : if (i=29) generate
		FA6_7: FA port map(in1 => L6(0)(i), in2 => L6(1)(i), carry_in => L6(2)(i), sum => L5(3)(i), carry_out => L5(0)(i+1)); -- Column 29
		FA6_8: FA port map(in1 => L6(3)(i), in2 => L6(4)(i), carry_in => L6(5)(i), sum => L5(4)(i), carry_out => L5(1)(i+1));
		FA6_9: FA port map(in1 => L6(6)(i), in2 => L6(7)(i), carry_in => L6(8)(i), sum => L5(5)(i), carry_out => L5(2)(i+1));

		FA6_16: FA port map(in1 => L6(2)(66-i), in2 => L6(3)(66-i), carry_in => L6(4)(66-i), sum => L5(4)(66-i), carry_out => L5(0)(66-i+1)); -- Column 37
		FA6_17: FA port map(in1 => L6(5)(66-i), in2 => L6(6)(66-i), carry_in => L6(7)(66-i), sum => L5(5)(66-i), carry_out => L5(1)(66-i+1));
		FA6_18: FA port map(in1 => L6(8)(66-i), in2 => L6(9)(66-i), carry_in => L6(10)(66-i), sum => L5(6)(66-i), carry_out => L5(2)(66-i+1));
	end generate G29;
	
	G30 : if (i=30) generate
		FA6_10: FA port map(in1 => L6(0)(i), in2 => L6(1)(i), carry_in => L6(2)(i), sum => L5(3)(i), carry_out => L5(0)(i+1)); -- Column 30
		FA6_11: FA port map(in1 => L6(3)(i), in2 => L6(4)(i), carry_in => L6(5)(i), sum => L5(4)(i), carry_out => L5(1)(i+1));
		FA6_12: FA port map(in1 => L6(6)(i), in2 => L6(7)(i), carry_in => L6(8)(i), sum => L5(5)(i), carry_out => L5(2)(i+1));
		HA6_4: HA port map(in1 => L6(9)(i), in2 => L6(10)(i), sum => L5(6)(i), carry_out => L5(3)(i+1));

		FA6_13: FA port map(in1 => L6(1)(66-i), in2 => L6(2)(66-i), carry_in => L6(3)(66-i), sum => L5(4)(66-i), carry_out => L5(0)(66-i+1)); -- Column 36
		FA6_14: FA port map(in1 => L6(4)(66-i), in2 => L6(5)(66-i), carry_in => L6(6)(66-i), sum => L5(5)(66-i), carry_out => L5(1)(66-i+1));
		FA6_15: FA port map(in1 => L6(7)(66-i), in2 => L6(8)(66-i), carry_in => L6(9)(66-i), sum => L5(6)(66-i), carry_out => L5(2)(66-i+1));
		HA6_5: HA port map(in1 => L6(10)(66-i), in2 => L6(11)(66-i), sum => L5(7)(66-i), carry_out => L5(3)(66-i+1));
	end generate G30;	
end generate Comp24_30_36_42;

--Compression from column 31 to 35
Level6Gen_centre: for i in 31 to 35 generate
	FA6_1c: FA port map(in1 => L6(0)(i), in2 => L6(1)(i), carry_in => L6(2)(i), sum => L5(4)(i), carry_out => L5(0)(i+1));
	FA6_2c: FA port map(in1 => L6(3)(i), in2 => L6(4)(i), carry_in => L6(5)(i), sum => L5(5)(i), carry_out => L5(1)(i+1));
	FA6_3c: FA port map(in1 => L6(6)(i), in2 => L6(7)(i), carry_in => L6(8)(i), sum => L5(6)(i), carry_out => L5(2)(i+1));
	FA6_4c: FA port map(in1 => L6(9)(i), in2 => L6(10)(i), carry_in => L6(11)(i), sum => L5(7)(i), carry_out => L5(3)(i+1));

	C31_35 : for j in 8 to N5-1 generate
		L5(j)(i) <= L6(j+4)(i); -- Report the bits of matrix L6 not used in the FA or HA in the matrix L5 
	end generate C31_35;
end generate Level6Gen_centre;

-- Report the bits of matrix L6 not used in the FA or HA in the matrix L5

--From column 0 to 23
Level5Gen_right : for i in 0 to N5-1 generate
	L5(i)(23 downto 0) <= L6(i)(23 downto 0);
end generate Level5Gen_right;

C24_29 : for i in 0 to 2 generate -- From column 24 to 29
	G1: for j in (2*i+1) to N5-1 generate
		L5(j)(23+(2*i+1)) <= L6(j+i+1)(23+(2*i+1));
	end generate G1;
	G2: for j in (2*i+2) to N5-1 generate
		L5(j)(23+(2*i+2)) <= L6(j+i+1)(23+(2*i+2));
	end generate G2;
end generate C24_29;

C30 : for j in 7 to N5-1 generate -- Column 30
	L5(j)(30) <= L6(j+4)(30);
end generate C30;

C36_43 : for i in 8 downto 1 generate -- From column 36 to 43
	G: for j in i to N5-1 generate
		L5(j)(44-i) <= L6(j+4)(44-i);
	end generate G;
end generate C36_43;

C44: for j in 0 to N5-2 generate -- Column 44
	L5(j)(44) <= L6(j+5)(44);
end generate C44;
L5(N5-1)(44) <= '0';

C45_62: for i in 0 to 8 generate -- From column 45 to 62
	G3: for j in 0 to N5-(i+3) generate
		L5(j)(44+(2*i+1)) <= L6(j+i+6)(44+(2*i+1));
		L5(j)(45+(2*i+1)) <= L6(j+i+6)(45+(2*i+1));
	end generate G3;
	G4: for j in N5-(i+2) to N5-1 generate
		L5(j)(44+(2*i+1)) <= '0';
		L5(j)(45+(2*i+1)) <= '0';
	end generate G4;
end generate C45_62;

C63: for j in 0 to N5-12 generate -- Column 63
	L5(j)(63) <= L6(j+15)(63);
end generate C63;
C63z: for j in N5-11 to N5-1 generate
	L5(j)(63) <= '0';
end generate C63z;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ LEVEL 4 of the DADDA TREE ------
-- Generation of the matrix L4 (dimension 9x64)

--Compression from column 16 to 22 and from column 44 to 50
Comp16_22_44_50: for i in 16 to 22 generate 
	G16 : if (i=16) generate
		HA5_1: HA port map(in1 => L5(0)(i), in2 => L5(1)(i), sum => L4(0)(i), carry_out => L4(0)(i+1)); -- Column 16
		HA5_8: HA port map(in1 => L5(0)(66-i), in2 => L5(1)(66-i), sum => L4(1)(66-i), carry_out => L4(0)(66-i+1)); -- Column 50
	end generate G16;

	G17 : if (i=17) generate
		FA5_1: FA port map(in1 => L5(0)(i), in2 => L5(1)(i), carry_in => L5(2)(i), sum => L4(1)(i), carry_out => L4(0)(i+1)); -- Column 17
		FA5_24: FA port map(in1 => L5(0)(66-i), in2 => L5(1)(66-i), carry_in => L5(2)(66-i), sum => L4(2)(66-i), carry_out => L4(0)(66-i+1)); -- Column 49
	end generate G17;

	G18 : if (i=18) generate
		FA5_2: FA port map(in1 => L5(0)(i), in2 => L5(1)(i), carry_in => L5(2)(i), sum => L4(1)(i), carry_out => L4(0)(i+1)); -- Column 18
		HA5_2: HA port map(in1 => L5(3)(i), in2 => L5(4)(i), sum => L4(2)(i), carry_out => L4(1)(i+1));

		FA5_23: FA port map(in1 => L5(0)(66-i), in2 => L5(1)(66-i), carry_in => L5(2)(66-i), sum => L4(2)(66-i), carry_out => L4(0)(66-i+1)); -- Column 48
		HA5_7: HA port map(in1 => L5(3)(66-i), in2 => L5(4)(66-i), sum => L4(3)(66-i), carry_out => L4(1)(66-i+1));
	end generate G18;
	
	G19 : if (i=19) generate
		FA5_3: FA port map(in1 => L5(0)(i), in2 => L5(1)(i), carry_in => L5(2)(i), sum => L4(2)(i), carry_out => L4(0)(i+1)); -- Column 19
		FA5_4: FA port map(in1 => L5(3)(i), in2 => L5(4)(i), carry_in => L5(5)(i), sum => L4(3)(i), carry_out => L4(1)(i+1));

		FA5_21: FA port map(in1 => L5(0)(66-i), in2 => L5(1)(66-i), carry_in => L5(2)(66-i), sum => L4(3)(66-i), carry_out => L4(0)(66-i+1)); -- Column 47
		FA5_22: FA port map(in1 => L5(3)(66-i), in2 => L5(4)(66-i), carry_in => L5(5)(66-i), sum => L4(4)(66-i), carry_out => L4(1)(66-i+1));
	end generate G19;
	
	G20 : if (i=20) generate
		FA5_5: FA port map(in1 => L5(0)(i), in2 => L5(1)(i), carry_in => L5(2)(i), sum => L4(2)(i), carry_out => L4(0)(i+1)); -- Column 20
		FA5_6: FA port map(in1 => L5(3)(i), in2 => L5(4)(i), carry_in => L5(5)(i), sum => L4(3)(i), carry_out => L4(1)(i+1));
		HA5_3: HA port map(in1 => L5(6)(i), in2 => L5(7)(i), sum => L4(4)(i), carry_out => L4(2)(i+1));

		FA5_19: FA port map(in1 => L5(0)(66-i), in2 => L5(1)(66-i), carry_in => L5(2)(66-i), sum => L4(3)(66-i), carry_out => L4(0)(66-i+1)); -- Column 46
		FA5_20: FA port map(in1 => L5(3)(66-i), in2 => L5(4)(66-i), carry_in => L5(5)(66-i), sum => L4(4)(66-i), carry_out => L4(1)(66-i+1));
		HA5_6: HA port map(in1 => L5(6)(66-i), in2 => L5(7)(66-i), sum => L4(5)(66-i), carry_out => L4(2)(66-i+1));	
	end generate G20;

	G21 : if (i=21) generate
		FA5_7: FA port map(in1 => L5(0)(i), in2 => L5(1)(i), carry_in => L5(2)(i), sum => L4(3)(i), carry_out => L4(0)(i+1)); -- Column 21
		FA5_8: FA port map(in1 => L5(3)(i), in2 => L5(4)(i), carry_in => L5(5)(i), sum => L4(4)(i), carry_out => L4(1)(i+1));
		FA5_9: FA port map(in1 => L5(6)(i), in2 => L5(7)(i), carry_in => L5(8)(i), sum => L4(5)(i), carry_out => L4(2)(i+1));

		FA5_16: FA port map(in1 => L5(0)(66-i), in2 => L5(1)(66-i), carry_in => L5(2)(66-i), sum => L4(4)(66-i), carry_out => L4(0)(66-i+1)); -- Column 45
		FA5_17: FA port map(in1 => L5(3)(66-i), in2 => L5(4)(66-i), carry_in => L5(5)(66-i), sum => L4(5)(66-i), carry_out => L4(1)(66-i+1));
		FA5_18: FA port map(in1 => L5(6)(66-i), in2 => L5(7)(66-i), carry_in => L5(8)(66-i), sum => L4(6)(66-i), carry_out => L4(2)(66-i+1));
	end generate G21;
	
	G22 : if (i=22) generate
		FA5_10: FA port map(in1 => L5(0)(i), in2 => L5(1)(i), carry_in => L5(2)(i), sum => L4(3)(i), carry_out => L4(0)(i+1)); -- Column 22
		FA5_11: FA port map(in1 => L5(3)(i), in2 => L5(4)(i), carry_in => L5(5)(i), sum => L4(4)(i), carry_out => L4(1)(i+1));
		FA5_12: FA port map(in1 => L5(6)(i), in2 => L5(7)(i), carry_in => L5(8)(i), sum => L4(5)(i), carry_out => L4(2)(i+1));
		HA5_4: HA port map(in1 => L5(9)(i), in2 => L5(10)(i), sum => L4(6)(i), carry_out => L4(3)(i+1));

		FA5_13: FA port map(in1 => L5(0)(66-i), in2 => L5(1)(66-i), carry_in => L5(2)(66-i), sum => L4(4)(66-i), carry_out => L4(0)(66-i+1)); -- Column 44
		FA5_14: FA port map(in1 => L5(3)(66-i), in2 => L5(4)(66-i), carry_in => L5(5)(66-i), sum => L4(5)(66-i), carry_out => L4(1)(66-i+1));
		FA5_15: FA port map(in1 => L5(6)(66-i), in2 => L5(7)(66-i), carry_in => L5(8)(66-i), sum => L4(6)(66-i), carry_out => L4(2)(66-i+1));
		HA5_5: HA port map(in1 => L5(9)(66-i), in2 => L5(10)(66-i), sum => L4(7)(66-i), carry_out => L4(3)(66-i+1));
	end generate G22;	
end generate Comp16_22_44_50;

--Compression from column 23 to 43
Level5Gen_centre: for i in 23 to 43 generate
	FA5_1c: FA port map(in1 => L5(0)(i), in2 => L5(1)(i), carry_in => L5(2)(i), sum => L4(4)(i), carry_out => L4(0)(i+1));
	FA5_2c: FA port map(in1 => L5(3)(i), in2 => L5(4)(i), carry_in => L5(5)(i), sum => L4(5)(i), carry_out => L4(1)(i+1));
	FA5_3c: FA port map(in1 => L5(6)(i), in2 => L5(7)(i), carry_in => L5(8)(i), sum => L4(6)(i), carry_out => L4(2)(i+1));
	FA5_4c: FA port map(in1 => L5(9)(i), in2 => L5(10)(i), carry_in => L5(11)(i), sum => L4(7)(i), carry_out => L4(3)(i+1));

	L4(N4-1)(i) <= L5(N5-1)(i); -- Report the bit of matrix L5 not used in the FA or HA in the matrix L4
end generate Level5Gen_centre;

-- Report the bit of matrix L5 not used in the FA or HA in the matrix L4

Level4Gen_right_left : for i in 0 to N4-1 generate
	L4(i)(15 downto 0) <= L5(i)(15 downto 0); --From column 0 to 15
	L4(i)(63 downto 52) <= L5(i)(63 downto 52); -- From column 52 to 63
end generate Level4Gen_right_left;

C16_21_45_50 : for i in 0 to 2 generate 
	G1: for j in (2*i+1) to N4-1 generate
		L4(j)(15+(2*i+1)) <= L5(j+i+1)(15+(2*i+1)); -- From column 16 to 21
		G45: if(j <= N4-2) generate
			L4(j+1)(51-(2*i+1)) <= L5(j+i+1)(51-(2*i+1)); -- From column 45 to 50
		end generate G45;
	end generate G1;
	G2: for j in (2*i+2) to N4-1 generate
		L4(j)(15+(2*i+2)) <= L5(j+i+1)(15+(2*i+2)); -- From column 16 to 21
		G45_2: if(j <= N4-2) generate
			L4(j+1)(51-(2*i+2)) <= L5(j+i+1)(51-(2*i+2)); -- From column 45 to 50
		end generate G45_2;
	end generate G2;
end generate C16_21_45_50;

C22 : for j in 7 to N4-1 generate -- Column 22
	L4(j)(22) <= L5(j+4)(22);
end generate C22;

L4(N4-1)(44) <= L5(N5-2)(44); -- Column 44

C51 : for j in 1 to N4-1 generate -- Column 51
	L4(j)(51) <= L5(j-1)(51);
end generate C51;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ LEVEL 3 of the DADDA TREE ------
-- Generation of the matrix L3 (dimension 6x64)

--Compression from column 10 to 14 and from column 52 to 56
Comp10_14: for i in 10 to 14 generate 
	G10 : if (i=10) generate
		HA4_1: HA port map(in1 => L4(0)(i), in2 => L4(1)(i), sum => L3(0)(i), carry_out => L3(0)(i+1)); -- Column 10
		HA4_6: HA port map(in1 => L4(0)(66-i), in2 => L4(1)(66-i), sum => L3(1)(66-i), carry_out => L3(0)(66-i+1)); -- Column 56
	end generate G10;

	G11 : if (i=11) generate
		FA4_1: FA port map(in1 => L4(0)(i), in2 => L4(1)(i), carry_in => L4(2)(i), sum => L3(1)(i), carry_out => L3(0)(i+1)); -- Column 11
		FA4_12: FA port map(in1 => L4(0)(66-i), in2 => L4(1)(66-i), carry_in => L4(2)(66-i), sum => L3(2)(66-i), carry_out => L3(0)(66-i+1)); -- Column 55
	end generate G11;

	G12 : if (i=12) generate
		FA4_2: FA port map(in1 => L4(0)(i), in2 => L4(1)(i), carry_in => L4(2)(i), sum => L3(1)(i), carry_out => L3(0)(i+1)); -- Column 12
		HA4_2: HA port map(in1 => L4(3)(i), in2 => L4(4)(i), sum => L3(2)(i), carry_out => L3(1)(i+1));

		FA4_11: FA port map(in1 => L4(0)(66-i), in2 => L4(1)(66-i), carry_in => L4(2)(66-i), sum => L3(2)(66-i), carry_out => L3(0)(66-i+1)); -- Column 54
		HA4_5: HA port map(in1 => L4(3)(66-i), in2 => L4(4)(66-i), sum => L3(3)(66-i), carry_out => L3(1)(66-i+1));
	end generate G12;
	
	G13 : if (i=13) generate
		FA4_3: FA port map(in1 => L4(0)(i), in2 => L4(1)(i), carry_in => L4(2)(i), sum => L3(2)(i), carry_out => L3(0)(i+1)); -- Column 13
		FA4_4: FA port map(in1 => L4(3)(i), in2 => L4(4)(i), carry_in => L4(5)(i), sum => L3(3)(i), carry_out => L3(1)(i+1));

		FA4_9: FA port map(in1 => L4(0)(66-i), in2 => L4(1)(66-i), carry_in => L4(2)(66-i), sum => L3(3)(66-i), carry_out => L3(0)(66-i+1)); -- Column 53
		FA4_10: FA port map(in1 => L4(3)(66-i), in2 => L4(4)(66-i), carry_in => L4(5)(66-i), sum => L3(4)(66-i), carry_out => L3(1)(66-i+1));
	end generate G13;
	
	G14 : if (i=14) generate
		FA4_5: FA port map(in1 => L4(0)(i), in2 => L4(1)(i), carry_in => L4(2)(i), sum => L3(2)(i), carry_out => L3(0)(i+1)); -- Column 14
		FA4_6: FA port map(in1 => L4(3)(i), in2 => L4(4)(i), carry_in => L4(5)(i), sum => L3(3)(i), carry_out => L3(1)(i+1));
		HA4_3: HA port map(in1 => L4(6)(i), in2 => L4(7)(i), sum => L3(4)(i), carry_out => L3(2)(i+1));

		FA4_7: FA port map(in1 => L4(0)(66-i), in2 => L4(1)(66-i), carry_in => L4(2)(66-i), sum => L3(3)(66-i), carry_out => L3(0)(66-i+1)); -- Column 52
		FA4_8: FA port map(in1 => L4(3)(66-i), in2 => L4(4)(66-i), carry_in => L4(5)(66-i), sum => L3(4)(66-i), carry_out => L3(1)(66-i+1));
		HA4_4: HA port map(in1 => L4(6)(66-i), in2 => L4(7)(66-i), sum => L3(5)(66-i), carry_out => L3(2)(66-i+1));	
	end generate G14;
end generate Comp10_14;

--Compression from column 15 to 51
Level4Gen_centre: for i in 15 to 51 generate
	FA4_1c: FA port map(in1 => L4(0)(i), in2 => L4(1)(i), carry_in => L4(2)(i), sum => L3(3)(i), carry_out => L3(0)(i+1));
	FA4_2c: FA port map(in1 => L4(3)(i), in2 => L4(4)(i), carry_in => L4(5)(i), sum => L3(4)(i), carry_out => L3(1)(i+1));
	FA4_3c: FA port map(in1 => L4(6)(i), in2 => L4(7)(i), carry_in => L4(8)(i), sum => L3(5)(i), carry_out => L3(2)(i+1));
end generate Level4Gen_centre;

-- Report the bit of matrix L4 not used in the FA or HA in the matrix L3

Level3Gen_right_left : for i in 0 to N3-1 generate
	L3(i)(9 downto 0) <= L4(i)(9 downto 0); --From column 0 to 9
	L3(i)(63 downto 58) <= L4(i)(63 downto 58); -- From column 58 to 63
end generate Level3Gen_right_left;

C10_13: for i in 0 to 1 generate 
	G1: for j in (2*i+1) to N3-1 generate
		L3(j)(9+(2*i+1)) <= L4(j+i+1)(9+(2*i+1)); -- From column 10 to 13
	end generate G1;
	G2: for j in (2*i+2) to N3-1 generate
		L3(j)(9+(2*i+2)) <= L4(j+i+1)(9+(2*i+2)); -- From column 10 to 13
	end generate G2;
end generate C10_13;

L3(N3-1)(14) <= L4(N4-1)(14); -- Column 14
L3(N3-1)(53) <= L4(N4-3)(53); -- Column 53

C54 : for j in 4 to N3-1 generate -- Column 54
	L3(j)(54) <= L4(j+1)(54);
end generate C54;
C55 : for j in 3 to N3-1 generate -- Column 55
	L3(j)(55) <= L4(j)(55);
end generate C55;
C56 : for j in 2 to N3-1 generate -- Column 56
	L3(j)(56) <= L4(j)(56);
end generate C56;
C57 : for j in 1 to N3-1 generate -- Column 57
	L3(j)(57) <= L4(j-1)(57);
end generate C57;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ LEVEL 2 of the DADDA TREE ------
-- Generation of the matrix L2 (dimension 4x64)

--Compression from column 6 to 8 and from 58 to 60
Comp6_8_58_60: for i in 6 to 8 generate 
	G6 : if (i=6) generate
		HA3_1: HA port map(in1 => L3(0)(i), in2 => L3(1)(i), sum => L2(0)(i), carry_out => L2(0)(i+1)); -- Column 6
		HA3_4: HA port map(in1 => L3(0)(66-i), in2 => L3(1)(66-i), sum => L2(1)(66-i), carry_out => L2(0)(66-i+1)); -- Column 60
	end generate G6;

	G7 : if (i=7) generate
		FA3_1: FA port map(in1 => L3(0)(i), in2 => L3(1)(i), carry_in => L3(2)(i), sum => L2(1)(i), carry_out => L2(0)(i+1)); -- Column 7
		FA3_4: FA port map(in1 => L3(0)(66-i), in2 => L3(1)(66-i), carry_in => L3(2)(66-i), sum => L2(2)(66-i), carry_out => L2(0)(66-i+1)); -- Column 59
	end generate G7;

	G8 : if (i=8) generate
		FA3_2: FA port map(in1 => L3(0)(i), in2 => L3(1)(i), carry_in => L3(2)(i), sum => L2(1)(i), carry_out => L2(0)(i+1)); -- Column 8
		HA3_2: HA port map(in1 => L3(3)(i), in2 => L3(4)(i), sum => L2(2)(i), carry_out => L2(1)(i+1));

		FA3_3: FA port map(in1 => L3(0)(66-i), in2 => L3(1)(66-i), carry_in => L3(2)(66-i), sum => L2(2)(66-i), carry_out => L2(0)(66-i+1)); -- Column 58
		HA3_3: HA port map(in1 => L3(3)(66-i), in2 => L3(4)(66-i), sum => L2(3)(66-i), carry_out => L2(1)(66-i+1));
	end generate G8;
end generate Comp6_8_58_60;

--Compression from column 9 to 57
Level3Gen_centre: for i in 9 to 57 generate
	FA3_1c: FA port map(in1 => L3(0)(i), in2 => L3(1)(i), carry_in => L3(2)(i), sum => L2(2)(i), carry_out => L2(0)(i+1));
	FA3_2c: FA port map(in1 => L3(3)(i), in2 => L3(4)(i), carry_in => L3(5)(i), sum => L2(3)(i), carry_out => L2(1)(i+1));
end generate Level3Gen_centre;

-- Report the bit of matrix L3 not used in the FA or HA in the matrix L2

Level2Gen_right_left : for i in 0 to N2-1 generate
	L2(i)(5 downto 0) <= L3(i)(5 downto 0); --From column 0 to 5
	L2(i)(63 downto 62) <= L3(i)(63 downto 62); -- From column 62 to 63
end generate Level2Gen_right_left;

C6 : for j in 1 to N2-1 generate -- column 6
	L2(j)(6) <= L3(j+1)(6);
end generate C6;

C7 : for j in 2 to N2-1 generate -- column 7
	L2(j)(7) <= L3(j+1)(7);
end generate C7;

L2(N2-1)(8) <= L3(N3-1)(8); -- Column 8
L2(N2-1)(59) <= L3(N3-3)(59); -- Column 59

C60 : for j in 2 to N2-1 generate -- column 60
	L2(j)(60) <= L3(j)(60);
end generate C60;

C61 : for j in 1 to N2-1 generate -- column 61
	L2(j)(61) <= L3(j-1)(61);
end generate C61;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ LEVEL 1 of the DADDA TREE ------
-- Generation of the matrix L1 (dimension 3x64)

--Compression of all required columns
Comp_L2: for i in 4 to 62 generate 
	-- Columns 4 and 62
	G4 : if (i=4) generate
		HA2_1: HA port map(in1 => L2(0)(i), in2 => L2(1)(i), sum => L1(0)(i), carry_out => L1(0)(i+1)); -- Column 4
		HA2_2: HA port map(in1 => L2(0)(66-i), in2 => L2(1)(66-i), sum => L1(1)(66-i), carry_out => L1(0)(66-i+1)); -- Column 62
	end generate G4;

	-- Columns 5 to 61
	G5_61 : if ((i>4) AND (i<62)) generate
		FA2_c: FA port map(in1 => L2(0)(i), in2 => L2(1)(i), carry_in => L2(2)(i), sum => L1(1)(i), carry_out => L1(0)(i+1));
		L1(N1-1)(i) <= L2(N2-1)(i); -- Report the bit of matrix L2 not used in the FA or HA in the matrix L1
	end generate G5_61;
end generate Comp_L2;

Level1Gen_right : for i in 0 to N1-1 generate
	L1(i)(3 downto 0) <= L2(i)(3 downto 0); -- From column 0 to 3
end generate Level1Gen_right;

C4_63 : for j in 1 to N1-1 generate -- Column 4
	L1(j)(4) <= L2(j+1)(4);
	L1(j)(63) <= L2(j-1)(63); -- Column 63
end generate C4_63;

L1(N1-1)(62) <= L2(N1-1)(62); -- Column 62

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ LEVEL 0 of the DADDA TREE ------
-- Generation of the matrix L0 (dimension 2x64)

--Compression of all required columns
Comp_L1: for i in 2 to 63 generate
	-- Column 2
	G2 : if (i=2) generate
		HA1_1: HA port map(in1 => L1(0)(i), in2 => L1(1)(i), sum => L0(0)(i), carry_out => L0(0)(i+1));
	end generate G2;

	-- Columns 3 to 62
	G3_62 : if ((i>2) AND (i<63)) generate
		FA1_c: FA port map(in1 => L1(0)(i), in2 => L1(1)(i), carry_in => L1(2)(i), sum => L0(1)(i), carry_out => L0(0)(i+1));
	end generate G3_62;

	G63 : if (i=63) generate
		FA1_last: FA port map(in1 => L1(0)(i), in2 => L1(1)(i), carry_in => L1(2)(i), sum => L0(1)(i), carry_out => Cout);
	end generate G63;
end generate Comp_L1;

Level0Gen_right : for i in 0 to N0-1 generate
	L0(i)(1 downto 0) <= L1(i)(1 downto 0); -- Column 0 and column 1
end generate Level0Gen_right;

L0(1)(2) <= L1(2)(2); -- Column 2
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Assign the first row of L0 to the output OP1 
-- Assign the second row of L0 to the output OP2
OP1 <= L0(0);
OP2 <= L0(1);


end structural;
