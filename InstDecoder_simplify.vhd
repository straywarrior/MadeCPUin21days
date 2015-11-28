----------------------------------------------------------------------------------
-- Company: 
-- Engineer:       StrayWarrior 
-- 
-- Create Date:    15:16:45 11/14/2015 
-- Design Name: 
-- Module Name:    InstDecoder - Behavioral 
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
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity InstDecoder is
    Port ( pc : in  STD_LOGIC_VECTOR (15 downto 0);
           inst : in  STD_LOGIC_VECTOR (15 downto 0);
           RegAVal : in  STD_LOGIC_VECTOR (15 downto 0);
           RegBVal : in  STD_LOGIC_VECTOR (15 downto 0);
           RAVal : in  STD_LOGIC_VECTOR (15 downto 0);
           SPVal : in  STD_LOGIC_VECTOR (15 downto 0);
           IHVal : in  STD_LOGIC_VECTOR (15 downto 0);
           T_in : in STD_LOGIC;
           T_out : out STD_LOGIC;
           pc_imm : out  STD_LOGIC_VECTOR (15 downto 0);
           pc_sel : out STD_LOGIC_VECTOR (1 downto 0);
           RegWE : out  STD_LOGIC;
           RegDest : out  STD_LOGIC_VECTOR (3 downto 0);
           MemRd : out  STD_LOGIC;
           MemDIn : out  STD_LOGIC_VECTOR (15 downto 0);
           MemWE : out  STD_LOGIC;
           opcode : out  STD_LOGIC_VECTOR (3 downto 0);
           RegOpA : out  STD_LOGIC_VECTOR (3 downto 0);
           RegOpB : out  STD_LOGIC_VECTOR (3 downto 0);
           CReg : out  STD_LOGIC;
           CRegA : out  STD_LOGIC_VECTOR (3 downto 0);
           CRegB : out  STD_LOGIC_VECTOR (3 downto 0);
           operandA : out  STD_LOGIC_VECTOR (15 downto 0);
           operandB : out  STD_LOGIC_VECTOR (15 downto 0)
           );
end InstDecoder;

architecture Behavioral of InstDecoder is
begin

	operandA <= 
		RegAVal when (inst(15 downto 11) = "11100" or (inst(15 downto 11) = "11101" and inst(4 downto 2) = "011")) else
		pc when (inst(15 downto 11) = "11101" and inst(4 downto 0) = "00000") else
		RegBVal when (inst(15 downto 11) = "11101" and inst(4 downto 2) = "001") else
		(others => '0') when (inst(15 downto 11) = "11101" and inst(4 downto 0) = "01011") else
		RegAVal when (inst(15 downto 11) = "11110" and inst(1 downto 0) = "01") or (inst(15 downto 11) = "01000") or (inst(15 downto 11) = "01001") else
		IHVal when (inst(15 downto 11) = "11110" and inst(1 downto 0) = "00") else
		RegBVal when (inst(15 downto 11) = "00110" or inst(15 downto 11) = "01111" or (inst(15 dowto 11) = "01100" and inst(10 downto 8) = "100")) else
		SPVal when ((inst(15 downto 11) = "01100" and (inst(10 downo 8) = "010" or inst(10 downto 8) = "011")) or inst(15 downto 11) = "00000") else


    -- Use Process firt. TODO: Rewrite to combinational logic circuit
    process (inst, pc, RegAVal, RegBVal, T_in, IHVal, RAVal, SPVal)
    begin
        case inst(15 downto 11) is
            -- R type instruction
            when "11100" =>
                case inst(1 downto 0) is
                    when "01" => opcode <= "0000";
                    when "11" => opcode <= "0001";
                    when others => opcode <= "1111"; -- 1111 means doing nothing
                end case;
                operandA <= RegAVal;
                operandB <= RegBVal;
                RegDest(2 downto 0) <= inst(4 downto 2);
                RegDest(3) <= '0';
                RegWE <= '1';
                MemWE <= '0';
                MemRd <= '0';
                RegOpA(2 downto 0) <= inst(10 downto 8);
                RegOpA(3) <= '0';
                RegOpB(2 downto 0) <= inst(7 downto 5);
                RegOpB(3) <= '0';
                pc_sel <= "00";
                CReg <= '0';
                CRegA <= "1111";
                CRegB <= "1111";
                T_out <= T_in;
            -- R type instruction & J type instruction (excpet INT & NOP)
            when "11101" =>
                case inst(4 downto 2) is
                    when "000" => -- SLT SLTU & MFPC JR JRRA JALR
                        RegOpA <= "1111";
                        RegOpB <= "1111";
                        case inst(1 downto 0) is
                            when "10" => -- SLT
                                if (signed(RegAVal) < signed(RegBVal)) then
                                    T_out <= '1';
                                else
                                    T_out <= '0';
                                end if;
                                RegDest <= "1111"; -- dummy number
                                pc_sel <= "00";
                                CReg <= '1';
                                CRegA(2 downto 0) <= inst(10 downto 8); CRegA(3) <= '0';
                                CRegB(2 downto 0) <= inst(7 downto 5); CRegB(3) <= '0';
                            when "11" => -- SLTU
                                if (unsigned(RegAVal) < unsigned(RegBVal)) then
                                    T_out <= '1';
                                else
                                    T_out <= '0';
                                end if;
                                RegDest <= "1111"; -- dummy number
                                pc_sel <= "00";
                                CReg <= '1';
                                CRegA(2 downto 0) <= inst(10 downto 8); CRegA(3) <= '0';
                                CRegB(2 downto 0) <= inst(7 downto 5); CRegB(3) <= '0';
                            when "00" => -- MFPC JR JRRA JALR
                                opcode <= "1111";
                                T_out <= T_in;
                                case inst(7 downto 5) is
                                    when "010" => -- MFPC
                                        operandA <= pc;
                                        RegDest(2 downto 0) <= inst(10 downto 8);
                                        RegDest(3) <= '0';
                                        pc_sel <= "00";
                                        CReg <= '0';
                                    when "000" => -- JR  TODO: PC Select!!!
                                        pc_sel <= "10";
                                        RegDest <= "1111"; -- dummy number
                                        CReg <= '1';
                                        CRegA(2 downto 0) <= inst(10 downto 8); CRegA(3) <= '0';
                                        CRegB <= "1111";
                                    when "001" => -- JRRA
                                        pc_sel <= "01";
                                        RegDest <= "1111"; -- dummy number
                                        CReg <= '1';
                                        CRegA <= "1000";
                                        CRegB <= "1111";
                                        null;
                                    when "110" => -- JALR
                                        pc_sel <= "10";
                                        operandA <= pc;
                                        RegDest <= "1000";
                                        CReg <= '1';
                                        CRegA(2 downto 0) <= inst(10 downto 8); CRegA(3) <= '0';
                                        CRegB <= "1111";
                                    when others => null;
                                end case;
                            when others => null;
                        end case;        
                    when "001" => -- SLLV SRLV SRAV
                        case inst(1 downto 0) is
                            when "00" => opcode <= "1000";
                            when "10" => opcode <= "1010";
                            when "11" => opcode <= "1011";
                            when others => null;
                        end case;
                        operandA <= RegBVal;
                        operandB <= RegAVal;
                        -- RegDest is ry
                        RegDest(2 downto 0) <= inst(7 downto 5);
                        RegDest(3) <= '0';
                        RegOpA(2 downto 0) <= inst(7 downto 5);
                        RegOpA(3) <= '0';							
						RegOpB(2 downto 0) <= inst(10 downto 8);
						RegOpB(3) <= '0';
                        pc_sel <= "00";
                        CReg <= '0';
                        T_out <= T_in;
                    when "010" => -- CMP NEG
                        case inst(1 downto 0) is
                            when "10" => -- CMP
                                if (RegAVal = RegBVal)  then
                                    T_out <= '0';
                                else
                                    T_out <= '1';
                                end if;
                                RegDest <= "1111";
                                RegOpA <= "1111";
                                RegOpB <= "1111";
                                CReg <= '1';
                                CRegA(2 downto 0) <= inst(10 downto 8); CRegA(3) <= '0';
                                CRegB(2 downto 0) <= inst(7 downto 5); CRegB(3) <= '0';
                            when "11" => -- NEG
                                opcode <= "0001"; 
                                operandA <= (others => '0'); 
                                operandB <= RegBVal;
                                RegDest(2 downto 0) <= inst(10 downto 8); RegDest(3) <= '0';
                                RegOpA <= "1111";
                                RegOpB(2 downto 0) <= inst(7 downto 5); RegOpB(3) <= '0';
                                CReg <= '0';
                                T_out <= T_in;
                            when others => null;
                        end case;
                        pc_sel <= "00";
                    when "011" => -- AND OR XOR NOT
                        case inst(1 downto 0) is
                            when "00" => opcode <= "0100";
                            when "01" => opcode <= "0101";
                            when "10" => opcode <= "0110";
                            when "11" => opcode <= "0111";
                            when others => null;
                        end case;
                        operandA <= RegAVal;
                        operandB <= RegBVal;
                        RegOpA(2 downto 0) <= inst(10 downto 8);
                        RegOpA(3) <= '0';
                        RegOpB(2 downto 0) <= inst(7 downto 5);
                        RegOpB(3) <= '0';
                        -- RegDest is rx
                        RegDest(2 downto 0) <= inst(10 downto 8);
                        RegDest(3) <= '0';
                        pc_sel <= "00";
                        CReg <= '0';
                        T_out <= T_in;
                    when others =>
                        pc_sel <= "00";
                        opcode <= "1111"; -- 1111 means doing nothing
                        RegOpA <= "1111";
                        RegOpA <= "1111";
                        CReg <= '0';
                        CRegA <= "1111";
                        CRegB <= "1111";
                        T_out <= T_in;
                end case;
                RegWE <= '1';
                MemWE <= '0';
                MemRd <= '0';
                -- prefix "11101" ended
            when "11110" => -- MFIH MTIH 
                case inst(1 downto 0) is
                    when "00" => --MFIH
                        operandA <= IHVal;
                        -- RegDest is rx
                        RegDest(2 downto 0) <= inst(10 downto 8);
                        RegDest(3) <= '0';
                        RegOpA <= "1010";
                    when "01" => --MTIH
                        operandA <= RegAVal;
                        RegDest <= "1010";
                        RegOpA(2 downto 0) <= inst(10 downto 8);
                        RegOpA(3) <= '0';
                    when others => null;
                end case;
                opcode <= "1111";
                RegWE <= '1';
                MemWE <= '0';
                MemRd <= '0';
                RegOpB <= "1111";
                pc_sel <= "00";
                CReg <= '0';
                CRegA <= "1111";
                CRegB <= "1111";
                T_out <= T_in;
            when "00110" => -- SRL SRA SLL
                case inst(1 downto 0) is 
                    when "00" => -- SLL
                        opcode <= "1000";
                    when "10" => -- SRL
                        opcode <= "1010";
                    when "11" => -- SRA
                        opcode <= "1011";
                    when others => null;
                end case;
                RegWE <= '1';
                -- RegDest is rx
                RegDest(2 downto 0) <= inst(10 downto 8);
                RegDest(3) <= '0';
                operandA <= RegBVal;
				if (inst(4 downto 2) = "000") then
					operandB(3) <= '1';
				else
					operandB(3) <= '0';
				end if;
                operandB(2 downto 0) <= inst(4 downto 2);
                operandB(15 downto 4) <= (others => '0');
                MemWE <= '0';
                MemRd <= '0';
                RegOpA(2 downto 0) <= inst(7 downto 5);
                RegOpA(3) <= '0';
                RegOpB <= "1111";
                pc_sel <= "00";
                CReg <= '0';
                CRegA <= "1111";
                CRegB <= "1111";
                T_out <= T_in;
            when "01111" => -- MOVE
                opcode <= "1111";
                operandA <= RegBVal;
                RegWE <= '1';
                -- RegDest is rx
                RegDest(2 downto 0) <= inst(10 downto 8);
                RegDest(3) <= '0';
                MemWE <= '0';
                MemRd <= '0';
                RegOpA(2 downto 0) <= inst(7 downto 5);
                RegOpA(3) <= '0';
                RegOpB <= "1111";
                pc_sel <= "00";
                CReg <= '0';
                CRegA <= "1111";
                CRegB <= "1111";
                T_out <= T_in;
            when "01100" => -- MTSP SW_RS ADDSP BTEQZ BTNEZ
                case inst(10 downto 8) is
                    when "100" => -- MTSP
                        opcode <= "1111";
                        operandA <= RegBVal; -- NOTE: ry here is "rx"
                        RegWE <= '1';
                        RegDest <= "1001";
                        MemWE <= '0';
                        RegOpA(2 downto 0) <= inst(7 downto 5); RegOpA(3) <= '0';
                        RegOpB <= "1111";
                        pc_sel <= "00";
                    when "010" => -- SW_RS
                        RegWE <= '0';
                        MemDIn <= RAVal;
                        MemWE <= '1';
                        opcode <= "0000";
                        operandA <= SPVal;
                        operandB(7 downto 0) <= inst(7 downto 0);
                        operandB(15 downto 8) <= (others => inst(7)); -- FIXME? S_EXT OR Z_EXT?
                        RegOpA <= "1001";
                        RegOpB <= "1111";
                        pc_sel <= "00";
                    when "011" => -- ADDSP
                        RegWE <= '1';
                        MemWE <= '0';
                        RegDest <= "1001";
                        opcode <= "0000";
                        operandA <= SPVal;
                        operandB(7 downto 0) <= inst(7 downto 0);
                        operandB(15 downto 8) <= (others => inst(7)); -- FIXME? S_EXT OR Z_EXT?
                        RegOpA <= "1001";
                        RegOpB <= "1111";
                        pc_sel <= "00";
                    when "000" => -- BTEQZ
                        RegWE <= '0';
                        MemWE <= '0';
                        if (T_in = '0') then
                            pc_sel <= "11";
                        else
                            pc_sel <= "00";
                        end if;
                        RegOpA <= "1111";
                        RegOpB <= "1111";
                    when "001" => -- BTNEZ
                        RegWE <= '0';
                        MemWE <= '0';
                        if (T_in /= '0') then
                            pc_sel <= "11";
                        else
                            pc_sel <= "00";
                        end if;
                        RegOpA <= "1111";
                        RegOpB <= "1111";
                    when others => null;
                end case;
                MemRd <= '0';
                CReg <= '0';
                CRegA <= "1111";
                CRegB <= "1111";
                T_out <= T_in;
            when "11111" => -- INT TODO!
                -- FIXME!!!
                RegWE <= '0';
                MemWE <= '0';
                MemRd <= '0';
                RegOpA <= "1111";
                RegOpB <= "1111";
                pc_sel <= "00";
                CReg <= '0';
                CRegA <= "1111";
                CRegB <= "1111";
                T_out <= T_in;
            when "00001" => -- NOP
                pc_sel <= "00";
                RegWE <= '0';
                MemWE <= '0';
                MemRd <= '0';
                RegOpA <= "1111";
                RegOpB <= "1111";
                CReg <= '0';
                CRegA <= "1111";
                CRegB <= "1111";
                T_out <= T_in;
            when "00000" => -- ADDSP3
                pc_sel <= "00";
                RegWE <= '1';
                -- RegDest is rx
                RegDest(2 downto 0) <= inst(10 downto 8);
                RegDest(3) <= '0';
                MemWE <= '0';
                MemRd <= '0';
                opcode <= "0000";
                operandA <= SPVal;
                operandB(7 downto 0) <= inst(7 downto 0);
                operandB(15 downto 8) <= (others => inst(7));
                RegOpA <= "1001";
                RegOpB <= "1111";
                CReg <= '0';
                CRegA <= "1111";
                CRegB <= "1111";
                T_out <= T_in;
            when "01000" => -- ADDIU3
                pc_sel <= "00";
                RegWE <= '1';
                -- RegDest is ry
                RegDest(2 downto 0) <= inst(7 downto 5);
                RegDest(3) <= '0';
                MemWE <= '0';
                MemRd <= '0';
                opcode <= "0000";
                operandA <= RegAVal;
                operandB(3 downto 0) <= inst(3 downto 0);
                operandB(15 downto 4) <= (others => inst(3));
                RegOpA(2 downto 0) <= inst(10 downto 8);
                RegOpA(3) <= '0';
                RegOpB <= "1111";
                CReg <= '0';
                CRegA <= "1111";
                CRegB <= "1111";
                T_out <= T_in;
            when "01001" => -- ADDIU
                pc_sel <= "00";
                RegWE <= '1';
                -- RegDest is rx
                RegDest(2 downto 0) <= inst(10 downto 8);
                RegDest(3) <= '0';
                opcode <= "0000";
                MemWE <= '0';
                MemRd <= '0';
                operandA <= RegAVal;
                operandB(7 downto 0) <= inst(7 downto 0);
                operandB(15 downto 8) <= (others => inst(7));
                RegOpA(2 downto 0) <= inst(10 downto 8);
                RegOpA(3) <= '0';
                RegOpB <= "1111";
                CReg <= '0';
                CRegA <= "1111";
                CRegB <= "1111";
                T_out <= T_in;
            when "01010" => -- SLTI
                pc_sel <= "00";
                RegWE <= '1';
                MemWE <= '0';
                MemRd <= '0';
                RegOpA <= "1111";
                RegOpB <= "1111";
                CReg <= '1';
                CRegA <= "1111";
                CRegB <= "1111";
                if (signed(RegAVal) < signed(inst(7 downto 0))) then
                    T_out <= '1';
                else
                    T_out <= '0';
                end if;
            when "01011" => -- SLTUI
                pc_sel <= "00";
                RegWE <= '1';
                MemWE <= '0';
                MemRd <= '0';
                RegOpA <= "1111";
                RegOpB <= "1111";
                CReg <= '1';
                CRegA <= "1111";
                CRegB <= "1111";
                if (unsigned(RegAVal) < unsigned(inst(7 downto 0))) then  -- FIXME?
                    T_out <= '1';
                else
                    T_out <= '0';
                end if;
            when "01101" => -- LI
                pc_sel <= "00";
                RegWE <= '1';
                MemWE <= '0';
                MemRd <= '0';
                RegOpA <= "1111";
                RegOpB <= "1111";
                -- RegDest is rx
                RegDest(2 downto 0) <= inst(10 downto 8);
                RegDest(3) <= '0';
                opcode <= "1111";
                operandA(7 downto 0) <= inst(7 downto 0);
                operandA(15 downto 8) <= (others => '0');
                CReg <= '0';
                CRegA <= "1111";
                CRegB <= "1111";
                T_out <= T_in;
            when "01110" => -- CMPI
                pc_sel <= "00";
                RegWE <= '1';
                RegDest <= "1111";
                MemWE <= '0';
                MemRd <= '0';
                RegOpA <= "1111";
                RegOpB <= "1111";
                CReg <= '1';
                CRegA(2 downto 0) <= inst(10 downto 8); CRegA(3) <= '0';
                CRegB <= "1111";
                if (signed(RegAVal) = signed(inst(7 downto 0))) then  -- FIXME?
                    T_out <= '0';
                else
                    T_out <= '1';
                end if;
            when "10010" => -- LW_SP
                pc_sel <= "00";
                RegWE <= '1';
                MemWE <= '0';
                MemRd <= '1';
                RegOpA <= "1001";
                RegOpB <= "1111";
                -- RegDest is rx
                RegDest(2 downto 0) <= inst(10 downto 8);
                RegDest(3) <= '0';
                opcode <= "0000";
                operandA <= SPVal;
                operandB(7 downto 0) <= inst(7 downto 0);
                operandB(15 downto 8) <= (others => inst(7));
                CReg <= '0';
                CRegA <= "1111";
                CRegB <= "1111";
                T_out <= T_in;
            when "10011" => -- LW
                pc_sel <= "00";
                RegWE <= '1';
                MemWE <= '0';
                MemRd <= '1';
                RegOpA(2 downto 0) <= inst(10 downto 8);
                RegOpA(3) <= '0';
                RegOpB <= "1111";
                -- RegDest is ry
                RegDest(2 downto 0) <= inst(7 downto 5);
                RegDest(3) <= '0';
                opcode <= "0000";
                operandA <= RegAVal;
                operandB(4 downto 0) <= inst(4 downto 0);
                operandB(15 downto 5) <= (others => inst(4));
                CReg <= '0';
                CRegA <= "1111";
                CRegB <= "1111";
                T_out <= T_in;
            when "11010" => -- SW_SP
                pc_sel <= "00";
                RegWE <= '0';
                MemWE <= '1';
                MemDIn <= RegAVal;
                MemRd <= '0';
                RegOpA <= "1001";
                RegOpB <= "1111";
                opcode <= "0000";
                operandA <= SPVal;
                operandB(7 downto 0) <= inst(7 downto 0);
                operandB(15 downto 8) <= (others => inst(7));
                CReg <= '0';
                CRegA <= "1111";
                CRegB <= "1111";
                T_out <= T_in;
            when "11011" => -- SW
                pc_sel <= "00";
                RegWE <= '0';
                MemWE <= '1';
                MemDIn <= RegBVal;
                MemRd <= '0';
                RegOpA(2 downto 0) <= inst(10 downto 8);
                RegOpA(3) <= '0';
                RegOpB <= "1111";
                opcode <= "0000";
                operandA <= RegAVal;
                operandB(4 downto 0) <= inst(4 downto 0);
                operandB(15 downto 5) <= (others => inst(4));
                CReg <= '0';
                CRegA <= "1111";
                CRegB <= "1111";
                T_out <= T_in;
            when "00010" => -- B
                RegWE <= '0';
                MemWE <= '0';
                MemRd <= '0';
                RegOpA <= "1111";
                RegOpB <= "1111";
                CReg <= '0';
                CRegA <= "1111";
                CRegB <= "1111";
                pc_imm(10 downto 0) <= inst(10 downto 0);
                pc_imm(15 downto 11) <= (others => '0'); 
                pc_sel <= "11";
                T_out <= T_in;
            when "00100" => -- BEQZ
                RegWE <= '0';
                MemWE <= '0';
                MemRd <= '0';
                RegOpA <= "1111";
                RegOpB <= "1111";
                pc_imm(7 downto 0) <= inst(7 downto 0);
                pc_imm(15 downto 8) <= (others => '0'); 
                CReg <= '1';
                CRegA(2 downto 0) <= inst(10 downto 8); CRegA(3) <= '0';
                CRegB <= "1111";
                T_out <= T_in;
                if (RegAVal = "0000000000000000") then
                    pc_sel <= "11";
                else
                    pc_sel <= "00";
                end if;
            when "00101" => -- BNEZ
                RegWE <= '0';
                MemWE <= '0';
                MemRd <= '0';
                RegOpA <= "1111";
                RegOpB <= "1111";
                pc_imm(7 downto 0) <= inst(7 downto 0);
                pc_imm(15 downto 8) <= (others => '0'); 
                CReg <= '1';
                CRegA(2 downto 0) <= inst(10 downto 8); CRegA(3) <= '0';
                CRegB <= "1111";
                T_out <= T_in;
                if (RegAVal /= "0000000000000000") then
                    pc_sel <= "11";
                else
                    pc_sel <= "00";
                end if;
            when others => 
                RegWE <= '0';
                MemWE <= '0';
                MemRd <= '0';
                RegOpA <= "1111";
                RegOpB <= "1111";
                pc_sel <= "00";
                CReg <= '0';
                CRegA <= "1111";
                CRegB <= "1111";
                T_out <= T_in;
        end case;
    end process;

end Behavioral;

