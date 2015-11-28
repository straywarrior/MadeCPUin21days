----------------------------------------------------------------------------------
-- Company: 
-- Engineer:       StrayWarrior
-- 
-- Create Date:    14:18:20 11/14/2015 
-- Design Name: 
-- Module Name:    ID_EXE_REG - Behavioral 
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

entity ID_EXE_REG is
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
           RegMemDIn_in : in  STD_LOGIC_VECTOR (3 downto 0);
           RegWE_out : out  STD_LOGIC;
           RegDest_out : out  STD_LOGIC_VECTOR (3 downto 0);
           MemRd_out : out  STD_LOGIC;
           MemWE_out : out  STD_LOGIC;
           MemDIn_out : out  STD_LOGIC_VECTOR (15 downto 0);
           RegMemDIn_out : out  STD_LOGIC_VECTOR (3 downto 0);
           opcode_out : out  STD_LOGIC_VECTOR (3 downto 0);
           operandA_out : out  STD_LOGIC_VECTOR (15 downto 0);
           operandB_out : out  STD_LOGIC_VECTOR (15 downto 0);
           RegOpA_out : out  STD_LOGIC_VECTOR (3 downto 0);
           RegOpB_out : out  STD_LOGIC_VECTOR (3 downto 0)
           );
end ID_EXE_REG;

architecture Behavioral of ID_EXE_REG is

begin
process (clear, reset, clk)
    begin
        if (reset = '0') then
            RegWE_out <= '0';
            RegDest_out <= (others => '1');
            MemRd_out <= '0';
            MemWE_out <= '0';
            MemDIn_out <= (others => '0');
            RegMemDIn_out <= (others => '0');
            opcode_out <= (others => '1');
            operandA_out <= (others => '0');
            operandB_out <= (others => '0');
            RegOpA_out <= (others => '1');
            RegOpB_out <= (others => '1');
        elsif (clk'event and clk = '1') then
            if (clear = '0' and stall = '0') then
                RegWE_out <= RegWE_in;
                RegDest_out <= RegDest_in;
                MemRd_out <= MemRd_in;
                MemWE_out <= MemWE_in;
                MemDIn_out <= MemDIn_in;
                opcode_out <= opcode_in;
                operandA_out <= operandA_in;
                operandB_out <= operandB_in;
                RegOpA_out <= RegOpA_in;
                RegOpB_out <= RegOpB_in;
                RegMemDIn_out <= RegMemDIn_in;
            elsif (clear = '1' and stall = '0') then
                RegWE_out <= '0';
                RegDest_out <= (others => '1');
                MemRd_out <= '0';
                MemWE_out <= '0';
                MemDIn_out <= (others => '0');
                RegMemDIn_out <= (others => '0');
                opcode_out <= (others => '1');
                operandA_out <= (others => '0');
                operandB_out <= (others => '0');
                RegOpA_out <= (others => '1');
                RegOpB_out <= (others => '1');
            else
                -- Insert a bubble here
                null;
            end if;
        end if;
    end process;

end Behavioral;

