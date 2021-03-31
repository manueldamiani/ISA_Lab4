library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use WORK.constants.all;
use WORK.all;

entity HA is
  port (in1  : in std_logic;
    	in2  : in std_logic;
   	sum   : out std_logic;
    	carry_out : out std_logic);
end HA;
 
architecture structural of HA is
begin
  sum   <= in1 XOR in2;
  carry_out <= in1 AND in2;
end structural;
