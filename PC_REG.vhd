----------------------------------------------------------------------------------
-- Company: 
-- Engineer:       StrayWarrior
-- 
-- Create Date:    23:36:20 11/21/2015 
-- Design Name: 
-- Module Name:    PC_REG - Behavioral 
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

entity PC_REG is
    Port ( clk : in  STD_LOGIC;
           reset : in STD_LOGIC;
           stall : in  STD_LOGIC;
           PC_in : in STD_LOGIC_VECTOR (15 downto 0);
           PC_out : out STD_LOGIC_VECTOR (15 downto 0)
         );
end PC_REG;

architecture Behavioral of PC_REG is

begin
process (reset, clk)
    begin
        if (reset = '0') then
            PC_out <= (others => '0'); 
        elsif (clk'event and clk = '1' and stall = '0') then
            PC_out <= PC_in; 
        end if;
    end process;

end Behavioral;

