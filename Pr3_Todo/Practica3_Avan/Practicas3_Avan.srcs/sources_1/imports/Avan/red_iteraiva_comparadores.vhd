library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity red_iteraiva_comparadores is
generic ( 
            num_bits     : natural := 4;
            num_entradas : natural := 4
        );
        port(
            X : in  std_logic_vector (num_entradas*num_bits-1 downto 0);
            G : out std_logic_vector (num_entradas-2 downto 0);
            S : out std_logic_vector (num_bits-1 downto 0)
        );
end red_iteraiva_comparadores;

architecture Behavioral of red_iteraiva_comparadores is
    type aux_type is array (num_entradas-1 downto 0) of std_logic_vector(num_bits-1 downto 0);
    signal aux : aux_type;
    
    COMPONENT comparador IS
        generic(num_bits : natural := 4);
        PORT (
            a, b : IN std_logic_vector(num_bits-1 DOWNTO 0);
            c : OUT std_logic_vector(num_bits-1 downto 0));
    END COMPONENT;
begin
    aux(0) <= X(num_bits-1 downto 0);
    
    gen_comparadores : for i in 0 to num_entradas-2 generate
        comparador_i : comparador
            generic map(num_bits)
            port map(aux(i), X((i+2)*num_bits-1 downto (i+1)*num_bits), aux(i+1));
    end generate gen_comparadores;
        
    S <= aux(num_entradas-1);
end Behavioral;
