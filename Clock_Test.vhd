--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   01:20:41 11/25/2015
-- Design Name:   
-- Module Name:   Z:/Project/MadeCPUin21days/Clock_Test.vhd
-- Project Name:  MadeCPUin21days
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ClockDiv
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
 
ENTITY Clock_Test IS
END Clock_Test;
 
ARCHITECTURE behavior OF Clock_Test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ClockDiv
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         clk_2t : OUT  std_logic;
         clk_4t : OUT  std_logic;
         clk_16t : OUT std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal clk_2t : std_logic;
   signal clk_4t : std_logic;
   signal clk_16t : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ClockDiv PORT MAP (
          clk => clk,
          reset => reset,
          clk_2t => clk_2t,
          clk_4t => clk_4t,
          clk_16t => clk_16t
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
      -- hold reset state for 100 ns.
      wait for 100 ns;	
      
      reset <= '0';
      wait for 10 ns;
      reset <= '1';
      wait for 10 ns;

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
