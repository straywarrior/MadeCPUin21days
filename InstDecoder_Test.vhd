--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:33:51 11/14/2015
-- Design Name:   
-- Module Name:   InstDecoder_Test
-- Project Name:  MadeCPUin21days
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: InstDecoder
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY InstDecoder_Test IS
END InstDecoder_Test;
 
ARCHITECTURE behavior OF InstDecoder_Test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT InstDecoder
    PORT(
         pc : IN  std_logic_vector(15 downto 0);
         inst : IN  std_logic_vector(15 downto 0);
         RegAVal : IN  std_logic_vector(15 downto 0);
         RegBVal : IN  std_logic_vector(15 downto 0);
         RAVal : IN  std_logic_vector(15 downto 0);
         SPVal : IN  std_logic_vector(15 downto 0);
         IHVal : IN  std_logic_vector(15 downto 0);
         pc_imm : OUT  std_logic_vector(15 downto 0);
         pc_sel : OUT  std_logic_vector(1 downto 0);
         T_in : in STD_LOGIC;
         T_out : out STD_LOGIC;
         CReg : OUT  std_logic;
         CRegA : OUT  std_logic_vector(3 downto 0);
         CRegB : OUT  std_logic_vector(3 downto 0);
         RegWE : OUT  std_logic;
         RegDest : OUT  std_logic_vector(3 downto 0);
         MemRd : OUT  std_logic;
         MemDIn : OUT  std_logic_vector(15 downto 0);
         MemWE : OUT  std_logic;
         opcode : OUT  std_logic_vector(3 downto 0);
         RegOpA : OUT  std_logic_vector(3 downto 0);
         RegOpB : OUT  std_logic_vector(3 downto 0);
         operandA : OUT  std_logic_vector(15 downto 0);
         operandB : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    
    COMPONENT T_REG
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           T_in : in STD_LOGIC;
           T_out : out STD_LOGIC
         );
    END COMPONENT;
   
   --Inputs
   signal pc : std_logic_vector(15 downto 0) := (others => '0');
   signal inst : std_logic_vector(15 downto 0) := (others => '0');
   signal RegAVal : std_logic_vector(15 downto 0) := (others => '0');
   signal RegBVal : std_logic_vector(15 downto 0) := (others => '0');
   signal RAVal : std_logic_vector(15 downto 0) := (others => '0');
   signal SPVal : std_logic_vector(15 downto 0) := (others => '0');
   signal IHVal : std_logic_vector(15 downto 0) := (others => '0');

   --Outputs
   signal pc_imm : std_logic_vector(15 downto 0);
   signal pc_sel : std_logic_vector(1 downto 0);
   signal RegWE : std_logic;
   signal RegDest : std_logic_vector(3 downto 0);
   signal MemRd : std_logic;
   signal MemDIn : std_logic_vector(15 downto 0);
   signal MemWE : std_logic;
   signal opcode : std_logic_vector(3 downto 0);
   signal CReg : std_logic;
   signal CRegA : std_logic_vector(3 downto 0);
   signal CRegB : std_logic_vector(3 downto 0);
   signal RegOpA : std_logic_vector(3 downto 0);
   signal RegOpB : std_logic_vector(3 downto 0);
   signal operandA : std_logic_vector(15 downto 0);
   signal operandB : std_logic_vector(15 downto 0);
   -- No clocks detected in port list. Replace clock below with 
   -- appropriate port name 
   signal clock : std_logic;
   constant clock_period : time := 50 ns;
   
   signal reset : std_logic;
   
   --Medium Line
   signal T_REG_out : std_logic;
   signal T_REG_in : std_logic;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: InstDecoder PORT MAP (
          pc => pc,
          inst => inst,
          RegAVal => RegAVal,
          RegBVal => RegBVal,
          RAVal => RAVal,
          SPVal => SPVal,
          IHVal => IHVal,
          pc_imm => pc_imm,
          pc_sel => pc_sel,
          RegWE => RegWE,
          RegDest => RegDest,
          MemRd => MemRd,
          MemDIn => MemDIn,
          MemWE => MemWE,
          opcode => opcode,
          RegOpA => RegOpA,
          RegOpB => RegOpB,
          operandA => operandA,
          operandB => operandB,
          CReg => CReg,
          CRegA => CRegA,
          CRegB => CRegB,
          T_in => T_REG_out,
          T_out => T_REG_in
        );
   
   t_reg_0 : T_REG PORT MAP(
          clock, reset, T_REG_in, T_REG_out
        );

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		-- hold reset state for 100 ns.
        reset <= '1';
        wait for 25 ns;
        reset <= '0';
        
		wait for 75 ns;
        -- LI R0 x"FF"
        inst <= "0110100011111111";
        wait for clock_period;
        
        -- SW R0 R1 1
        inst <= "1101100000100001";
        wait for clock_period;
        
		-- R Type
		-- ADDU
		inst <= "1110000101001101";
		wait for clock_period;

		-- SUBU
		inst <= "1110011101100111";
		wait for clock_period;
		
		-- SLT
		inst <= "1110100101100010";
		wait for clock_period;
		
		-- SLTU
		inst <= "1110101101000011";
		wait for clock_period;
		
		-- SLLV
		inst <= "1110100101000100";
		wait for clock_period;
		
		-- SRLV
		inst <= "1110110101100110";
		wait for clock_period;
		
		-- SRAV
		inst <= "1110110000100111";
		wait for clock_period;
		
		-- CMP
		inst <= "1110101010101010";
		wait for clock_period;
		
		-- NEG
		inst <= "1110101010101011";
		wait for clock_period;
		
		-- AND
		inst <= "1110101010101100";
		wait for clock_period;
		
		-- OR
		inst <= "1110101010101101";
		wait for clock_period;
		
		-- XOR
		inst <= "1110101010101110";
		wait for clock_period;
		
		-- NOT
		inst <= "1110101010101111";
		wait for clock_period;
		
		-- MFPC
		inst <= "1110101001000000";
		wait for clock_period;
		
		-- MFIH
		inst <= "1111001100000000";
		wait for clock_period;
		
		-- MTIH
		inst <= "1111000100000001";
		wait for clock_period;
		
		-- SLL
		inst <= "0011000101001000";
		wait for clock_period;
		
		-- SRA
		inst <= "0011001011011010";
		wait for clock_period;
		
		-- SRA
		inst <= "0011000101001011";
		wait for clock_period;
		
		-- MOVE
		inst <= "0111101100100000";
		wait for clock_period;
		
		-- MTSP
		inst <= "0110010000100000";
		wait for clock_period;
		
		-- I Type
		-- ADDSP3
		inst <= "0000001000100001";
		wait for clock_period;
		
		-- ADDIU3
		inst <= "0100001000100001";
		wait for clock_period;

		-- ADDIU
		inst <= "0100100100100010";
		wait for clock_period;
		
		-- SLTI
		inst <= "0101001000100011";
		wait for clock_period;
		
		-- SLTUI
		inst <= "0101100100100100";
		wait for clock_period;
        
		-- SW_RS
		inst <= "0110001000100101";
		wait for clock_period;
		
		-- ADDSP
		inst <= "0110001100100110";
		wait for clock_period;
		
		-- LI
		inst <= "0110100100100111";
		wait for clock_period;
		
		-- CMPI
		inst <= "0111001000101000";
		wait for clock_period;
		
		-- LW_SP
		inst <= "1001001100101001";
		wait for clock_period;
				
		-- LW
		inst <= "1001110000101010";
		wait for clock_period;

		-- SW_SP
		inst <= "1101010100101011";
		wait for clock_period;
		
		-- SW
		inst <= "1101111000101100";
		wait for clock_period;
		
		-- B Type
		-- B
		inst <= "0001010000101101";
		wait for clock_period;
		
		-- BEQZ
		inst <= "0010000100101110";
		wait for clock_period;
		
		-- BNEZ
		inst <= "0010110000101111";
		wait for clock_period;
		
		-- BTEQZ
		inst <= "0110000000110000";
		wait for clock_period;
		
		-- BTNEZ
		inst <= "0110000100110001";
		wait for clock_period;
		
		-- J Type
		-- JR
		inst <= "1110101000000000";
		wait for clock_period;
		
		-- JRRA
		inst <= "1110100000100000";
		wait for clock_period;
		
		-- JALR
		inst <= "1110101111000000";
		wait for clock_period;
		
		-- INT
		inst <= "1111100000000000";
		wait for clock_period;
		
		-- NOP
		inst <= "0000100000000000";
		wait for clock_period;
		
		-- insert stimulus here 

      wait;
   end process;

END;
