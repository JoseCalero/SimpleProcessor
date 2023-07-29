
----------------------------------------------------------------------------------
-- Máster en Microelectrónica: Diseño y Aplicaciones de Sistemas Micro/Nanométricos
-- Asignatura: Aplicaciones, sistemas y técnicas para el tratamiento de la información
-- Course: Applications, systems and techniques for information processing
-- 
-- Create Date:    2014/2015
-- Module Name:    file_register - Behavioral 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity file_register is
    Port ( clock        : in  STD_LOGIC;
           ram_enable   : in  STD_LOGIC;
           write_enable : in  STD_LOGIC;
           address_write: in  STD_LOGIC_VECTOR (4 downto 0);
           addressA     : in  STD_LOGIC_VECTOR (4 downto 0);
           addressB     : in  STD_LOGIC_VECTOR (4 downto 0);
           data_input   : in  STD_LOGIC_VECTOR (31 downto 0);
           data_outputA : out STD_LOGIC_VECTOR (31 downto 0);
           data_outputB : out STD_LOGIC_VECTOR (31 downto 0));
end file_register;

architecture Behavioral of file_register is
-- Definir aqui señales, tipos, funciones, etc 
	type file_type is array (31 downto 0) of STD_LOGIC_VECTOR (31 downto 0);
	signal file_reg: file_type := ((others=> (others=>'0')));
	
	--Registro para guardar las direcciones de lectura:
	signal addr_regA : STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
	signal addr_regB : STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
-- Fin de definiciones
begin
-- Iniciar aquí la descripción 
	process( clock )
	begin
		if( clock = '1' ) then
		
			if( ram_enable = '1' ) then
			
				if( write_enable = '1' ) then
					
					if( address_write /= "00000" ) then
				
						file_reg( conv_integer( address_write )) <= data_input;
						
					end if;
					
				else
				
					addr_regA <= addressA;
					addr_regB <= addressB;
					
				end if;
				
			end if;			
			
		end if;
	
	end process;
	
	data_outputA <= file_reg( conv_integer( addr_regA ));
	data_outputB <= file_reg( conv_integer( addr_regB ));

-- Fin de la descripción

end Behavioral;


