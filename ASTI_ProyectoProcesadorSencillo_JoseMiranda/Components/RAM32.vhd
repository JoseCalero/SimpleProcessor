----------------------------------------------------------------------------------
-- Máster en Microelectrónica: Diseño y Aplicaciones de Sistemas Micro/Nanométricos
-- Asignatura: Aplicaciones, sistemas y técnicas para el tratamiento de la información
-- Course: Applications, systems and techniques for information processing
-- 
-- Create Date:    2014/2015
-- Module Name:    RAM_single_port - Behavioral 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity RAM_single_port is
    generic (N: integer:=32;   -- memory width
             M: integer:=10); -- address width
    Port ( clock       : in  STD_LOGIC;
           ram_enable  : in  STD_LOGIC;
           write_enable: in  STD_LOGIC;
           address     : in  STD_LOGIC_VECTOR (M-1 downto 0);
           data_input  : in  STD_LOGIC_VECTOR (N-1 downto 0);
           data_output : out STD_LOGIC_VECTOR (N-1 downto 0);
	   dvalid      : out STD_LOGIC);
end RAM_single_port;

architecture Behavioral of RAM_single_port is
  type memory_type is array ((2**M)-1 downto 0) of STD_LOGIC_VECTOR (N-1 downto 0);
  signal memory : memory_type;

  --Register to hold the address
  signal addr_reg : STD_LOGIC_VECTOR (M-1 downto 0) := (others => '0');
begin
-- Iniciar aquí la descripción del comportamiento de la memoria RAM
	process( clock )
	begin
		if( clock = '1' ) then
		
			if( ram_enable = '1' ) then
			
				if( write_enable = '1' ) then

					dvalid <= '0';
					memory( conv_integer( address )) <= data_input;
					
				else
					dvalid <= '1';
					addr_reg <= address;
					
				end if;
				
			end if;			
			
		end if;
	
	end process;
	
	data_output <= memory( conv_integer( addr_reg));

-- Fin de la descripción
end Behavioral;
