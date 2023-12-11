library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity restador is
  Port (
    A : IN   std_logic_vector(3 downto 0);
    B : IN   std_logic_vector(3 downto 0);
    C : OUT  std_logic_vector(3 downto 0)   
  );
end restador;

architecture Behavioral of restador is
signal A_N, B_N, C_N : unsigned(3 downto 0);
begin
  C_N <= unsigned(A) - unsigned(B);
  C <= std_logic_vector(C_N);

end Behavioral;
