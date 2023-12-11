library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unidadControl is
	port(clk: in std_logic;
		 rst: in std_logic;
		 ini : in std_logic;
		 fin : in std_logic;
		 ctrl:out std_logic_vector (6 downto 0);
		 status : in std_logic_vector(1 downto 0));
end unidadControl;

architecture behavioral of unidadControl is
 	type states is (waiting, looping, win, lose);
    signal gameWin, endWaiting : std_logic;
	signal current_state, next_state: states;
begin
    (gameWin, endWaiting) <= status;
	process (clk,rst)
	begin
		if rst = '1' then 
			current_state <= waiting;
	   	elsif rising_edge(clk) then 
			current_state <= next_state;
	   	end if;
	end process;
	  
	process(ini,fin,gameWin,endWaiting,current_state)
	begin
		case current_state is
			when waiting => 
			 	if ini='1' then next_state <= looping;
			 	else next_state <= waiting;
			 	end if;	 
			when looping =>
				if fin = '1' then 
			 		if gameWin = '1' then next_state <= win;
			 		else next_state <= lose;
			 		end if;
				else next_state <= looping;
				end if;	
		   	when win =>
				if endWaiting = '1' then next_state <= waiting;
				else next_state <= win;
				end if;				
			when lose =>
				if endWaiting = '1' then next_state <= waiting;
				else next_state <= lose;
				end if;
		end case;
	end process;

	process(current_state)
		constant cont_rst : std_logic_vector(6 downto 0) := "1000000";
        constant cont_enable : std_logic_vector(6 downto 0) := "0100000";
        constant seq_rst : std_logic_vector(6 downto 0) := "0010000";
        constant seq_enable : std_logic_vector(6 downto 0) := "0001000";
        constant mux_leds_a : std_logic_vector(6 downto 0) := "0000100";
        constant mux_leds_b : std_logic_vector(6 downto 0) := "0000010";
        constant att_rst : std_logic_vector(6 downto 0) := "0000001";
	begin 
	    ctrl <= (others => '0');
		case current_state is
			when waiting => 
				ctrl <= cont_rst or seq_rst or mux_leds_a;
		   	when looping =>
				ctrl <= cont_enable or seq_rst or att_rst;
		   	when win => 
				ctrl <= seq_enable or mux_leds_a or mux_leds_b or att_rst;
		   	when lose => 
				ctrl <= seq_enable or mux_leds_b or att_rst;
		end case;
	end process;
	
end behavioral;