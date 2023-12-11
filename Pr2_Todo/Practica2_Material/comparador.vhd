LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY comparador IS
    PORT (
        a, b : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        c : OUT STD_LOGIC
    );
END comparador;

ARCHITECTURE Behavioral OF comparador IS
BEGIN
    PROCESS (a, b)
    BEGIN
        IF a = b THEN
            c <= '1';
        ELSE
            c <= '0';
        END IF;
    END PROCESS;
END Behavioral;