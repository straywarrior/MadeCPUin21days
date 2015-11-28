----------------------------------------------------------------------------------
-- Company:
-- Engineer:       StrayWarrior
--
-- Create Date:    23:19:33 11/16/2015 
-- Design Name: 
-- Module Name:    ClockDiv - Behavioral 
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
--use UNISIM.VComponents.all;

entity ClockDiv is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           clk_2t : out STD_LOGIC;
           clk_4t : out STD_LOGIC;
           clk_16t : out STD_LOGIC
           );
end ClockDiv;

architecture Behavioral of ClockDiv is
    signal clk_2t_q : STD_LOGIC := '0';
    signal div_4t : STD_LOGIC := '0';
    signal clk_4t_q : STD_LOGIC := '0';
    signal div_16t : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    signal clk_16t_q : STD_LOGIC := '0';

begin
    process (clk, reset)
    begin
        if (reset = '0') then
            div_4t <= '0';
        elsif (clk'event and clk = '1') then
            div_4t <= not div_4t;
        end if;
    end process;
    
    process (clk, reset)
    begin
        if (reset = '0') then
            div_16t <= (others => '0');
        elsif (clk'event and clk = '1') then
            div_16t <= div_16t + '1';
        end if;
    end process;

    process (clk, reset)
    begin
        if (reset = '0') then
            clk_2t_q <= '0';
            clk_4t_q <= '0';
            clk_16t_q <= '0';
        elsif (clk'event and clk = '1') then
            clk_2t_q <= not clk_2t_q;
            if (div_4t = '0') then
                clk_4t_q <= not clk_4t_q;
            else
                clk_4t_q <= clk_4t_q;
            end if;
            
            if (div_16t = "0000") then
                clk_16t_q <= not clk_16t_q;
            else
                clk_16t_q <= clk_16t_q;
            end if;
        end if;
    end process;

    clk_2t <= clk_2t_q;
    clk_4t <= clk_4t_q;
    clk_16t <= clk_16t_q;

end Behavioral;

