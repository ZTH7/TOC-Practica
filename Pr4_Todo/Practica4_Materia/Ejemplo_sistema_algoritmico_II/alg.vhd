----------------------------------------------------------------------------------
-- company:        UCM
-- engineer:       Oscar Garnica
-- 
-- create date:    10:18:00 12/26/2011 
-- design name:    
-- module name:    alg 
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


entity alg is
  port(clk           : in  std_logic;   -- Input clock
       reset         : in  std_logic;   -- General reset
       inicio        : in  std_logic;   -- Start of algorithm
       cambio        : in  std_logic;   -- Mode change
       dato_serie    : in  std_logic;   -- Entrada dato serie
       dato_paralelo : in  std_logic_vector(3 downto 0);  -- Input golden keyword
       acierto       : out std_logic;   -- External output signal
       );
end alg;

architecture structural of alg is
  signal desplaza, carga : std_logic;   -- Control signals
  signal cond            : std_logic;   -- Status signal
begin
  component controller
    port (
      clk      : in  std_logic;         -- Input clock
      reset    : in  std_logic;         -- General reset
      cambio   : in  std_logic;         -- Mode change
      inicio   : in  std_logic;         -- Start of algorithm
      cond     : in  std_logic;         -- Status signal
      desplaza : out std_logic;         -- Control signal 
      carga    : out std_logic;         -- Control signal
      acierto  : out std_logic;         -- External output signal
      );
  end component;

  component datapath
    port (
      clk           : in  std_logic;    -- Input clock
      reset         : in  std_logic;    -- General reset
      dato_serie    : in  std_logic;    -- Entrada de dato serie
      dato_paralelo : in  std_logic_vector(3 downto 0);  -- Input golden keyword
      desplaza      : in  std_logic;    -- Control signal 
      carga         : in  std_logic;    -- Control signal
      cond          : out               -- Status signal
      );
  end component;

  uc : controller port map (
    clk      => clk,                    -- Input clock
    reset    => reset,                  -- General reset
    cambio   => cambio,                 -- Mode change
    inicio   => inicio,                 -- Start of algorithm
    cond     => cond                    -- Status signal
    desplaza => desplaza,               -- Control signal 
    carga    => carga,                  -- Control signal
    acierto  => acierto                 -- External output signal
    );

  dp : datapath port map
    (clk           => clk,              -- Input clock
     reset         => reset,            -- General reset
     dato_serie    => dato_serie,       -- Entrada de dato serie
     dato_paralelo => dato_paralelo,    -- Input golden keyword
     desplaza      => desplaza,         -- Control signal 
     carga         => carga,            -- Control signal
     cond          => cond              -- Status signal
     );

end structural;
