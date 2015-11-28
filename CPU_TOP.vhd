----------------------------------------------------------------------------------
-- Company: 
-- Engineer:       StrayWarrior
-- 
-- Create Date:    20:37:26 11/15/2015 
-- Design Name: 
-- Module Name:    CPU_TOP - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.Vcomponents.all;

entity CPU_TOP is
    Port ( clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           RAM1ADDR : out  STD_LOGIC_VECTOR (17 downto 0);
           RAM1DATA : inout  STD_LOGIC_VECTOR (15 downto 0);
           RAM1EN : out STD_LOGIC;
           RAM1OE : out STD_LOGIC;
           RAM1RW : out STD_LOGIC;

           RAM2ADDR : out  STD_LOGIC_VECTOR (17 downto 0);
           RAM2DATA : inout  STD_LOGIC_VECTOR (15 downto 0);
           RAM2EN : out STD_LOGIC;
           RAM2OE : out STD_LOGIC;
           RAM2RW : out STD_LOGIC;
           
           -- Serial Port
           SERIAL_DATA_READY : in STD_LOGIC;
           SERIAL_RDN : out STD_LOGIC;
           SERIAL_TBRE : in STD_LOGIC;
           SERIAL_TSRE : in STD_LOGIC;
           SERIAL_WRN : out STD_LOGIC;
           
           -- For Debug
           LED : out  STD_LOGIC_VECTOR (15 downto 0);
           SW : in STD_LOGIC_VECTOR (15 downto 0);
           DLED_RIGHT : out STD_LOGIC_VECTOR (6 downto 0)
           );
end CPU_TOP;

architecture Behavioral of CPU_TOP is

-- Universal component
    component ClockDiv
        Port ( clk : in  STD_LOGIC;
               reset : in  STD_LOGIC;
               clk_2t : out STD_LOGIC;
               clk_4t : out STD_LOGIC
               );
    end component;

    signal clock_2t : STD_LOGIC;
    signal clock_4t : STD_LOGIC;
    
    component TwoInMuxer_16bit
        Port ( input1 : in  STD_LOGIC_VECTOR (15 downto 0);
               input2 : in  STD_LOGIC_VECTOR (15 downto 0);
               opcode : in  STD_LOGIC;
               output : out  STD_LOGIC_VECTOR (15 downto 0));
    end component;

    component FourInMuxer_16bit
        Port ( input1 : in  STD_LOGIC_VECTOR (15 downto 0);
               input2 : in  STD_LOGIC_VECTOR (15 downto 0);
               input3 : in  STD_LOGIC_VECTOR (15 downto 0);
               input4 : in  STD_LOGIC_VECTOR (15 downto 0);
               opcode : in  STD_LOGIC_VECTOR (1 downto 0);
               output : out  STD_LOGIC_VECTOR (15 downto 0));
    end component;

    component BubbleUnit
        Port ( RegOpA : in  STD_LOGIC_VECTOR (3 downto 0);
               RegOpB : in  STD_LOGIC_VECTOR (3 downto 0);
               RegWE_EXE : in  STD_LOGIC;
               RegDest_EXE : in  STD_LOGIC_VECTOR (3 downto 0);
               RegWE_MEM: in  STD_LOGIC;
               RegDest_MEM : in  STD_LOGIC_VECTOR (3 downto 0);
               MemRead_EXE : in  STD_LOGIC;
               MemWrite_EXE : in  STD_LOGIC;
               MemRead_MEM : in STD_LOGIC;
               MemWrite_MEM : in STD_LOGIC;
               MemAddr : in  STD_LOGIC_VECTOR (15 downto 0);
               pc_sel: in  STD_LOGIC_VECTOR (1 downto 0);
               CReg : in STD_LOGIC;
               CRegA : in STD_LOGIC_VECTOR (3 downto 0);
               CRegB : in STD_LOGIC_VECTOR (3 downto 0);
            
               SerialFinish : in STD_LOGIC;
               
               pc_stall : out  STD_LOGIC;
               InstAddrSel : out  STD_LOGIC;
               InstMemRead : out  STD_LOGIC;
               InstMemWrite : out  STD_LOGIC;
               Mem_Result_Sel : out STD_LOGIC;
               
               IF_ID_stall : out  STD_LOGIC;
               ID_EXE_stall : out  STD_LOGIC;
               EXE_MEM_stall : out  STD_LOGIC;
               IF_ID_clear: out  STD_LOGIC;
               ID_EXE_clear : out  STD_LOGIC;
               EXE_MEM_clear: out  STD_LOGIC
               );
    end component;
    
    signal IF_ID_REG_STALL : STD_LOGIC;
    signal IF_ID_REG_CLEAR : STD_LOGIC;
    signal ID_EXE_REG_STALL : STD_LOGIC;
    signal ID_EXE_REG_CLEAR : STD_LOGIC;
    signal EXE_MEM_REG_STALL : STD_LOGIC;
    signal EXE_MEM_REG_CLEAR : STD_LOGIC;

    component ForwardingUnit
        Port ( RegOpA : in  STD_LOGIC_VECTOR (3 downto 0);
               RegOpB : in  STD_LOGIC_VECTOR (3 downto 0);
               RegWE_MEM: in  STD_LOGIC;
               RegDest_MEM : in  STD_LOGIC_VECTOR (3 downto 0);
               RegWE_WB : in STD_LOGIC;
               RegDest_WB : STD_LOGIC_VECTOR (3 downto 0);
               MemRead_EXE : in  STD_LOGIC;
               MemRead_WB : in STD_LOGIC;
               CReg : in STD_LOGIC;
               CRegA : in STD_LOGIC_VECTOR (3 downto 0);
               CRegB : in STD_LOGIC_VECTOR (3 downto 0);
               RegMemDIn : in STD_LOGIC_VECTOR (3 downto 0);

               RegAValSel : out STD_LOGIC;
               RegBValSel : out STD_LOGIC;
               RegRAValSel : out STD_LOGIC;
               OperandASel : out STD_LOGIC_VECTOR (1 downto 0);
               OperandBSel : out STD_LOGIC_VECTOR (1 downto 0);
               MemDInSel : out STD_LOGIC_VECTOR (1 downto 0)
               );
    end component;

-- IF Section

    component PC_REG
        Port ( clk : in  STD_LOGIC;
               reset : in STD_LOGIC;
               stall : in  STD_LOGIC;
               PC_in : in STD_LOGIC_VECTOR (15 downto 0);
               PC_out : out STD_LOGIC_VECTOR (15 downto 0)
             );
    end component;

    component PCAdder
        Port ( A : in  STD_LOGIC_VECTOR (15 downto 0);
               B : in  STD_LOGIC_VECTOR (15 downto 0);
               result : out  STD_LOGIC_VECTOR (15 downto 0));
    end component;

    COMPONENT InstMemoryControl
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               MemRead : in STD_LOGIC;
               MemWrite: in STD_LOGIC;
               MemAddr : in  STD_LOGIC_VECTOR (15 downto 0);
               MemData : in  STD_LOGIC_VECTOR (15 downto 0);
               MemOut : out STD_LOGIC_VECTOR (15 downto 0);

               RAM2Addr : out STD_LOGIC_VECTOR (17 downto 0);
               RAM2Data : inout STD_LOGIC_VECTOR (15 downto 0);
               RAM2EN : out STD_LOGIC;
               RAM2OE : out STD_LOGIC;
               RAM2RW : out STD_LOGIC
             );
    end COMPONENT;

    component IF_ID_REG
        Port ( clk : in  STD_LOGIC;
               reset : in STD_LOGIC;
               pc_in : in  STD_LOGIC_VECTOR (15 downto 0);
               inst_in : in  STD_LOGIC_VECTOR (15 downto 0);    
               stall : in  STD_LOGIC;
               clear : in  STD_LOGIC;
               pc_out : out  STD_LOGIC_VECTOR (15 downto 0);
               inst_out : out  STD_LOGIC_VECTOR (15 downto 0);
               rx : out  STD_LOGIC_VECTOR (3 downto 0);
               ry : out  STD_LOGIC_VECTOR (3 downto 0)
               );
    end component;
    
    -- PC Register
    signal PC_REG_IN : STD_LOGIC_VECTOR (15 downto 0);
    signal PC_REG_OUT : STD_LOGIC_VECTOR (15 downto 0);
    signal PC_REG_STALL : STD_LOGIC;
    -- Instruction Selector
    signal INST_ADDR_OUT : STD_LOGIC_VECTOR (15 downto 0);
    signal INST_ADDR_SEL : STD_LOGIC;
    -- Instruction Memory
    signal INST_MEM_READ : STD_LOGIC;
    signal INST_MEM_WRITE : STD_LOGIC;
    signal INST_MEM_OUT : STD_LOGIC_VECTOR (15 downto 0);
    -- PC Incr & PC Selector
    signal PC_INCR_OUT : STD_LOGIC_VECTOR (15 downto 0);
    -- signal PC_JUMP : STD_LOGIC_VECTOR (15 downto 0);
    -- signal PC_SEL : STD_LOGIC_VECTOR (1 downto 0);
    signal PC_INCR : STD_LOGIC_VECTOR (15 downto 0) := ( 0 => '1', others => '0');
    -- IF/ID Register


-- ID Section
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
             RegMemDIn : out STD_LOGIC_VECTOR (3 downto 0);
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
    
    COMPONENT Register_Files
        Port ( clk : in  STD_LOGIC;
               reset : in STD_LOGIC;
               ASel : in  STD_LOGIC_VECTOR (3 downto 0);
               BSel : in  STD_LOGIC_VECTOR (3 downto 0);
               WSel : in  STD_LOGIC_VECTOR (3 downto 0);
               WE : in  STD_LOGIC;
               WVal : in  STD_LOGIC_VECTOR (15 downto 0);
               AVal : out  STD_LOGIC_VECTOR (15 downto 0);
               BVal : out  STD_LOGIC_VECTOR (15 downto 0);
               RAVal : out  STD_LOGIC_VECTOR (15 downto 0);
               SPVal : out  STD_LOGIC_VECTOR (15 downto 0);
               IHVal : out  STD_LOGIC_VECTOR (15 downto 0)
               );
    end COMPONENT;

    COMPONENT ID_EXE_REG
        Port ( clk : in  STD_LOGIC;
               reset : in  STD_LOGIC;
               clear : in  STD_LOGIC;
               stall : in  STD_LOGIC;
               RegWE_in : in  STD_LOGIC;
               RegDest_in : in  STD_LOGIC_VECTOR (3 downto 0);
               MemRd_in : in  STD_LOGIC;
               MemWE_in : in  STD_LOGIC;
               MemDIn_in : in  STD_LOGIC_VECTOR (15 downto 0);
               opcode_in : in  STD_LOGIC_VECTOR (3 downto 0);
               operandA_in : in  STD_LOGIC_VECTOR (15 downto 0);
               operandB_in : in  STD_LOGIC_VECTOR (15 downto 0);
               RegOpA_in : in  STD_LOGIC_VECTOR (3 downto 0);
               RegOpB_in : in  STD_LOGIC_VECTOR (3 downto 0);
               RegMemDIn_in : in STD_LOGIC_VECTOR (3 downto 0);
               RegWE_out : out  STD_LOGIC;
               RegDest_out : out  STD_LOGIC_VECTOR (3 downto 0);
               MemRd_out : out  STD_LOGIC;
               MemWE_out : out  STD_LOGIC;
               MemDIn_out : out  STD_LOGIC_VECTOR (15 downto 0);
               opcode_out : out  STD_LOGIC_VECTOR (3 downto 0);
               operandA_out : out  STD_LOGIC_VECTOR (15 downto 0);
               operandB_out : out  STD_LOGIC_VECTOR (15 downto 0);
               RegOpA_out : out  STD_LOGIC_VECTOR (3 downto 0);
               RegOpB_out : out  STD_LOGIC_VECTOR (3 downto 0);
               RegMemDIn_out : out STD_LOGIC_VECTOR (3 downto 0)
               );
    end COMPONENT;

    -- IF/ID Register Out
    signal IF_ID_PC : STD_LOGIC_VECTOR (15 downto 0);
    signal IF_ID_INST : STD_LOGIC_VECTOR (15 downto 0);
    signal IF_ID_REGX : STD_LOGIC_VECTOR (3 downto 0); 
    signal IF_ID_REGY : STD_LOGIC_VECTOR (3 downto 0); 
    -- T Register & Instruction Decoder
    signal T_REG_OUT : STD_LOGIC;
    signal T_REG_IN : STD_LOGIC;
    signal Decoder_PC_Imm: STD_LOGIC_VECTOR (15 downto 0);
    signal Decoder_PC_Sel : STD_LOGIC_VECTOR (1 downto 0);
    signal Decoder_RegDest : STD_LOGIC_VECTOR (3 downto 0);
    signal Decoder_RegWrite : STD_LOGIC;
    signal Decoder_MemRead : STD_LOGIC;
    signal Decoder_MemDIn : STD_LOGIC_VECTOR (15 downto 0);
    signal Decoder_RegMemDIn : STD_LOGIC_VECTOR (3 downto 0);
    signal Decoder_MemWrite : STD_LOGIC;
    signal Decoder_OpCode : STD_LOGIC_VECTOR (3 downto 0);
    signal Decoder_OperandA : STD_LOGIC_VECTOR (15 downto 0);
    signal Decoder_OperandB : STD_LOGIC_VECTOR (15 downto 0);
    signal Decoder_RegOpA : STD_LOGIC_VECTOR (3 downto 0);
    signal Decoder_RegOpB : STD_LOGIC_VECTOR (3 downto 0);
    signal Decoder_CReg : STD_LOGIC;
    signal Decoder_CRegA : STD_LOGIC_VECTOR (3 downto 0);
    signal Decoder_CRegB : STD_LOGIC_VECTOR (3 downto 0);
    -- Register Files
    signal Regs_RegAVal : STD_LOGIC_VECTOR (15 downto 0);
    signal Regs_RegBVal : STD_LOGIC_VECTOR (15 downto 0);
    signal Regs_RAVal : STD_LOGIC_VECTOR (15 downto 0);
    signal Regs_SPVal : STD_LOGIC_VECTOR (15 downto 0);
    signal Regs_IHVal : STD_LOGIC_VECTOR (15 downto 0);
    -- PC Adder
    signal PC_JUMP_ADDR : STD_LOGIC_VECTOR (15 downto 0);

    

-- EXE Section

    COMPONENT ALU
        Port ( op : in  STD_LOGIC_VECTOR (3 downto 0);
               A : in  STD_LOGIC_VECTOR (15 downto 0);
               B : in  STD_LOGIC_VECTOR (15 downto 0);
               result : out  STD_LOGIC_VECTOR (15 downto 0));
    end COMPONENT;
        
    COMPONENT EXE_MEM_REG
        Port ( clk : in  STD_LOGIC;
               reset : in STD_LOGIC;
               clear : in  STD_LOGIC;
               stall : in  STD_LOGIC;
               RegWE_in : in  STD_LOGIC;
               RegDest_in : in  STD_LOGIC_VECTOR (3 downto 0);
               MemRd_in : in  STD_LOGIC;
               MemWE_in : in  STD_LOGIC;
               MemDIn_in : in  STD_LOGIC_VECTOR (15 downto 0);
               ALUout_in : in  STD_LOGIC_VECTOR (15 downto 0);
               RegWE_out : out  STD_LOGIC;
               RegDest_out : out  STD_LOGIC_VECTOR (3 downto 0);
               MemRd_out : out  STD_LOGIC;
               MemWE_out : out  STD_LOGIC;
               MemDIn_out : out  STD_LOGIC_VECTOR (15 downto 0);
               ALUout_out : out  STD_LOGIC_VECTOR (15 downto 0)
               );
    end COMPONENT;

    -- ID/EXE Register
    signal ID_EXE_RegWrite : STD_LOGIC;
    signal ID_EXE_RegDest : STD_LOGIC_VECTOR (3 downto 0);
    signal ID_EXE_MemRead : STD_LOGIC;
    signal ID_EXE_MemDIn : STD_LOGIC_VECTOR (15 downto 0);
    signal ID_EXE_MemWrite : STD_LOGIC;
    signal ID_EXE_RegMemDIn : STD_LOGIC_VECTOR (3 downto 0);
    signal ID_EXE_OpCode : STD_LOGIC_VECTOR (3 downto 0);
    signal ID_EXE_OperandA : STD_LOGIC_VECTOR (15 downto 0);
    signal ID_EXE_OperandB : STD_LOGIC_VECTOR (15 downto 0);
    signal ID_EXE_RegOpA : STD_LOGIC_VECTOR (3 downto 0);
    signal ID_EXE_RegOpB : STD_LOGIC_VECTOR (3 downto 0);
    -- Operand A Selector
    signal OpA_MUX_OUT : STD_LOGIC_VECTOR (15 downto 0);
    -- Operand B Selector
    signal OpB_MUX_OUT : STD_LOGIC_VECTOR (15 downto 0);
    -- ALU
    signal ALU_RESULT : STD_LOGIC_VECTOR (15 downto 0);
    -- EXE/MEM Register
    signal MemDIn_MUX_OUT : STD_LOGIC_VECTOR (15 downto 0);
    
    -- Forwarding Unit
    signal OpA_MUX_SEL : STD_LOGIC_VECTOR (1 downto 0);
    signal OpB_MUX_SEL : STD_LOGIC_VECTOR (1 downto 0);
    signal RegRA_MUX_SEL : STD_LOGIC;
    signal RegAVal_MUX_SEL : STD_LOGIC;
    signal RegBVal_MUX_SEL : STD_LOGIC;
    signal MemDIn_MUX_SEL : STD_LOGIC_VECTOR (1 downto 0);
    
    signal RegAVal_MUX_OUT : STD_LOGIC_VECTOR (15 downto 0);
    signal RegBVal_MUX_OUT : STD_LOGIC_VECTOR (15 downto 0);
    signal RegRA_MUX_OUT : STD_LOGIC_VECTOR (15 downto 0);
    
-- MEM Section
    COMPONENT DataMemoryControl
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               MemRead : in STD_LOGIC;
               MemWrite: in STD_LOGIC;
               MemAddr : in  STD_LOGIC_VECTOR (15 downto 0);
               MemData : in  STD_LOGIC_VECTOR (15 downto 0);
               MemOut : out STD_LOGIC_VECTOR (15 downto 0);
               SerialFinish : out STD_LOGIC;

               RAM1Addr : out STD_LOGIC_VECTOR (17 downto 0);
               RAM1Data : inout STD_LOGIC_VECTOR (15 downto 0);
               RAM1EN : out STD_LOGIC;
               RAM1OE : out STD_LOGIC;
               RAM1RW : out STD_LOGIC;
               
               Serial_dataready : in STD_LOGIC;
               Serial_rdn : out STD_LOGIC;
               Serial_tbre : in STD_LOGIC;
               Serial_tsre : in STD_LOGIC;
               Serial_wrn : out STD_LOGIC;
               
               DLED_Right : out STD_LOGIC_VECTOR (6 downto 0)
               );
    end COMPONENT;

    COMPONENT MEM_WB_REG is
        Port ( clk : in  STD_LOGIC;
               reset : in  STD_LOGIC;
               RegWE_in : in  STD_LOGIC;
               RegDest_in : in  STD_LOGIC_VECTOR (3 downto 0);
               RegWriteVal_in : in  STD_LOGIC_VECTOR (15 downto 0);
               MemRd_in : in  STD_LOGIC;
               RegWE_out : out  STD_LOGIC;
               RegDest_out : out  STD_LOGIC_VECTOR (3 downto 0);
               RegWriteVal_out : out  STD_LOGIC_VECTOR (15 downto 0);
               MemRd_out : out  STD_LOGIC
               );
    end COMPONENT;
    
    -- EXE/MEM Register
    signal EXE_MEM_RegWrite : STD_LOGIC;
    signal EXE_MEM_RegDest : STD_LOGIC_VECTOR (3 downto 0);
    signal EXE_MEM_MemRead : STD_LOGIC;
    signal EXE_MEM_MemDIn : STD_LOGIC_VECTOR (15 downto 0);
    signal EXE_MEM_MemWrite : STD_LOGIC;
    signal EXE_MEM_ALUOUT : STD_LOGIC_VECTOR (15 downto 0);
    -- Data Memory & Serial Port
    signal DATA_MEM_OUT : STD_LOGIC_VECTOR (15 downto 0);
    signal DATA_MEM_MUX_OUT : STD_LOGIC_VECTOR (15 downto 0);
    signal MEM_RESULT_MUX_OUT : STD_LOGIC_VECTOR (15 downto 0);
    signal MEM_RESULT_SEL : STD_LOGIC;
    signal DATA_MEM_SERIAL_FINISH : STD_LOGIC;


-- WB Section
    -- MEM/WB Register
    signal MEM_WB_RegWrite : STD_LOGIC;
    signal MEM_WB_RegDest : STD_LOGIC_VECTOR (3 downto 0);
    signal MEM_WB_RegWriteVal : STD_LOGIC_VECTOR (15 downto 0);
    signal MEM_WB_MemRead : STD_LOGIC;
    
begin

-- Universal
    --LED <= ALU_RESULT;
    LED <=
        PC_REG_OUT when (SW = "0000000000000000") else
        INST_ADDR_OUT when (SW = "0000000000000001") else
        INST_MEM_OUT when (SW = "0000000000000010") else
        Decoder_PC_Imm when (SW = "0000000000000011") else
        PC_JUMP_ADDR when (SW = "0000000000000100") else
        PC_REG_IN when (SW = "0000000000000101") else
        
        IF_ID_PC when (SW = "0000000000010000") else
        IF_ID_INST when (SW = "0000000000010001") else
        "00000000" & IF_ID_REGX & IF_ID_REGY when (SW = "0000000000011001") else
        (PC_REG_STALL & INST_ADDR_SEL & IF_ID_REG_STALL & IF_ID_REG_CLEAR 
            & ID_EXE_REG_STALL & ID_EXE_REG_CLEAR 
            & EXE_MEM_REG_STALL & EXE_MEM_REG_CLEAR & "00000000") when (SW = "0000000000011011") else
        Decoder_OperandA when (SW = "0000000000010010") else
        Decoder_OperandB when (SW = "0000000000010011") else
        Decoder_RegOpA & Decoder_RegOpB & Decoder_CRegA & Decoder_CRegB when (SW = "0000000000010111") else
        Decoder_RegDest & Decoder_RegWrite & Decoder_CReg & Decoder_MemRead & Decoder_MemWrite 
            & Decoder_PC_Sel & RegAVal_MUX_SEL & RegBVal_MUX_SEL & "0000" when (SW = "0000000000010110") else
        RegAVal_MUX_OUT when (SW = "0000000000011110") else
        RegBVal_MUX_OUT when (SW = "0000000000011100") else
        
        ALU_RESULT when (SW = "0000000000100000") else
        OpA_MUX_SEL & OpB_MUX_SEL & MemDIn_MUX_SEL & ID_EXE_RegOpA & ID_EXE_RegOpB & "00" when (SW = "0000000000100001") else
        ID_EXE_OpCode & ID_EXE_MemRead & ID_EXE_MemWrite & ID_EXE_RegWrite & ID_EXE_RegDest & "00000" when (SW = "0000000000100011") else
        ID_EXE_MemDIn when (SW = "0000000000100111") else
        ID_EXE_RegMemDIn & "000000000000" when (SW = "0000000000100110") else
        
        EXE_MEM_RegWrite & EXE_MEM_RegDest & EXE_MEM_MemRead & EXE_MEM_MemWrite 
            & SERIAL_DATA_READY & SERIAL_TBRE & SERIAL_TSRE & DATA_MEM_SERIAL_FINISH & "00000" when (SW = "0000000001000001") else
        DATA_MEM_OUT when (SW = "0000000001000011") else
        DATA_MEM_MUX_OUT when (SW = "0000000001000010") else
        EXE_MEM_MemDIn when (SW = "0000000001000111") else
        
        MEM_WB_RegWriteVal when (SW = "0000000010000000") else
        MEM_WB_RegDest & MEM_WB_RegWrite & "00000000000" when (SW = "0000000010000001") else

        (others => '0');
    
    ClockDiv_0 : ClockDiv PORT MAP (
        clk => clock,
        reset => reset,
        clk_2t => clock_2t,
        clk_4t => clock_4t
        );

    BubbleUnit_0 : BubbleUnit PORT MAP (
        RegOpA => Decoder_RegOpA,
        RegOpB => Decoder_RegOpB,
        RegWE_EXE => ID_EXE_RegWrite,
        RegDest_EXE => ID_EXE_RegDest,
        RegWE_MEM=> EXE_MEM_RegWrite,
        RegDest_MEM => EXE_MEM_RegDest,
        MemRead_EXE => ID_EXE_MemRead,
        MemWrite_EXE => ID_EXE_MemWrite,
        MemRead_MEM => EXE_MEM_MemRead,
        MemWrite_MEM => EXE_MEM_MemWrite,
        MemAddr => EXE_MEM_ALUOUT,
        pc_sel=> Decoder_PC_Sel,
        CReg => Decoder_CReg,
        CRegA => Decoder_CRegA,
        CRegB => Decoder_CRegB,
        SerialFinish => DATA_MEM_SERIAL_FINISH,

        pc_stall => PC_REG_STALL,
        InstAddrSel => INST_ADDR_SEL,
        InstMemRead => INST_MEM_READ,
        InstMemWrite => INST_MEM_WRITE,
        Mem_Result_Sel => MEM_RESULT_SEL,

        IF_ID_stall => IF_ID_REG_STALL,
        ID_EXE_stall => ID_EXE_REG_STALL,
        EXE_MEM_stall => EXE_MEM_REG_STALL,
        IF_ID_clear => IF_ID_REG_CLEAR,
        ID_EXE_clear => ID_EXE_REG_CLEAR,
        EXE_MEM_clear => EXE_MEM_REG_CLEAR
        );

-- IF Section
    PC_REG_0 : PC_REG PORT MAP (
        clk => clock_4t,
        reset => reset,
        stall => PC_REG_STALL,
        PC_in => PC_REG_IN,
        PC_out => PC_REG_OUT
        );
    
    INST_ADDR_MUX : TwoInMuxer_16bit PORT MAP (
        input1 => PC_REG_OUT,
        input2 => EXE_MEM_ALUOUT,
        opcode => INST_ADDR_SEL,
        output => INST_ADDR_OUT 
        );

    INST_MEMORY_0 : InstMemoryControl PORT MAP (
        clk => clock,
        reset => reset,
        MemRead => INST_MEM_READ,
        MemWrite => INST_MEM_WRITE,
        MemAddr => INST_ADDR_OUT,
        MemData => EXE_MEM_MemDIn,
        MemOut => INST_MEM_OUT,
        
        RAM2Addr => RAM2ADDR,
        RAM2Data => RAM2DATA,
        RAM2EN => RAM2EN,
        RAM2OE => RAM2OE,
        RAM2RW => RAM2RW 
        );

    PCAdder_0 : PCAdder PORT MAP (
        A => PC_REG_OUT,
        B => PC_INCR,
        result => PC_INCR_OUT
        );

    PC_REG_MUX : FourInMuxer_16bit PORT MAP (
        input1 => PC_INCR_OUT,
        input2 => Regs_RAVal,
        input3 => Regs_RegAVal,
        input4 => PC_JUMP_ADDR,
        opcode => Decoder_PC_Sel,
        output => PC_REG_IN
        );

    IF_ID_REG_0 : IF_ID_REG PORT MAP (
        clk => clock_4t,
        reset => reset,
        pc_in => PC_INCR_OUT,
        inst_in => INST_MEM_OUT,
        stall => IF_ID_REG_STALL,
        clear => IF_ID_REG_CLEAR,
        pc_out => IF_ID_PC,
        inst_out => IF_ID_INST,
        rx => IF_ID_REGX,
        ry => IF_ID_REGY
        );

-- ID Section
    PCAdder_1 : PCAdder PORT MAP (
        A => IF_ID_PC,
        B => Decoder_PC_Imm,
        result => PC_JUMP_ADDR
        );

    InstDecoder_0 : InstDecoder PORT MAP (
        pc => IF_ID_PC,
        inst => IF_ID_INST,
        RegAVal => RegAVal_MUX_OUT,
        RegBVal => RegBVal_MUX_OUT,
        RAVal => RegRA_MUX_OUT,
        SPVal => Regs_SPVal,
        IHVal => Regs_IHVal,
        T_in => T_REG_OUT,
        T_out => T_REG_IN,
        pc_imm => Decoder_PC_Imm,
        pc_sel => Decoder_PC_Sel,
        RegWE => Decoder_RegWrite,
        RegDest => Decoder_RegDest,
        MemRd => Decoder_MemRead,
        MemDIn => Decoder_MemDIn,
        RegMemDIn => Decoder_RegMemDIn,
        MemWE => Decoder_MemWrite,
        opcode => Decoder_OpCode,
        RegOpA => Decoder_RegOpA,
        RegOpB => Decoder_RegOpB,
        CReg => Decoder_CReg,
        CRegA => Decoder_CRegA,
        CRegB => Decoder_CRegB,
        operandA => Decoder_OperandA,
        operandB => Decoder_OperandB
        );

    Register_Files_0 : Register_Files PORT MAP (
        clk => clock,
        reset => reset,
        ASel => IF_ID_REGX,
        BSel => IF_ID_REGY,
        WSel => MEM_WB_RegDest,
        WE => MEM_WB_RegWrite,
        WVal => MEM_WB_RegWriteVal,
        AVal => Regs_RegAVal,
        BVal => Regs_RegBVal,
        RAVal => Regs_RAVal,
        SPVal => Regs_SPVal,
        IHVal => Regs_IHVal
        );

    T_REG_0 : T_REG PORT MAP (
        clk => clock,
        reset => reset,
        T_in => T_REG_IN,
        T_out => T_REG_OUT
        );
    
    ID_EXE_REG_0 : ID_EXE_REG PORT MAP (
        clk => clock_4t,
        reset => reset,
        clear => ID_EXE_REG_CLEAR,
        stall => ID_EXE_REG_STALL,
        RegWE_in => Decoder_RegWrite,
        RegDest_in => Decoder_RegDest,
        RegMemDIn_in => Decoder_RegMemDIn,
        MemRd_in => Decoder_MemRead,
        MemWE_in => Decoder_MemWrite,
        MemDIn_in => Decoder_MemDIn,
        opcode_in => Decoder_OpCode,
        operandA_in => Decoder_OperandA,
        operandB_in => Decoder_OperandB,
        RegOpA_in => Decoder_RegOpA,
        RegOpB_in => Decoder_RegOpB,
        RegWE_out => ID_EXE_RegWrite,
        RegDest_out => ID_EXE_RegDest,
        RegMemDIn_out => ID_EXE_RegMemDIn,
        MemRd_out => ID_EXE_MemRead,
        MemWE_out => ID_EXE_MemWrite,
        MemDIn_out => ID_EXE_MemDIn,
        opcode_out => ID_EXE_OpCode,
        operandA_out => ID_EXE_OperandA,
        operandB_out => ID_EXE_OperandB,
        RegOpA_out => ID_EXE_RegOpA,
        RegOpB_out => ID_EXE_RegOpB
        );

    RegAVal_MUX : TwoInMuxer_16bit PORT MAP (
        input1 => Regs_RegAVal,
        input2 => EXE_MEM_ALUOUT,
        opcode => RegAVal_MUX_SEL,
        output => RegAVal_MUX_OUT
        );
        
    RegBVal_MUX : TwoInMuxer_16bit PORT MAP (
        input1 => Regs_RegBVal,
        input2 => EXE_MEM_ALUOUT,
        opcode => RegBVal_MUX_SEL,
        output => RegBVal_MUX_OUT
        );
        
    RegRA_MUX : TwoInMuxer_16bit PORT MAP (
        input1 => Regs_RAVal,
        input2 => EXE_MEM_ALUOUT,
        opcode => RegRA_MUX_SEL,
        output => RegRA_MUX_OUT
        );
-- EXE Section

    ALU_0 : ALU PORT MAP (
        op => ID_EXE_OpCode,
        A => OpA_MUX_OUT,
        B => OpB_MUX_OUT,
        result => ALU_RESULT
        );

    OpA_MUX : FourInMuxer_16bit PORT MAP (
        input1 => ID_EXE_OperandA,
        input2 => EXE_MEM_ALUOUT,
        input3 => MEM_WB_RegWriteVal,
        input4 => "0000000000000000",
        opcode => OpA_MUX_SEL,
        output => OpA_MUX_OUT
        );

    OpB_MUX : FourInMuxer_16bit PORT MAP (
        input1 => ID_EXE_OperandB,
        input2 => EXE_MEM_ALUOUT,
        input3 => MEM_WB_RegWriteVal,
        input4 => "0000000000000000",
        opcode => OpB_MUX_SEL,
        output => OpB_MUX_OUT
        );
    
    MemDIn_MUX : FourInMuxer_16bit PORT MAP (
        input1 => ID_EXE_MemDIn,
        input2 => EXE_MEM_ALUOUT,
        input3 => MEM_WB_RegWriteVal,
        input4 => "0000000000000000",
        opcode => MemDIn_MUX_SEL,
        output => MemDIn_MUX_OUT
        );

    EXE_MEM_REG_0 : EXE_MEM_REG PORT MAP (
        clk => clock_4t,
        reset => reset,
        clear => EXE_MEM_REG_CLEAR,
        stall => EXE_MEM_REG_STALL,
        RegWE_in => ID_EXE_RegWrite,
        RegDest_in => ID_EXE_RegDest,
        MemRd_in => ID_EXE_MemRead,
        MemWE_in => ID_EXE_MemWrite,
        MemDIn_in => MemDIn_MUX_OUT,
        ALUout_in => ALU_RESULT,
        RegWE_out => EXE_MEM_RegWrite,
        RegDest_out => EXE_MEM_RegDest,
        MemRd_out => EXE_MEM_MemRead,
        MemWE_out => EXE_MEM_MemWrite,
        MemDIn_out => EXE_MEM_MemDIn,
        ALUout_out => EXE_MEM_ALUOUT
        );

    ForwardingUnit_0 : ForwardingUnit PORT MAP (
        RegOpA => ID_EXE_RegOpA,
        RegOpB => ID_EXE_RegOpB, 
        RegWE_WB => MEM_WB_RegWrite, 
        RegDest_WB => MEM_WB_RegDest, 
        RegWE_MEM => EXE_MEM_RegWrite, 
        RegDest_MEM => EXE_MEM_RegDest, 
        MemRead_EXE => ID_EXE_MemRead, 
        MemRead_WB => MEM_WB_MemRead, 
        CReg => Decoder_CReg,
        CRegA => Decoder_CRegA,
        CRegB => Decoder_CRegB,
        RegMemDIn => ID_EXE_RegMemDIn,

        RegAValSel => RegAVal_MUX_SEL,
        RegBValSel => RegBVal_MUX_SEL,
        RegRAValSel => RegRA_MUX_SEL,
        OperandASel => OpA_MUX_SEL,
        OperandBSel => OpB_MUX_SEL,
        MemDInSel => MemDIn_MUX_SEL
        );
 
-- MEM Section
       
    DATA_MEMORY_0 : DataMemoryControl PORT MAP (
        clk => clock,
        reset => reset,
        MemRead => EXE_MEM_MemRead,
        MemWrite=> EXE_MEM_MemWrite,
        MemAddr => EXE_MEM_ALUOUT,
        MemData => EXE_MEM_MemDIn,
        MemOut => DATA_MEM_OUT,
        SerialFinish => DATA_MEM_SERIAL_FINISH,

        RAM1Addr => RAM1ADDR,
        RAM1Data => RAM1DATA,
        RAM1EN => RAM1EN,
        RAM1OE => RAM1OE,
        RAM1RW => RAM1RW,

        Serial_dataready => SERIAL_DATA_READY,
        Serial_rdn => SERIAL_RDN,
        Serial_tbre => SERIAL_TBRE,
        Serial_tsre => SERIAL_TSRE,
        Serial_wrn => SERIAL_WRN,
        
        DLED_Right => DLED_RIGHT
        );
    
    MEM_MUX : TwoInMuxer_16bit PORT MAP (
        input1 => DATA_MEM_OUT,
        input2 => INST_MEM_OUT,
        opcode => MEM_RESULT_SEL,
        output => DATA_MEM_MUX_OUT 
        );
        
    MEM_RESULT_MUX : TwoInMuxer_16bit PORT MAP (
        input1 => EXE_MEM_ALUOUT,
        input2 => DATA_MEM_MUX_OUT,
        opcode => EXE_MEM_MemRead,
        output => MEM_RESULT_MUX_OUT 
        );
    
    MEM_WB_REG_0 : MEM_WB_REG PORT MAP (
        clk => clock_4t,
        reset => reset,
        RegWE_in => EXE_MEM_RegWrite,
        RegDest_in => EXE_MEM_RegDest,
        RegWriteVal_in => MEM_RESULT_MUX_OUT,
        MemRd_in => EXE_MEM_MemRead,
        RegWE_out => MEM_WB_RegWrite,
        RegDest_out => MEM_WB_RegDest,
        RegWriteVal_out => MEM_WB_RegWriteVal,
        MemRd_out => MEM_WB_MemRead
    );

-- WB Section


end Behavioral;

