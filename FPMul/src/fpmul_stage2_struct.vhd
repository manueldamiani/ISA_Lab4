-- VHDL Entity HAVOC.FPmul_stage2.interface
--
-- Created by
-- Guillermo Marcus, gmarcus@ieee.org
-- using Mentor Graphics FPGA Advantage tools.
--
-- Visit "http://fpga.mty.itesm.mx" for more info.
--
-- 2003-2004. V1.0
--

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
use WORK.constants.all;
use WORK.all;

ENTITY FPmul_stage2 IS
   PORT( 
      A_EXP           : IN     std_logic_vector (7 DOWNTO 0);
      A_SIG           : IN     std_logic_vector (31 DOWNTO 0);
      B_EXP           : IN     std_logic_vector (7 DOWNTO 0);
      B_SIG           : IN     std_logic_vector (31 DOWNTO 0);
      SIGN_out_stage1 : IN     std_logic;
      clk             : IN     std_logic;
      isINF_stage1    : IN     std_logic;
      isNaN_stage1    : IN     std_logic;
      isZ_tab_stage1  : IN     std_logic;
      EXP_in          : OUT    std_logic_vector (7 DOWNTO 0);
      EXP_neg_stage2  : OUT    std_logic;
      EXP_pos_stage2  : OUT    std_logic;
      SIGN_out_stage2 : OUT    std_logic;
      SIG_in          : OUT    std_logic_vector (27 DOWNTO 0);
      isINF_stage2    : OUT    std_logic;
      isNaN_stage2    : OUT    std_logic;
      isZ_tab_stage2  : OUT    std_logic
   );

-- Declarations

END FPmul_stage2 ;

--
-- VHDL Architecture HAVOC.FPmul_stage2.struct
--
-- Created by
-- Guillermo Marcus, gmarcus@ieee.org
-- using Mentor Graphics FPGA Advantage tools.
--
-- Visit "http://fpga.mty.itesm.mx" for more info.
--
-- Copyright 2003-2004. V1.0
--


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;


ARCHITECTURE struct OF FPmul_stage2 IS

   -- Architecture declarations
   COMPONENT regn0
   PORT (  D   : IN std_logic;
	   CLK : IN std_logic;
	   Q   : OUT std_logic);
   END COMPONENT;
   COMPONENT regn
   GENERIC(N : integer := 32);
   PORT (  D   : IN std_logic_vector(N-1 DOWNTO 0);
	   CLK : IN std_logic;
	   Q   : OUT std_logic_vector(N-1 DOWNTO 0));
   END COMPONENT;

   COMPONENT MBE IS
      PORT(A : IN     std_logic_vector (N-1 DOWNTO 0);
      	   B : IN     std_logic_vector (N-1 DOWNTO 0);
      	   P  : OUT    std_logic_vector (2*N-1 DOWNTO 0));
   END COMPONENT;

   -- Internal signal declarations
   SIGNAL EXP_in_int  : std_logic_vector(7 DOWNTO 0);
   SIGNAL EXP_in_int2 : std_logic_vector(7 DOWNTO 0);
   SIGNAL EXP_neg_int : std_logic;
   SIGNAL EXP_neg_int2 : std_logic;
   SIGNAL EXP_pos_int : std_logic;
   SIGNAL EXP_pos_int2 : std_logic;
   SIGNAL SIG_in_int  : std_logic_vector(27 DOWNTO 0);
   SIGNAL SIG_in_int2 : std_logic_vector(27 DOWNTO 0);
   SIGNAL dout        : std_logic;
   SIGNAL dout1       : std_logic_vector(7 DOWNTO 0);
   SIGNAL prod        : std_logic_vector(63 DOWNTO 0);
   SIGNAL SIGN_out_stage1_int : std_logic;
   SIGNAL isINF_stage1_int : std_logic;
   SIGNAL isNaN_stage1_int: std_logic;
   SIGNAL isZ_tab_stage1_int: std_logic;
	


BEGIN
   -- Architecture concurrent statements
   -- HDL Embedded Text Block 1 sig
   -- eb1 1
   SIG_in_int2 <= prod(47 DOWNTO 20);

   -- HDL Embedded Text Block 2 inv
   -- eb5 5
   EXP_in_int2 <= (NOT dout1(7)) & dout1(6 DOWNTO 0);

   -- HDL Embedded Text Block 3 latch
   -- eb2 2
   
   REG_sig_in : regn
      GENERIC MAP(N => 28)
	  PORT MAP (D => SIG_in_int2, CLK => clk, Q => SIG_in_int);

   REG_exp_in : regn
      GENERIC MAP(N => 8)
	  PORT MAP (D => EXP_in_int2, CLK => clk,Q => EXP_in_int);

   REG_exp_pos : regn0
	  PORT MAP (D => EXP_pos_int2,CLK => clk,Q => EXP_pos_int);
   REG_exp_neg : regn0
	  PORT MAP (D => EXP_neg_int2,CLK => clk,Q => EXP_neg_int);
   REG_sign_out : regn0
	  PORT MAP (D => SIGN_out_stage1,CLK => clk, Q => SIGN_out_stage1_int);
   REG_isInf : regn0
	  PORT MAP (D => isINF_stage1,CLK => clk, Q => isINF_stage1_int);
   REG_isNan : regn0
	  PORT MAP (D => isNaN_stage1,CLK => clk, Q => isNaN_stage1_int);
   REG_isZ : regn0
	  PORT MAP (D => isZ_tab_stage1,CLK => clk, Q => isZ_tab_stage1_int);
 
   PROCESS(clk)
   BEGIN
      IF RISING_EDGE(clk) THEN
         EXP_in <= EXP_in_int;
         SIG_in <= SIG_in_int;
         EXP_pos_stage2 <= EXP_pos_int;
         EXP_neg_stage2 <= EXP_neg_int;
      END IF;
   END PROCESS;

   -- HDL Embedded Text Block 4 latch2
   -- latch2 4
   PROCESS(clk)
   BEGIN
      IF RISING_EDGE(clk) THEN
         isINF_stage2 <= isINF_stage1_int;
         isNaN_stage2 <= isNaN_stage1_int;
         isZ_tab_stage2 <= isZ_tab_stage1_int;
         SIGN_out_stage2 <= SIGN_out_stage1_int;
      END IF;
   END PROCESS;

   -- HDL Embedded Text Block 5 eb1
   -- exp_pos 5
   EXP_pos_int2 <= A_EXP(7) AND B_EXP(7);
--   EXP_neg_int <= NOT(A_EXP(7) OR B_EXP(7));
   EXP_neg_int2 <= '1' WHEN ( (A_EXP(7)='0' AND NOT (A_EXP=X"7F")) AND (B_EXP(7)='0' AND NOT (B_EXP=X"7F")) ) ELSE '0';


   -- ModuleWare code(v1.1) for instance 'I4' of 'add'
   I4combo: PROCESS (A_EXP, B_EXP, dout)
   VARIABLE mw_I4t0 : std_logic_vector(8 DOWNTO 0);
   VARIABLE mw_I4t1 : std_logic_vector(8 DOWNTO 0);
   VARIABLE mw_I4sum : unsigned(8 DOWNTO 0);
   VARIABLE mw_I4carry : std_logic;
   BEGIN
      mw_I4t0 := '0' & A_EXP;
      mw_I4t1 := '0' & B_EXP;
      mw_I4carry := dout;
      mw_I4sum := unsigned(mw_I4t0) + unsigned(mw_I4t1) + mw_I4carry;
      dout1 <= conv_std_logic_vector(mw_I4sum(7 DOWNTO 0),8);
   END PROCESS I4combo;

   -- ModuleWare code(v1.1) for instance 'I2' of 'mult'
   --I2combo : PROCESS (A_SIG, B_SIG)
   --VARIABLE dtemp : unsigned(63 DOWNTO 0);
   --BEGIN
   --   dtemp := (unsigned(A_SIG) * unsigned(B_SIG));
    --  prod <= std_logic_vector(dtemp);
   --END PROCESS I2combo;


	Mul : MBE PORT MAP(	A => A_SIG,
      	   			B => B_SIG,
      	  	 		P => prod);

   -- ModuleWare code(v1.1) for instance 'I6' of 'vdd'
   dout <= '1';

   -- Instance port mappings.

END struct;
