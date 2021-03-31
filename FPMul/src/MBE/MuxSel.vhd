library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use WORK.constants.all;
use WORK.all;

entity MuxSel is
    Port ( IN2m1 : in  STD_LOGIC;   -- input
	   IN2 : in  STD_LOGIC;   -- input
	   IN2p1 : in  STD_LOGIC;   -- input	   
           Q  : out STD_LOGIC_VECTOR (1 downto 0)); -- output
end MuxSel;

architecture Behavioral of MuxSel is
	
begin

muxsel: process(IN2m1,IN2,IN2p1)

	VARIABLE cond0 : std_logic;
	VARIABLE condA : std_logic;
	VARIABLE cond2A : std_logic;

	begin

	cond0 := ((NOT(IN2 XOR IN2m1)) AND (NOT(IN2p1 XOR IN2)));
	condA := (IN2 XOR IN2m1);
	cond2A :=((NOT(IN2 XOR IN2m1)) AND (IN2p1 XOR IN2));

 	if (cond0 = '1') then
		Q <= "00";
	elsif (condA = '1') then
		Q <= "01";
	elsif (cond2A = '1') then
		Q <= "10";
	else 
		Q <= "00";
	end if;
	end process;
end Behavioral;
