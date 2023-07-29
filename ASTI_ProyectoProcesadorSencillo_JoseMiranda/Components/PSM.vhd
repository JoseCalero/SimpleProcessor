----------------------------------------------------------------------------------
-- Máster en Microelectrónica: Diseño y Aplicaciones de Sistemas Micro/Nanométricos
-- Asignatura: Aplicaciones, sistemas y técnicas para el tratamiento de la información
-- Course: Applications, systems and techniques for information processing
-- 
-- Create Date:    2014/2015
-- PSM Procesador Simple del Master
-- Module Name:    PSM - estructura
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

use WORK.configuracion.all;

entity PSM is
	port (CLK         : in  STD_LOGIC;
		  Reset       : in  STD_LOGIC;
		  WR_enable   : out STD_LOGIC;
          dvalid      : in STD_LOGIC;
		  -- buses externos
		  DATABUS_in  : in  STD_LOGIC_VECTOR (31 downto 0);
		  DATABUS_out : out STD_LOGIC_VECTOR (31 downto 0);
		  ADDRBUS     : out STD_LOGIC_VECTOR (31 downto 0));
end PSM;

architecture estructura of PSM is
-- Definir aqui señales, tipos, funciones, etc 

	--component for mux2to1
	component mux2to1 is
	  port ( A_IN     : in std_logic_vector( 31 downto 0 );
			 B_IN     : in std_logic_vector( 31 downto 0 );
			 CONT_SIG : in  std_logic;
			 OUT_SIG  : out std_logic_vector( 31 downto 0 ) );
	end component;
	
	--component for mux3to1
	component mux3to1 is
	  port ( A_IN     : in std_logic_vector( 31 downto 0 );
			 B_IN     : in std_logic_vector( 31 downto 0 );
			 C_IN	  : in std_logic_vector( 31 downto 0 );
			 CONT_SIG: in std_logic_vector(1 downto 0);
			 OUT_SIG  : out std_logic_vector( 31 downto 0 ) );
	end component;
	
	--component for status register
	component STATUS is
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
	end component;
	
	--component for the ALU
	component alu is
		port (Rin, Sin :   In  std_logic_vector (31 downto 0);
			Cin      :   In  std_logic;                       
			Fout     :   Out std_logic_vector (31 downto 0); 
			Cout     :   Out std_logic;                       
			Cero     :   Out std_logic;                       
			Control  :   In  std_logic_vector (2 downto 0));
	end component;
	
	--component for the file register
	component file_register is
		Port ( clock        : in  STD_LOGIC;
			   ram_enable   : in  STD_LOGIC;
			   write_enable : in  STD_LOGIC;
			   address_write: in  STD_LOGIC_VECTOR (4 downto 0);
			   addressA     : in  STD_LOGIC_VECTOR (4 downto 0);
			   addressB     : in  STD_LOGIC_VECTOR (4 downto 0);
			   data_input   : in  STD_LOGIC_VECTOR (31 downto 0);
			   data_outputA : out STD_LOGIC_VECTOR (31 downto 0);
			   data_outputB : out STD_LOGIC_VECTOR (31 downto 0));
	end component;
	
	--component for Counter Program
	component PC is
		port (CLK   : in  STD_LOGIC;
			  Reset : in  STD_LOGIC;
			  Cuenta: in  STD_LOGIC;
			  Load  : in  STD_LOGIC;
			  Din   : in  STD_LOGIC_VECTOR (31 downto 0);
			  Dout  : out STD_LOGIC_VECTOR (31 downto 0));
	end component;
	
	--component for Ri
	component RI is
		port (CLK   : in  STD_LOGIC;
			  Reset : in  STD_LOGIC;
			  Load  : in  STD_LOGIC;
			  Din   : in  STD_LOGIC_VECTOR (31 downto 0);
			  Dout  : out STD_LOGIC_VECTOR (31 downto 0));
	end component;
	
	--component for SP
	component SP is
		port (CLK   : in  STD_LOGIC;
			  Reset : in  STD_LOGIC;
			  Up    : in  STD_LOGIC;
			  Down  : in  STD_LOGIC;
			  Load  : in  STD_LOGIC;
			  Din   : in  STD_LOGIC_VECTOR (31 downto 0);
			  Dout  : out STD_LOGIC_VECTOR (31 downto 0);
			  full  : out STD_LOGIC;
			  empty : out STD_LOGIC);
	end component;
	
	--component for UC (Unit Control)
	component Control is
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
	end component;
	
	--señales de control
	signal control_reg_din:     std_logic := '0';
	signal control_DATABUS_out: std_logic := '0';
	signal control_PC_Din:      std_logic := '0';
	signal control_ADDRBUS:     std_logic_vector(1 downto 0) := (others => '0');
	signal dir: std_logic_vector (31 downto 0);
	
	--señales temporales de entrada
	signal temp_in_fileReg:   std_logic_vector (31 downto 0) := (others => '0'); --Entrada Fichero registros
	signal temp_in_pc:        std_logic_vector (31 downto 0) := (others => '0'); --Entrada PC
	
	signal temp_pc_control_cuenta: std_logic := '0'; -- Salida UC puerto PC_cuenta, Entrada puerto Cuenta PC
	signal temp_pc_control_load: std_logic := '0'; -- Salida UC puerto PC_load, Entrada puerto Load PC
	
	-- Salida UC puerto Reg_enable, Entrada puerto ram_enable File_reg
	signal temp_fileReg_control_enable: std_logic := '0'; 
	-- Salida UC puerto Reg_write, Entrada puerto write_enable File_reg
	signal temp_fileReg_control_write:  std_logic := '0';
	-- Salida UC puerto Reg_address_WR, Entrada puerto address_write File_reg
	signal temp_fileReg_control_addressWR: std_logic_vector (4 downto 0) := (others => '0');
	-- Salida UC puerto Reg_addr_A, Entrada puerto addressA File_reg
	signal temp_fileReg_control_addrA: std_logic_vector (4 downto 0) := (others => '0');
	-- Salida UC puerto Reg_addr_B, Entrada puerto addressB File_reg
	signal temp_fileReg_control_addrB: std_logic_vector (4 downto 0) := (others => '0');
	
	-- Salida UC puerto ALU_control, Entrada puerto control alu
	signal temp_alu_control: std_logic_vector(2 downto 0) := (others => '0');
	
	-- Salida UC puerto RI_load, Entrada puerto Load RI
	signal temp_RI_control_load: std_logic := '0';
	
	-- Salida UC puerto SP_up, Entrada puerto Up SP
	signal temp_SP_control_Up:           std_logic := '0';
	-- Salida UC puerto SP_down, Entrada puerto Down SP
	signal temp_SP_control_Down:         std_logic := '0';
	-- Salida UC puerto SP_load, Entrada puerto Load SP
	signal temp_SP_control_Load:		 std_logic := '0';
	
	-- Salida UC puerto STAT_C_load, Entrada puerto  STAT
	signal temp_STAT_control_C_Load:         std_logic := '0';
	-- Salida UC puerto STAT_Z_load, Entrada puerto  STAT
	signal temp_STAT_control_Z_Load:		 std_logic := '0';
	-- Salida UC puerto STAT_C_Set, Entrada puerto  STAT
	signal temp_STAT_control_C_Set:           std_logic := '0';
	-- Salida UC puerto STAT_C_Clear, Entrada puerto  STAT
	signal temp_STAT_control_C_Clear:         std_logic := '0';
	-- Salida UC puerto STAT_SPF_load, Entrada puerto  STAT
	signal temp_STAT_control_F_Load:		 std_logic := '0';
	-- Salida UC puerto STAT_SPE_load, Entrada puerto  STAT
	signal temp_STAT_control_E_Load:		 std_logic := '0';
	
	--señales temporales de salida
	signal temp_out_alu:       std_logic_vector (31 downto 0) := (others => '0'); -- Salida ALU
	signal temp_out_alu_cout:  std_logic := '0'; -- Salida ALU acarreo
	signal temp_out_alu_cero:  std_logic := '0'; -- Salida ALU indicador de cero
	signal temp_out_pc:        std_logic_vector (31 downto 0) := (others => '0'); -- Salida PC
	signal temp_out_sp:        std_logic_vector (31 downto 0) := (others => '0'); -- Salida out SP
	signal temp_out_sp_empty:  std_logic := '0'; -- Salida empty SP
	signal temp_out_sp_full:   std_logic := '0'; -- Salida full SP
	signal temp_out_ri:        std_logic_vector (31 downto 0) := (others => '0'); -- Salida RI
	signal temp_out_fileReg_A: std_logic_vector (31 downto 0) := (others => '0'); -- Salida A Fichero de registros
	signal temp_out_fileReg_B: std_logic_vector (31 downto 0) := (others => '0'); -- Salida B Fichero de registros
	signal temp_out_stat_cout: std_logic := '0'; -- Salida registro acarreo STAT
	
	-- Otras señales temporales de control de los diferentes bloques
	-- Estas señales serán generadas por la unidad de control en el 
	-- siguiente entregable.
		
		--*******--
		--  SP   --
		--*******--
		signal stackPointer: std_logic_vector(31 downto 0):= STACK_BASE_ADDRESS;
		
		--*********--
		--  STAT   --
		--*********--		
		signal STAT_Z_out:   std_logic := '0';
		
		signal STAT_SPF_out: std_logic := '0';
		
		signal STAT_SPE_out:  std_logic := '0';
	
-- Fin de definiciones
begin
	
	dir <= (x"0000" & temp_out_ri(15 downto 0)) + MEM_BASE_ADDRESS;
	
-- Iniciar aquí la descripción 
	RI_reg: RI
		port map ( 
			  CLK => CLK,
			  Reset => Reset,
			  Load => temp_RI_control_load,
			  Din  => DATABUS_in,
			  Dout => temp_out_ri
			  );
			  
	SP_reg: SP
		port map (
			  CLK => CLK,
			  Reset => Reset,
			  Up   => temp_SP_control_Up,
			  Down => temp_SP_control_Down,
			  Load  => temp_SP_control_Load,
			  Din  => stackPointer,
			  Dout => temp_out_sp,
			  full => temp_out_sp_full,
			  empty => temp_out_sp_empty
			  );
	
	mux3: mux2to1
		port map ( 
				A_IN => DATABUS_in,
				B_IN => dir,
				CONT_SIG => control_PC_Din,
				OUT_SIG => temp_in_pc
				);
				
	PC_reg: PC
		port map (
			  CLK  => CLK,
			  Reset => Reset,
			  Cuenta => temp_pc_control_cuenta,
			  Load => temp_pc_control_load,
			  Din  => temp_in_pc,
			  Dout => temp_out_pc
			  );
			  
	mux4: mux3to1 
		port map ( 
				A_IN => temp_out_pc,
				B_IN => temp_out_sp,
				C_IN => dir,
				CONT_SIG => control_ADDRBUS,
				OUT_SIG => ADDRBUS
				);
				
	File_reg: file_register
		port map ( 
				clock        => CLK,
			   ram_enable    => temp_fileReg_control_enable,
			   write_enable  => temp_fileReg_control_write,
			   address_write => temp_fileReg_control_addressWR,
			   addressA      => temp_fileReg_control_addrA,
			   addressB      => temp_fileReg_control_addrB,
			   data_input    => temp_in_fileReg,
			   data_outputA  => temp_out_fileReg_A,
			   data_outputB  => temp_out_fileReg_B
			   );
			   
	Unidad_aritmetica: alu
		port map(
				Rin => temp_out_fileReg_A, 
				Sin => temp_out_fileReg_B,
				Cin => temp_out_stat_cout,
				Fout => temp_out_alu,   
				Cout => temp_out_alu_cout,
				Cero => temp_out_alu_cero,
				Control => temp_alu_control
				);
				
	mux1: mux2to1
		port map ( 
				A_IN => DATABUS_in,
				B_IN => temp_out_alu,
				CONT_SIG => control_reg_din,
				OUT_SIG => temp_in_fileReg
				);
				
	mux2: mux2to1
		port map ( 
				A_IN => temp_out_fileReg_A,
				B_IN => temp_out_pc,
				CONT_SIG => control_DATABUS_out,
				OUT_SIG => DATABUS_out
				);	
	
	STAT: STATUS
		port map (CLK => CLK,       
				Reset => Reset,
				
				-- acarreo
				STAT_C_load  => temp_STAT_control_C_Load,
				STAT_C_Set   => temp_STAT_control_C_Set,
				STAT_C_Clear => temp_STAT_control_C_Clear,
				STAT_C_in    => temp_out_alu_cout,
				STAT_C_out   => temp_out_stat_cout,
				
				-- indicador de cero
				STAT_Z_load => temp_STAT_control_Z_Load,
				STAT_Z_in   => temp_out_alu_cero,
				STAT_Z_out  => STAT_Z_out,
				
				-- stack pointer
				STAT_SPF_load => temp_STAT_control_F_Load,
				STAT_SPF_in   => temp_out_sp_full,
				STAT_SPF_out  => STAT_SPF_out,

				STAT_SPE_load => temp_STAT_control_E_Load,
				STAT_SPE_in   => temp_out_sp_empty,
				STAT_SPE_out => STAT_SPE_out
				);
				
	UC: Control
		port map (
				  CLK => CLK,
				  Reset  => Reset,
				  -- control externo
				  WR_enable => WR_enable,
				  dvalid => dvalid,
				  -- control de buses
				  control_DATABUS_out => control_DATABUS_out, -- Control de bus externo de datos de salida
				  control_ADDRBUS => control_ADDRBUS, -- Control de bus de externo de direccion
				  control_PC_Din => control_PC_Din, -- control del bus de entrada del PC
				  control_Reg_Din => control_reg_din, -- control del bus de entrada del fichero de registros 
				  -- control del contador de programa
				  PC_cuenta =>temp_pc_control_cuenta,
				  PC_load   =>temp_pc_control_load,
				  -- control del fichero de registros de proposito general
				  Reg_enable => temp_fileReg_control_enable,
				  Reg_write => temp_fileReg_control_write,
				  Reg_address_WR => temp_fileReg_control_addressWR,
				  Reg_addr_A => temp_fileReg_control_addrA,
				  Reg_addr_B => temp_fileReg_control_addrB,
				  -- control de la ALU 
				  ALU_control => temp_alu_control,
				  -- control del registro de instrucciones (RI: registro) 
				  RI_load => temp_RI_control_load,
				  RI_Dout => temp_out_ri,
				  -- control del stack pointer (USP: SP) 
				  SP_up => temp_SP_control_Up,
				  SP_down => temp_SP_control_Down,
				  SP_load => temp_SP_control_Load,
				 -- control del registro de estado
				  STAT_C    => temp_out_alu_cout,
				  STAT_C_load => temp_STAT_control_C_Load,
				  STAT_Z_load => temp_STAT_control_Z_Load,
				  STAT_C_Set => temp_STAT_control_C_Set,
				  STAT_C_Clear => temp_STAT_control_C_Clear,
				  STAT_SPF_load => temp_STAT_control_F_Load,
				  STAT_SPE_load => temp_STAT_control_E_Load
				);

-- Fin de la descripción
end estructura;

