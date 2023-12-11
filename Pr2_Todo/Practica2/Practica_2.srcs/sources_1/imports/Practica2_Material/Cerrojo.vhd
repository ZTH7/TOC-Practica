
----------------------------------------------------------------------------------
--                                  Cerrojo                                     --
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity cerrojo is
    generic (k : integer := 4;
             n : integer := 8);
  -- k < 2**n
    port (rst  : in  std_logic;
          clk  : in  std_logic;
          load : in  std_logic;
          enter: in  std_logic;
          pwd  : in std_logic_vector(n-1 downto 0);
          led  : out std_logic_vector(n-1 downto 0);
          seg  : out std_logic_vector (6 downto 0));
end cerrojo;


architecture rtl of cerrojo is
  
  signal chance : std_logic_vector(k-1 downto 0);
  signal pwd_correct : unsigned(n-1 downto 0);
  signal pwd_entered : unsigned(n-1 downto 0);
  signal xDeb : std_logic;
  signal xDebFallingEdge : std_logic;
  signal xDebRisingEdge : std_logic;
  
  --signal seg : std_logic_vector (6 downto 0);

  component conv_7seg is
    port (x       : in  std_logic_vector (3 downto 0);
          display : out std_logic_vector (6 downto 0));
  end component;
  
  component debouncer is
    port (
        rst             : in  std_logic;
        clk             : in  std_logic;
        x               : in  std_logic;
        xDeb            : out std_logic;
        xDebFallingEdge : out std_logic;
        xDebRisingEdge  : out std_logic
      );
  end component debouncer;

  begin
  
    conv : conv_7seg port map(chance,seg);
    debo : debouncer port map(rst, clk, enter, xDeb, xDebFallingEdge, xDebRisingEdge);
  
    checkPwd : process(clk, rst)
    begin
      if rst = '1' then
        pwd_correct <= (others => '0');
        led <= "00000000";
        chance<="0000";
      elsif rising_edge(clk) then
        if load = '1' then
          pwd_correct <= unsigned(pwd);
          chance<="0011";
        elsif xDebFallingEdge = '1' then
          if chance > "0000" then
            --pwd_entered<= unsigned(pwd);

            if pwd_correct = unsigned(pwd) then
              led<="11111111";
            else 
              led<="00000000";
              chance<=std_logic_vector(unsigned(chance)-1);
            end if;

          end if;
          
        end if;

      end if;
    end process checkPwd;
  
  end rtl;
