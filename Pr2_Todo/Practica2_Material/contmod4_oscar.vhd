----------------------------------------------------------------------------------
-- Company:        UCM
-- Engineer:       Oscar Garnica
-- 
-- Create Date:    11:07:57 10/22/2012 
-- Design Name:    counter
-- Module Name:    rtl 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity cntr is
  generic (k : integer := 4;            -- Module value
           n : integer := 2);           -- Counter width
-- k < 2**n
  port (rst  : in  std_logic;           -- Asynch reset
        clk  : in  std_logic;           -- Input clock
        cntr : out std_logic_vector(n-1 downto 0));
end cntr;

architecture rtl of cntr is
  signal cntr_reg : unsigned(n-1 downto 0);
begin

  cntr <= std_logic_vector(cntr_reg);

  p_cntr_reg : process(clk, rst)
  begin
    if rst = '1' then
      cntr_reg <= (others => '0');
    elsif rising_edge(clk) then
      if cntr_reg < (k-1) then
        cntr_reg <= cntr_reg+1;
      else
        cntr_reg <= (others => '0');
      end if;
    end if;
  end process p_cntr_reg;

end rtl;

