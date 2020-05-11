library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;


package son is
  
    constant Tclk : time := 20000 ps;   -- frequence horloge de base 50 MHZ
    constant DIV_CLK : integer := 5000;   -- division de l'horloge clk pour frequence d'echantillonage d'entrée 5000 donne 10Khz
    constant taille_cpt : integer := 13;  -- nombre de bits necessaires pour faire cette division de frequence
    constant duree_convst: integer := 3; -- nombre d'incrément pour la durée à 1 du ADC_CONVST 
    constant duree_conv: integer := 80;   -- nombre d'incrément pour la durée du temps de conversion de l'ADC 
    constant taille_tick : integer := 8;  -- nombre de bits necessaires pour faire les timing du CAN
  
    constant N : integer := 128;           -- son size
    constant EXP : integer := 7;          -- LOG2 son size
  
    constant NbitCNA : integer := 12;    -- Number of bit for CNA
    constant NbitCAN : integer := 12;    -- Number of bit for CAN
   
    constant Ts : integer := 2500 ;-- 5000 correspond à 5Khz pour la fréquence d'échantillonage de sortie ;

    type states_ADC is (attenteFE,CONVST,TCONV,trame,mesure_faite); -- pour la machine d'état dans l'interface avec l'ADC

end son;

