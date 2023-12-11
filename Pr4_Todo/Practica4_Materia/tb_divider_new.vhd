----------------------------------------------------------------------------------
-- Company:        Universidad Complutense de Madrid
-- Engineer:       TOC&TC
-- 
-- Create Date:    
-- Design Name:    Divisor secuencial
-- Module Name:    tb_divider - beh 
-- Project Name:   Practica 5
-- Target Devices: Spartan-3 
-- Tool versions:  ISE 14.1
-- Description:    Testbech del divisor secuencial de numeros 8 bits
-- Dependencies: 
-- Revision: 
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity tb_divider is

end tb_divider;

architecture beh of tb_divider is
  component divisor
    port (clk   : in  std_logic;
          rst_n : in  std_logic;
          ini   : in  std_logic;
          fin   : out std_logic;
          dndo  : in  std_logic_vector(7 downto 0);
          dsor  : in  std_logic_vector(7 downto 0);
          coc   : out std_logic_vector(7 downto 0);
          res   : out std_logic_vector(7 downto 0)
          );
  end component;

  constant c_m                     : natural := 3;
  constant c_n                     : natural := 6;
  signal clk, rst_n, inicio, ready : std_logic;
  signal dsor                      : std_logic_vector(7 downto 0);
  signal cociente, dndo            : std_logic_vector(7 downto 0);
  signal resto                     : std_logic_vector(7 downto 0);
begin


  -------------------------------------------------------------------------------
  -- Component instantiation
  -------------------------------------------------------------------------------

  i_dut : divisor
    port map (
      clk   => clk,
      rst_n => rst_n,
      ini   => inicio,
      dsor  => dsor,
      dndo  => dndo,
      coc   => cociente,
      res   => resto,
      fin   => ready
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
    variable v_i, v_j    : natural := 0;
    variable v_calculo   : std_logic_vector(7 downto 0);
    variable v_correctas : natural := 0;

  begin
    inicio <= '0';
    dndo <= (others => '0');
    dsor <= (others => '0');
    wait until rising_edge(rst_n);
    dndo_loop : for v_i in 1 to 255 loop
      dndo <= std_logic_vector(to_unsigned(v_i, 8));
      dsor_loop : for v_j in 1 to v_i loop
        dsor      <= std_logic_vector(to_unsigned(v_j, 8));
        wait until rising_edge(clk);
        inicio    <= '1';
        wait until rising_edge(clk);
        inicio    <= '0';
        wait until ready = '1';
        wait until rising_edge(clk);
        v_calculo := std_logic_vector(unsigned(dndo)/unsigned(dsor));
        assert v_calculo = cociente
          report "Error en la division"
          severity error;
        --   if v_calculo = cociente then
        --     v_correctas := v_correctas +1;
        --   end if;
        wait until rising_edge(clk);
      end loop dsor_loop;
    end loop dndo_loop;
    -- assert false report "Divisiones v_correctas: "& integer'image(v_correctas)
    --   severity note;
    wait;
  end process p_driver;

end beh;
