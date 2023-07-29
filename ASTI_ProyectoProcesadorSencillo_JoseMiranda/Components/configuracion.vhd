----------------------------------------------------------------------------------
-- Máster en Microelectrónica: Diseño y Aplicaciones de Sistemas Micro/Nanométricos
-- Asignatura: Aplicaciones, sistemas y técnicas para el tratamiento de la información
-- Course: Applications, systems and techniques for information processing
-- 
-- Create Date:    2014/2015
-- Package Name:    config
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

package configuracion is

constant STACK_BASE_ADDRESS: std_logic_vector(31 downto 0):=x"00001100";
constant STACK_HIGH_ADDRESS: std_logic_vector(31 downto 0):=x"000013FF";

constant MEM_BASE_ADDRESS: std_logic_vector(31 downto 0):=x"00001000";
constant MEM_HIGH_ADDRESS: std_logic_vector(31 downto 0):=x"000013FF";

end package;



	
