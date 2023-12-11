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

architecture circuit of tb_registro_pipo is

-- declaracion del componente que vamos a simular

  component parallel_reg
    port(
      rst  : in  std_logic;
      clk  : in  std_logic;
      load : in  std_logic;
      I   : in  std_logic_vector(3 downto 0);
      O   : out std_logic_vector(3 downto 0)
      );
  end component;
  

--entradas
  signal rst  : std_logic;
  signal clk  : std_logic;
  signal I    : std_logic_vector(3 downto 0);
  signal load : std_logic;

--salidas
  signal O : std_logic_vector(3 downto 0);

--se define el periodo de reloj 
  constant clk_period : time := 50 ns;

begin

  -- instanciacion de la unidad a simular 

  dut : parallel_reg port map (
    rst  => rst,
    clk  => clk,
    load => load,
    I   => I,
    O   => O
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
    I    <= (others => '0');
    wait for 50 ns;
    wait until rising_edge(clk);
    rst  <= '0';
    wait until rising_edge(clk);
    load <= '1';
    I   <= (others => '1');
    wait until rising_edge(clk);
    I   <= "1010";
    wait for 10 ns;
    I   <= "1110";
    wait until rising_edge(clk);
    I   <= "0011";
    wait until rising_edge(clk);
    I   <= "1001";
    wait until rising_edge(clk);
    I   <= "1111";
    wait until rising_edge(clk);
    I   <= "0001";
    wait until rising_edge(clk);
    I   <= "1000";
    wait until rising_edge(clk);
    load <= '0';
    I   <= "0000";
    wait until rising_edge(clk);
    I   <= "0110";
    wait;
  end process p_stim;

end circuit;
