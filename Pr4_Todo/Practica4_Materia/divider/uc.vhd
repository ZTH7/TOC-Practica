----------------------------------------------------------------------------------
-- Company:        Universidad Complutense de Madrid
-- Engineer:       TOC&TC
-- 
-- Create Date:    
-- Design Name:    Divisor secuencial
-- Module Name:    unidad de control - rtl 
-- Project Name:   Practica 5
-- Target Devices: Spartan-3 
-- Tool versions:  ISE 14.1
-- Description:    Unidad de control del divisor secuencial de numeros de 8 bits.
-- Dependencies: 
-- Revision: 
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is
  port (
    clk    : in  std_logic;                      -- clock
    rst_n  : in  std_logic;                      -- reset
    ini    : in  std_logic;                      -- External control signal
    fin    : out std_logic;                      -- External control signal
    ctrl   : out std_logic_vector(9 downto 0);   -- Control vector
    status : in  std_logic_vector(1 downto 0));  -- Status vector
end entity uc;

architecture rtl of uc is
  type t_st is (s0, s1, s2, s3, s4, s5, s6);
  signal current_state, next_state : t_st;
  signal zero, msb                 : std_logic;
begin

  -----------------------------------------------------------------------------
  -- Internamente no trabajo con las componentes del vector status sino que
  -- damos nombre a cada una de las componentes y trabajamos con ellas por
  -- separado. De esta forma es mucho más legible el codigo obtenido. Luego
  -- la componente status(0) la asigno a la senal zero y la componente
  -- status(1) la asigna la senal msb.
  -----------------------------------------------------------------------------
  p_status_signals : (msb, zero) <= status;

  -----------------------------------------------------------------------------
  -- Proceso estado siguiente.
  -----------------------------------------------------------------------------
  p_next_state : process (current_state, ini, msb, zero) is
  begin  -- process p_next_state
    case current_state is
      when s0 =>
        if ini = '1' then
          next_state <= s1;
        else
          next_state <= s0;
        end if;
      when s1 =>
      -- Completar
      when s2 =>
      -- Completar        
      when s3 =>
        if msb = '1' then
          next_state <= s4;
        else
          next_state <= s5;
        end if;
      when s4 =>
      -- Completar
      when s5 =>
      -- Completar
      when s6 =>
      -- Completar
      when others => null;
    end case;
  end process p_next_state;

  p_outputs : process (current_state)
    ---------------------------------------------------------------------------
    -- Definición de cada uno de las senales de control
    -- mux -----------------------------------------------------------¡
    -- coc_sh -------------------------------------------------------¡¡
    -- coc_ld ------------------------------------------------------¡¡¡
    -- dndo_ld ----------------------------------------------------vvvv
    constant c_mux        : std_logic_vector(9 downto 0) := "0000000001";
    constant c_coc_sh     : std_logic_vector(9 downto 0) := "0000000010";
    constant c_coc_ld     : std_logic_vector(9 downto 0) := "0000000100";
    constant c_dndo_ld    : std_logic_vector(9 downto 0) := "0000001000";
    constant c_dsor_sh    : std_logic_vector(9 downto 0) := "0000010000";
    constant c_dsor_ld    : std_logic_vector(9 downto 0) := "0000100000";
    constant c_cntr_cu    : std_logic_vector(9 downto 0) := "0001000000";
    constant c_cntr_ld    : std_logic_vector(9 downto 0) := "0010000000";
    constant c_cntr_d1_ld : std_logic_vector(9 downto 0) := "0100000000";
    constant c_add_sub    : std_logic_vector(9 downto 0) := "1000000000";

  begin
    ctrl <= (others => '0');
    case current_state is
      when s0 =>
        ctrl <= (others => '0');
        fin  <= '1';
      when s1 =>
        -----------------------------------------------------------------------
        -- Se hace la OR logica de todas las constantes asociadas a las senales
        -- de control que se deben activar en el estado S1.
        -----------------------------------------------------------------------
        ctrl <= c_dndo_ld or
                c_dsor_ld or
                c_coc_ld or
                c_cntr_ld;
        fin <= '0';
      when s2 =>
      -- Completar
      when s3 =>
      -- Completar
      when s4 =>
      -- Completar
      when s5 =>
      -- Completar
      when s6 =>
      -- Completar
      when others => null;
    end case;
  end process p_outputs;

  p_status_reg : process (clk, rst_n) is
  begin
    if rst_n = '0' then
      current_state <= s0;
    elsif rising_edge(clk) then
      current_state <= next_state;
    end if;
  end process p_status_reg;

end architecture rtl;
