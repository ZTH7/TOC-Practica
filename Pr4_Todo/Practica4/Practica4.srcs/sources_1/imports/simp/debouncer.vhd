library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity debouncer is
    port (
        rst             : in std_logic;
        clk             : in std_logic;
        x               : in std_logic;
        xDeb            : out std_logic;
        xDebFallingEdge : out std_logic;
        xDebRisingEdge  : out std_logic
    );
end entity debouncer;

architecture rtl of debouncer is
    
    signal XSyncAnterior    : std_logic;
    signal XSync            : std_logic;

    -- espera 50 ms para un reloj a 100 MHz
    constant timeOut : unsigned (22 downto 0) := "10011000100101101000000";
    signal count     : unsigned (22 downto 0);

    type states is (waitingPression, pressionDebouncing, waitingDepression, depressionDebouncing);
    signal state, next_state    : states;
    signal startTimer, timerEnd : std_logic;


begin
    
    synchronizer :
    process (rst, clk)
    begin
        if (rst = '1') then
            XSyncAnterior <= '1';
            XSync         <= '1';
        elsif (RISING_EDGE(clk)) then
            XSync         <= XSyncAnterior;
            XSyncAnterior <= x;
        end if;
    end process synchronizer;

    timer :
    process (rst, clk)
    begin
        if (rst = '1') then
            count <= (others => '0');
        elsif (rising_edge(clk)) then
            if (startTimer = '1') then
                count <= (others => '0');
            elsif (timerEnd = '0') then
                count <= count + 1;
            end if;
        end if;
    end process timer;

    timerEnd <= '1' when (count = timeOut) else '0';

    CU_sync :
    process (rst, clk)
    begin
        if (rst = '1') then
            state <= waitingPression;
        elsif (rising_edge(clk)) then
            state <= next_state;
        end if;
    end process CU_sync;

    CU_comb :
    process (state, xSync, timerEnd)
    begin

        xDeb            <= '1';
        xDebFallingEdge <= '0';
        xDebRisingEdge  <= '0';
        startTimer      <= '0';
        next_state      <= state;

        case state is

            when waitingPression =>
                if (xSync = '0') then
                    xDebFallingEdge <= '1';
                    startTimer      <= '1';
                    next_state      <= pressionDebouncing;
                end if;

            when pressionDebouncing =>
                xDeb <= '0';
                if (timerEnd = '1') then
                    next_state <= waitingDepression;
                end if;

            when waitingDepression =>
                xDeb <= '0';
                if (xSync = '1') then
                    xDebRisingEdge <= '1';
                    startTimer     <= '1';
                    next_state     <= depressionDebouncing;
                end if;

            when depressionDebouncing =>
                if (timerEnd = '1') then
                    next_state <= waitingPression;
                end if;

        end case;
    end process CU_comb;
    
end architecture rtl;