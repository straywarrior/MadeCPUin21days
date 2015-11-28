----------------------------------------------------------------------------------
-- Company: 
-- Engineer:       StrayWarrior
-- 
-- Create Date:    18:53:30 11/17/2015 
-- Design Name: 
-- Module Name:    T_REG - Behavioral 
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

entity T_REG is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           T_in : in STD_LOGIC;
           T_out : out STD_LOGIC
         );
end T_REG;

architecture Behavioral of T_REG is

begin
process (reset, clk)
    begin
        if (reset = '0') then
            T_out <= '0'; 
        elsif (clk'event and clk = '1') then
            T_out <= T_in; 
        end if;
    end process;

end Behavioral;

