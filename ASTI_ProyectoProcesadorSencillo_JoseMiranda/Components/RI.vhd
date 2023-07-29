----------------------------------------------------------------------------------
-- Máster en Microelectrónica: Diseño y Aplicaciones de Sistemas Micro/Nanométricos
-- Asignatura: Aplicaciones, sistemas y técnicas para el tratamiento de la información
-- Course: Applications, systems and techniques for information processing
-- 
-- Create Date:    2014/2015
-- Module Name:    RI -  funcional
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

use WORK.configuracion.all;

entity RI is
	port (CLK   : in  STD_LOGIC;
		  Reset : in  STD_LOGIC;
		  Load  : in  STD_LOGIC;
		  Din   : in  STD_LOGIC_VECTOR (31 downto 0);
		  Dout  : out STD_LOGIC_VECTOR (31 downto 0));
end RI;

architecture funcional of RI is
-- Definir aqui señales, tipos, funciones, etc 

-- Fin de definiciones
begin
-- Iniciar aquí la descripción 
PC: process ( CLK )
		begin
			if( rising_edge(CLK) and Reset = '0' ) then
				
				-- Operación de carga del RI
				if( Load = '1' ) then
					
					--if( Din >= MEM_BASE_ADDRESS and Din <= MEM_HIGH_ADDRESS )then
						Dout <= Din;
					--end if;
				end if;
				
			elsif( Reset = '1' ) then
		
				-- El RI es re-inicializado.
				Dout <= MEM_BASE_ADDRESS;
				
			end if;
	end process;
-- Fin de la descripción
end funcional;

	
