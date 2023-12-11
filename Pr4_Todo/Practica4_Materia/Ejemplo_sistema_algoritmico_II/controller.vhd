----------------------------------------------------------------------------------
-- company:        UCM
-- engineer:       Oscar Garnica
-- 
-- create date:    10:18:00 12/26/2011 
-- design name: 
-- module name:    controller
-- project name:   Lab 3
-- target devices: 
-- tool versions:  
-- description: 
--
-- dependencies: 
--
-- revision: 
-- revision 0.01 - file created
-- additional comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;


entity controller is
  port(clk      : in  std_logic;        -- Input clock
       reset    : in  std_logic;        -- General reset
       cambio   : in  std_logic;        -- Mode change
       inicio   : in  std_logic;        -- Start of algorithm
       cond     : in  std_logic;        -- Status signal
       desplaza : out std_logic;        -- Control signal 
       carga    : out std_logic;        -- Control signal
       acierto  : out std_logic;        -- External output signal
       );
end controller;

architecture rtl of controller is
  type codestados is (estado_inicial, carga_paralelo, desplaza1, desplaza2, desplaza3, desplaza4, compara, correcto, error);
  signal estado_act, estado_sig : codestados;
begin

  -----------------------------------------------------------------------------
  -- Este proceso implementa tanto la funcion siguiente estado como la funcion
  -- salida de la maquina de estados que implementa el controlador.
  -----------------------------------------------------------------------------
  p_algoritmo : process(cambio, inicio, estado_act)
  begin
    case estado_act is
      -------------------------------------------------------------------------
      -- when estado => 
      -- dar valor a todas las señales que se
      -- modifican alguna vez en el case
      -- +
      -- valor a las salidas
      -- +
      -- condiciones para el cambio de estado
      -------------------------------------------------------------------------

      when estado_inicial =>
        acierto  <= '0';
        desplaza <= '0';
        carga    <= '0';
        if inicio = '0' then
          estado_sig <= estado_inicial;
        else
          if cambio = '1' then
            estado_sig <= carga_paralelo;
          else
            estado_sig <= desplaza1;
          end if;
        end if;

      when carga_paralelo =>
        acierto    <= '0';
        desplaza   <= '0';
        carga      <= '1';
        estado_sig <= estado_inicial;

      when desplaza1 =>
        acierto    <= '0';
        desplaza   <= '1';
        carga      <= '0';
        estado_sig <= desplaza2;

      when desplaza2 =>
        acierto    <= '0';
        desplaza   <= '1';
        carga      <= '0';
        estado_sig <= desplaza3;

      when desplaza3 =>
        acierto    <= '0';
        desplaza   <= '1';
        carga      <= '0';
        estado_sig <= desplaza4;

      when desplaza4 =>
        acierto    <= '0';
        desplaza   <= '1';
        carga      <= '0';
        estado_sig <= compara;

      when compara =>
        acierto  <= '0';
        desplaza <= '0';
        carga    <= '0';
        if clave = clave_introducida then
          estado_sig <= correcto;
        else
          estado_sig <= error;
        end if;

      when correcto =>
        acierto    <= '1';
        desplaza   <= '0';
        carga      <= '0';
        estado_sig <= estado_inicial;

      when error =>
        acierto    <= '0';
        desplaza   <= '0';
        carga      <= '0';
        estado_sig <= estado_inicial;

    end case;
  -- ¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
  -- Prohibido que en este process aparezca en cualquier punto clk'event
  -- Es un proceso combinacional
  -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  end process p_algoritmo;


  -----------------------------------------------------------------------------
  -- purpose: Registro de estado de la Unidad de Control
  -- type   : sequential
  -- inputs : clk, reset
  -- outputs: estado_act (estado actual)
  -----------------------------------------------------------------------------

  estado_reg : process(clk, reset)
  begin
    if reset = '1' then                 -- asynchronous reset (active high)
      estado_act <= estado_inicial;
    elsif rising_edge(clk) then
      estado_act <= estado_sig;
    end if;
  end process estado_reg;

end rtl;
