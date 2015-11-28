--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:37:46 11/22/2015
-- Design Name:   
-- Module Name:   Z:/Downloads/VMware Shared Files/ComputerOrganization/MadeCPUin21days/CPU_TEST.vhd
-- Project Name:  MadeCPUin21days
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CPU_TOP
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
 
ENTITY CPU_TEST IS
END CPU_TEST;
 
ARCHITECTURE behavior OF CPU_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CPU_TOP
    PORT(
         clock : IN  std_logic;
         reset : IN  std_logic;
         RAM1ADDR : OUT  std_logic_vector(17 downto 0);
         RAM1DATA : INOUT  std_logic_vector(15 downto 0);
         RAM1EN : OUT  std_logic;
         RAM1OE : OUT  std_logic;
         RAM1RW : OUT  std_logic;
         RAM2ADDR : OUT  std_logic_vector(17 downto 0);
         RAM2DATA : INOUT  std_logic_vector(15 downto 0);
         RAM2EN : OUT  std_logic;
         RAM2OE : OUT  std_logic;
         RAM2RW : OUT  std_logic;
         SERIAL_DATA_READY : IN  std_logic;
         SERIAL_RDN : OUT  std_logic;
         SERIAL_TBRE : IN  std_logic;
         SERIAL_TSRE : IN  std_logic;
         SERIAL_WRN : OUT  std_logic;
         SW : IN std_logic_vector (15 downto 0);
         LED : OUT  std_logic_vector(15 downto 0);
         DLED_RIGHT : out STD_LOGIC_VECTOR (6 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clock : std_logic := '0';
   signal reset : std_logic := '0';
   signal SERIAL_DATA_READY : std_logic := '0';
   signal SERIAL_TBRE : std_logic := '1';
   signal SERIAL_TSRE : std_logic := '1';

	--BiDirs
   signal RAM1DATA : std_logic_vector(15 downto 0);
   signal RAM2DATA : std_logic_vector(15 downto 0);

 	--Outputs
   signal RAM1ADDR : std_logic_vector(17 downto 0);
   signal RAM1EN : std_logic;
   signal RAM1OE : std_logic;
   signal RAM1RW : std_logic;
   signal RAM2ADDR : std_logic_vector(17 downto 0);
   signal RAM2EN : std_logic;
   signal RAM2OE : std_logic;
   signal RAM2RW : std_logic;
   signal SERIAL_RDN : std_logic;
   signal SERIAL_WRN : std_logic;
   signal LED : std_logic_vector(15 downto 0);
   signal SW : std_logic_vector (15 downto 0);
   signal DLED_RIGHT : std_logic_vector (6 downto 0);

   -- Clock period definitions
   constant clock_period : time := 20 ns;
   constant clock_2t_period : time := 40 ns;
   constant clock_4t_period : time := 80 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CPU_TOP PORT MAP (
          clock => clock,
          reset => reset,
          RAM1ADDR => RAM1ADDR,
          RAM1DATA => RAM1DATA,
          RAM1EN => RAM1EN,
          RAM1OE => RAM1OE,
          RAM1RW => RAM1RW,
          RAM2ADDR => RAM2ADDR,
          RAM2DATA => RAM2DATA,
          RAM2EN => RAM2EN,
          RAM2OE => RAM2OE,
          RAM2RW => RAM2RW,
          SERIAL_DATA_READY => SERIAL_DATA_READY,
          SERIAL_RDN => SERIAL_RDN,
          SERIAL_TBRE => SERIAL_TBRE,
          SERIAL_TSRE => SERIAL_TSRE,
          SERIAL_WRN => SERIAL_WRN,
          SW => SW,
          LED => LED,
          DLED_RIGHT => DLED_RIGHT
        );

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
        -- hold reset state.
        reset <= '0';
        sw <= "0000000001000111";
        wait for 10 ns;
        reset <= '1';

        -- NOP
        RAM2DATA <= "0000100000000000";
        wait for clock_4t_period;
        
        RAM2DATA <= x"0800";
        wait for clock_4t_period;
        RAM2DATA <= x"0800";
        wait for clock_4t_period;
        RAM2DATA <= x"6D40";
        wait for clock_4t_period;
        RAM2DATA <= x"35A0";
        wait for clock_4t_period;
        RAM2DATA <= x"6880";
        wait for clock_4t_period;
        RAM2DATA <= x"3000";
        wait for clock_4t_period;
        RAM2DATA <= x"DD00";
        wait for clock_4t_period;
        RAM2DATA <= x"68EF";
        wait for clock_4t_period;
        
        RAM2DATA <= (others => 'Z');
        wait for clock_4t_period;
        
        RAM2DATA <= x"3000";
        wait for clock_4t_period;
        RAM2DATA <= x"DD01";
        wait for clock_4t_period;
        RAM2DATA <= x"0800";
        wait for clock_4t_period;
        RAM2DATA <= x"0800";
        wait for clock_4t_period;
        -- NOP
        RAM2DATA <= "0000100000000000";
        wait for clock_4t_period;

        -- B 0x31
        RAM2DATA <= "0001000001100001";
        wait for clock_4t_period;

        -- R0 <= x"FF"
        RAM2DATA <= "0110100011111111";
        wait for clock_4t_period;

        -- SW R0 R1 1
        RAM2DATA <= "1101100000100001";
        wait for clock_4t_period;

        -- SLL R0 R0
        RAM2DATA <= "0011000000000000";
        wait for clock_4t_period;

        -- R1 <= x"0F"
        RAM2DATA <= "0110100000001111";
        wait for clock_4t_period;


        -- NOP
        RAM2DATA <= "0000100000000000";
        wait for clock_4t_period;

        -- SW R0 R1 1
        RAM2DATA <= "1101100000100001";
        wait for clock_4t_period;

        -- SLL R0 R0
        RAM2DATA <= "0011000000000000";

        -- ADDU R0 R1 R2
        RAM2DATA <= "1110000000101001";
        wait for clock_4t_period;

        -- NOP
        RAM2DATA <= "0000100000000000";
        wait for clock_4t_period;

        -- SW R0 R1 0
        RAM2DATA <= "1101100000100000";
        wait for clock_4t_period;

        -- insert stimulus here 

        wait;
   end process;

END;
