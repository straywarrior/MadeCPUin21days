----------------------------------------------------------------------------------
-- Company: 
-- Engineer:       StrayWarrior
-- 
-- Create Date:    14:18:20 11/14/2015 
-- Design Name: 
-- Module Name:    MEM_WB_REG - Behavioral 
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

entity MEM_WB_REG is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           RegWE_in : in  STD_LOGIC;
           RegDest_in : in  STD_LOGIC_VECTOR (3 downto 0);
           RegWriteVal_in : in  STD_LOGIC_VECTOR (15 downto 0);
           MemRd_in : in STD_LOGIC;
           RegWE_out : out  STD_LOGIC;
           RegDest_out : out  STD_LOGIC_VECTOR (3 downto 0);
           RegWriteVal_out : out  STD_LOGIC_VECTOR (15 downto 0);
           MemRd_out : out STD_LOGIC
           );
end MEM_WB_REG;

architecture Behavioral of MEM_WB_REG is

begin
process (reset, clk)
    begin
        if (reset = '0') then
            RegWE_out <= '0';
            RegDest_out <= (others => '1');
            RegWriteVal_out <= (others => '0');
            MemRd_out <= '0';
        elsif (clk'event and clk = '1') then
            RegWE_out <= RegWE_in;
            RegDest_out <= RegDest_in;
            RegWriteVal_out <= RegWriteVal_in;
            MemRd_out <= MemRd_in;
        end if;
    end process;

end Behavioral;

