----------------------------------------------------------------------------------
-- Company:        Universidad Complutense de Madrid
-- Engineer:       
-- 
-- Create Date:    
-- Design Name:    Practica 1b
-- Module Name:    tb_registro_siso - rtl 
-- Project Name:   Practica 1b
-- Target Devices: Spartan-3 
-- Tool versions:  ISE 14.1
-- Description:    Testbench registro SISO 
-- Dependencies: 
-- Revision: 
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;


entity tb_registro_siso is
end tb_registro_siso;

architecture beh of tb_registro_siso is

-- declaracion del componente que vamos a simular

  component registro_siso
    port(
      rst : in  std_logic;
      clk : in  std_logic;
      es  : in  std_logic;
      ss  : out std_logic
      );
  end component;

--entradas
  signal rst : std_logic;
  signal clk : std_logic;
  signal es  : std_logic;

--salidas
  signal ss : std_logic;

--se define el periodo de reloj 
  constant clk_period : time := 50 ns;

begin

  -- instanciacion de la unidad a simular 

  uut : registro_siso port map (
    rst => rst,
    clk => clk,
    es  => es,
    ss  => ss
    );

  -- definicion del process de reloj
  p_reloj : process
  begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
  end process;


  --proceso de estimulos
  p_stim : process
  begin
    -- se mantiene el rst activado durante 50 ns.
    rst <= '1';
    es  <= '0';
    wait for 50 ns;
    rst <= '0';
    es  <= '0';
    wait for 50 ns;
    rst <= '0';
    es  <= '1';
    wait for 50 ns;
    rst <= '0';
    es  <= '0';
    wait for 50 ns;
    rst <= '0';
    es  <= '1';
    wait for 50 ns;
    rst <= '0';
    es  <= '1';
    wait for 50 ns;
    rst <= '0';
    es  <= '0';
    wait for 50 ns;
    rst <= '0';
    es  <= '1';
    wait for 50 ns;
    rst <= '0';
    es  <= '1';
    wait for 50 ns;
    rst <= '0';
    es  <= '0';
    wait for 50 ns;
    rst <= '0';
    es  <= '0';
    wait;
  end process;

end beh;
