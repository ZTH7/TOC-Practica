
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;


entity comparador_lubin is
    Port ( a : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           b : in STD_LOGIC_VECTOR (7 DOWNTO 0);
           c : out STD_LOGIC);
end comparador_lubin;

architecture Behavioral of comparador_lubin is

begin
comp : process(a,b) is
begin
    if a = b then 
    c <= '1';
    else 
    c <= '0';
    end if;
end process comp;

end Behavioral;
