----------------------------------------------------------------------------------
-- company:        UCM
-- engineer:       Oscar Garnica
-- 
-- create date:    10:18:00 12/26/2011 
-- design name: 
-- module name:    datapath
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


entity datapath is
  port(clk           : in  std_logic;   -- Input clock
       reset         : in  std_logic;   -- General reset
       dato_serie    : in  std_logic;   -- Entrada de dato serie
       dato_paralelo : in  std_logic_vector(3 downto 0);  -- Input golden keyword
       desplaza      : in  std_logic;   -- Control signal 
       carga         : in  std_logic;   -- Control signal
       cond          : out              -- Status signal
       );
end datapath;

architecture rtl of datapath is

begin

  -----------------------------------------------------------------------------
  -- purpose: Registro de de clave para almacenar la clave "golden" (PIPO)
  -- type   : sequential
  -- inputs : clk, reset
  -- outputs: clave
  -----------------------------------------------------------------------------
  p_clave_reg : process(clk, reset)
  begin
    if reset = '1' then                 -- asynchronous reset (active high)
      clave <= "0000";
    elsif rising_edge(clk) then
      if carga = '1' then
        clave <= dato_paralelo;
      end if;
    end if;
  end process p_clave_reg;

  -----------------------------------------------------------------------------
  -- purpose: Registro de desplazamiento que almacena la clave a comprobar (SIPO)
  -- type   : sequential
  -- inputs : clk, reset
  -- outputs: estado_act (estado actual)
  -----------------------------------------------------------------------------
  p_desplazador_reg : process(clk, reset)
  begin
    if reset = '1' then                 -- asynchronous reset (active high)
      clave_introducida <= "0000";
    elsif rising_edge(clk) then
      if desplaza = '1' then
        clave_introducida <= dato_serie&clave_introducida(3 downto 1);
      end if;
    end if;
  end process p_desplazador_reg;

  -----------------------------------------------------------------------------
  -- purpose: Este proceso implementa la comparación de los dos datos almacenados
  -- en registros
  -- type   : combinational
  -- inputs : clave, clave_introducida
  -- outputs: cond
  -----------------------------------------------------------------------------
  p_comparison : process (clave, clave_introducida)
  begin  -- process p_comparison
    if clave = clave_introducida then
      cond <= '1';
    else
      cond <= '0';
    end if;
  end process p_comparison;
  
end rtl
