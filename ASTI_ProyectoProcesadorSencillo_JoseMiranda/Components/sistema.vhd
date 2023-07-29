----------------------------------------------------------------------------------
-- Máster en Microelectrónica: Diseño y Aplicaciones de Sistemas Micro/Nanométricos
-- Asignatura: Aplicaciones, sistemas y técnicas para el tratamiento de la información
-- Course: Applications, systems and techniques for information processing
-- 
-- Create Date:    2014/2015
-- Module Name:    sistema - estructura
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

use WORK.configuracion.all;

entity sistema is
	port (CLK         : in  STD_LOGIC;
		  Reset       : in  STD_LOGIC;
		  ext_sel         : in STD_LOGIC;
		  WR_enable   : in STD_LOGIC;
		  -- buses externos
		  DATABUS_in  : in  STD_LOGIC_VECTOR (31 downto 0);
		  DATABUS_out : out STD_LOGIC_VECTOR (31 downto 0);
		  ADDRBUS     : in STD_LOGIC_VECTOR (31 downto 0));
end sistema;

architecture estructura of sistema is

component PSM
	port (CLK         : in  STD_LOGIC;
		  Reset       : in  STD_LOGIC;
		  WR_enable   : out STD_LOGIC;
        dvalid      : in STD_LOGIC;
		  -- buses externos
		  DATABUS_in  : in  STD_LOGIC_VECTOR (31 downto 0);
		  DATABUS_out : out STD_LOGIC_VECTOR (31 downto 0);
		  ADDRBUS     : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component RAM_single_port 
    generic (N: integer:=8;   -- memory width
             M: integer:=1024); -- address width
    Port ( clock       : in  STD_LOGIC;
           ram_enable  : in  STD_LOGIC;
           write_enable: in  STD_LOGIC;
           address     : in  STD_LOGIC_VECTOR (M-1 downto 0);
           data_input  : in  STD_LOGIC_VECTOR (N-1 downto 0);
           data_output : out STD_LOGIC_VECTOR (N-1 downto 0);
			  dvalid      : out STD_LOGIC);
end component;

-- Señales del procesador
signal PSM_WR_enable   :  STD_LOGIC;
signal PSM_DATABUS_in  :  STD_LOGIC_VECTOR (31 downto 0);
signal PSM_DATABUS_out :  STD_LOGIC_VECTOR (31 downto 0);
signal PSM_ADDRBUS     :  STD_LOGIC_VECTOR (31 downto 0);

-- Señales de la memoria
signal RAM_enable      :   STD_LOGIC;
signal RAM_write_enable:   STD_LOGIC;
signal RAM_address     :   STD_LOGIC_VECTOR (9 downto 0);
signal RAM_data_input  :   STD_LOGIC_VECTOR (31 downto 0);
signal RAM_data_output :   STD_LOGIC_VECTOR (31 downto 0);

signal dvalid      :   STD_LOGIC;
signal nclk      :   STD_LOGIC;

begin

nclk<=not clk;

Procesador: PSM port map(CLK,Reset,PSM_WR_enable,dvalid, PSM_DATABUS_in,PSM_DATABUS_out,PSM_ADDRBUS);
Memoria: RAM_single_port generic map (N =>32, M => 10)
                         port map(clk,RAM_enable,RAM_write_enable,RAM_address,RAM_data_input,RAM_data_output,dvalid);

-- Arbitrador
process(clk,ext_sel,PSM_ADDRBUS,PSM_WR_enable,PSM_ADDRBUS,PSM_DATABUS_in,WR_enable,ADDRBUS,DATABUS_in,RAM_data_output)
begin
--  if falling_edge(clk) then
     if ext_sel='0' and CONV_INTEGER(PSM_ADDRBUS)>=CONV_INTEGER(MEM_BASE_ADDRESS) and CONV_INTEGER(PSM_ADDRBUS)<=CONV_INTEGER(MEM_HIGH_ADDRESS) then
	   RAM_enable <= '1';
	   RAM_write_enable<=PSM_WR_enable;
	   RAM_address<=PSM_ADDRBUS(9 downto 0);
	   RAM_data_input<=PSM_DATABUS_out;
	   PSM_DATABUS_in<=RAM_data_output;
     elsif ext_sel='1' and CONV_INTEGER(ADDRBUS)>=CONV_INTEGER(MEM_BASE_ADDRESS) and CONV_INTEGER(ADDRBUS)<=CONV_INTEGER(MEM_HIGH_ADDRESS) then
	   RAM_enable <= '1';
	   RAM_write_enable<=WR_enable;
	   RAM_address<=ADDRBUS(9 downto 0);
	   DATABUS_out<=RAM_data_output;
	   RAM_data_input<=DATABUS_in;
	 else
	   RAM_enable <= '0';
	   RAM_write_enable<='0';
     end if;
--  end if;
end process;

end estructura;

