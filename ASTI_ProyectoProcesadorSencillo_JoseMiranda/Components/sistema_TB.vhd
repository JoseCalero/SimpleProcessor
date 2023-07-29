----------------------------------------------------------------------------------
-- Máster en Microelectrónica: Diseño y Aplicaciones de Sistemas Micro/Nanométricos
-- Asignatura: Aplicaciones, sistemas y técnicas para el tratamiento de la información
-- Course: Applications, systems and techniques for information processing
-- 
-- Create Date:    2014/2015
-- Module Name:    sistema_TB - simulacion
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

use WORK.configuracion.all;

use STD.textio.all;
use IEEE.STD_LOGIC_textio.all;

entity sistema_TB is
end sistema_TB;

architecture simulacion of sistema_TB is

component sistema 
	port (CLK         : in  STD_LOGIC;
		  Reset       : in  STD_LOGIC;
		  ext_sel         : in STD_LOGIC;
		  WR_enable   : in STD_LOGIC;
		  -- buses externos
		  DATABUS_in  : in  STD_LOGIC_VECTOR (31 downto 0);
		  DATABUS_out : out STD_LOGIC_VECTOR (31 downto 0);
		  ADDRBUS     : in STD_LOGIC_VECTOR (31 downto 0));
end component;

signal CLK         :  STD_LOGIC;
signal Reset       :  STD_LOGIC;
signal ext_sel         :  STD_LOGIC;
signal WR_enable   :  STD_LOGIC;
signal DATABUS_in  :  STD_LOGIC_VECTOR (31 downto 0);
signal DATABUS_out :  STD_LOGIC_VECTOR (31 downto 0);
signal ADDRBUS     :  STD_LOGIC_VECTOR (31 downto 0);

signal fin: boolean:=false;

begin

UUT: sistema port map(CLK,Reset,ext_sel,WR_enable,DATABUS_in,DATABUS_out,ADDRBUS);

Test: process
      file TestFile_in    : text is in "programa.txt";
	   variable L          : line;
		variable contador   : integer;
		variable codigo     : string(1 to 4);
		variable registro   : string(1 to 9);
		variable dato       : std_logic_vector(31 downto 0);
		variable caracter   : character;
		variable operando   : integer;
		variable OpCode     : STD_LOGIC_VECTOR(5 downto 0);
      variable Destination: STD_LOGIC_VECTOR(4 downto 0);
      variable SourceA    : STD_LOGIC_VECTOR(4 downto 0);
      variable SourceB    : STD_LOGIC_VECTOR(4 downto 0);
      variable direccion  : STD_LOGIC_VECTOR(15 downto 0);
      variable direccion2 : STD_LOGIC_VECTOR(31 downto 0);
		
		variable finLine    : boolean;
		variable numoperand,numdigit: integer;
	 begin
	   fin <= false;
      reset<='1';
		wait until falling_edge(clk);
		wait until falling_edge(clk);
		
		reset<='0';
		-- Lectura del fichero de datos y escritura en memoria de datos
		ext_sel <= '1'; 
		WR_enable <= '1';
		contador:=CONV_INTEGER(MEM_BASE_ADDRESS);
      while not endfile(TestFile_in) loop
	       readline (TestFile_in,L); -- Se lee del fichero	 
--        read (L,codigo); 
          codigo:="    ";
			 finLine:=false; numdigit:=1;
			 while not finLine loop
			   read (L,caracter);
			   if caracter=';' then finLine:=true;
			   elsif caracter=' ' then finLine:=true;
			   else codigo(numdigit):=caracter; numdigit:=numdigit+1;
			   end if;
			 end loop;
			 
		   case codigo is
		      when "SUM " | "SUB " | "AND " | "OR  " | "XOR " => 
				               case codigo is 
				                  when "SUM " => opcode:="000000";
										when "SUB " => opcode:="000001";
		                        when "AND " => opcode:="000101";
		                        when "OR  " => opcode:="000110";
		                        when "XOR " => opcode:="000111"; 
										when others => opcode:="000000";
									end case;
									
			                  finLine:=false; numoperand:=1; numdigit:=1; registro:=(others=>' ');
			                  while not finLine loop
							        read (L,caracter);
								     if caracter=';' then
								       finLine:=true;
								       operando:=integer'value(registro(1 to numdigit-1));
								       SourceB:= conv_std_logic_vector(operando,5);
								     elsif caracter=' ' then
								       operando:=integer'value(registro(1 to numdigit-1));
								       if numoperand=1 then Destination:= conv_std_logic_vector(operando,5);
								       elsif numoperand=2 then SourceA:= conv_std_logic_vector(operando,5);
								       else SourceB:= conv_std_logic_vector(operando,5); end if;
								       numdigit:=1;
								       numoperand:=numoperand+1;
								     elsif caracter='R' then 
								     else registro(numdigit):=caracter; numdigit:=numdigit+1;
								     end if;
							      end loop;
							      dato:=opcode&Destination&SourceA&SourceB&"00000000000";

		      when "SHR " | "SHL " | "NOT " => 
				               case codigo is 
				                  when "SHR " => opcode:="000010";
		                        when "SHL " => opcode:="000011";
		                        when "NOT " => opcode:="000100";
										when others => opcode:="000000";
									end case;
									
			                  finLine:=false; numoperand:=1; numdigit:=1; registro:=(others=>' ');
			                  while not finLine loop
							        read (L,caracter);
								     if caracter=';' then
								       finLine:=true;
								       operando:=integer'value(registro(1 to numdigit-1));
								       SourceA:= conv_std_logic_vector(operando,5);
								     elsif caracter=' ' then
								       operando:=integer'value(registro(1 to numdigit-1));
								       Destination:= conv_std_logic_vector(operando,5);
								       numdigit:=1;
								       numoperand:=numoperand+1;
								     elsif caracter='R' then 
								     else registro(numdigit):=caracter; numdigit:=numdigit+1;
								     end if;
							      end loop;
							      dato:=opcode&Destination&SourceA&"0000000000000000";


		      when "LD  " => opcode:="001000";
			                  finLine:=false; numoperand:=0; numdigit:=1; registro:=(others=>' ');
			                  while not finLine loop
							        read (L,caracter);
								     if caracter=';' then
								       finLine:=true;
								       operando:=integer'value(registro(1 to numdigit-1));
								       direccion:= conv_std_logic_vector(operando,16);
								     elsif caracter=' ' then
								       operando:=integer'value(registro(1 to numdigit-1));
								       Destination:= conv_std_logic_vector(operando,5);
								       numdigit:=1;
								     elsif caracter='R' then 
								     else registro(numdigit):=caracter; numdigit:=numdigit+1;
								     end if;
							      end loop;
							     dato:=opcode&Destination&"00000"&direccion;
							 
			  when "ST  " => opcode:="001001";
			                  finLine:=false; numoperand:=0; numdigit:=1; registro:=(others=>' ');
			                  while not finLine loop
							        read (L,caracter);
								     if caracter=';' then
								       finLine:=true;
								       operando:=integer'value(registro(1 to numdigit-1));
								       SourceA:= conv_std_logic_vector(operando,5);
								     elsif caracter=' ' then
								       operando:=integer'value(registro(1 to numdigit-1));
								       direccion:= conv_std_logic_vector(operando,16);
								       numdigit:=1;
								     elsif caracter='R' then 
								     else registro(numdigit):=caracter; numdigit:=numdigit+1;
								     end if;
							      end loop;
							     dato:=opcode&"00000"&SourceA&direccion;
							 
		      when "JMP " | "JPC " | "JSR " => 
				               case codigo is 
				                  when "JMP " => opcode:="001010";
		                        when "JPC " => opcode:="001011";
		                        when "JSR " => opcode:="001100";
										when others => opcode:="000000";
									end case;

			                  finLine:=false; numoperand:=0; numdigit:=1; registro:=(others=>' ');
			                  while not finLine loop
							        read (L,caracter);
								     if caracter=';' then
								       finLine:=true;
								       operando:=integer'value(registro(1 to numdigit-1));
								       direccion:= conv_std_logic_vector(operando,16);
								     elsif caracter=' ' then
								     else registro(numdigit):=caracter; numdigit:=numdigit+1;
								     end if;
							      end loop;
							     dato:=opcode&"0000000000"&direccion;

		      when "RTS " => opcode:="001101"; dato:=opcode&"00000000000000000000000000";
		      when "CLC " => opcode:="001110"; dato:=opcode&"00000000000000000000000000";
		      when "SETC" => opcode:="001111"; dato:=opcode&"00000000000000000000000000";
		      when "STOP" => opcode:="010000"; dato:=opcode&"00000000000000000000000000";		  
		      when "NOP " => opcode:="010001"; dato:=opcode&"00000000000000000000000000";
		      when "DATO" => opcode:="111111";
			                  read (L,operando);
			                  direccion2:= conv_std_logic_vector(operando,32);
			                  read (L,operando);
							      dato:=conv_std_logic_vector(operando,32);
							 
		      when others => opcode:="111111";
		   end case;
				   
		   if codigo="DATO" then ADDRBUS <= direccion2+MEM_BASE_ADDRESS;
		   else ADDRBUS <= conv_std_logic_vector(contador,32); end if;
         DATABUS_in <= dato;  -- se escribe el dato de entrada
         wait until falling_edge(clk);
		   contador:=contador+1;
		end loop;

		ext_sel <= '0'; 
      reset<='1';
		wait until falling_edge(clk);
		
		reset<='0';		
		for i in 0 to 200 loop
           wait until falling_edge(clk);
		end loop;
		
		fin <= true;
		wait;
	  end process;

Reloj: process
       begin
	     while not fin loop
		   clk<='0'; wait for 1 ns;
		   clk<='1'; wait for 1 ns;
		 end loop;
		 wait;
	   end process;
	   
end simulacion;

