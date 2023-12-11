library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity caminoDatos is
	port(clk : in std_logic;
	     rst : in std_logic;
	     A_out : out std_logic_vector(3 downto 0);
	     B_out : out std_logic_vector(3 downto 0);
	     ctrl : in std_logic_vector(6 downto 0);
	     status : out std_logic_vector(1 downto 0);
	     leds: out std_logic_vector(9 downto 0));
end caminoDatos;

architecture behavioral of caminoDatos is
    component divisor 
        port(rst : in std_logic;
             clk_entrada : in std_logic;
             clk_salida : out std_logic;
             clk_salida_a : out std_logic; 
             clk_salida_b : out std_logic);
    end component;
 
 	component contador
  		port(rst: in std_logic;
		     clk: in std_logic;
		     enable : in std_logic;
		     output : out std_logic_vector(3 downto 0));
 	end component;
 
 	component conv_7seg
  		port (x: in std_logic_vector (3 downto 0);
  			  display : out std_logic_vector (6 downto 0));
 	end component;
 
	signal lose, waiting, win : std_logic_vector(9 downto 0);
	signal cont_a, cont_b, cont_n, dsp_a_ram, dsp_b_ram : std_logic_vector(3 downto 0);
    signal cont_rst, cont_enable, seq_rst, seq_enable, mux_A, mux_B, rst_wait, clk_1hleds, clk_a, clk_b : std_logic;
 
	begin
	(cont_rst, cont_enable, seq_rst, seq_enable, mux_A, mux_B, rst_wait) <= ctrl;
	A_out <= cont_a;
	B_out <= cont_b;
 
    div: divisor port map(rst, clk, clk_1hleds, clk_a, clk_b);
 
 	contadorA : contador port map(cont_rst, clk_a, cont_enable, cont_a);
 
	contadorB : contador port map(cont_rst, clk_b, cont_enable, cont_b);
	 
	contadorN : contador port map(seq_rst, clk_1hleds, seq_enable, cont_n);
 
	end_waiting : process (cont_n)
	begin 
		if cont_n = "1001" then status(0) <= '1';
	  	else status(0) <= '0';
	  	end if;
	end process;
 
 	if_win : process (cont_a, cont_b)
 	begin 
  		if cont_a = cont_b then status(1) <= '1';
  		else status(1) <= '0';
  		end if;
 	end process;
 
    lose_p : process(seq_rst, clk_1hleds, lose) begin
	   if seq_rst = '1' then lose <= (others => '0');
	   elsif rising_edge(clk_1hleds) then 
		  if lose = "0101010101" then lose <= "1010101010";
		  else lose <= "0101010101"; end if; end if;
	end process;
	
	win_p : process(seq_rst, clk_1hleds, win) begin
	   if seq_rst = '1' then win <= (others => '0');
	   elsif rising_edge(clk_1hleds) then 
		  if win = "0000000000" then win <= "1111111111";
		  else win <= "0000000000"; end if; end if;
	end process;
	
	wait_p : process(rst_wait, clk_1hleds, waiting) begin
	   if rst_wait = '1' then waiting <= (others => '0');
  	   elsif rising_edge(clk_1hleds) then 
   		   if waiting(9) = '1' then
			    waiting(9 downto 1) <= waiting(8 downto 0);
				waiting(0) <= '0';
   		   else
				waiting(9 downto 1) <= waiting(8 downto 0);
				waiting(0) <= '1';
   		   end if;
 	   end if;
	end process;
 
 	process(win, lose, waiting, mux_A, mux_B)
  	begin
   		if mux_B = '0' and mux_A = '0' then leds <= "0000000000";
   		elsif mux_B = '1' and mux_A = '1' then leds <= win;
   		elsif mux_B = '1' and mux_A = '0' then leds <= lose;
   		else leds <= waiting; end if;
 	end process; 
 	
end architecture behavioral;