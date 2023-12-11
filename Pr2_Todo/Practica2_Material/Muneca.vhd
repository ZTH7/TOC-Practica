
----------------------------------------------------------------------------------
--                                  muneca                                     --
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity muneca is
    port (clk : in std_logic;
    rst_n : in std_logic;
    r : in std_logic;
    c : in std_logic;
    g : out std_logic;
    l : out std_logic);
    end muneca;


architecture rtl of muneca is
  
    type state is (tranquila , habla , dormida , asustada);
    signal current_state , next_state : t_state;

  begin
  
    
  
    runstates : process(clk, rst)
    begin
      if rst = '1' then
        r<='0';
        c<='0';
        g<='0';
        l<='0';
        state<=tranquila;
        
      elsif rising_edge(clk) then
        







        case state is
            when tranquila =>
                g<='0';
            when habla =>
                g<='1';
                l<='0';
            when dormida =>
                g<='0';
            when asustada =>
                g<='1';
                l<='1';
        end case;


      end if;
    end process runstates;
  
  end rtl;
