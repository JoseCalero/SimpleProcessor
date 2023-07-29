----------------------------------------------------------------------------------
-- Máster en Microelectrónica: Diseño y Aplicaciones de Sistemas Micro/Nanométricos
-- Asignatura: Aplicaciones, sistemas y técnicas para el tratamiento de la información
-- Course: Applications, systems and techniques for information processing
-- 
-- Create Date:    2014/2015
-- Module Name:    SP -  funcional
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

use WORK.configuracion.all;

entity SP is
	port (CLK   : in  STD_LOGIC;
		  Reset : in  STD_LOGIC;
		  Up    : in  STD_LOGIC;
		  Down  : in  STD_LOGIC;
		  Load  : in  STD_LOGIC;
		  Din   : in  STD_LOGIC_VECTOR (31 downto 0);
		  Dout  : out STD_LOGIC_VECTOR (31 downto 0);
		  full  : out STD_LOGIC;
		  empty : out STD_LOGIC);
end SP;

architecture funcional of SP is
-- Definir aqui señales, tipos, funciones, etc 
-- Fin de definiciones
begin
-- Iniciar aquí la descripción 
	SP: process ( CLK )
	variable stackPointer: std_logic_vector(31 downto 0):= STACK_BASE_ADDRESS;
		begin
			if( rising_edge(CLK) and Reset = '0' ) then
			
				if( Load = '1' ) then
					-- Operación de carga del SP
					if( Din >= STACK_BASE_ADDRESS and Din <= STACK_HIGH_ADDRESS )then
						stackPointer := Din;
						Dout <= stackPointer;
						if( Din = STACK_BASE_ADDRESS ) then
							full  <= '0';
							empty <= '1';
						elsif( Din = STACK_HIGH_ADDRESS ) then
							full  <= '1';
							empty <= '0';
						else
							full  <= '0';
							empty <= '0';
						end if;
						
					end if;
					
				end if;
					
					-- Operación de incremento del SP.
				if( Up = '1' and Down = '0' ) then
					if( stackPointer = STACK_HIGH_ADDRESS ) then
						full <= '1';
					else
						stackPointer := stackPointer + 1;
						Dout <= stackPointer;
						full  <= '0';
						empty <= '0';
					end if;					
				end if;
				
				-- Operación de decremento del SP.
				if( Down = '1' and Up = '0' ) then
					if( stackPointer = STACK_BASE_ADDRESS ) then
						empty <= '1';
					else
						stackPointer := stackPointer - 1;
						Dout <= stackPointer;
						empty <= '0';
						full  <= '0';
					end if;	
				end if;
				
			elsif( Reset = '1' ) then
			
				-- El SP es re-inicializado.
				stackPointer := STACK_BASE_ADDRESS;
				full  <= '0';
				empty <= '1';
				Dout <= stackPointer;
				
			end if;
	end process;
	
-- Fin de la descripción
end funcional;

	
