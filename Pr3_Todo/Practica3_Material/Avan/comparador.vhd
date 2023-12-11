LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY comparador IS
    generic(num_bits : natural := 4);
    PORT (
        a, b : IN std_logic_vector(num_bits-1 DOWNTO 0);
        c : OUT std_logic_vector(num_bits-1 DOWNTO 0)
    );
END comparador;

ARCHITECTURE Behavioral OF comparador IS
BEGIN
    c(num_bits-1 DOWNTO 0) <= a(num_bits-1 DOWNTO 0) when signed(a) > signed(b) else b(num_bits-1 DOWNTO 0);
END Behavioral;