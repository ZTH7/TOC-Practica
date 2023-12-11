library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity caminoDatos is
    generic (num_bits : natural := 4);
    port (
        clk : in std_logic;
        rst : in std_logic;
        A_in : in std_logic_vector(num_bits-1 downto 0);
        B_in : in std_logic_vector(num_bits-1 downto 0);
        result : out std_logic_vector(15 downto 0);
        ctrl : in std_logic_vector(7 downto 0);
        status : out std_logic_vector(3 downto 0));
end entity caminoDatos;

architecture rtl of caminoDatos is
    signal A_mux, B_mux, N_mux, ACC_mux, A_ld, B_ld, N_ld, ACC_ld : std_logic; -- Control
    signal A, B, A_reg, B_reg : std_logic_vector(7 downto 0);
    signal N, N_reg : std_logic_vector(2 downto 0);
    signal ACC, ACC_reg : std_logic_vector(15 downto 0);
begin
    (A_mux, B_mux, N_mux, ACC_mux, A_ld, B_ld, N_ld, ACC_ld) <= ctrl;
    status <= (B(0) & N);
    result <= ACC;

    Multiplexor_A : process (A, A_mux, A_in)
    begin
        if A_mux = '1' then 
            A_reg <= (others => '0');
            A_reg(num_bits-1 downto 0) <= A_in(num_bits-1 downto 0);
        else A_reg <= A(6 downto 0) & '0';
        end if;
    end process;

    Registro_A : process (clk, rst)
    begin
        if rst = '1' then A <= (others => '0');
        elsif rising_edge(clk) then if A_ld = '1' then A <= A_reg; end if;
        end if;
    end process;

    Multiplexor_B : process (B, B_mux, B_in)
    begin
        if B_mux = '1' then 
            B_reg <= (others => '0');
            B_reg(num_bits-1 downto 0) <= B_in(num_bits-1 downto 0);
        else B_reg <= '0' & B(7 downto 1);
        end if;
    end process;

    Registro_B : process (clk, rst)
    begin
        if rst = '1' then B <= (others => '0');
        elsif rising_edge(clk) then if B_ld = '1' then B <= B_reg; end if;
        end if;
    end process;

    Multiplexor_ACC : process (A, ACC, ACC_mux)
    begin
        if ACC_mux = '1' then ACC_reg <= (others => '0');
        else ACC_reg <= std_logic_vector(unsigned(A) + unsigned(ACC));
        end if;
    end process;

    Registro_ACC : process (clk, rst)
    begin
        if rst = '1' then ACC <= (others => '0');
        elsif rising_edge(clk) then if ACC_ld = '1' then ACC <= ACC_reg; end if;
        end if;
    end process;

    Multiplexor_N : process (N, N_mux)
    begin
        if N_mux = '1' then N_reg <= "100";
        else N_reg <= std_logic_vector(unsigned(N) - 1);
        end if;
    end process;

    Registro_N : process (clk, rst)
    begin
        if rst = '1' then N <= (others => '0');
        elsif rising_edge(clk) then if N_ld = '1' then N <= N_reg; end if;
        end if;
    end process;
end architecture rtl;