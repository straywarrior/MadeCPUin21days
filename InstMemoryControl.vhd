---------------------------------------------------------------------------------
-- Company: 
-- Engineer:       StrayWarrior
-- 
-- Create Date:    21:17:00 11/15/2015 
-- Design Name: 
-- Module Name:    InstMemoryControl - Behavioral 
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

entity InstMemoryControl is
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
end InstMemoryControl;

architecture Behavioral of InstMemoryControl is
    type state_type is (s0, s1, s2, s3);
    signal state : state_type;

begin
    RAM2Addr(17 downto 16) <= (others => '0');
    RAM2Addr(15 downto 0) <= MemAddr;
    RAM2Data <=
        (others => 'Z') when MemRead = '1' else
        MemData when MemWrite = '1' else
        (others => 'Z');
    MemOut <= RAM2Data;
        
        
    process (reset, clk)
    begin
        if (reset = '0') then
            state <= s0;
            RAM2EN <= '1';
            RAM2OE <= '1';
            RAM2RW <= '1';
        elsif (clk'event and clk = '1') then
            if (state = s0) then
                state <= s1;
                RAM2EN <= '0';
                RAM2OE <= '1';
                RAM2RW <= '1';
            elsif (state = s1) then
                state <= s2;
                -- Read Memory (LW rx ry imm)
                if (MemRead = '1' and MemAddr >= x"0000" and MemAddr <= x"7FFF") then
                    RAM2EN <= '0';
                    RAM2OE <= '0';
                    RAM2RW <= '1';
                -- Write Memory (SW rx ry imm)
                elsif (MemWrite = '1' and MemAddr >= x"0000" and MemAddr <= x"7FFF") then
                    RAM2EN <= '0';
                    RAM2OE <= '1';
                    RAM2RW <= '0';
                end if;
            elsif (state = s2) then
                state <= s3;
                -- Read Memory (LW rx ry imm)
                if (MemRead = '1' and MemAddr >= x"0000" and MemAddr <= x"7FFF") then
                    RAM2EN <= '0';
                    RAM2OE <= '0';
                    RAM2RW <= '1';
                -- Write Memory (SW rx ry imm)
                elsif (MemWrite = '1' and MemAddr >= x"0000" and MemAddr <= x"7FFF") then
                    RAM2EN <= '0';
                    RAM2OE <= '1';
                    RAM2RW <= '1';
                end if;
            elsif (state = s3) then
                state <= s0;
            end if;
        end if;
    end process;

end Behavioral;
