LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY cerrojo IS
   PORT (
      rst : IN STD_LOGIC;
      clk : IN STD_LOGIC;
      boton : IN STD_LOGIC;
      clave : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      bloqueado : OUT STD_LOGIC;
      intentos : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
   );
END cerrojo;

ARCHITECTURE ARCH OF cerrojo IS

   COMPONENT registro IS
      PORT (
         clk : IN STD_LOGIC;
         load : IN STD_LOGIC;
         e : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
         s : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
      );
   END COMPONENT;

   COMPONENT comparador IS
      PORT (
         a, b : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
         c : OUT STD_LOGIC
      );
   END COMPONENT;

   TYPE ESTADOS IS (INICIAL, TRES, DOS, UNO, FINAL);
   SIGNAL ESTADO, SIG_ESTADO : ESTADOS;
   SIGNAL eq, ld_clave : STD_LOGIC;
   SIGNAL clave_ini : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN

   registro_clave : registro PORT MAP(clk, ld_clave, clave, clave_ini);
   comparador_clave : comparador PORT MAP(clave_ini, clave, eq);
   SYNC : PROCESS (clk)
   BEGIN
      IF rising_edge(clk) THEN
         IF rst = '1' THEN
            ESTADO <= INICIAL;
         ELSE
            ESTADO <= SIG_ESTADO;
         END IF;
      END IF;
   END PROCESS SYNC;

   COMB : PROCESS (ESTADO, boton, eq)
   BEGIN
      CASE ESTADO IS
         WHEN INICIAL =>
            bloqueado <= '1';
            ld_clave <= '1';
            IF boton = '1' THEN
               SIG_ESTADO <= TRES;
            ELSE
               SIG_ESTADO <= INICIAL;
            END IF;
         WHEN TRES =>
            bloqueado <= '0';
            intentos <= "0011";
            ld_clave <= '0';
            IF boton = '1' THEN
               IF eq = '1' THEN
                  SIG_ESTADO <= INICIAL;
               ELSE
                  SIG_ESTADO <= DOS;
               END IF;
            ELSE
               SIG_ESTADO <= TRES;
            END IF;
         WHEN DOS =>
            bloqueado <= '0';
            intentos <= "0010";
            ld_clave <= '0';
            IF boton = '1' THEN
               IF eq = '1' THEN
                  SIG_ESTADO <= INICIAL;
               ELSE
                  SIG_ESTADO <= UNO;
               END IF;
            ELSE
               SIG_ESTADO <= DOS;
            END IF;
         WHEN UNO =>
            bloqueado <= '0';
            intentos <= "0001";
            ld_clave <= '0';
            IF boton = '1' THEN
               IF eq = '1' THEN
                  SIG_ESTADO <= INICIAL;
               ELSE
                  SIG_ESTADO <= FINAL;
               END IF;
            ELSE
               SIG_ESTADO <= UNO;
            END IF;
         WHEN FINAL =>
            bloqueado <= '0';
            intentos <= "0000";
            ld_clave <= '0';
            SIG_ESTADO <= FINAL;
      END CASE;
   END PROCESS COMB;


END ARCH;