library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity caminoDatos is
	port(clk : in std_logic;
	     rst : in std_logic;
	     datos : in std_logic_vector(7 downto 0);
	     A_out : out std_logic_vector(3 downto 0);
	     B_out : out std_logic_vector(3 downto 0);
	     ctrl : in std_logic_vector(7 downto 0);
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
 
    component blk_mem_gen_A
        port (clka : IN STD_LOGIC;
              ena : IN STD_LOGIC;
              wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
              addra : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
              dina : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
              douta : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
    end component;
    
    component blk_mem_gen_B
        port (clka : IN STD_LOGIC;
              ena : IN STD_LOGIC;
              wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
              addra : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
              dina : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
              douta : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
    end component;
 
	signal lose, waiting, win : std_logic_vector(9 downto 0);
	signal write_A, write_B, dir_a, dir_b, cont_a, cont_b, cont_n, dsp_a_ram, dsp_b_ram : std_logic_vector(3 downto 0);
    signal writeable, cont_rst, cont_enable, seq_rst, seq_enable, mux_A, mux_B, rst_wait, clk_led, clk_a, clk_b : std_logic;
    signal wea : std_logic_vector(0 downto 0);
 
	begin
	(cont_rst, cont_enable, seq_rst, seq_enable, mux_A, mux_B, rst_wait, writeable) <= ctrl;
	A_out <= cont_a;
	B_out <= cont_b;
	write_A <= datos(3 downto 0);
	write_B <= datos(7 downto 4);
	wea <= (0 => writeable, others => '0');
 
    div: divisor port map(rst, clk, clk_led, clk_a, clk_b);
 
 	contadorA : contador port map(cont_rst, clk_a, cont_enable, dir_a);
	contadorB : contador port map(cont_rst, clk_b, cont_enable, dir_b);
    BRAM_A : blk_mem_gen_A PORT MAP (clk, '1', wea, dir_a, write_A, cont_a);
    BRAM_B : blk_mem_gen_B PORT MAP (clk, '1', wea, dir_b, write_B, cont_b);
    
	contadorN : contador port map(seq_rst, clk_led, seq_enable, cont_n);
 
	end_waiting : process (cont_n)
	begin 
		if cont_n = "0001" then status(0) <= '1';
	  	else status(0) <= '0';
	  	end if;
	end process;
 
 	if_win : process (cont_a, cont_b)
 	begin 
  		if cont_a = cont_b then status(1) <= '1';
  		else status(1) <= '0';
  		end if;
 	end process;
 
    lose_p : process(seq_rst, clk_led, lose) begin
	   if seq_rst = '1' then lose <= (others => '0');
	   elsif rising_edge(clk_led) then 
		  if lose = "0101010101" then lose <= "1010101010";
		  else lose <= "0101010101"; end if; end if;
	end process;
	
	win_p : process(seq_rst, clk_led, win) begin
	   if seq_rst = '1' then win <= (others => '0');
	   elsif rising_edge(clk_led) then 
		  if win = "0000000000" then win <= "1111111111";
		  else win <= "0000000000"; end if; end if;
	end process;
	
	wait_p : process(rst_wait, clk_led, waiting) begin
	   if rst_wait = '1' then waiting <= (others => '0');
  	   elsif rising_edge(clk_led) then 
   		   if waiting(0) = '1' then
			    waiting(8 downto 0) <= waiting(9 downto 1);
				waiting(9) <= '0';
   		   else
				waiting(8 downto 0) <= waiting(9 downto 1);
				waiting(9) <= '1';
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