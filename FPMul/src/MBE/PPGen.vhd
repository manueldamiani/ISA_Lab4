library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use WORK.constants.all;
use WORK.all;

ENTITY PPgen IS

   PORT( 
      	A : IN     std_logic_vector (N-1 DOWNTO 0);
      	B : IN     std_logic_vector (N-1 DOWNTO 0);
      	P0  : OUT    std_logic_vector (36 DOWNTO 0);
	P1  : OUT    std_logic_vector (36 DOWNTO 0);
	P2  : OUT    std_logic_vector (36 DOWNTO 0);
      	P3  : OUT    std_logic_vector (36 DOWNTO 0);
	P4  : OUT    std_logic_vector (36 DOWNTO 0);
	P5  : OUT    std_logic_vector (36 DOWNTO 0);
     	P6  : OUT    std_logic_vector (36 DOWNTO 0);
	P7  : OUT    std_logic_vector (36 DOWNTO 0);
	P8  : OUT    std_logic_vector (36 DOWNTO 0);
     	P9  : OUT    std_logic_vector (36 DOWNTO 0);
	P10 : OUT    std_logic_vector (36 DOWNTO 0);
	P11 : OUT    std_logic_vector (36 DOWNTO 0);
      	P12 : OUT    std_logic_vector (36 DOWNTO 0);
	P13 : OUT    std_logic_vector (36 DOWNTO 0);
	P14 : OUT    std_logic_vector (36 DOWNTO 0);
      	P15 : OUT    std_logic_vector (36 DOWNTO 0);
	P16 : OUT    std_logic_vector (36 DOWNTO 0)
   );

END PPgen ;

architecture structural of PPgen is

component QjGen is
    Port ( A : in std_logic_vector(N-1 downto 0);
	   b2m1 : in  STD_LOGIC;   -- input
	   b2 : in  STD_LOGIC;   -- input
	   b2p1 : in  STD_LOGIC;   -- input	   
           Qj  : out STD_LOGIC_VECTOR (N downto 0)); -- output
end component;

type tmp_product is array (0 to (N/2)-1) of std_logic_vector(N downto 0); 
type product is array (0 to N/2) of std_logic_vector(N+4 downto 0);
type q is array (0 to N/2) of std_logic_vector(N downto 0);
type sign is array (0 to N/2) of std_logic;

SIGNAL p_tmp16 : std_logic_vector(N-1 downto 0);-- partial product p16 (one bit less than the others)
SIGNAL p_tmp : tmp_product; --array of 16 elements for the partial products p0,...,p15
SIGNAL p: product; -- array for the partial products p0,...,p16 after the extension operation
SIGNAL extB : std_logic_vector(N+2 downto 0); --Extension for the B operand on 35 bits (0&0&B&0)
SIGNAL qj : q;-- array for qj that can be 0, A or 2A
SIGNAL S : sign; -- array of signs used for the sign extesion (it is equal to 0 if the partial product 
		 -- is positive, otherwise it is negative)

begin

extB <= '0'&'0'& B & '0';

-- Generation of qj contributions
Qjgeneration: for j in 0 to N/2 generate
	--Using the QjGen component, each qj is computed
	--Since we add b_1 =0, instead of taking the indexes 2j+1, 2j, 2j-1 , we take 2j+2, 2j+1, 2j
	qj_gen : QjGen port map(A=>A, b2m1 =>extB(2*j),b2=>extB(2*j+1), b2p1=>extB(2*j+2), Qj => qj(j));
end generate Qjgeneration;


--Generation of the partial product
PP_tmpGeneration: for k in 0 to N/2 generate
	-- for the last partial product p16, it is not needed to perform the formula pj=(b2j+2 XOR qj)+ b2j+2
	-- since the MSB of extended B is always 0, so the partial product pj is equal to qj
	p_tmp16generate: if(k=16) generate
		p_tmp16 <= qj(k)(N-1 downto 0); 
	end generate p_tmp16generate;

	-- for the partial products p0,...,p15 the formula 
	-- pj=(b2j+2 XOR qj) is performed
	p_tmpgenerate: if(k/=16) generate
		p_tmp_gen:for i in 0 to N generate
			p_tmp(k)(i) <= (extB(2*k+2) XOR qj(k)(i));
		end generate p_tmp_gen;
	end generate p_tmpgenerate;
end generate PP_tmpGeneration;

--Generation of the signs bits
SGeneration: for k in 0 to N/2 generate
	--the sign bit is equal to the MSB of the triplet 
	--(b2j+2, b2j+1, b2j) extracted from the extended B
	S(k) <= extB(2*k+2);
end generate SGeneration;

--Generation of the partial products with the sign extension
PPGeneration:for k in 0 to N/2 generate
	--Sign extension
	Gen0: if(k=0) generate
		p(k) <= '0' & NOT(S(k)) & S(k) & S(k) & p_tmp(k);
	end generate Gen0;

	Gen15: if(k=15) generate
		p(k) <= '0' & NOT(S(k)) & p_tmp(k) & '0' & S(k-1);
	end generate Gen15;

	Gen16: if(k=16) generate
		p(k) <= '0' & '0' &'0' & p_tmp16 & '0' & S(k-1);
	end generate Gen16;
	
	Gen: if(k/=0 AND k/=15 AND k/=16) generate
		p(k) <= '1' & NOT(S(k)) & p_tmp(k) & '0' & S(k-1);
	end generate Gen;
end generate PPGeneration;

P0<= p(0);
P1<= p(1);
P2<= p(2);
P3<= p(3);
P4<= p(4);
P5<= p(5);
P6<= p(6);
P7<= p(7);
P8<= p(8);
P9<= p(9);
P10<= p(10);
P11<= p(11);
P12<= p(12);
P13<= p(13);
P14<= p(14);
P15<= p(15);
P16<= p(16);

end structural;





