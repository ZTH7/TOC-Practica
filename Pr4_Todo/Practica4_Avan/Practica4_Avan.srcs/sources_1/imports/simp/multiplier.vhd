library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity multiplier is
    generic (num_bits : natural := 4);
    port (
        clk : in std_logic;
        rst : in std_logic;
        start : in std_logic;
        sw : in std_logic_vector(2*num_bits-1 downto 0);
        led : out std_logic_vector(15 downto 0);
        display : out std_logic_vector(6 downto 0);
        display_enable : out std_logic_vector(3 downto 0));
end entity multiplier;

architecture rtl of multiplier is
    component debouncer
        port (
            rst : in std_logic;
            clk : in std_logic;
            x : in std_logic;
            xDeb : out std_logic;
            xDebFallingEdge : out std_logic;
            xDebRisingEdge : out std_logic);
    end component;

    component multiplicador
        generic (num_bits : natural := 4);
        port (
            clk : in std_logic;
            rst : in std_logic;
            start : in std_logic;
            A : in std_logic_vector(num_bits-1 downto 0);
            B : in std_logic_vector(num_bits-1 downto 0);
            result : out std_logic_vector(15 downto 0);
            done : out std_logic);
    end component;

    component displays
        port (
            rst : in STD_LOGIC;
            clk : in STD_LOGIC;       
            digito_0 : in  STD_LOGIC_VECTOR (3 downto 0);
            digito_1 : in  STD_LOGIC_VECTOR (3 downto 0);
            digito_2 : in  STD_LOGIC_VECTOR (3 downto 0);
            digito_3 : in  STD_LOGIC_VECTOR (3 downto 0);
            display : out  STD_LOGIC_VECTOR (6 downto 0);
            display_enable : out  STD_LOGIC_VECTOR (3 downto 0));
    end component;
    signal A, B : std_logic_vector(num_bits-1 downto 0);
    signal ini, done : std_logic;
    signal S : std_logic_vector(15 downto 0);
begin
    A <= sw(num_bits-1 downto 0);
    B <= sw(2*num_bits-1 downto num_bits);

    deb : debouncer port map (rst, clk, start, open, ini);
    mult : multiplicador generic map(num_bits) port map (clk, rst, ini, A, B, S, done);
    disply : displays port map (rst, clk, S(15 downto 12), S(11 downto 8), S(7 downto 4), S(3 downto 0), display, display_enable);
    
    led <= (others => done);
end architecture rtl;