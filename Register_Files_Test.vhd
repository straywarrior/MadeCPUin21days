--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:42:00 11/24/2015
-- Design Name:   
-- Module Name:   Z:/Project/MadeCPUin21days/Register_Files_Test.vhd
-- Project Name:  MadeCPUin21days
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Register_Files
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Register_Files_Test IS
END Register_Files_Test;
 
ARCHITECTURE behavior OF Register_Files_Test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Register_Files
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         ASel : IN  std_logic_vector(3 downto 0);
         BSel : IN  std_logic_vector(3 downto 0);
         WSel : IN  std_logic_vector(3 downto 0);
         WE : IN  std_logic;
         WVal : IN  std_logic_vector(15 downto 0);
         AVal : OUT  std_logic_vector(15 downto 0);
         BVal : OUT  std_logic_vector(15 downto 0);
         RAVal : OUT  std_logic_vector(15 downto 0);
         SPVal : OUT  std_logic_vector(15 downto 0);
         IHVal : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal ASel : std_logic_vector(3 downto 0) := (others => '0');
   signal BSel : std_logic_vector(3 downto 0) := (others => '0');
   signal WSel : std_logic_vector(3 downto 0) := (others => '0');
   signal WE : std_logic := '0';
   signal WVal : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal AVal : std_logic_vector(15 downto 0);
   signal BVal : std_logic_vector(15 downto 0);
   signal RAVal : std_logic_vector(15 downto 0);
   signal SPVal : std_logic_vector(15 downto 0);
   signal IHVal : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Register_Files PORT MAP (
          clk => clk,
          reset => reset,
          ASel => ASel,
          BSel => BSel,
          WSel => WSel,
          WE => WE,
          WVal => WVal,
          AVal => AVal,
          BVal => BVal,
          RAVal => RAVal,
          SPVal => SPVal,
          IHVal => IHVal
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
        -- hold reset state.
        reset <= '1';
        wait for 10 ns;
        reset <= '0';
        wait for 10 ns;
        -- insert stimulus here
        ASel <= "0000";
        BSel <= "0001";
        WSel <= "1001";
        WVal <= "1010010100001000";
        WE <= '1';
        wait for 20 ns;
        
        ASel <= "0000";
        BSel <= "0001";
        WSel <= "0001";
        WVal <= "1010010100001001";
        WE <= '1';
        wait for 20 ns;
        
        ASel <= "0001";
        BSel <= "0010";
        WSel <= "0001";
        WVal <= "1010010100001010";
        WE <= '1';
        wait for 20 ns;
        
        wait;
   end process;

END;
