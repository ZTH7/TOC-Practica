------------------------------------------------------------
-- register with parallel input / parallel output
------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY parallel_reg IS
    PORT (
        rst, clk, load : IN STD_LOGIC;
        I : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        O : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END parallel_reg;

ARCHITECTURE circuit OF parallel_reg IS
BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF rst = '1' THEN
                O <= "0000";
            ELSIF load = '1' THEN
                O <= I;
            END IF;
        END IF;
    END PROCESS;
END circuit;