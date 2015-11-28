----------------------------------------------------------------------------------
-- Company: 
-- Engineer:       StrayWarrior
-- 
-- Create Date:    11:18:33 11/14/2015 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( op : in  STD_LOGIC_VECTOR (3 downto 0);
           A : in  STD_LOGIC_VECTOR (15 downto 0);
           B : in  STD_LOGIC_VECTOR (15 downto 0);
           result : out  STD_LOGIC_VECTOR (15 downto 0));
end ALU;

architecture Behavioral of ALU is

begin
    process (A, B, op)
    begin
        case op is
            when "0000" => --add
                result <= A + B;
            when "0001" => --sub
                result <= A - B;
            when "0100" => --AND
                result <= A and B;
            when "0101" => --OR
                result <= A or B;
            when "0110" => --XOR
                result <= A xor B;
            when "0111" => --NOT
                result <= not B;
            when "1000" => --SLL
                result <= TO_STDLOGICVECTOR(TO_BITVECTOR(A) SLL CONV_INTEGER(unsigned(B)));
            when "1010" => --SRL
                result <= TO_STDLOGICVECTOR(TO_BITVECTOR(A) SRL CONV_INTEGER(unsigned(B)));
            when "1011" => --SRA
                result <= TO_STDLOGICVECTOR(TO_BITVECTOR(A) SRA CONV_INTEGER(unsigned(B)));
            --when "1100" => --ROL
                --result <= TO_STDLOGICVECTOR(TO_BITVECTOR(A) ROL CONV_INTEGER(unsigned(B)));
            when others => 
                result <= A;
        end case;
    end process;

end Behavioral;

