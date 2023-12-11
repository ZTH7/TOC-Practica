library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maquina is
    port(rst : in std_logic;
        clk : in std_logic;
        ini : in std_logic;
        fin : in std_logic;
        write : in std_logic;
        sw : in std_logic_vector(7 downto 0);
        display : out std_logic_vector(6 downto 0);
        display_enable : out std_logic_vector(3 downto 0);
        led : out std_logic_vector(9 downto 0));
end maquina;

architecture behavioral of maquina is
    component unidadControl
        port(clk : in std_logic;
             rst : in std_logic;
             ini : in std_logic;
             fin : in std_logic;
             write : in std_logic;
             ctrl :out std_logic_vector (7 downto 0);
             status : in std_logic_vector (1 downto 0));
    end component;
 
    component caminoDatos
        port(clk : in std_logic;
             rst : in std_logic;
             datos : in std_logic_vector(7 downto 0);
             A_out : out std_logic_vector(3 downto 0);
             B_out : out std_logic_vector(3 downto 0);
             ctrl : in std_logic_vector(7 downto 0);
             status : out std_logic_vector(1 downto 0);
             leds: out std_logic_vector(9 downto 0));
    end component;
 
    component debouncer is
        port(rst: in  std_logic;
             clk: in  std_logic;
             x: in  std_logic;
             xdeb: out std_logic;
             xdebfallingedge: out std_logic;
             xdebrisingedge: out std_logic);
    end component;
 
    component displays is
        port(rst: in STD_LOGIC;
             clk: in STD_LOGIC;       
             digito_0: in  STD_LOGIC_VECTOR (3 downto 0);
             digito_1: in  STD_LOGIC_VECTOR (3 downto 0);
             digito_2: in  STD_LOGIC_VECTOR (3 downto 0);
             digito_3: in  STD_LOGIC_VECTOR (3 downto 0);
             display: out  STD_LOGIC_VECTOR (6 downto 0);
             display_enable: out  STD_LOGIC_VECTOR (3 downto 0));
    end component;
 
    signal button_rst, button_ini, button_fin, button_write : std_logic;
    signal A_out, B_out : std_logic_vector(3 downto 0);
    signal ctrl : std_logic_vector (7 downto 0);
    signal status : std_logic_vector (1 downto 0);
begin
    deb_rst : debouncer port map('1', clk, rst, button_rst);      
    deb_ini : debouncer port map('1', clk, ini, button_ini);
    deb_fin : debouncer port map('1', clk, fin, button_fin);
    deb_write : debouncer port map('1', clk, write, button_write);
  
    cd: caminoDatos port map(clk, button_rst, sw, A_out, B_out, ctrl, status, led);

    uc: unidadControl port map(clk, button_rst, button_ini, button_fin, write, ctrl, status);

    dsp: displays port map(button_rst, clk, A_out, B_out, "0000", "0000", display, display_enable);

end architecture behavioral;