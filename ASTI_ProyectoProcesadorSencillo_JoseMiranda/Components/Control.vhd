----------------------------------------------------------------------------------
-- Máster en Microelectrónica: Diseño y Aplicaciones de Sistemas Micro/Nanométricos
-- Asignatura: Aplicaciones, sistemas y técnicas para el tratamiento de la información
-- Course: Applications, systems and techniques for information processing
-- 
-- Create Date:    2014/2015
-- Module Name:    Control - FSM
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity Control is
	port (CLK         : in  STD_LOGIC;
		  Reset       : in  STD_LOGIC;
		  -- control externo
		  WR_enable       : out  STD_LOGIC;
		  dvalid      : in STD_LOGIC;
		  -- control de buses
          control_DATABUS_out: out std_logic; -- Control de bus externo de datos de salida
          control_ADDRBUS    : out std_logic_vector(1 downto 0); -- Control de bus de externo de direccion
          control_PC_Din     : out std_logic; -- control del bus de entrada del PC
          control_Reg_Din    : out std_logic; -- control del bus de entrada del fichero de registros 
          -- control del contador de programa
          PC_cuenta: out STD_LOGIC;
          PC_load  : out STD_LOGIC;
          -- control del fichero de registros de proposito general
          Reg_enable: out STD_LOGIC;
          Reg_write : out STD_LOGIC;
		  Reg_address_WR: out std_logic_vector (4 downto 0);
		  Reg_addr_A: out std_logic_vector (4 downto 0);
		  Reg_addr_B: out std_logic_vector (4 downto 0);
          -- control de la ALU 
          ALU_control: out std_logic_vector (2 downto 0);  -- control de operacion de la ALU
          -- control del registro de instrucciones (RI: registro) 
          RI_load: out STD_LOGIC;
          RI_Dout: in STD_LOGIC_VECTOR (31 downto 0);
          -- control del stack pointer (USP: SP) 
          SP_up  : out STD_LOGIC;
          SP_down: out STD_LOGIC;
          SP_load: out STD_LOGIC;
         -- control del registro de estado
          STAT_C     : in  std_logic;
          STAT_C_load: out std_logic;
          STAT_Z_load: out std_logic;
		  STAT_C_Set : out std_logic;
          STAT_C_Clear: out std_logic;
		  STAT_SPF_load: out std_logic;
          STAT_SPE_load: out std_logic);
end Control;

architecture FSM of Control is

type instrucciones is (NOP,FETCH1,FETCH2,SUM,SUB,SHR,SHL,INOT,IAND,IOR,IXOR,LD1,LD2,ST1,ST2,
                       JMP,JMPC,JSR1,JSR2,JSR3,RTS1,RTS2,RTS3,CLC,SETC,STOP);
signal estado_actual, proximo_estado: instrucciones;

alias OpCode     : STD_LOGIC_VECTOR(4 downto 0) is RI_Dout(30 downto 26);
alias Destination: STD_LOGIC_VECTOR(4 downto 0) is RI_Dout(25 downto 21);
alias SourceA    : STD_LOGIC_VECTOR(4 downto 0) is RI_Dout(20 downto 16);
alias SourceB    : STD_LOGIC_VECTOR(4 downto 0) is RI_Dout(15 downto 11);
alias direccion  : STD_LOGIC_VECTOR(15 downto 0) is RI_Dout(15 downto 0);

begin

process(clk,reset,proximo_estado)
begin
  if rising_edge(clk) then
     if reset='1' then
	    estado_actual <= NOP;
	 else
	    estado_actual <= proximo_estado;
	 end if;
  end if;
end process;

process(estado_actual,RI_Dout,STAT_C,dvalid)
begin
  case estado_actual is
    when FETCH1 => -- ciclo 1 de busqueda de instrucción
		           -- control externo
		           WR_enable <= '0';
		           -- control de buses
                   control_DATABUS_out <= '0'; 
				   control_ADDRBUS <= "00"; 
                   control_PC_Din <= '0'; 
				   control_Reg_Din <= '0';  
                   -- control del contador de programa
                   PC_cuenta <= '1'; PC_load <= '0';
                   -- control del fichero de registros de proposito general
                   Reg_enable <= '0'; 
				   Reg_write <= '0';
				   Reg_address_WR <= (others=>'0'); 
				   Reg_addr_A <= (others=>'0'); 
				   Reg_addr_B <= (others=>'0');
                   -- control de la ALU 
                   ALU_control <= "000";  -- control de operacion de la ALU
                   -- control del registro de instrucciones (RI: registro) 
                   RI_load <= '1';
                   -- control del stack pointer (USP: SP) 
                   SP_up <= '0'; SP_down <= '0'; SP_load <= '0';
                   -- control del registro de estado
                   STAT_C_load <= '0'; STAT_Z_load <= '0';
                   STAT_C_Set <= '0'; STAT_C_Clear <= '0';
				   STAT_SPF_load <= '0'; STAT_SPE_load <='0';

		           proximo_estado <= FETCH2;
	-------------------------------------------------------------------------------------
    when FETCH2 => -- ciclo 2 de busqueda de instrucción
		           -- control externo
		           WR_enable <= '0';
		           -- control de buses
                   control_DATABUS_out <= '0'; 
				   control_ADDRBUS <= "00"; 
                   control_PC_Din <= '0'; 
				   control_Reg_Din <= '0';  
                   -- control del contador de programa
                   PC_cuenta <= '0'; PC_load <= '0';
                   -- control del fichero de registros de proposito general
                   Reg_enable <= '1'; 
				   Reg_write <= '0';
				   Reg_address_WR <= (others=>'0'); 
				   Reg_addr_A <= SourceA; 
				   Reg_addr_B <= SourceB;
                   -- control de la ALU 
                   ALU_control <= "000";  -- control de operacion de la ALU
                   -- control del registro de instrucciones (RI: registro) 
                   RI_load <= '0';
                   -- control del stack pointer (USP: SP) 
                   SP_up <= '0'; SP_down <= '0'; SP_load <= '0';
                   -- control del registro de estado
                   STAT_C_load <= '0'; STAT_Z_load <= '0';
                   STAT_C_Set <= '0'; STAT_C_Clear <= '0';
				   STAT_SPF_load <= '0'; STAT_SPE_load <='0';
		 
		           case OpCode is 
				     when "00000" => proximo_estado <= SUM;
				     when "00001" => proximo_estado <= SUB;
				     when "00010" => proximo_estado <= SHR;
				     when "00011" => proximo_estado <= SHL;
				     when "00100" => proximo_estado <= INOT;
				     when "00101" => proximo_estado <= IAND;
				     when "00110" => proximo_estado <= IOR;
				     when "00111" => proximo_estado <= IXOR;
				     when "01000" => proximo_estado <= LD1;
					 when "01001" => proximo_estado <= ST1;
				     when "01010" => proximo_estado <= JMP;
				     when "01011" => proximo_estado <= JMPC;
				     when "01100" => proximo_estado <= JSR1;
				     when "01101" => proximo_estado <= RTS1;
				     when "01110" => proximo_estado <= CLC;
				     when "01111" => proximo_estado <= SETC;
				     when "10000" => proximo_estado <= STOP;
				     when "10001" => proximo_estado <= NOP;
                     when others  => proximo_estado <= FETCH1;
				   end case;
	-------------------------------------------------------------------------------------
    when SUM    => -- SUM Ra,Rb,Rc: Ra<-Rb+Rc
		           -- control externo
		           WR_enable <= '0';
		           -- control de buses
                   control_DATABUS_out <= '0'; 
				   control_ADDRBUS <= "00"; 
                   control_PC_Din <= '0'; 
				   control_Reg_Din <= '1';  
                   -- control del contador de programa
                   PC_cuenta <= '0'; PC_load <= '0';
                   -- control del fichero de registros de proposito general
                   Reg_enable <= '1'; 
				   Reg_write <= '1';
				   Reg_address_WR <= Destination; 
				   Reg_addr_A <= (others=>'0'); 
				   Reg_addr_B <= (others=>'0');
                   -- control de la ALU 
                   ALU_control <= "000";  -- control de operacion de la ALU
                   -- control del registro de instrucciones (RI: registro) 
                   RI_load <= '0';
                   -- control del stack pointer (USP: SP) 
                   SP_up <= '0'; SP_down <= '0'; SP_load <= '0';
                   -- control del registro de estado
                   STAT_C_load <= '1'; STAT_Z_load <= '1';
                   STAT_C_Set <= '0'; STAT_C_Clear <= '0';
				   STAT_SPF_load <= '0'; STAT_SPE_load <='0';
		 
		           proximo_estado <= FETCH1;
	-------------------------------------------------------------------------------------
    when SUB    => -- SUB Ra,Rb,Rc: Ra<-Rb-Rc
		           -- control externo
		           WR_enable <= '0';
		           -- control de buses
                   control_DATABUS_out <= '0'; 
				   control_ADDRBUS <= "00"; 
                   control_PC_Din <= '0'; 
				   control_Reg_Din <= '1';  
                   -- control del contador de programa
                   PC_cuenta <= '0'; PC_load <= '0';
                   -- control del fichero de registros de proposito general
                   Reg_enable <= '1'; 
				   Reg_write <= '1';
				   Reg_address_WR <= Destination; 
				   Reg_addr_A <= (others=>'0');
				   Reg_addr_B <= (others=>'0');
                   -- control de la ALU 
                   ALU_control <= "001";  -- control de operacion de la ALU
                   -- control del registro de instrucciones (RI: registro) 
                   RI_load <= '0';
                   -- control del stack pointer (USP: SP) 
                   SP_up <= '0'; SP_down <= '0'; SP_load <= '0';
                   -- control del registro de estado
                   STAT_C_load <= '1'; STAT_Z_load <= '1';
                   STAT_C_Set <= '0'; STAT_C_Clear <= '0';
				   STAT_SPF_load <= '0'; STAT_SPE_load <='0';
		 
		           proximo_estado <= FETCH1;
	-------------------------------------------------------------------------------------
    when SHR    => -- SHR Ra: Ra<-Ra>>1; Ra(31)<-STAT_C; STAT_C<-Ra(0)
		           -- control externo
		           WR_enable <= '0';
		           -- control de buses
                   control_DATABUS_out <= '0'; 
				   control_ADDRBUS <= "00"; 
                   control_PC_Din <= '0'; 
				   control_Reg_Din <= '1';  
                   -- control del contador de programa
                   PC_cuenta <= '0'; PC_load <= '0';
                   -- control del fichero de registros de proposito general
                   Reg_enable <= '1'; 
				   Reg_write <= '1';
				   Reg_address_WR <= Destination; 
				   Reg_addr_A <= (others=>'0'); 
				   Reg_addr_B <= (others=>'0');
                   -- control de la ALU 
                   ALU_control <= "010";  -- control de operacion de la ALU
                   -- control del registro de instrucciones (RI: registro) 
                   RI_load <= '0';
                   -- control del stack pointer (USP: SP) 
                   SP_up <= '0'; SP_down <= '0'; SP_load <= '0';
                   -- control del registro de estado
                   STAT_C_load <= '1'; STAT_Z_load <= '0';
                   STAT_C_Set <= '0'; STAT_C_Clear <= '0';
				   STAT_SPF_load <= '0'; STAT_SPE_load <='0';
		 
		           proximo_estado <= FETCH1;
	-------------------------------------------------------------------------------------
    when SHL    => -- SHR Ra: Ra<-Ra<<1; Ra(0)<-STAT_C; STAT_C<-Ra(31)
		           -- control externo
		           WR_enable <= '0';
		           -- control de buses
                   control_DATABUS_out <= '0'; 
				   control_ADDRBUS <= "00"; 
                   control_PC_Din <= '0'; 
				   control_Reg_Din <= '1';  
                   -- control del contador de programa
                   PC_cuenta <= '0'; PC_load <= '0';
                   -- control del fichero de registros de proposito general
                   Reg_enable <= '1'; 
				   Reg_write <= '1';
				   Reg_address_WR <= Destination; 
				   Reg_addr_A <= (others=>'0'); 
				   Reg_addr_B <= (others=>'0');
                   -- control de la ALU 
                   ALU_control <= "011";  -- control de operacion de la ALU
                   -- control del registro de instrucciones (RI: registro) 
                   RI_load <= '0';
                   -- control del stack pointer (USP: SP) 
                   SP_up <= '0'; SP_down <= '0'; SP_load <= '0';
                   -- control del registro de estado
                   STAT_C_load <= '1'; STAT_Z_load <= '0';
                   STAT_C_Set <= '0'; STAT_C_Clear <= '0';
				   STAT_SPF_load <= '0'; STAT_SPE_load <='0';
		 
		           proximo_estado <= FETCH1;
	-------------------------------------------------------------------------------------
    when INOT   => -- NOT Ra: Ra<-not Ra
		           -- control externo
		           WR_enable <= '0';
		           -- control de buses
                   control_DATABUS_out <= '0'; 
				   control_ADDRBUS <= "00"; 
                   control_PC_Din <= '0'; 
				   control_Reg_Din <= '1';  
                   -- control del contador de programa
                   PC_cuenta <= '0'; PC_load <= '0';
                   -- control del fichero de registros de proposito general
                   Reg_enable <= '1'; 
				   Reg_write <= '1';
				   Reg_address_WR <= Destination; 
				   Reg_addr_A <= (others=>'0'); 
				   Reg_addr_B <= (others=>'0');
                   -- control de la ALU 
                   ALU_control <= "100";  -- control de operacion de la ALU
                   -- control del registro de instrucciones (RI: registro) 
                   RI_load <= '0';
                   -- control del stack pointer (USP: SP) 
                   SP_up <= '0'; SP_down <= '0'; SP_load <= '0';
                   -- control del registro de estado
                   STAT_C_load <= '0'; STAT_Z_load <= '0';
                   STAT_C_Set <= '0'; STAT_C_Clear <= '0';
				   STAT_SPF_load <= '0'; STAT_SPE_load <='0';
		 
		           proximo_estado <= FETCH1;
	-------------------------------------------------------------------------------------
    when IAND   => -- AND Ra,Rb,Rc: Ra<-Rb and Rc
		           -- control externo
		           WR_enable <= '0';
		           -- control de buses
                   control_DATABUS_out <= '0'; 
				   control_ADDRBUS <= "00"; 
                   control_PC_Din <= '0'; 
				   control_Reg_Din <= '1';  
                   -- control del contador de programa
                   PC_cuenta <= '0'; PC_load <= '0';
                   -- control del fichero de registros de proposito general
                   Reg_enable <= '1'; 
				   Reg_write <= '1';
				   Reg_address_WR <= Destination; 
				   Reg_addr_A <= (others=>'0'); 
				   Reg_addr_B <= (others=>'0');
                   -- control de la ALU 
                   ALU_control <= "101";  -- control de operacion de la ALU
                   -- control del registro de instrucciones (RI: registro) 
                   RI_load <= '0';
                   -- control del stack pointer (USP: SP) 
                   SP_up <= '0'; SP_down <= '0'; SP_load <= '0';
                   -- control del registro de estado
                   STAT_C_load <= '0'; STAT_Z_load <= '0';
                   STAT_C_Set <= '0'; STAT_C_Clear <= '0';
				   STAT_SPF_load <= '0'; STAT_SPE_load <='0';
	 
		           proximo_estado <= FETCH1;
	-------------------------------------------------------------------------------------
    when IOR    => -- OR Ra,Rb,Rc: Ra<-Rb or Rc
		           -- control externo
		           WR_enable <= '0';
		           -- control de buses
                   control_DATABUS_out <= '0'; 
				   control_ADDRBUS <= "00"; 
                   control_PC_Din <= '0'; 
				   control_Reg_Din <= '1';  
                   -- control del contador de programa
                   PC_cuenta <= '0'; PC_load <= '0';
                   -- control del fichero de registros de proposito general
                   Reg_enable <= '1'; 
				   Reg_write <= '1';
				   Reg_address_WR <= Destination; 
				   Reg_addr_A <= (others=>'0'); 
				   Reg_addr_B <= (others=>'0');
				   -- control de la ALU 
                   ALU_control <= "110";  -- control de operacion de la ALU
                   -- control del registro de instrucciones (RI: registro) 
                   RI_load <= '0';
                   -- control del stack pointer (USP: SP) 
                   SP_up <= '0'; SP_down <= '0'; SP_load <= '0';
                   -- control del registro de estado
                   STAT_C_load <= '0'; STAT_Z_load <= '0';
                   STAT_C_Set <= '0'; STAT_C_Clear <= '0';
				   STAT_SPF_load <= '0'; STAT_SPE_load <='0';
		 
		           proximo_estado <= FETCH1;
	-------------------------------------------------------------------------------------
    when IXOR   => -- XOR Ra,Rb,Rc: Ra<-Rb xor Rc
		           -- control externo
		           WR_enable <= '0';
		           -- control de buses
                   control_DATABUS_out <= '0'; 
				   control_ADDRBUS <= "00"; 
                   control_PC_Din <= '0'; 
				   control_Reg_Din <= '1';  
                   -- control del contador de programa
                   PC_cuenta <= '0'; PC_load <= '0';
                   -- control del fichero de registros de proposito general
                   Reg_enable <= '1'; 
				   Reg_write <= '1';
				   Reg_address_WR <= Destination; 
				   Reg_addr_A <= (others=>'0'); 
				   Reg_addr_B <= (others=>'0');
				   -- control de la ALU 
                   ALU_control <= "111";  -- control de operacion de la ALU
                   -- control del registro de instrucciones (RI: registro) 
                   RI_load <= '0';
                   -- control del stack pointer (USP: SP) 
                   SP_up <= '0'; SP_down <= '0'; SP_load <= '0';
                   -- control del registro de estado
                   STAT_C_load <= '0'; STAT_Z_load <= '0';
                   STAT_C_Set <= '0'; STAT_C_Clear <= '0';
				   STAT_SPF_load <= '0'; STAT_SPE_load <='0';
		 
		           proximo_estado <= FETCH1;
	-------------------------------------------------------------------------------------
    when LD1     => -- Ld Ra,dir: Ra<-Mem(dir)
		           -- control externo
		           WR_enable <= '0';
		           -- control de buses
                   control_DATABUS_out <= '0'; 
				   control_ADDRBUS <= "10"; 
                   control_PC_Din <= '0'; 
				   control_Reg_Din <= '0';  
                   -- control del contador de programa
                   PC_cuenta <= '0'; PC_load <= '0';
                   -- control del fichero de registros de proposito general
                   Reg_enable <= '1'; 
				   Reg_write <= '1';
				   Reg_address_WR <= Destination; 
				   Reg_addr_A <= (others=>'0'); 
				   Reg_addr_B <= (others=>'0');
                   -- control de la ALU 
                   ALU_control <= "000";  -- control de operacion de la ALU
                   -- control del registro de instrucciones (RI: registro) 
                   RI_load <= '0';
                   -- control del stack pointer (USP: SP) 
                   SP_up <= '0'; SP_down <= '0'; SP_load <= '0';
                   -- control del registro de estado
                   STAT_C_load <= '0'; STAT_Z_load <= '0';
                   STAT_C_Set <= '0'; STAT_C_Clear <= '0';
				   STAT_SPF_load <= '0'; STAT_SPE_load <='0';
		 
						 proximo_estado <= LD2;
	-------------------------------------------------------------------------------------
	
    when LD2     => -- Ld Ra,dir: Ra<-Mem(dir)
		           -- control externo
		           WR_enable <= '0';
		           -- control de buses
                   control_DATABUS_out <= '0'; 
				   control_ADDRBUS <= "00"; 
                   control_PC_Din <= '0'; 
				   control_Reg_Din <= '0';  
                   -- control del contador de programa
                   PC_cuenta <= '0'; PC_load <= '0';
                   -- control del fichero de registros de proposito general
                   Reg_enable <= '1'; 
				   Reg_write <= '1';
				   Reg_address_WR <= Destination; 
				   Reg_addr_A <= (others=>'0');
				   Reg_addr_B <= (others=>'0');
                   -- control de la ALU 
                   ALU_control <= "000";  -- control de operacion de la ALU
                   -- control del registro de instrucciones (RI: registro) 
                   RI_load <= '0';
                   -- control del stack pointer (USP: SP) 
                   SP_up <= '0'; SP_down <= '0'; SP_load <= '0';
                   -- control del registro de estado
                   STAT_C_load <= '0'; STAT_Z_load <= '0';
                   STAT_C_Set <= '0'; STAT_C_Clear <= '0';
				   STAT_SPF_load <= '0'; STAT_SPE_load <='0';
		 
		             if dvalid='1' then
						    proximo_estado <= FETCH1;
						 else
						    proximo_estado <= LD2;
						 end if;
	-------------------------------------------------------------------------------------
	
    when ST1     => -- ST Ra,dir: Mem(dir)<-Ra
		           -- control externo
		           WR_enable <= '1';
		           -- control de buses
                   control_DATABUS_out <= '0'; 
				   control_ADDRBUS <= "10"; 
                   control_PC_Din <= '0'; 
				   control_Reg_Din <= '0';  
                   -- control del contador de programa
                   PC_cuenta <= '0'; PC_load <= '0';
                   -- control del fichero de registros de proposito general
                   Reg_enable <= '1'; 
				   Reg_write <= '0';
				   Reg_address_WR <= (others=>'0'); 
				   Reg_addr_A <= SourceA; 
				   Reg_addr_B <= (others=>'0');
                   -- control de la ALU 
                   ALU_control <= "000";  -- control de operacion de la ALU
                   -- control del registro de instrucciones (RI: registro) 
                   RI_load <= '0';
                   -- control del stack pointer (USP: SP) 
                   SP_up <= '0'; SP_down <= '0'; SP_load <= '0';
                   -- control del registro de estado
                   STAT_C_load <= '0'; STAT_Z_load <= '0';
                   STAT_C_Set <= '0'; STAT_C_Clear <= '0';
				   STAT_SPF_load <= '0'; STAT_SPE_load <='0';
		 
		           proximo_estado <= ST2;
	-------------------------------------------------------------------------------------
	
    when ST2     => -- ST Ra,dir: Mem(dir)<-Ra
		           -- control externo
		           WR_enable <= '0';
		           -- control de buses
                   control_DATABUS_out <= '0'; 
				   control_ADDRBUS <= "00"; 
                   control_PC_Din <= '0'; 
				   control_Reg_Din <= '0';  
                   -- control del contador de programa
                   PC_cuenta <= '0'; PC_load <= '0';
                   -- control del fichero de registros de proposito general
                   Reg_enable <= '1'; 
				   Reg_write <= '0';
				   Reg_address_WR <= (others=>'0'); 
				   Reg_addr_A <= SourceA; 
				   Reg_addr_B <= (others=>'0');
                   -- control de la ALU 
                   ALU_control <= "000";  -- control de operacion de la ALU
                   -- control del registro de instrucciones (RI: registro) 
                   RI_load <= '0';
                   -- control del stack pointer (USP: SP) 
                   SP_up <= '0'; SP_down <= '0'; SP_load <= '0';
                   -- control del registro de estado
                   STAT_C_load <= '0'; STAT_Z_load <= '0';
                   STAT_C_Set <= '0'; STAT_C_Clear <= '0';
				   STAT_SPF_load <= '0'; STAT_SPE_load <='0';
		 
		           proximo_estado <= FETCH1;
	-------------------------------------------------------------------------------------
	
    when JMP    => -- JMP dir: PC<-dir
		           -- control externo
		           WR_enable <= '0';
		           -- control de buses
                   control_DATABUS_out <= '0'; 
				   control_ADDRBUS <= "00"; 
                   control_PC_Din <= '1'; 
				   control_Reg_Din <= '0';  
                   -- control del contador de programa
                   PC_cuenta <= '0'; PC_load <= '1';
                   -- control del fichero de registros de proposito general
                   Reg_enable <= '0'; 
				   Reg_write <= '0';
				   Reg_address_WR <= (others=>'0'); 
				   Reg_addr_A <= (others=>'0'); 
				   Reg_addr_B <= (others=>'0');
                   -- control de la ALU 
                   ALU_control <= "000";  -- control de operacion de la ALU
                   -- control del registro de instrucciones (RI: registro) 
                   RI_load <= '0';
                   -- control del stack pointer (USP: SP) 
                   SP_up <= '0'; SP_down <= '0'; SP_load <= '0';
                   -- control del registro de estado
                   STAT_C_load <= '0'; STAT_Z_load <= '0';
                   STAT_C_Set <= '0'; STAT_C_Clear <= '0';
				   STAT_SPF_load <= '0'; STAT_SPE_load <='0';
		 
		           proximo_estado <= FETCH1;
	-------------------------------------------------------------------------------------
    when JMPC   => -- JMPC dir: C: PC<-dir
		           -- control externo
		           WR_enable <= '0';
		           -- control de buses
                   control_DATABUS_out <= '0'; 
				   control_ADDRBUS <= "00"; 
                   control_PC_Din <= '1'; 
				   control_Reg_Din <= '0';  
                   -- control del contador de programa
                   PC_cuenta <= '0'; PC_load <= '1';
                   -- control del fichero de registros de proposito general
                   Reg_enable <= '0'; 
				   Reg_write <= '0';
				   Reg_address_WR <= (others=>'0'); 
				   Reg_addr_A <= (others=>'0'); 
				   Reg_addr_B <= (others=>'0');
                   -- control de la ALU 
                   ALU_control <= "000";  -- control de operacion de la ALU
                   -- control del registro de instrucciones (RI: registro) 
                   RI_load <= '0';
                   -- control del stack pointer (USP: SP) 
                   SP_up <= '0'; SP_down <= '0'; SP_load <= '0';
                   -- control del registro de estado
                   STAT_C_load <= '0'; STAT_Z_load <= '0';
                   STAT_C_Set <= '0'; STAT_C_Clear <= '0';
				   STAT_SPF_load <= '0'; STAT_SPE_load <='0';
		 
		           proximo_estado <= FETCH1;
	-------------------------------------------------------------------------------------
    when JSR1    => -- JSR dir: SP<-SP+1; Mem(SP)<-PC; PC<-dir
		           -- control externo
		           WR_enable <= '0';
		           -- control de buses
                   control_DATABUS_out <= '0'; 
				   control_ADDRBUS <= "00"; 
                   control_PC_Din <= '0'; 
				   control_Reg_Din <= '0';  
                   -- control del contador de programa
                   PC_cuenta <= '0'; PC_load <= '0';
                   -- control del fichero de registros de proposito general
                   Reg_enable <= '0'; 
				   Reg_write <= '0';
				   Reg_address_WR <= (others=>'0'); 
				   Reg_addr_A <= (others=>'0'); 
				   Reg_addr_B <= (others=>'0');
                   -- control de la ALU 
                   ALU_control <= "000";  -- control de operacion de la ALU
                   -- control del registro de instrucciones (RI: registro) 
                   RI_load <= '0';
                   -- control del stack pointer (USP: SP) 
                   SP_up <= '1'; SP_down <= '0'; SP_load <= '0';
                   -- control del registro de estado
                   STAT_C_load <= '0'; STAT_Z_load <= '0';
                   STAT_C_Set <= '0'; STAT_C_Clear <= '0';
				   STAT_SPF_load <= '0'; STAT_SPE_load <='0';
		 
		           proximo_estado <= JSR2;
	-------------------------------------------------------------------------------------
    when JSR2    => -- JSR dir: SP<-SP+1; Mem(SP)<-PC; PC<-dir
		           -- control externo
		           WR_enable <= '0';
		           -- control de buses
                   control_DATABUS_out <= '1'; 
				   control_ADDRBUS <= "01"; 
                   control_PC_Din <= '1'; 
				   control_Reg_Din <= '0';  
                   -- control del contador de programa
                   PC_cuenta <= '0'; PC_load <= '0';
                   -- control del fichero de registros de proposito general
                   Reg_enable <= '0'; 
				   Reg_write <= '0';
				   Reg_address_WR <= (others=>'0'); 
				   Reg_addr_A <= (others=>'0'); 
				   Reg_addr_B <= (others=>'0');
                   -- control de la ALU 
                   ALU_control <= "000";  -- control de operacion de la ALU
                   -- control del registro de instrucciones (RI: registro) 
                   RI_load <= '0';
                   -- control del stack pointer (USP: SP) 
                   SP_up <= '0'; SP_down <= '0'; SP_load <= '0';
                   -- control del registro de estado
                   STAT_C_load <= '0'; STAT_Z_load <= '0';
                   STAT_C_Set <= '0'; STAT_C_Clear <= '0';
				   STAT_SPF_load <= '0'; STAT_SPE_load <='0';
		 
		           proximo_estado <= JSR3;
	-------------------------------------------------------------------------------------
    when JSR3    => -- JSR dir: SP<-SP+1; Mem(SP)<-PC; PC<-dir
		           -- control externo
		           WR_enable <= '0';
		           -- control de buses
                   control_DATABUS_out <= '0'; 
				   control_ADDRBUS <= "00"; 
                   control_PC_Din <= '1';
				   control_Reg_Din <= '0';  
                   -- control del contador de programa
                   PC_cuenta <= '0'; PC_load <= '1';
                   -- control del fichero de registros de proposito general
                   Reg_enable <= '0'; Reg_write <= '0';
				   Reg_address_WR <= (others=>'0'); Reg_addr_A <= (others=>'0'); Reg_addr_B <= (others=>'0');
                   -- control de la ALU 
                   ALU_control <= "000";  -- control de operacion de la ALU
                   -- control del registro de instrucciones (RI: registro) 
                   RI_load <= '0';
                   -- control del stack pointer (USP: SP) 
                   SP_up <= '0'; SP_down <= '0'; SP_load <= '0';
                   -- control del registro de estado
                   STAT_C_load <= '0'; STAT_Z_load <= '0';
                   STAT_C_Set <= '0'; STAT_C_Clear <= '0';
				   STAT_SPF_load <= '0'; STAT_SPE_load <='0';
		 
		           proximo_estado <= FETCH1;
	-------------------------------------------------------------------------------------
	
    when RTS1    => -- ciclo 1 de busqueda de instrucción
		           -- control externo
		           WR_enable <= '0';
		           -- control de buses
                   control_DATABUS_out <= '0'; 
				   control_ADDRBUS <= "01"; 
                   control_PC_Din <= '0'; 
				   control_Reg_Din <= '0';  
                   -- control del contador de programa
                   PC_cuenta <= '0'; PC_load <= '0';
                   -- control del fichero de registros de proposito general
                   Reg_enable <= '0'; Reg_write <= '0';
				   Reg_address_WR <= (others=>'0'); Reg_addr_A <= (others=>'0'); Reg_addr_B <= (others=>'0');
                   -- control de la ALU 
                   ALU_control <= "000";  -- control de operacion de la ALU
                   -- control del registro de instrucciones (RI: registro) 
                   RI_load <= '0';
                   -- control del stack pointer (USP: SP) 
                   SP_up <= '0'; SP_down <= '0'; SP_load <= '0';
                   -- control del registro de estado
                   STAT_C_load <= '0'; STAT_Z_load <= '0';
                   STAT_C_Set <= '0'; STAT_C_Clear <= '0';
				   STAT_SPF_load <= '0'; STAT_SPE_load <='0';
		 
		           proximo_estado <= RTS2;
	-------------------------------------------------------------------------------------
	
    when RTS2    => -- ciclo 1 de busqueda de instrucción
		           -- control externo
		           WR_enable <= '0';
		           -- control de buses
                   control_DATABUS_out <= '0'; 
				   control_ADDRBUS <= "00"; 
                   control_PC_Din <= '0'; 
				   control_Reg_Din <= '0';  
                   -- control del contador de programa
                   PC_cuenta <= '0'; PC_load <= '1';
                   -- control del fichero de registros de proposito general
                   Reg_enable <= '0'; Reg_write <= '0';
				   Reg_address_WR <= (others=>'0'); Reg_addr_A <= (others=>'0'); Reg_addr_B <= (others=>'0');
                   -- control de la ALU 
                   ALU_control <= "000";  -- control de operacion de la ALU
                   -- control del registro de instrucciones (RI: registro) 
                   RI_load <= '0';
                   -- control del stack pointer (USP: SP) 
                   SP_up <= '0'; SP_down <= '0'; SP_load <= '0';
                   -- control del registro de estado
                   STAT_C_load <= '0'; STAT_Z_load <= '0';
                   STAT_C_Set <= '0'; STAT_C_Clear <= '0';
				   STAT_SPF_load <= '0'; STAT_SPE_load <='0';
		 
		           proximo_estado <= RTS3;
	-------------------------------------------------------------------------------------

    when RTS3    => -- ciclo 1 de busqueda de instrucción
		           -- control externo
		           WR_enable <= '0';
		           -- control de buses
                   control_DATABUS_out <= '0'; control_ADDRBUS <= "00"; 
                   control_PC_Din <= '0'; control_Reg_Din <= '0';  
                   -- control del contador de programa
                   PC_cuenta <= '0'; PC_load <= '0';
                   -- control del fichero de registros de proposito general
                   Reg_enable <= '0'; Reg_write <= '0';
				   Reg_address_WR <= (others=>'0'); Reg_addr_A <= (others=>'0'); Reg_addr_B <= (others=>'0');
                   -- control de la ALU 
                   ALU_control <= "000";  -- control de operacion de la ALU
                   -- control del registro de instrucciones (RI: registro) 
                   RI_load <= '0';
                   -- control del stack pointer (USP: SP) 
                   SP_up <= '0'; SP_down <= '1'; SP_load <= '0';
                   -- control del registro de estado
                   STAT_C_load <= '0'; STAT_Z_load <= '0';
                   STAT_C_Set <= '0'; STAT_C_Clear <= '0';
				   STAT_SPF_load <= '0'; STAT_SPE_load <='0';
		 
		           proximo_estado <= FETCH1;
	-------------------------------------------------------------------------------------
	
    when CLC    => -- ciclo 1 de busqueda de instrucción
		           -- control externo
		           WR_enable <= '0';
		           -- control de buses
                   control_DATABUS_out <= '0'; control_ADDRBUS <= "00"; 
                   control_PC_Din <= '0'; control_Reg_Din <= '0';  
                   -- control del contador de programa
                   PC_cuenta <= '0'; PC_load <= '0';
                   -- control del fichero de registros de proposito general
                   Reg_enable <= '0'; Reg_write <= '0';
				   Reg_address_WR <= (others=>'0'); Reg_addr_A <= (others=>'0'); Reg_addr_B <= (others=>'0');
                   -- control de la ALU 
                   ALU_control <= "000";  -- control de operacion de la ALU
                   -- control del registro de instrucciones (RI: registro) 
                   RI_load <= '0';
                   -- control del stack pointer (USP: SP) 
                   SP_up <= '0'; SP_down <= '0'; SP_load <= '0';
                   -- control del registro de estado
                   STAT_C_load <= '1'; STAT_Z_load <= '0';
                   STAT_C_Set <= '0'; STAT_C_Clear <= '1';
				   STAT_SPF_load <= '0'; STAT_SPE_load <='0';
		 
		           proximo_estado <= FETCH1;
	-------------------------------------------------------------------------------------
    when SETC   => -- ciclo 1 de busqueda de instrucción
		           -- control externo
		           WR_enable <= '0';
		           -- control de buses
                   control_DATABUS_out <= '0'; control_ADDRBUS <= "00"; 
                   control_PC_Din <= '0'; control_Reg_Din <= '0';  
                   -- control del contador de programa
                   PC_cuenta <= '0'; PC_load <= '0';
                   -- control del fichero de registros de proposito general
                   Reg_enable <= '0'; Reg_write <= '0';
				   Reg_address_WR <= (others=>'0'); Reg_addr_A <= (others=>'0'); Reg_addr_B <= (others=>'0');
                   -- control de la ALU 
                   ALU_control <= "000";  -- control de operacion de la ALU
                   -- control del registro de instrucciones (RI: registro) 
                   RI_load <= '0';
                   -- control del stack pointer (USP: SP) 
                   SP_up <= '0'; SP_down <= '0'; SP_load <= '0';
                   -- control del registro de estado
                   STAT_C_load <= '1'; STAT_Z_load <= '0';
                   STAT_C_Set <= '1'; STAT_C_Clear <= '0';
				   STAT_SPF_load <= '0'; STAT_SPE_load <='0';
		 
		           proximo_estado <= FETCH1;
	-------------------------------------------------------------------------------------
    when STOP   => -- ciclo 1 de busqueda de instrucción
		           -- control externo
		           WR_enable <= '0';
		           -- control de buses
                   control_DATABUS_out <= '0'; control_ADDRBUS <= "00"; 
                   control_PC_Din <= '0'; control_Reg_Din <= '0';  
                   -- control del contador de programa
                   PC_cuenta <= '0'; PC_load <= '0';
                   -- control del fichero de registros de proposito general
                   Reg_enable <= '0'; Reg_write <= '0';
				   Reg_address_WR <= (others=>'0'); Reg_addr_A <= (others=>'0'); Reg_addr_B <= (others=>'0');
                   -- control de la ALU 
                   ALU_control <= "000";  -- control de operacion de la ALU
                   -- control del registro de instrucciones (RI: registro) 
                   RI_load <= '0';
                   -- control del stack pointer (USP: SP) 
                   SP_up <= '0'; SP_down <= '0'; SP_load <= '0';
                   -- control del registro de estado
                   STAT_C_load <= '0'; STAT_Z_load <= '0';
                   STAT_C_Set <= '0'; STAT_C_Clear <= '0';
				   STAT_SPF_load <= '0'; STAT_SPE_load <='0';
		 
		           proximo_estado <= STOP;
					  
	-------------------------------------------------------------------------------------
    when NOP   => -- ciclo 1 de busqueda de instrucción
		           -- control externo
		           WR_enable <= '0';
		           -- control de buses
                   control_DATABUS_out <= '0'; control_ADDRBUS <= "00"; 
                   control_PC_Din <= '0'; control_Reg_Din <= '0';  
                   -- control del contador de programa
                   PC_cuenta <= '0'; PC_load <= '0';
                   -- control del fichero de registros de proposito general
                   Reg_enable <= '0'; Reg_write <= '0';
				   Reg_address_WR <= (others=>'0'); Reg_addr_A <= (others=>'0'); Reg_addr_B <= (others=>'0');
                   -- control de la ALU 
                   ALU_control <= "000";  -- control de operacion de la ALU
                   -- control del registro de instrucciones (RI: registro) 
                   RI_load <= '0';
                   -- control del stack pointer (USP: SP) 
                   SP_up <= '0'; SP_down <= '0'; SP_load <= '0';
                   -- control del registro de estado
                   STAT_C_load <= '0'; STAT_Z_load <= '0';
                   STAT_C_Set <= '0'; STAT_C_Clear <= '0';
				   STAT_SPF_load <= '0'; STAT_SPE_load <='0';
		 
		           proximo_estado <= FETCH1;
	-------------------------------------------------------------------------------------
  end case;
end process;

end FSM;

