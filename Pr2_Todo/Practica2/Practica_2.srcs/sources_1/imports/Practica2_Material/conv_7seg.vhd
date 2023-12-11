library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity conv_7seg is
  port (x       : in  std_logic_vector (3 downto 0);
        display : out std_logic_vector (6 downto 0));
end conv_7seg;

architecture rtl of conv_7seg is

begin

  with x select
    display <= not "0000110" when "0001",
    not "1011011"            when "0010",
    not "1001111"            when "0011",
    not "1100110"            when "0100",
    not "1101101"            when "0101",
    not "1111101"            when "0110",
    not "0000111"            when "0111",
    not "1111111"            when "1000",
    not "1101111"            when "1001",
    not "1110111"            when "1010",
    not "1111100"            when "1011",
    not "0111001"            when "1100",
    not "1011110"            when "1101",
    not "1111001"            when "1110",
    not "1110001"            when "1111",
    not "0111111"            when others;

end rtl;

