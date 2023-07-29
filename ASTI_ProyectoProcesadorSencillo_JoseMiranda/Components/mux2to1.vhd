------------------------------------------------------------------------------
--  File: mux.vhd
------------------------------------------------------------------------------
--Multiplexer design
--Control signal is CONT_SIG
--The output is chosen from 2 signals with length 8 bits
--If control signal is '1' then input A_in is chosen 
--If '0' then input B_IN is chosen to the output OUT_SIG


library IEEE;
use IEEE.std_logic_1164.all;

--Multiplexer entity
entity mux2to1 is
  port ( A_IN     : in std_logic_vector( 31 downto 0 );
         B_IN     : in std_logic_vector( 31 downto 0 );
         CONT_SIG : in  std_logic;
         OUT_SIG  : out std_logic_vector( 31 downto 0 ) );
end mux2to1;

--Architecture of the multiplexer
architecture RTL of mux2to1 is

begin
 
--DISP_MUX process
DISP_MUX: process 
  begin
    wait on A_IN,B_IN,CONT_SIG;
    if CONT_SIG = '0' then
       OUT_SIG <= A_IN;
    else
       OUT_SIG <= B_IN;
    end if;
  end process;
               
end RTL;
