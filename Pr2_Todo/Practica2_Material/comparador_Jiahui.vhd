library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
USE IEEE.std_logic_unsigned.ALL;

entity comparador is
    port(
        a, b: IN std_logic_vector(7 downto 0);
        c : OUT std_logic
    );
end comparador;

architecture Behavioral of comparador is
begin    
    process (a,b) 
    begin
        if a = b then
            c <= '1';
        else
            c <= '0';
        end if; 
    end process;
    
        
    

end Behavioral;
