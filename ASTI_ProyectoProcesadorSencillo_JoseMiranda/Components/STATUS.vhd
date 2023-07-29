----------------------------------------------------------------------------------
-- Máster en Microelectrónica: Diseño y Aplicaciones de Sistemas Micro/Nanométricos
-- Asignatura: Aplicaciones, sistemas y técnicas para el tratamiento de la información
-- Course: Applications, systems and techniques for information processing
-- 
-- Create Date:    2014/2015
-- Module Name:    STATUS - estructura
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity STATUS is
	port (CLK         : in  STD_LOGIC;
		  Reset       : in  STD_LOGIC;
		  -- acarreo
 		 STAT_C_load : in std_logic;
 		 STAT_C_Set  : in std_logic;
 		 STAT_C_Clear: in std_logic;
 		 STAT_C_in   : in std_logic;
 		 STAT_C_out  : out std_logic;
		 -- indicador de cero
 		 STAT_Z_load : in std_logic;
 		 STAT_Z_in   : in std_logic;
		 STAT_Z_out  : out std_logic;
         -- stack pointer
 		 STAT_SPF_load: in std_logic;
 		 STAT_SPF_in: in std_logic;
 		 STAT_SPF_out: out std_logic;
		 
 		 STAT_SPE_load: in std_logic;
 		 STAT_SPE_in: in std_logic;
 		 STAT_SPE_out: out std_logic);
end STATUS;

architecture estructura of STATUS is
-- Definir aqui señales, tipos, funciones, etc 

-- Fin de definiciones
begin
-- Iniciar aquí la descripción 
STAT_C: process ( CLK )
		begin
			if( rising_edge(CLK) and Reset = '0' ) then
				-- Operación de escritura del biestable STAT_C
				if( STAT_C_load = '1' ) then
					if( STAT_C_Set = '1' and STAT_C_Clear = '0' ) then
						STAT_C_out <= '1';
					elsif( STAT_C_Clear = '1' and STAT_C_Set = '0' ) then
						STAT_C_out <= '0';
					else
						STAT_C_out <= STAT_C_in;
					end if;
				end if;
			elsif( Reset = '1' ) then
				STAT_C_out <= '0'; 
			end if;
	end process;
	
STAT_Z: process ( CLK )
		begin
			if( rising_edge(CLK) and Reset = '0' ) then
				-- Operación de escritura del biestable STAT_Z
				if( STAT_Z_load = '1' ) then
					STAT_Z_out <= STAT_Z_in;
				end if;
			elsif( Reset = '1' ) then
				STAT_Z_out <= '0';
			end if;
	end process;
	
STAT_FULL: process ( CLK )
		begin
			if( rising_edge(CLK) and Reset = '0' ) then
				-- Operación de escritura del biestable STAT_FULL
				if( STAT_SPF_load = '1' ) then
					STAT_SPF_out <= STAT_SPF_in;
				end if;
			elsif( Reset = '1' ) then
				STAT_SPF_out <= '0';
			end if;
	end process;
	
STAT_EMPTY: process ( CLK )
		begin
			if( rising_edge(CLK) and Reset = '0' ) then
				-- Operación de escritura del biestable STAT_EMPTY
				if( STAT_SPE_load = '1' ) then
					STAT_SPE_out <= STAT_SPE_in;
				end if;
			elsif( Reset = '1' ) then
				STAT_SPE_out <= '0';
			end if;
	end process;
-- Fin de la descripción
end estructura;

