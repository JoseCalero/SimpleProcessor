----------------------------------------------------------------------------------
-- Máster en Microelectrónica: Diseño y Aplicaciones de Sistemas Micro/Nanométricos
-- Asignatura: Aplicaciones, sistemas y técnicas para el tratamiento de la información
-- Course: Applications, systems and techniques for information processing
-- 
-- Create Date:    2014/2015
-- Module Name:    alu -  funcional
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity alu is
   port (Rin, Sin :   In  std_logic_vector (31 downto 0); -- Entrada de datos
         Cin      :   In  std_logic;                       -- Entrada de acarreo
         Fout     :   Out std_logic_vector (31 downto 0); -- Salida de datos
         Cout     :   Out std_logic;                       -- Salida de acarreo
         Cero     :   Out std_logic;                       -- Salida de resultado igual a cero
         Control  :   In  std_logic_vector (2 downto 0));  -- Entradas de control de operacion
end alu;

architecture funcional of alu is
-- Definir aqui señales, tipos, funciones, etc 
-- Fin de definiciones
begin
-- Iniciar aquí la descripción 
	process( Control,Rin,Sin,Cin ) is
	variable temp: std_logic_vector(32 downto 0):= (others => '0');
	begin
		case Control is
		
			when "000"=> -- Suma
				temp := ('0' & Rin) + Sin + Cin;
				Fout <= temp(31 downto 0);
				Cout <= temp(32);
				if( temp(31 downto 0) = 0 ) then
					Cero <= '1';
				else
					Cero <= '0';
				end if;
				
			when "001"=> -- Resta
				temp := ('0' & Rin) - Sin - Cin;
				Fout <= temp(31 downto 0);
				Cout <= temp(32);
				if( temp(31 downto 0) = 0 ) then
					Cero <= '1';
				else
					Cero <= '0';
				end if;
				
			when "010"=> -- Rotación a la Drch
				Fout <= Cin & Rin(31 downto 1);
				Cout <= Rin(0);
				
			when "011"=> -- Rotación a la Izq
				Fout <= Rin(30 downto 0) & Cin;
				Cout <= Rin(31);
				
			when "100"=> -- NOT
				Fout <= not Rin;
				
			when "101"=> -- AND
				Fout <= Rin and Sin;
				
			when "110"=> -- OR
				Fout <= Rin or Sin;
				
			when "111"=> -- XOR
				Fout <= Rin xor Sin;
				
			when others => --nothing
				Fout <= (others => '0');
				
		end case;
	end process;
-- Fin de la descripción
end funcional;




