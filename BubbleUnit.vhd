----------------------------------------------------------------------------------
-- Company: 
-- Engineer:       StrayWarrior
-- 
-- Create Date:    23:52:40 11/16/2015 
-- Design Name: 
-- Module Name:    BubbleUnit - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BubbleUnit is
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
           InstMemWrite : out STD_LOGIC;
           
           Mem_Result_Sel : out STD_LOGIC;
           
           IF_ID_stall : out  STD_LOGIC;
           ID_EXE_stall : out  STD_LOGIC;
           EXE_MEM_stall : out  STD_LOGIC;
           IF_ID_clear: out  STD_LOGIC;
           ID_EXE_clear : out  STD_LOGIC;
           EXE_MEM_clear: out  STD_LOGIC
           );
end BubbleUnit;

architecture Behavioral of BubbleUnit is
    -- InstMem Collision, just like Data Memory Collision
    signal InstMem_Collision_0 : STD_LOGIC := '0';
    -- InstMem Collision control.
    signal InstMem_Collision_1 : STD_LOGIC := '0';
    
    -- Data Memory Collision: LW R0 R1, ADDU R1 R2 R3, R1 is in collision
    signal DataMem_Collision_0 : STD_LOGIC := '0';
    -- LW R0 R1, CMP R1 R2, R1 is in collision. Need 2 bubble
    signal DataMem_Collision_1 : STD_LOGIC := '0';
    --LW R0 R1, CMP R1 R2, R1 is in collision. Need 2 bubble
    -- or CMP R1 R2 after another instruction after LW. Need 1 bubble
    -- or AND R0 R2, B R0 imm. Need 1 bubble
    signal DataMem_Collision_2 : STD_LOGIC := '0';
    -- SW BF00 or LW BF00
    signal DataMem_Collision_3 : STD_LOGIC := '0';
    
    
    
    

begin
    InstMem_Collision_0 <=
        '1' when (MemAddr <= x"7FFF" and (MemRead_EXE = '1' or MemWrite_EXE = '1')) else
        '0';
    InstMem_Collision_1 <=
        '1' when (MemAddr <= x"7FFF" and (MemRead_MEM = '1' or MemWrite_MEM = '1')) else
        '0';

    DataMem_Collision_0 <=
        '1' when (MemRead_EXE = '1' and RegWE_EXE = '1' and (RegDest_EXE = RegOpA or RegDest_EXE = RegOpB) and RegDest_EXE /= "1111") else
        '0';
    DataMem_Collision_1 <=
        '1' when (RegWE_EXE = '1' and (CReg = '1' and (RegDest_EXE = CRegA or RegDest_EXE = CRegB)) and RegDest_EXE /= "1111") else
        '0';
    DataMem_Collision_2 <=
        '1' when (MemRead_MEM = '1' and RegWE_MEM = '1' and (CReg = '1' and (RegDest_MEM = CRegA or RegDest_MEM = CRegB)) and RegDest_EXE /= "1111") else
        '0';
    DataMem_Collision_3 <=
        '1' when ((MemRead_MEM = '1' or MemWrite_MEM = '1') and MemAddr = x"BF00" and SerialFinish = '0') else
        '0';
    --DataMem_Collision_4 <=
    --    '1' when (RegWE_EXE = '1' and (CReg = '1' and (RegDest_EXE = CRegA or RegDest_EXE = CRegB) and RegDest_EXE /= "1111") else
    --    '0';

    Mem_Result_Sel <=
        '1' when (MemRead_MEM = '1' and MemAddr <= x"7FFF") else
        '0' when (MemRead_MEM = '1' and MemAddr >= x"8000") else
        '0';

    IF_ID_clear <=
        '1' when (pc_sel /= "00") else
        '0';
    
    IF_ID_stall <=
        '1' when (InstMem_Collision_1 = '1' or DataMem_Collision_0 = '1' 
                  or DataMem_Collision_1 = '1' or DataMem_Collision_2 = '1' or DataMem_Collision_3 = '1') else
        '0';

    pc_stall <=
        '1' when (InstMem_Collision_1 = '1' or DataMem_Collision_0 = '1' 
                  or DataMem_Collision_1 = '1' or DataMem_Collision_2 = '1' or DataMem_Collision_3 = '1') else
        '0';
    
    InstAddrSel <=
        '1' when (InstMem_Collision_1 = '1') else
        '0';

    InstMemRead <=
        MemRead_MEM when (InstMem_Collision_1 = '1') else
        '1';

    InstMemWrite <=
        MemWrite_MEM when (InstMem_Collision_1 = '1') else
        '0';

    EXE_MEM_stall <=
        '1' when (DataMem_Collision_3 = '1') else
        '0';

    ID_EXE_stall <=
        '1' when (InstMem_Collision_1 = '1' or DataMem_Collision_3 = '1') else
        '0';

    ID_EXE_clear <=
        '1' when (DataMem_Collision_0 = '1' or DataMem_Collision_1 = '1') else
        '0';
    
    EXE_MEM_clear <=
        '1' when (InstMem_Collision_1 = '1') else
        '0';

end Behavioral;

