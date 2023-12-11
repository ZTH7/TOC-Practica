------------------------------------------------------------
-- register with parallel input / parallel output
------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
entity parallel_reg is
port( rst, clk, load: in std_logic;
I: in std_logic_vector(3 downto 0);
O: out std_logic_vector(3 downto 0) );
end parallel_reg;

architecture circuit of parallel_reg is


  component divisor
    port(
      rst        : in  std_logic;         -- asynch reset
      clk_100mhz : in  std_logic;         -- 100 MHz input clock
      clk_1hz    : out std_logic          -- 1 Hz output clock
      );
  end component;
  
  component sumador
    port (
        A : IN   std_logic_vector(3 downto 0);
        B : IN   std_logic_vector(3 downto 0);
        C : OUT  std_logic_vector(3 downto 0)   
    );
  end component;
  
  component restador
    port (
        A : IN   std_logic_vector(3 downto 0);
        B : IN   std_logic_vector(3 downto 0);
        C : OUT  std_logic_vector(3 downto 0)   
    );
  end component;
  
  signal clk_out : std_logic;
  signal div_rst : std_logic;
  signal Sum_In : std_logic_vector(3 downto 0);
  signal Sum_Out : std_logic_vector(3 downto 0);
  signal start : std_logic;
  signal stop : std_logic;
  signal flag : std_logic;
  signal Res_In : std_logic_vector(3 downto 0);
  signal Res_Out : std_logic_vector(3 downto 0);

begin

sum: sumador port map(Sum_Out,"0001",Sum_In);
res: restador port map(Res_Out,"0001",Res_In);

div : divisor port map (
    rst => div_rst,
    clk_100mhZ => clk,
    clk_1hz  => clk_out
    );

process(clk_out)
begin
if rising_edge(clk_out) then
    if rst = '1' then
        O <= "0000";
        Sum_out<="0000";
        Res_out<="0000";
        --stop<='0';
        --start<='1';
        --flag<='0';
    elsif stop = '1' then

    elsif start = '1' then

        if flag = '0' then
            O <= Sum_In;
            Sum_out<=Sum_In;
            Res_out<=Sum_In;
        elsif flag = '1' then
            O <= Res_In;
            Res_out<=Res_In;
            Sum_out<=Res_In;
        end if;

    end if;

end if;
end process;
end circuit;