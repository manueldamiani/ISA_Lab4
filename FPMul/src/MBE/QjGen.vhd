library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use WORK.constants.all;
use WORK.all;

entity QjGen is
    Port ( A : in std_logic_vector(N-1 downto 0);
	   b2m1 : in  STD_LOGIC;   -- input
	   b2 : in  STD_LOGIC;   -- input
	   b2p1 : in  STD_LOGIC;   -- input	   
           Qj  : out STD_LOGIC_VECTOR (N downto 0)); -- output
end QjGen;

architecture structural of QjGen is

  component Mux4to1 is
    Port ( SEL : in  STD_LOGIC_VECTOR (1 downto 0);   -- select input
           IN1 : in  STD_LOGIC_VECTOR (N downto 0);   -- input
	   IN2 : in  STD_LOGIC_VECTOR (N downto 0);   -- input
	   IN3 : in  STD_LOGIC_VECTOR (N downto 0);   -- input
	   IN4 : in  STD_LOGIC_VECTOR (N downto 0);   -- input
           Q   : out STD_LOGIC_VECTOR (N downto 0)); -- output
  end component;

  component MuxSel is
    Port ( IN2m1 : in  STD_LOGIC;   -- input
	   IN2 : in  STD_LOGIC;   -- input
	   IN2p1 : in  STD_LOGIC;   -- input	   
           Q  : out STD_LOGIC_VECTOR (1 downto 0)); -- output
  end component;

	SIGNAL extA : std_logic_vector(N downto 0);
	SIGNAL twoA : std_logic_vector(N downto 0);
	SIGNAL zeros : std_logic_vector(N downto 0);
	SIGNAL MuxSelSig : std_logic_vector(1 downto 0);

begin
	
	zeros <= (others => '0');
	extA <= '0' & A;
	twoA <= A & '0';

	MuxSelSignal : MuxSel PORT MAP(IN2m1=>b2m1, IN2=>b2, IN2p1=>b2p1, Q=>MuxSelSig);

	Mux : Mux4to1 PORT MAP(SEL=>MuxSelSig, IN1=>zeros, IN2=>extA, IN3=>twoA, IN4=>zeros, Q=>Qj);
end structural;
