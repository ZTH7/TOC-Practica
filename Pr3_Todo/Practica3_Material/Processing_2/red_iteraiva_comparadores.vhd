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
  signal max : signed(num_bits-1 downto 0);
  COMPONENT comparador IS
    generic(num_bits : natural := 4);
    PORT (
      a, b : IN signed(num_bits-1 DOWNTO 0);
      c : OUT signed(num_bits-1 downto 0)
    );
  END COMPONENT;
begin
    max <= signed(X(num_bits-1 downto 0));
    gen_comparadores : for i in 2 to num_entradas-1 generate
        comparador_i : comparador
            generic map(num_bits)
            port map(max,signed(X((i+1)*num_bits-1 downto i*num_bits)),max);
        end generate gen_comparadores;
    S <= std_logic_vector(max);
end Behavioral;