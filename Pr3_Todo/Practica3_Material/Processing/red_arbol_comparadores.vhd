----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.10.2022 14:22:53
-- Design Name: 
-- Module Name: red_arbol_comparadores - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
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
    
  signal aux : std_logic_vector (num_entradas*num_bits-1 downto 0);
  COMPONENT comparador IS
    generic(num_bits : natural := 4);
    PORT (
      a, b : IN STD_LOGIC_VECTOR(num_bits-1 DOWNTO 0);
      c : OUT STD_LOGIC_VECTOR(num_bits-1 downto 0)
    );
  END COMPONENT;
  
begin
    aux <= X;
    gen_niveles : for i in 0 to Log2(num_entradas)-1 generate
        gen_comparadores : for j in 0 to (num_entradas / (2**(i+1)))-1 generate
            comparador_i : comparador
                generic map(num_bits)
                port map(aux((i+2*j+1)*num_bits-1 downto (i+2*j)*num_bits),aux((i+2*j+2)*num_bits-1 downto (i+2*j+1)*num_bits),aux((i+j+1)*num_bits-1 downto (i+j)*num_bits));
            end generate gen_comparadores;
        end generate gen_niveles;
    S <= aux(num_bits-1 downto 0);
end Behavioral;
