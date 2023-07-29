----------------------------------------------------------------------------------
-- M�ster en Microelectr�nica: Dise�o y Aplicaciones de Sistemas Micro/Nanom�tricos
-- Asignatura: Aplicaciones, sistemas y t�cnicas para el tratamiento de la informaci�n
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
-- Definir aqui se�ales, tipos, funciones, etc 

-- Fin de definiciones
begin
-- Iniciar aqu� la descripci�n 
	PC: process ( CLK )
	variable ProgramCounter: std_logic_vector(31 downto 0):= MEM_BASE_ADDRESS;
		begin
			if( rising_edge(CLK) and Reset = '0' ) then
				
				-- Operaci�n de carga del ProgramCounter
				if( Load = '1' ) then
					
					if( Din >= MEM_BASE_ADDRESS and Din <= MEM_HIGH_ADDRESS )then
						ProgramCounter := Din;
						Dout <= ProgramCounter;						
					end if;
				
				-- Operaci�n de incremento del ProgramCounter
				elsif( Cuenta = '1' ) then
					ProgramCounter := ProgramCounter + 1;
					
					-- En el caso en el que el contador de programa
					-- llegue al m�ximo de direcciones posible, se
					-- resetea autom�ticamente ( caracter�stica implementada
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
-- Fin de la descripci�n
end funcional;

	
