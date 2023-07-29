------------------------------------------------------------------------------
--  File: mux.vhd
------------------------------------------------------------------------------
--Multiplexer design
--Control signal is CONT_SIG
--The output is chosen from 3 signals with length 32 bits

library IEEE;
use IEEE.std_logic_1164.all;

--Multiplexer entity
entity mux3to1 is
		port( A_IN: in std_logic_vector( 31 downto 0 );
			  B_IN: in std_logic_vector( 31 downto 0 );
			  C_IN: in std_logic_vector( 31 downto 0 );
              CONT_SIG: in std_logic_vector(1 downto 0);
              OUT_SIG: out std_logic_vector( 31 downto 0 ));
end mux3to1;

Architecture behavioral of mux3to1 is
begin


Process(CONT_SIG,A_IN,B_IN,C_IN)
variable temp:std_logic_vector( 31 downto 0 );

Begin

case CONT_SIG is

when "00" => temp:=A_IN;
when "01" => temp:=B_IN;
when "10" => temp:=C_IN;
when Others => temp:=temp;

end case;

OUT_SIG<=temp;

end Process;
end behavioral;
