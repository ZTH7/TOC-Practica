library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplicador is
    generic (num_bits : natural := 4);
    port (
        clk : in std_logic;
        rst : in std_logic;
        start : in std_logic;
        A : in std_logic_vector(num_bits-1 downto 0);
        B : in std_logic_vector(num_bits-1 downto 0);
        result : out std_logic_vector(15 downto 0);
        done : out std_logic);
end entity multiplicador;

architecture struct of multiplicador is 
    component caminoDatos
        generic (num_bits : natural := 4);
        port (
            clk : in std_logic;
            rst : in std_logic;
            A_in : in std_logic_vector(num_bits-1 downto 0);
            B_in : in std_logic_vector(num_bits-1 downto 0);
            result : out std_logic_vector(15 downto 0);
            ctrl : in std_logic_vector(7 downto 0);
            status : out std_logic_vector(3 downto 0));
    end component;

    component unidadControl
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            start : in std_logic;
            done : out std_logic;
            ctrl : out std_logic_vector(7 downto 0);
            status : in std_logic_vector(3 downto 0));
    end component;
    signal ctrl : std_logic_vector(7 downto 0);
    signal status : std_logic_vector(3 downto 0);
begin
    cd : caminoDatos generic map(num_bits) port map (clk, rst, A, B, result, ctrl, status);
    uc : unidadControl port map (clk, rst, start, done, ctrl, status);
end architecture struct;