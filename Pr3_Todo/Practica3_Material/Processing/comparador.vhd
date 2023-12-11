LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY comparador IS
    generic(num_bits : natural := 4);
    PORT (
        a, b : IN STD_LOGIC_VECTOR(num_bits-1 DOWNTO 0);
        c : OUT STD_LOGIC_VECTOR(num_bits-1 DOWNTO 0)
    );
END comparador;

ARCHITECTURE Behavioral OF comparador IS
BEGIN
    PROCESS (a, b)
    BEGIN
        IF a > b THEN
            c <= a;
        ELSE
            c <= b;
        END IF;
    END PROCESS;
END Behavioral;