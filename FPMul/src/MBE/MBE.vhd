library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use WORK.constants.all;
use WORK.all;

ENTITY MBE IS
   PORT(A : IN     std_logic_vector (N-1 DOWNTO 0);
      	B : IN     std_logic_vector (N-1 DOWNTO 0);
      	P  : OUT    std_logic_vector (2*N-1 DOWNTO 0));
END MBE;

architecture structural of MBE is

component PPgen IS
   PORT(A : IN     std_logic_vector (N-1 DOWNTO 0);
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
	P16 : OUT    std_logic_vector (36 DOWNTO 0));
END component ;

component Dadda IS
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
	OP2 : OUT    std_logic_vector (63 DOWNTO 0));
END component ;

signal PP0s  :    std_logic_vector (36 DOWNTO 0);
signal PP1s  :     std_logic_vector (36 DOWNTO 0);
signal PP2s  :     std_logic_vector (36 DOWNTO 0);
signal PP3s  :     std_logic_vector (36 DOWNTO 0);
signal PP4s  :     std_logic_vector (36 DOWNTO 0);
signal PP5s  :     std_logic_vector (36 DOWNTO 0);
signal PP6s  :     std_logic_vector (36 DOWNTO 0);
signal PP7s :     std_logic_vector (36 DOWNTO 0);
signal PP8s  :     std_logic_vector (36 DOWNTO 0);
signal	PP9s  :     std_logic_vector (36 DOWNTO 0);
signal PP10s :     std_logic_vector (36 DOWNTO 0);
signal PP11s :     std_logic_vector (36 DOWNTO 0);
signal 	PP12s :     std_logic_vector (36 DOWNTO 0);
signal PP13s :     std_logic_vector (36 DOWNTO 0);
signal PP14s :     std_logic_vector (36 DOWNTO 0);
signal 	PP15s :     std_logic_vector (36 DOWNTO 0);
signal PP16s :     std_logic_vector (36 DOWNTO 0);
signal OP1s :     std_logic_vector (63 DOWNTO 0);
signal OP2s :     std_logic_vector (63 DOWNTO 0);

begin

PP : PPGen port map (	A => A,
		      	B => B,
		      	P0 => PP0s,
			P1 => PP1s,
			P2 => PP2s,
		      	P3 => PP3s,
			P4 => PP4s,
			P5 => PP5s,
		     	P6 => PP6s,
			P7 => PP7s,
			P8 => PP8s,
		     	P9 => PP9s,
			P10 => PP10s,
			P11 => PP11s,
		      	P12 => PP12s,
			P13 => PP13s,
			P14 => PP14s,
		      	P15 => PP15s,
			P16 => PP16s);

D : Dadda port map ( 	PP0 => PP0s,
			PP1 => PP1s,
			PP2 => PP2s,
		      	PP3 => PP3s,
			PP4 => PP4s,
			PP5 => PP5s,
		     	PP6 => PP6s,
			PP7 => PP7s,
			PP8 => PP8s,
		     	PP9 => PP9s,
			PP10 => PP10s,
			PP11 => PP11s,
		      	PP12 => PP12s,
			PP13 => PP13s,
			PP14 => PP14s,
		      	PP15 => PP15s,
			PP16 => PP16s,
			OP1 => OP1s,
			OP2 => OP2s);

P <= OP1s+OP2s;


end structural;
