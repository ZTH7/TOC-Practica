library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity red_arbol_comparadores is
generic ( 
            num_bits     : natural := 4;
            num_entradas : natural := 4
        );
        port(
        	rst  : in  std_logic;
            clk  : in  std_logic;
            X : in  std_logic_vector (num_entradas*num_bits-1 downto 0);
            S : out std_logic_vector (num_bits-1 downto 0)
        );
end red_arbol_comparadores;

architecture Behavioral of red_arbol_comparadores is
function Log2(input: integer) return integer is
    variable temp, log:integer;
    begin
        temp := input;
        log := 0;
        while (temp > 1) loop
            temp := temp / 2;
            log := log + 1;
        end loop;
        return log;
    end function Log2;
    
  type aux_type is array (Log2(num_entradas) downto 0, num_entradas-1 downto 0) of std_logic_vector(num_bits-1 downto 0);
  signal aux, aux_reg : aux_type;
  
  COMPONENT comparador IS
    generic(num_bits : natural := 4);
    PORT (
      a, b : IN std_logic_vector(num_bits-1 DOWNTO 0);
      c : OUT std_logic_vector(num_bits-1 downto 0)
    );
  END COMPONENT;
  
  COMPONENT parallel_reg IS
    generic(num_bits : natural := 4);
    PORT (
      rst, clk : IN STD_LOGIC;
      I : IN STD_LOGIC_VECTOR(num_bits-1 DOWNTO 0);
      O : OUT STD_LOGIC_VECTOR(num_bits-1 DOWNTO 0)
    );
  END COMPONENT;
  
begin
    inicial : for i in 0 to num_entradas-1 generate
        aux_reg(0,i) <= X((i+1)*num_bits-1 downto i*num_bits);
    end generate inicial;
    
    gen_niveles : for i in 0 to Log2(num_entradas)-1 generate
        gen_comparadores : for j in 0 to (num_entradas / (2**(i+1)))-1 generate
            comparador_i : comparador
                generic map(num_bits)
                port map(aux_reg(i, 2*j), aux_reg(i, 2*j+1), aux(i+1, j));
                
            reg_i : parallel_reg
                generic map(num_bits)
                port map(rst, clk, aux(i+1, j), aux_reg(i+1, j));
            end generate gen_comparadores;
        end generate gen_niveles;
    S <= aux_reg(Log2(num_entradas), 0);
end Behavioral;
