----------------------------------------------------------------------------------
-- Company: 
-- Engineer:       StrayWarrior
-- 
-- Create Date:    23:26:40 11/19/2015 
-- Design Name: 
-- Module Name:    ForwardingUnit - Behavioral 
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

entity ForwardingUnit is
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
end ForwardingUnit;

architecture Behavioral of ForwardingUnit is

begin
    OperandASel <= 
        "01" when RegWE_MEM = '1' and RegDest_MEM /= "1111" and RegDest_MEM = RegOpA else
        "10" when RegWE_WB = '1' and RegDest_WB /= "1111" and RegDest_WB = RegOpA and (RegDest_MEM /= RegOpA or MemRead_WB = '1') else
        "00";
    OperandBSel <= 
        "01" when RegWE_MEM = '1' and RegDest_MEM /= "1111" and RegDest_MEM = RegOpB else
        "10" when RegWE_WB = '1' and RegDest_WB /= "1111" and RegDest_WB = RegOpB and (RegDest_MEM /= RegOpB or MemRead_WB = '1') else
        "00";
    
    MemDInSel <= 
        "01" when RegWE_MEM = '1' and RegDest_MEM /= "1111" and RegDest_MEM = RegMemDIn else
        "10" when RegWE_WB = '1' and RegDest_WB /= "1111" and RegDest_WB = RegMemDIn and (RegDest_MEM /= RegMemDIn or MemRead_WB = '1') else
        "00";
    
    RegAValSel <= 
        '1' when RegWE_MEM = '1' and RegDest_MEM /= "1111" and RegDest_MEM = CRegA else
        '0';
    RegBValSel <= 
        '1' when RegWE_MEM = '1' and RegDest_MEM /= "1111" and RegDest_MEM = CRegB else
        '0';
    RegRAValSel <=
        '1' when RegWE_MEM = '1' and RegDest_MEM = "1000" else
        '0';


end Behavioral;

