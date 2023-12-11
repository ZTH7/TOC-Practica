LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY comparador IS
    generic(num_bits : natural := 4);
    PORT (
        a, b : IN signed(num_bits-1 DOWNTO 0);
        c : OUT signed(num_bits-1 DOWNTO 0)
    );
END comparador;

ARCHITECTURE Behavioral OF comparador IS
BEGIN
    c <= a when a > b else b;
END Behavioral;