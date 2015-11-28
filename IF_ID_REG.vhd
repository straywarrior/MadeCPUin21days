----------------------------------------------------------------------------------
-- Company: 
-- Engineer:       StrayWarrior
-- 
-- Create Date:    13:39:51 11/14/2015 
-- Design Name: 
-- Module Name:    IF_ID_REG - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IF_ID_REG is
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
end IF_ID_REG;

architecture Behavioral of IF_ID_REG is

begin
    process (clear, reset, clk)
    begin
        if (reset = '0') then
            pc_out <= (others => '0');
            inst_out <= (11 => '1', others => '0');
            rx <= (others => '0');
            ry <= (others => '0');
        elsif (clk'event and clk = '1') then
            if (stall = '0' and clear = '0') then
				pc_out <= pc_in;
                inst_out <= inst_in;
				rx(2 downto 0) <= inst_in(10 downto 8);
                rx(3) <= '0';
                ry(2 downto 0) <= inst_in(7 downto 5);
                ry(3) <= '0';
            elsif (stall = '0' and clear = '1') then
				-- Clear  the IF/ID
				pc_out <= (others => '0');
				inst_out <= (11 => '1', others => '0');
				rx <= (others => '0');
				ry <= (others => '0');
			else
                -- Insert a bubble here
                null;
            end if;
        end if;
    end process;

end Behavioral;

