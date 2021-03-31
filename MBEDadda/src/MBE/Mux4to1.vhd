library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use WORK.constants.all;
use WORK.all;

entity Mux4to1 is
    Port ( SEL : in  STD_LOGIC_VECTOR (1 downto 0);   -- select input
           IN1 : in  STD_LOGIC_VECTOR (N downto 0);   -- input
	   IN2 : in  STD_LOGIC_VECTOR (N downto 0);   -- input
	   IN3 : in  STD_LOGIC_VECTOR (N downto 0);   -- input
	   IN4 : in  STD_LOGIC_VECTOR (N downto 0);   -- input
           Q   : out STD_LOGIC_VECTOR (N downto 0)); -- output
end Mux4to1;

architecture Behavioral of Mux4to1 is
begin

mux: process(IN1, IN2, IN3, IN4, SEL)
	begin
 	case SEL is
		when "00" => Q<=IN1 ;
  		when "01" => Q<=IN2 ;
  		when "10" => Q<=IN3 ;
		when "11" => Q<=IN4 ;
		when others =>  Q<=IN1;
  	end case;
	end process;
end Behavioral;
