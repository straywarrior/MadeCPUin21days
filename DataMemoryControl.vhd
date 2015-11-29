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
           Serial_wrn : out STD_LOGIC;
           
           DLED_Right : out STD_LOGIC_VECTOR (6 downto 0)
           );
end DataMemoryControl;

architecture Behavioral of DataMemoryControl is
    type state_type is (s0, s1, s2, s3, sr0, sr1, sr2, sr3, sr4, sr5, sr6, sr7, sr8, sr9, sr10, sr11); -- sr1 - sr11 is state for serial write. 50 MHz is too fast for serial port.
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
        elsif (clk'event and clk = '1') then
            case state is
            when s0 => state <= s1;
            when s1 => state <= s2;
            when s2 => state <= s3;
            when s3 => 
                if (MemAddr = x"BF00" and MemWrite = '1') then
                    state <= sr0;
                else
                    state <= s0;
                end if;
            when sr0 => state <= sr1;
            when sr1 => state <= sr2;
            when sr2 => state <= sr3;
            when sr3 => state <= sr4;
            when sr4 => state <= sr5;
            when sr5 => state <= sr6;
            when sr6 => state <= sr7;
            when sr7 => state <= sr8;
            when sr8 => state <= sr9;
            when sr9 => state <= sr10;
            when sr10 => state <= sr11;
            when sr11 =>
                if (Serial_tbre = '1' and Serial_tsre = '1') then
                    state <= s0;
                else
                    state <= sr0;
                end if;
            when others => state <= s0;
            end case;
        end if;
    end process;
    
    process (clk, reset)
    begin
        if (reset = '0') then
            RAM1EN <= '1';
            RAM1OE <= '1';
            RAM1RW <= '1';
            Serial_rdn <= '1';
            Serial_wrn <= '1';
            SerialFinish <= '1';
        elsif (clk'event and clk = '1' and MemAddr >= x"8000" and MemAddr <= x"FFFF") then
            case state is
            when s0 =>
                -- prepare for the control, data and address
                RAM1EN <= '1';
                RAM1OE <= '1';
                RAM1RW <= '1';
                SerialFinish <= '1';
                Serial_rdn <= '1';
                Serial_wrn <= '1';
            when s1 =>
                if (MemRead = '1') then
                    case MemAddr is
                    when x"BF00" =>
                        RAM1EN <= '1'; RAM1OE <= '1'; RAM1RW <= '1';
                        SerialFinish <= '0';
                        Serial_rdn <= '0';
                        Serial_wrn <= '1';
                    when x"BF01" =>
                        RAM1EN <= '1'; RAM1OE <= '1'; RAM1RW <= '1';
                        SerialFinish <= '0';
                        Serial_wrn <= '1';
                        Serial_rdn <= '1';
                    when others =>
                        RAM1EN <= '0';
                        RAM1OE <= '0';
                        RAM1RW <= '1';
                        SerialFinish <= '1'; Serial_rdn <= '1'; Serial_wrn <= '1';
                    end case;
                end if;
                if (MemWrite = '1') then
                    case MemAddr is
                    when x"BF00" =>
                        RAM1EN <= '1'; RAM1OE <= '1'; RAM1RW <= '1';
                        SerialFinish <= '0';
                        Serial_rdn <= '1';
                        Serial_wrn <= '0';
                    when x"BF01" =>
                        RAM1EN <= '1'; RAM1OE <= '1'; RAM1RW <= '1';
                        SerialFinish <= '0'; Serial_wrn <= '1'; Serial_rdn <= '1';
                    when others =>
                        RAM1EN <= '0';
                        RAM1OE <= '1';
                        RAM1RW <= '0';
                        SerialFinish <= '1'; Serial_rdn <= '1'; Serial_wrn <= '1';
                    end case;
                end if;
            when s2 =>
                if (MemRead = '1') then
                    case MemAddr is
                    when x"BF00" =>
                        RAM1EN <= '1';  RAM1OE <= '1'; RAM1RW <= '1';
                        SerialFinish <= '0'; Serial_rdn <= '1'; Serial_wrn <= '1';

                    when x"BF01" =>
                        RAM1EN <= '1';  RAM1OE <= '1'; RAM1RW <= '1';
                        MemOut <= (1 => Serial_dataready, 0 => (Serial_tsre and Serial_tbre), others => '0');
                        SerialFinish <= '1';
                    when others =>
                        RAM1EN <= '0';
                        RAM1OE <= '0';
						RAM1RW <= '1';
                        SerialFinish <= '1';
                        MemOut <= RAM1Data;
                    end case;
                end if;
                if (MemWrite = '1') then
                    case MemAddr is
                    when x"BF00" =>
                        RAM1EN <= '1';  RAM1OE <= '1'; RAM1RW <= '1';
                        SerialFinish <= '0'; Serial_rdn <= '1'; Serial_wrn <= '1';
                    when x"BF01" =>
                        RAM1EN <= '1'; RAM1OE <= '1'; RAM1RW <= '1';
                        SerialFinish <= '1'; Serial_wrn <= '1'; Serial_rdn <= '1';
                    when others =>
                        RAM1EN <= '0'; RAM1OE <= '1'; RAM1RW <= '1';
                        SerialFinish <= '1'; Serial_wrn <= '1'; Serial_rdn <= '1';
                    end case;
                end if;
            when s3 =>
                if (MemRead = '1') then
                    case MemAddr is
                    when x"BF00" =>
                        RAM1EN <= '1'; RAM1OE <= '1'; RAM1RW <= '1';
                        Serial_rdn <= '1'; Serial_wrn <= '1'; SerialFinish <= '1';
                        MemOut <= RAM1Data;
                    when x"BF01" =>
                        RAM1EN <= '1';  RAM1OE <= '1'; RAM1RW <= '1';
                        SerialFinish <= '1';
                        MemOut <= (1 => Serial_dataready, 0 => (Serial_tsre and Serial_tbre), others => '0');
                    when others =>
                        RAM1EN <= '0'; RAM1OE <= '0'; RAM1RW <= '1';
                        SerialFinish <= '1';
                        MemOut <= RAM1Data;
                    end case;
                end if;
                if (MemWrite = '1') then
                    case MemAddr is
                    when x"BF00" =>
                        RAM1EN <= '1'; RAM1OE <= '1'; RAM1RW <= '1';Serial_rdn <= '1'; Serial_wrn <= '1'; SerialFinish <= '0';
                    when x"BF01" =>
                        RAM1EN <= '1'; RAM1OE <= '1'; RAM1RW <= '1'; Serial_rdn <= '1'; Serial_wrn <= '1'; SerialFinish <= '1';
                    when others =>
                        RAM1EN <= '0'; RAM1OE <= '1'; RAM1RW <= '1'; Serial_rdn <= '1'; Serial_wrn <= '1'; SerialFinish <= '1';
                    end case;
                end if;
            when sr0 =>
                RAM1EN <= '1'; RAM1OE <= '1'; RAM1RW <= '1';Serial_rdn <= '1'; Serial_wrn <= '1'; SerialFinish <= '0';
            when sr1 =>
                RAM1EN <= '1'; RAM1OE <= '1'; RAM1RW <= '1';Serial_rdn <= '1'; Serial_wrn <= '1'; SerialFinish <= '0';
            when sr2 =>
                RAM1EN <= '1'; RAM1OE <= '1'; RAM1RW <= '1';Serial_rdn <= '1'; Serial_wrn <= '1'; SerialFinish <= '0';
            when sr3 =>
                RAM1EN <= '1'; RAM1OE <= '1'; RAM1RW <= '1';Serial_rdn <= '1'; Serial_wrn <= '1'; SerialFinish <= '0';
            when sr4 =>
                RAM1EN <= '1'; RAM1OE <= '1'; RAM1RW <= '1';Serial_rdn <= '1'; Serial_wrn <= '1'; SerialFinish <= '0';
            when sr5 =>
                RAM1EN <= '1'; RAM1OE <= '1'; RAM1RW <= '1';Serial_rdn <= '1'; Serial_wrn <= '1'; SerialFinish <= '0';
            when sr6 =>
                RAM1EN <= '1'; RAM1OE <= '1'; RAM1RW <= '1';Serial_rdn <= '1'; Serial_wrn <= '1'; SerialFinish <= '0';
            when sr7 =>
                RAM1EN <= '1'; RAM1OE <= '1'; RAM1RW <= '1';Serial_rdn <= '1'; Serial_wrn <= '1'; SerialFinish <= '0';
            when sr8 =>
                RAM1EN <= '1'; RAM1OE <= '1'; RAM1RW <= '1';Serial_rdn <= '1'; Serial_wrn <= '1'; SerialFinish <= '0';
            when sr9 =>
                RAM1EN <= '1'; RAM1OE <= '1'; RAM1RW <= '1';Serial_rdn <= '1'; Serial_wrn <= '1'; SerialFinish <= '0';
            when sr10 =>
                RAM1EN <= '1'; RAM1OE <= '1'; RAM1RW <= '1';Serial_rdn <= '1'; Serial_wrn <= '1'; SerialFinish <= '1';
            when sr11 =>
                RAM1EN <= '1'; RAM1OE <= '1'; RAM1RW <= '1';
                Serial_rdn <= '1'; Serial_wrn <= '1'; 
                if (Serial_tsre = '1' and Serial_tbre = '1') then
                    SerialFinish <= '1';
                else
                    SerialFinish <= '0';
                end if;
            when others =>
                RAM1EN <= '1'; RAM1OE <= '1'; RAM1RW <= '1';Serial_rdn <= '1'; Serial_wrn <= '1'; SerialFinish <= '1';
            end case;
        end if;
    end process;
    
    DLED_Right <=
        "1111110" when state = s0 else
        "0110000" when state = s1 else
        "1101101" when state = s2 else
        "1111001" when state = s3 else
        "0110011" when state = sr0 else
        "1011011" when state = sr1 else
        "0000000";
        
    

end Behavioral;
