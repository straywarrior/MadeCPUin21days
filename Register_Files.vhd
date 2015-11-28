----------------------------------------------------------------------------------
-- Company: 
-- Engineer:       StrayWarrior
-- 
-- Create Date:    15:28:57 11/14/2015 
-- Design Name: 
-- Module Name:    Register_Files - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Register_Files is
    Port ( clk : in  STD_LOGIC;
		   reset : in STD_LOGIC;
           ASel : in  STD_LOGIC_VECTOR (3 downto 0);
           BSel : in  STD_LOGIC_VECTOR (3 downto 0);
           WSel : in  STD_LOGIC_VECTOR (3 downto 0);
           WE : in  STD_LOGIC;
           WVal : in  STD_LOGIC_VECTOR (15 downto 0);
           AVal : out  STD_LOGIC_VECTOR (15 downto 0);
           BVal : out  STD_LOGIC_VECTOR (15 downto 0);
           RAVal : out  STD_LOGIC_VECTOR (15 downto 0);
           SPVal : out  STD_LOGIC_VECTOR (15 downto 0);
           IHVal : out  STD_LOGIC_VECTOR (15 downto 0)
           );
end Register_Files;

architecture Behavioral of Register_Files is
    type regs is array (0 to 10) of STD_LOGIC_VECTOR(15 downto 0);
    -- 8 universal regs (R0 ~ R7) and 3 special regs (RA 1000, SP 1001, IH 1010)
    signal regfiles : regs := (others => (others => '0'));
begin
    process (clk, reset)
    begin
		if (reset = '0') then
			RAVal <= (others => '0');
			SPVal <= (others => '0');
			IHVal <= (others => '0');
			AVal <= (others => '0');
			BVal <= (others => '0');
			regfiles <= (others => (others => '0'));
        elsif (clk'event and clk = '1') then
            if (WE = '1' and WSel /= "1111") then
                regfiles(CONV_INTEGER(unsigned(WSel))) <= WVal;
                if ("1000" = WSel) then
                    RAVal <= WVal;
                else
                    RAVal <= regfiles(8);
                end if;
                
                if ("1001" = WSel) then
                    SPVal <= WVal;
                else
                    SPVal <= regfiles(9);
                end if;
                
                if ("1010" = WSel) then
                    IHVal <= WVal;
                else
                    IHVal <= regfiles(10);
                end if;
                
                if (ASel = WSel) then
                    AVal <= WVal;
                else
                    AVal <= regfiles(CONV_INTEGER(unsigned(ASel(2 downto 0))));
                end if;
                
                if (BSel = WSel) then
                    BVal <= WVal;
                else
                    BVal <= regfiles(CONV_INTEGER(unsigned(BSel(2 downto 0))));
                end if;
            else
                RAVal <= regfiles(8);
                SPVal <= regfiles(9);
                IHVal <= regfiles(10);
                AVal <= regfiles(CONV_INTEGER(unsigned(ASel(2 downto 0))));
                BVal <= regfiles(CONV_INTEGER(unsigned(BSel(2 downto 0))));
            end if;
        end if;
    end process;

end Behavioral;

