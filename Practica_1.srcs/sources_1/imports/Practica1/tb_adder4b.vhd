----------------------------------------------------------------------------------
-- Company:        Universidad Complutense de Madrid
-- Engineer:       
-- 
-- Create Date:    
-- Design Name:    Practica 1a
-- Module Name:    tb_sumador - beh
-- Project Name:   Practica 1a
-- Target Devices: Spartan-3 
-- Tool versions: 
-- Description:    Testbench del sumador de 4 bits sin carry de salida 
-- Dependencies: 
-- Revision: 
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

-------------------------------------------------------------------------------
-- Entidad
-------------------------------------------------------------------------------
entity tb_sumador is
end tb_sumador;

-------------------------------------------------------------------------------
-- Arquitectura
-------------------------------------------------------------------------------

architecture beh of tb_sumador is

-- Declaracion del componente que vamos a simular
  component adder4b
    port(
      a : in  std_logic_vector(3 downto 0);
      b : in  std_logic_vector(3 downto 0);
      c : out std_logic_vector(3 downto 0)
      );
  end component;

-- Entradas
  signal a : std_logic_vector(3 downto 0) := (others => '0');
  signal b : std_logic_vector(3 downto 0) := (others => '0');

-- Salidas
  signal c : std_logic_vector(3 downto 0);
  signal d : std_logic_vector(3 downto 0);
  

begin

-- Instanciacion de la unidad a simular 
  dut : adder4b port map (
    a => a,
    b => b,
    c => c
    );

-- Proceso de estimulos
  p_stim : process
    variable v_i : natural := 0;
    variable v_j : natural := 0;
  begin
    i_loop : for v_i in 0 to 15 loop
      j_loop : for v_j in 0 to 15 loop
        a <= std_logic_vector(to_unsigned(v_i, 4));
        b <= std_logic_vector(to_unsigned(v_j, 4));
        d <= std_logic_vector(to_unsigned(v_i,4)+to_unsigned(v_j,4));
        wait for 10 ns;
        assert c = d
          report "Error: suma incorrecta"
          severity error;
        wait for 10 ns;
      end loop j_loop;
    end loop i_loop;
    wait;
  end process p_stim;

end beh;
