
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
    load_n : IN STD_LOGIC;
    chance_n : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    bloqueado : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
    seg : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
    an : OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
END cerrojo;

ARCHITECTURE rtl OF cerrojo IS
  TYPE t_state IS (Chance_enter, INICIAL, Bucle, Bucle_2, FINAL);
  SIGNAL current_state, next_state : t_state;
  SIGNAL chance, chance_res : STD_LOGIC_VECTOR(3 DOWNTO 0);
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
  
  COMPONENT restador IS
    PORT (
      A, B : IN std_logic_vector(3 downto 0);
      C : OUT std_logic_vector(3 downto 0)
    );
  END COMPONENT;

BEGIN

  conv : conv_7seg PORT MAP(chance, seg);
  debo : debouncer PORT MAP(rst, clk, enter, OPEN, xDebFallingEdge, OPEN);
  regi : parallel_reg PORT MAP(rst, clk, load_pwd, pwd, pwd_correct);
  comp : comparador PORT MAP(pwd, pwd_correct, eq);
  rest : restador PORT MAP(chance, "0001", chance_res);

  an <= "1110";

  start : PROCESS (clk, rst)
  BEGIN
    IF rst = '1' THEN
      current_state <= INICIAL;
    ELSIF rising_edge(clk) THEN
      --IF xDebFallingEdge = '1' THEN
        current_state <= next_state;
      --END IF;
    END IF;
  END PROCESS start;

  COMB : PROCESS (current_state, xDebFallingEdge)
  BEGIN
    CASE current_state IS
      WHEN INICIAL =>
        bloqueado <= (others=>'1');
        load_pwd <= '1';
        chance <= "0000";
        IF xDebFallingEdge = '1' THEN
          next_state <= Chance_enter;
        ELSE
          next_state <= INICIAL;
        END IF;
      WHEN Chance_enter =>
        bloqueado <= (others=>'0');
        load_pwd <= '0';
        IF load = '1' THEN
          chance <= chance_n;
          next_state <= Bucle;
        ELSE
          next_state <= Chance_enter;
        END IF;   
        
      WHEN Bucle =>
        bloqueado <= (others=>'0');
        load_pwd <= '0';
        IF xDebFallingEdge = '1' THEN
          IF eq = '1' THEN
            next_state <= INICIAL;
          
          ELSE
            chance <= std_logic_vector(unsigned(chance)-1);
            
          END IF;
       
          next_state <= Bucle_2;
        END IF;
      WHEN FINAL =>
        bloqueado <= (others=>'0');
        chance <= "0000";
        load_pwd <= '0';
        next_state <= FINAL;
        
      When Bucle_2 =>
      
      IF chance = "0000" then
                next_state <= Final;
            ELSE next_state <= Bucle;
            end if;
            
    END CASE;
  END PROCESS COMB;

END rtl;