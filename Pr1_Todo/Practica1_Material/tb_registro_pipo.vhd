----------------------------------------------------------------------------------
-- Company:        Universidad Complutense de Madrid
-- Engineer:       
-- 
-- Create Date:    
-- Design Name:    Practica 1b
-- Module Name:    tb_registro_pipo - rtl 
-- Project Name:   Practica 1b
-- Target Devices: Basys-3 
-- Tool versions:  Vivado 2019.1
-- Description:    Testbench registro PIPO 
-- Dependencies: 
-- Revision: 
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;


entity tb_registro_pipo is
end tb_registro_pipo;

architecture beh of tb_registro_pipo is

-- declaracion del componente que vamos a simular

  component registro_pipo
    port(
      rst  : in  std_logic;
      clk  : in  std_logic;
      load : in  std_logic;
      ep   : in  std_logic_vector(3 downto 0);
      sp   : out std_logic_vector(3 downto 0)
      );
  end component;

--entradas
  signal rst  : std_logic;
  signal clk  : std_logic;
  signal e    : std_logic_vector(3 downto 0);
  signal load : std_logic;

--salidas
  signal s : std_logic;

--se define el periodo de reloj 
  constant clk_period : time := 50 ns;

begin

  -- instanciacion de la unidad a simular 

  dut : registro_pipo port map (
    rst  => rst,
    clk  => clk,
    load => load,
    ep   => e,
    sp   => s
    );

  -- definicion del process de reloj
  p_clk : process
  begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
  end process p_clk;


  --proceso de estimulos
  p_stim : process
  begin
    -- se mantiene el rst activado durante 50 ns.
    rst  <= '1';
    load <= '0';
    e    <= (others => '0');
    wait for 50 ns;
    wait until rising_edge(clk);
    rst  <= '0';
    wait until rising_edge(clk);
    load <= '1';
    es   <= (others => '1');
    wait until rising_edge(clk);
    es   <= "1010";
    wait for 10 ns;
    es   <= "1110";
    wait until rising_edge(clk);
    es   <= "0011";
    wait until rising_edge(clk);
    es   <= "1001";
    wait until rising_edge(clk);
    es   <= "1111";
    wait until rising_edge(clk);
    es   <= "0001";
    wait until rising_edge(clk);
    es   <= "1000";
    wait until rising_edge(clk);
    load <= '0';
    es   <= "0000";
    wait until rising_edge(clk);
    es   <= "0110";
    wait;
  end process p_stim;

end beh;
