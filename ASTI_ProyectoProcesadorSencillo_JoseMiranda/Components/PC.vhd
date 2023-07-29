----------------------------------------------------------------------------------
-- Máster en Microelectrónica: Diseño y Aplicaciones de Sistemas Micro/Nanométricos
-- Asignatura: Aplicaciones, sistemas y técnicas para el tratamiento de la información
-- Course: Applications, systems and techniques for information processing
-- 
-- Create Date:    2014/2015
-- Module Name:    PC -  funcional
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

use WORK.configuracion.all;

entity PC is
	port (CLK   : in  STD_LOGIC;
		  Reset : in  STD_LOGIC;
		  Cuenta: in  STD_LOGIC;
		  Load  : in  STD_LOGIC;
		  Din   : in  STD_LOGIC_VECTOR (31 downto 0);
		  Dout  : out STD_LOGIC_VECTOR (31 downto 0));
end PC;

architecture funcional of PC is
-- Definir aqui señales, tipos, funciones, etc 

-- Fin de definiciones
begin
-- Iniciar aquí la descripción 
	PC: process ( CLK )
	variable ProgramCounter: std_logic_vector(31 downto 0):= MEM_BASE_ADDRESS;
		begin
			if( rising_edge(CLK) and Reset = '0' ) then
				
				-- Operación de carga del ProgramCounter
				if( Load = '1' ) then
					
					if( Din >= MEM_BASE_ADDRESS and Din <= MEM_HIGH_ADDRESS )then
						ProgramCounter := Din;
						Dout <= ProgramCounter;						
					end if;
				
				-- Operación de incremento del ProgramCounter
				elsif( Cuenta = '1' ) then
					ProgramCounter := ProgramCounter + 1;
					
					-- En el caso en el que el contador de programa
					-- llegue al máximo de direcciones posible, se
					-- resetea automáticamente ( característica implementada
					-- adicionalmente por el usuario, no especificada en el
					-- documento ).
					if ( ProgramCounter > MEM_HIGH_ADDRESS ) then
						ProgramCounter := MEM_BASE_ADDRESS;
					end if;
					
					Dout <= ProgramCounter;				
				end if;
			elsif( Reset = '1' ) then
			
				-- El ProgramCounter es re-inicializado.
				ProgramCounter := MEM_BASE_ADDRESS;
				Dout <= ProgramCounter;
				
			end if;
	end process;
-- Fin de la descripción
end funcional;

	
