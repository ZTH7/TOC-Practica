library ieee;
use ieee.std_logic_1164.all;

entity unidadControl is
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        start : in std_logic;
        done : out std_logic;
        ctrl : out std_logic_vector(7 downto 0);
        status : in std_logic_vector(3 downto 0));
end entity unidadControl;

architecture rtl of unidadControl is
    type t_states is (finish, inicial, idle, calculate1, calculate2);
    signal current_state, next_state : t_states;
    signal lsb : std_logic;
    signal n : std_logic_vector(2 downto 0);
begin
    (lsb, n(2), n(1), n(0)) <= status;
    p_next_state : process (current_state, start, n, lsb)
    begin
        case current_state is
            when finish =>
                if start = '1' then next_state <= inicial;
                else next_state <= finish;
                end if;
            when inicial =>
                next_state <= idle;
            when idle =>
                if n = "000" then next_state <= finish;
                else
                    if lsb = '1' then next_state <= calculate1;
                    else next_state <= calculate2;
                    end if;
                end if; 
            when calculate1 =>
                next_state <= idle;
            when calculate2 => 
                next_state <= idle;
        end case;
    end process;

    p_ctrl : process (current_state)
        constant A_mux : std_logic_vector(7 downto 0) := "10000000";
        constant B_mux : std_logic_vector(7 downto 0) := "01000000";
        constant N_mux : std_logic_vector(7 downto 0) := "00100000";
        constant ACC_mux : std_logic_vector(7 downto 0) := "00010000";
        constant A_ld : std_logic_vector(7 downto 0) := "00001000";
        constant B_ld : std_logic_vector(7 downto 0) := "00000100";
        constant N_ld : std_logic_vector(7 downto 0) := "00000010";
        constant ACC_ld : std_logic_vector(7 downto 0) := "00000001";
    begin
        ctrl <= (others => '0');
        case current_state is
            when finish =>
                done <= '1';
            when inicial =>
                done <= '0';
                ctrl <= A_mux or B_mux or N_mux or ACC_mux or A_ld or B_ld or N_ld or ACC_ld;
            when idle =>
            when calculate1 =>
                ctrl <= A_ld or B_ld or N_ld or ACC_ld;
            when calculate2 =>
                ctrl <= A_ld or B_ld or N_ld;
        end case;
    end process;

    p_status_reg : process (clk, rst)
    begin
        if rst = '1' then
            current_state <= inicial;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;
end architecture rtl;