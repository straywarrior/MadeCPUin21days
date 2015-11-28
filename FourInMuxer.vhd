----------------------------------------------------------------------------------
-- Company: 
-- Engineer:       StrayWarrior 
-- 
-- Create Date:    15:00:30 11/14/2015 
-- Design Name: 
-- Module Name:    FourInMuxer_16bit - Behavioral 
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

entity FourInMuxer_16bit is
    Port ( input1 : in  STD_LOGIC_VECTOR (15 downto 0);
           input2 : in  STD_LOGIC_VECTOR (15 downto 0);
           input3 : in  STD_LOGIC_VECTOR (15 downto 0);
           input4 : in  STD_LOGIC_VECTOR (15 downto 0);
           opcode : in  STD_LOGIC_VECTOR (1 downto 0);
           output : out  STD_LOGIC_VECTOR (15 downto 0));
end FourInMuxer_16bit;

architecture Behavioral of FourInMuxer_16bit is

begin
    with opcode select
        output <= input1 when "00",
                  input2 when "01",
                  input3 when "10",
                  input4 when "11",
                  input1 when others; --Is it appropriate?
end Behavioral;

