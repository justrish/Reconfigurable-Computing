library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ltecomp is
	generic (
		width : positive:=8 );
	port (
		in1 : in std_logic_vector(width -1 downto 0);
		in2 : in std_logic_vector(width -1 downto 0);
		result : out std_logic
		);
end ltecomp;

architecture BHV of ltecomp is
begin 
	process (in1,in2)
	begin
		if ( unsigned(in1) <= unsigned(in2)) then
			result <= '1';
		--elsif if ( unsigned(in1) = unsigned(in2))
		--	result <= 1;
		else 
			result <= '0';
		end if; 
	end process;
end BHV;