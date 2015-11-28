----------------------------------------------------------------------------------
-- Company: 
-- Engineer:       StrayWarrior
-- 
-- Create Date:    21:17:00 11/15/2015 
-- Design Name: 
-- Module Name:    DataMemoryControl - Behavioral 
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

entity DataMemoryControl is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           MemRead : in STD_LOGIC;
           MemWrite: in STD_LOGIC;
           MemAddr : in  STD_LOGIC_VECTOR (15 downto 0);
           MemData : in  STD_LOGIC_VECTOR (15 downto 0);
           MemOut : out STD_LOGIC_VECTOR (15 downto 0);
           SerialFinish : out STD_LOGIC;

           RAM1Addr : out STD_LOGIC_VECTOR (17 downto 0);
           RAM1Data : inout STD_LOGIC_VECTOR (15 downto 0);
           RAM1EN : out STD_LOGIC;
           RAM1OE : out STD_LOGIC;
           RAM1RW : out STD_LOGIC;
           
           Serial_dataready : in STD_LOGIC;
           Serial_rdn : out STD_LOGIC;
           Serial_tbre : in STD_LOGIC;
           Serial_tsre : in STD_LOGIC;
           Serial_wrn : out STD_LOGIC
            
           );
end DataMemoryControl;

architecture Behavioral of DataMemoryControl is
    type state_type is (s0, s1, s2, s3);
    signal state : state_type;

begin
    RAM1Addr(17 downto 16) <= (others => '0');
    RAM1Addr(15 downto 0) <= MemAddr - x"8000";
    RAM1Data <=
        (others => 'Z') when MemRead = '1' else
        MemData when MemWrite = '1' else
        (others => 'Z');
    
    process (clk, reset)
    begin
        if (reset = '0') then
            state <= s0;
            RAM1EN <= '1';
            RAM1OE <= '1';
            RAM1RW <= '1';
            Serial_rdn <= '1';
            Serial_wrn <= '1';
            SerialFinish <= '1';
        elsif (clk'event and clk = '1') then
            if (state = s0) then
                state <= s1;
                -- prepare for the control, data and address
                RAM1EN <= '1';
                RAM1OE <= '1';
                RAM1RW <= '1';
                SerialFinish <= '0';
                Serial_rdn <= '1';
                Serial_wrn <= '1';
            elsif (state = s1) then
                state <= s2;
                -- Read Memory (LW rx ry imm)
                if (MemRead = '1') then
                    -- Serial Port
                    if (MemAddr = x"BF00") then
                        RAM1EN <= '1';
                        RAM1OE <= '1';
                        RAM1RW <= '1';
                        SerialFinish <= '0';
                        Serial_rdn <= '0';
                        Serial_wrn <= '1';
                    elsif (MemAddr = x"BF01") then
                        RAM1EN <= '1';
                        RAM1OE <= '1';
                        RAM1RW <= '1';
                        SerialFinish <= '0';
                        Serial_wrn <= '1';
                        Serial_rdn <= '1';
                    -- RAM1
                    elsif (MemAddr >= x"8000" and MemAddr <= x"FFFF") then
                        RAM1EN <= '0';
                        RAM1OE <= '0';
                        RAM1RW <= '1';
                        SerialFinish <= '1';
                        Serial_rdn <= '1';
                        Serial_wrn <= '1';
                    else
                        RAM1EN <= '1';
                        RAM1OE <= '1';
                        RAM1RW <= '1';
                        SerialFinish <= '1';
                        Serial_rdn <= '1';
                        Serial_wrn <= '1';
                    end if;
                -- Write Memory (SW rx ry imm)
                elsif (MemWrite = '1') then
                    -- Serial Port
                    if (MemAddr = x"BF00") then
                        if (Serial_tsre = '1' and Serial_tbre = '1') then
                            Serial_wrn <= '0';
                            SerialFinish <= '0';
                        else
                            Serial_wrn <= '1';
                            SerialFinish <= '0';
                        end if;
                        Serial_rdn <= '1';
                        RAM1EN <= '1';
                        RAM1OE <= '1';
                        RAM1RW <= '1';
                    elsif (MemAddr = x"BF01") then
                        RAM1EN <= '1';
                        RAM1OE <= '1';
                        RAM1RW <= '1';
                        SerialFinish <= '1';
                        Serial_rdn <= '1';
                        Serial_wrn <= '1';
                    -- RAM1
                    elsif (MemAddr >= x"8000" and MemAddr <= x"FFFF") then
                        RAM1EN <= '0';
                        RAM1OE <= '1';
                        RAM1RW <= '0';
                        SerialFinish <= '1';
                        Serial_rdn <= '1';
                        Serial_wrn <= '1';
                    else
                        RAM1EN <= '1';
                        RAM1OE <= '1';
                        RAM1RW <= '1';
                        SerialFinish <= '1';
                        Serial_rdn <= '1';
                        Serial_wrn <= '1';
                    end if;
                else
                    RAM1EN <= '1';
                    RAM1OE <= '1';
                    RAM1RW <= '1';
                    SerialFinish <= '1';
                    Serial_rdn <= '1';
                    Serial_wrn <= '1';
                end if;
            elsif (state = s2) then
                state <= s3;
                -- Read Memory (LW rx ry imm)
                if (MemRead = '1') then
                    -- Serial Port
                    if (MemAddr = x"BF00") then
                        Serial_rdn <= '1';
                        SerialFinish <= '1';
                        MemOut <= RAM1Data;
                    elsif (MemAddr = x"BF01") then
                        MemOut <= (1 => Serial_dataready, 0 => (Serial_tsre and Serial_tbre), others => '0');
                        SerialFinish <= '1';
                    -- RAM1
                    elsif (MemAddr >= x"8000" and MemAddr <= x"FFFF") then
                        RAM1EN <= '0';
                        RAM1OE <= '0';
						RAM1RW <= '1';
                        SerialFinish <= '1';
                        MemOut <= RAM1Data;
                    end if;
                -- Write Memory (SW rx ry imm)
                elsif (MemWrite = '1') then
                    -- Serial Port
                    if (MemAddr = x"BF00") then
                        RAM1EN <= '1';
                        Serial_wrn<= '1';
                        SerialFinish <= '0';
                    elsif (MemAddr = x"BF01") then
                        SerialFinish <= '1';
                    -- RAM1
                    elsif (MemAddr >= x"8000" and MemAddr <= x"FFFF") then
                        RAM1EN <= '0';
						RAM1OE <= '1';
                        RAM1RW <= '1';
                        SerialFinish <= '1';
                    end if;
                end if;
            elsif (state = s3) then
                state <= s0;
                -- Read Memory (LW rx ry imm)
                if (MemRead = '1') then
                    -- Serial Port
                    if (MemAddr = x"BF00") then
                        RAM1EN <= '1';
                        Serial_rdn <= '1';
                        SerialFinish <= '1';
                        MemOut <= RAM1Data;
                    elsif (MemAddr = x"BF01") then
                        MemOut <= (1 => Serial_dataready, 0 => (Serial_tsre and Serial_tbre), others => '0');
                        SerialFinish <= '1';
                    -- RAM1
                    elsif (MemAddr >= x"8000" and MemAddr <= x"FFFF") then
                        RAM1EN <= '0';
                        RAM1OE <= '0';
						RAM1RW <= '1';
                        SerialFinish <= '1';
                        MemOut <= RAM1Data;
                    end if;
                -- Write Memory (SW rx ry imm)
                elsif (MemWrite = '1') then
                    -- Serial Port
                    if (MemAddr = x"BF00") then
                        RAM1EN <= '1';
                        Serial_wrn<= '1';
                        if (Serial_tsre = '1' and Serial_tbre = '1') then
                            SerialFinish <= '1';
                        else
                            SerialFinish <= '0';
                        end if;
                    elsif (MemAddr = x"BF01") then
                        SerialFinish <= '1';
                    -- RAM1
                    elsif (MemAddr >= x"8000" and MemAddr <= x"FFFF") then
                        RAM1EN <= '0';
						RAM1OE <= '1';
                        RAM1RW <= '1';
                        SerialFinish <= '1';
                    end if;
                end if;
            end if;
        end if;
    end process;

end Behavioral;
