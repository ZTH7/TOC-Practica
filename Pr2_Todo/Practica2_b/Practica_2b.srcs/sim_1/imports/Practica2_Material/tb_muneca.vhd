----------------------------------------------------------------------------------
-- Company:        Universidad Complutense de Madrid
-- Engineer:       TOC & TC
--
-- Create Date:    
-- Design Name:    Practica 2
-- Module Name:    tb_muneca - beh 
-- Project Name:   Practica 2
-- Target Devices: Spartan-3 
-- Tool versions:  ISE 14.1
-- Description:    Testbench de la entidad uneca
-- Dependencies: 
-- Revision: 
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;


entity tb_muneca is

end tb_muneca;

architecture beh of tb_muneca is

---------------------------------------------------------------------------------
-- Component declaration

  component muneca
    port (clk   : in  std_logic;
          rst_n : in  std_logic;
          r     : in  std_logic;
          c     : in  std_logic;
          g     : out std_logic;
          l     : out std_logic);
  end component;

  signal clk, rst_n, g, l : std_logic;
  signal rc               : std_logic_vector(1 downto 0);
begin


  -------------------------------------------------------------------------------
  -- Component instantiation
  -------------------------------------------------------------------------------

  dut : muneca port map (
    clk   => clk,
    rst_n => rst_n,
    r     => rc(1),
    c     => rc(0),
    g     => g,
    l     => l
    );

  -----------------------------------------------------------------------------
  -- Process declaration
  -----------------------------------------------------------------------------
  -- Input clock
  p_clk : process
  begin
    clk <= '0', '1' after 5 ns;
    wait for 10 ns;
  end process p_clk;

  -- External reset
  p_rst : process
  begin
    rst_n <= '0';
    wait for 250 ns;
    rst_n <= '1';
    wait;
  end process p_rst;

  p_driver : process
    variable v_i : natural := 0;
  begin
    rc <= "00";
    wait for 50 ns;
	 rc <= "10";
	 wait for 200 ns;
	   wait until falling_edge(clk);
      rc <= "00";
		wait until falling_edge(clk);
      rc <= "01";
	   assert g='0'
			report "tranquila -> tranquila"
			severity error;

		wait until falling_edge(clk);
      rc <= "10";
      assert g='0'
			report "tranquila -> dormida"
			severity error;	
		wait until falling_edge(clk);
		assert (g='1' and l='1')
			report "dormida -> asustada"
			severity error;	
      rc <= "00";
		wait until falling_edge(clk);
		assert g='0'
			report "asustada -> tranquila"
			severity error;	
      rc <= "10";
		wait until falling_edge(clk);
		assert g='1' and l='0'
			report "tranquila -> hablando"
			severity error;
		rc <= "01";
		wait until falling_edge(clk);
		assert g='0'
		    report "hablando -> dormida"
			 severity error;
		rc <= "11";
		wait until falling_edge(clk);
		assert (g='1' and l='1')
		    report "dormida -> asustada"
			 severity error;
		rc <= "01";
		wait until falling_edge(clk);
		assert g='0'
		    report "asustada -> dormida"
			 severity error;
		wait;
  end process p_driver;

end beh;
