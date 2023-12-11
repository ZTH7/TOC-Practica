------------------------------------------------------------
-- register with parallel input / parallel output
------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY parallel_reg IS
    generic(num_bits : natural := 4);
    PORT (
        rst, clk : IN STD_LOGIC;
        I : IN STD_LOGIC_VECTOR(num_bits-1 DOWNTO 0);
        O : OUT STD_LOGIC_VECTOR(num_bits-1 DOWNTO 0));
END parallel_reg;

ARCHITECTURE circuit OF parallel_reg IS
BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF rst = '1' THEN
                O <= (others => '0');
            ELSE
                O <= I;
            END IF;
        END IF;
    END PROCESS;
END circuit;