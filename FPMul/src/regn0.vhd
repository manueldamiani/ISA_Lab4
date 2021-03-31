library ieee;
use ieee.std_logic_1164.all;

entity regn0 is
	port( D: in std_logic;
		  CLK: in std_logic;
		  Q: out std_logic);
end regn0;

architecture bhv of regn0 is

begin
	reg_proc: process(CLK)
		begin
			if(CLK = '1' AND CLK'event) then
				Q <= D;
			end if;
	end process reg_proc;

end bhv;
