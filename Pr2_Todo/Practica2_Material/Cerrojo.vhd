
----------------------------------------------------------------------------------
--                                  Cerrojo                                     --
----------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY cerrojo IS
  PORT (
    rst : IN STD_LOGIC;
    clk : IN STD_LOGIC;
    load : IN STD_LOGIC;
    enter : IN STD_LOGIC;
    pwd : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    bloqueado : OUT STD_LOGIC;
    seg : OUT STD_LOGIC_VECTOR (6 DOWNTO 0));
END cerrojo;

ARCHITECTURE rtl OF cerrojo IS
  TYPE t_state IS (INICIAL, TRES, DOS, UNO, FINAL);
  SIGNAL current_state, next_state : t_state;
  SIGNAL chance : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL pwd_correct : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL load_pwd, xDebFallingEdge, eq : STD_LOGIC;

  COMPONENT conv_7seg IS
    PORT (
      x : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      display : OUT STD_LOGIC_VECTOR (6 DOWNTO 0));
  END COMPONENT;

  COMPONENT debouncer IS
    PORT (
      rst : IN STD_LOGIC;
      clk : IN STD_LOGIC;
      x : IN STD_LOGIC;
      xDeb : OUT STD_LOGIC;
      xDebFallingEdge : OUT STD_LOGIC;
      xDebRisingEdge : OUT STD_LOGIC
    );
  END COMPONENT debouncer;

  COMPONENT parallel_reg IS
    PORT (
      rst, clk, load : IN STD_LOGIC;
      I : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      O : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
  END COMPONENT parallel_reg;

  COMPONENT comparador IS
    PORT (
      a, b : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      c : OUT STD_LOGIC
    );
  END COMPONENT;

BEGIN

  conv : conv_7seg PORT MAP(chance, seg);
  debo : debouncer PORT MAP(rst, clk, enter, OPEN, xDebFallingEdge, OPEN);
  regi : parallel_reg PORT MAP(rst, clk, load_pwd, pwd, pwd_correct);
  comp : comparador PORT MAP(pwd, pwd_correct, eq);

  start : PROCESS (clk, rst)
  BEGIN
    IF rst = '1' THEN
      current_state <= INICIAL;
    ELSIF rising_edge(clk) THEN
      IF xDebFallingEdge = '1' THEN
        current_state <= next_state;
      END IF;
    END IF;
  END PROCESS start;

  COMB : PROCESS (current_state, xDebFallingEdge)
  BEGIN
    CASE current_state IS
      WHEN INICIAL =>
        bloqueado <= '1';
        load_pwd <= '1';
        IF xDebFallingEdge = '1' THEN
          next_state <= TRES;
        ELSE
          next_state <= INICIAL;
        END IF;
      WHEN TRES =>
        bloqueado <= '0';
        chance <= "0011";
        load_pwd <= '0';
        IF xDebFallingEdge = '1' THEN
          IF eq = '1' THEN
            next_state <= INICIAL;
          ELSE
            next_state <= DOS;
          END IF;
        ELSE
          next_state <= TRES;
        END IF;
      WHEN DOS =>
        bloqueado <= '0';
        chance <= "0010";
        load_pwd <= '0';
        IF xDebFallingEdge = '1' THEN
          IF eq = '1' THEN
            next_state <= INICIAL;
          ELSE
            next_state <= UNO;
          END IF;
        ELSE
          next_state <= DOS;
        END IF;
      WHEN UNO =>
        bloqueado <= '0';
        chance <= "0001";
        load_pwd <= '0';
        IF xDebFallingEdge = '1' THEN
          IF eq = '1' THEN
            next_state <= INICIAL;
          ELSE
            next_state <= FINAL;
          END IF;
        ELSE
          next_state <= UNO;
        END IF;
      WHEN FINAL =>
        bloqueado <= '0';
        chance <= "0000";
        load_pwd <= '0';
        next_state <= FINAL;
    END CASE;
  END PROCESS COMB;

END rtl;