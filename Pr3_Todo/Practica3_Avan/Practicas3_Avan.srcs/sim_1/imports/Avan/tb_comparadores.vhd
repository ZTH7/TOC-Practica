----------------------------------------------------------------------------------
library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------
-- Entity
-------------------------------------------------------------------------------
entity tb_comparadores is
end tb_comparadores;

-------------------------------------------------------------------------------
-- Architecture
-------------------------------------------------------------------------------

architecture beh of tb_comparadores is
    -- Component Declaration for the Unit Under Test (UUT)
    
    component red_arbol_comparadores
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
    end component;    

    constant num_bits     : natural := 4;
    constant num_entradas : natural := 16;

    -- Inputs
    signal rst : std_logic;
    signal clk : std_logic;
    signal X : std_logic_vector (num_entradas*num_bits-1 downto 0);
    
    -- Outputs
    signal S_arbol : std_logic_vector (num_bits-1 downto 0);
    
    --Se define el periodo de reloj 
    constant clk_period : time := 20 ns;    

begin

	-- Instantiate the Unit Under Test (UUT)
        
    UUT_a : red_arbol_comparadores
        generic map ( 
            num_bits     => num_bits,
            num_entradas => num_entradas
        )
        port map (
            rst => rst,
            clk => clk,
            X => X,
            S => S_arbol
        );        


    -- Definicion del process de reloj
    reloj_process :process
       begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
    
   -- Stimulus process
    p_stim : process
    begin
        for i in 0 to num_entradas-1 loop
            X((i+1)*num_bits-1 downto i*num_bits) <= std_logic_vector(to_signed(i-(num_entradas/2), num_bits));
        end loop;       
                    
        rst <= '1';
        wait for 45 ns; 
        
        rst <= '0';    
        wait for 200 ns;
        X <= "0000000000000000000000000000000000000000000000000000001100100001";
        wait for 200 ns;
        X <= "0000000000000000000000000000000000000000000000000000010100100001";
        wait for 200 ns;
        X <= "0000000000000000000000000000000000000000000000000000010000100001"; 
        wait for 200 ns;
        X <= "0000000000000000000000000000000000000000000000000000011000100001";                       
        wait;
    end process p_stim;
end beh;
