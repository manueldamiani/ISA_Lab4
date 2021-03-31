library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use WORK.constants.all;
use WORK.all;

entity FA is
  port (in1  : in std_logic;
    	in2  : in std_logic;
	carry_in : in std_logic;
   	sum   : out std_logic;
    	carry_out : out std_logic);
end FA;
 
architecture structural of FA is
begin
  sum   <= in1 XOR in2 XOR carry_in;
  carry_out <= (in1 AND in2) OR (in1 AND carry_in) OR (in2 AND carry_in);
end structural;
