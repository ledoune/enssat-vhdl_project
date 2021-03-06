-- bloc realisant l'interface SPI avec le convertisseur AD LTC2308
-- inspire d'un code fourni et re-ecrit
library IEEE;  -- Name of the library
use IEEE.STD_LOGIC_1164.ALL; -- name of the  package  in IEEE library 
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library work;
use work.ALL;
use work.son.all;


ENTITY ADC2 IS       
  PORT( 
    rstb             : in std_logic; -- reset asynchrone général
	clk              : in std_logic;
	measure_ch       : in std_logic_vector (2 downto 0);  --canal à mesurer (entre 0 et 7)
	measure_done     : out std_logic;  --indique si la conversion est finie
	measure_dataread : out std_logic_vector (NbitCAN-1 downto 0); --la valeur numérique du signal analogique (sur 12 bits)
    ADC_CONVST       : out std_logic;  --impulsion = start la conversion
	ADC_SCK          : out std_logic;  --data clock du bus SPI
    ADC_SDI          : out std_logic;  --data input (configuration de l ADC, par exemple channel à mesurer)
	ADC_SDO	         : in std_logic;  --data output (envoie la valeur numérique bit par bit)
	ECHANT           : out std_logic   --impulsion = identique a ADC_CONVST pour observation sur le connecteur GPIO  
	); 
 END ADC2;
 
 architecture behavior of ADC2 is
    
	signal clk_enable               : std_logic; --c'est ADC_SCK 
	signal reg_data                 : std_logic_vector (NbitCAN-1 downto 0) :="000000000000"; ----la valeur numérique du signal analogique (sur 12 bits)
	signal decal_data               : std_logic;
	signal reg_cmd                  : std_logic_vector (5 downto 0); --(S/D) (O/S) (S1) (S0) (UNI) (SLP) voir partie ADC6
	signal charg_cmd                : std_logic; --preparation de la transmission de ADC_SDI 
	signal decal_cmd                : std_logic; --la transmission de ADC_SDI
	signal cpt                      : std_logic_vector (taille_cpt-1 downto 0) :=(others =>'0'); --compteur pour la fr�quence de la conversion
	signal dec1,dec2,dec3,dec4      : std_logic;-- signaux de décodage de certaines valeurs du compteur
	signal CurrentState,NextState   : states_ADC;
	  
begin
---------------compteur de durée ---------------------------------
cpt_FE : process (clk,rstb,cpt)
begin
    if (rstb='0') then 
        cpt <= (others => '0');
    elsif ( rising_edge(clk) ) then
        if (cpt = conv_std_logic_vector(DIV_CLK-1, taille_cpt)) then
            cpt <= (others => '0');
		else
		   cpt <= cpt + 1;
		end if;
    end if;
end process cpt_FE;

 -----------Registre de commande------------------------------
--config_cmd (ADC_SDI) reçoit = (S/D) (O/S) (S1) (S0) (UNI) (SLP) 
--S/D = SINGLE-ENDED/DIFFERENTIAL BIT (1: on mesure une difference de potentiel 0: on mesure par rapport à la masse) 
--O/S = ODD/SIGN BIT (0: channel à numéro pair 1: channel à numéro impair)
--S1  = ADDRESS SELECT BIT 1 (numéro du channel est codé sur 2 bits: S1S0)
--S0  = ADDRESS SELECT BIT 0
--UNI = UNIPOLAR/BIPOLAR BIT (1: Unipolar, 0:Bipolar)
--SLP = SLEEP MODE BIT (1: enable sleep)

registre_cmd : process (clk, rstb,charg_cmd,decal_cmd)
begin
    if (rstb='0') then 
        reg_cmd <= (others =>'0');
	elsif ( falling_edge(clk) ) then
        if charg_cmd='1' then
            reg_cmd <= ('1','0','0','0','1','0'); -- attention numero de canal figé à 0 et pas lié aux entrées mesure_ch
		elsif (decal_cmd='1') then   -- décalage lors de l'envoi de la trame
            reg_cmd(5 downto 1) <= reg_cmd(4 downto 0);
            reg_cmd(0) <='0';
		end if;
    end if;
end process registre_cmd;

ADC_SDI <= reg_cmd(5);

--------Registre de données -------------------------- 
 
registre_data : process (clk, rstb,decal_data)
begin	
    if (rstb='0') then 
        reg_data <= (others =>'0');
    elsif ( falling_edge(clk) ) then
        if decal_data='1' then
            reg_data(NbitCAN-1 downto 1) <= reg_data(NbitCAN-2 downto 0); 
            reg_data(0) <= ADC_SDO; 
		end if;
	end if;
end process registre_data;

measure_dataread <= reg_data; 
	
-----------------------------------------
--------décodeur des différents instants pour respecter le timing de l'ADC ------------------------	
    dec1 <= '1' when (cpt = conv_std_logic_vector(0,taille_cpt )) else '0'; 
	dec2 <= '1' when (cpt = conv_std_logic_vector(duree_convst,taille_cpt )) else '0'; 
	dec3 <= '1'  when (cpt = conv_std_logic_vector(duree_conv,taille_cpt )) else '0'; 
	dec4 <= '1'  when (cpt = conv_std_logic_vector(duree_conv+NbitCAN ,taille_cpt )) else '0';

----------libération de l'horloge seulement au bon moment -------------------------------
    ADC_SCK <= clk when (clk_enable='1') else '0';

-------machine d'état---------------------	
StateRegister : PROCESS(Clk, Rstb)
BEGIN
    IF Rstb = '0' THEN
        CurrentState <= attenteFE;
    ELSIF Clk'event AND Clk = '1' THEN
        CurrentState <= NextState;
    END IF;
END PROCESS StateRegister;  
  
StateMachine_entree : PROCESS(CurrentState, dec1,dec2,dec3,dec4)
BEGIN
    CASE CurrentState IS
        WHEN attenteFE =>
            decal_cmd <='0';
            charg_cmd <= '0' ;
            decal_data <= '0';
            clk_enable <='0';
            measure_done <='0';
            ADC_CONVST <='0';
            ECHANT <='0';
            IF  dec1 = '1' THEN
                NextState <= CONVST ;
            ELSE
                NextState <= attenteFE ;
            END IF; 
            
        WHEN CONVST =>
            decal_cmd <='0';
            charg_cmd <= '0' ;
            decal_data <= '0';
            clk_enable <='0';
            measure_done <='0';
            ADC_CONVST <='1';
            ECHANT <='1';
            IF dec2 = '1' THEN
                NextState <= TCONV ;
            ELSE
                NextState <= CONVST ;
            END IF ; 
            
        WHEN TCONV =>
            decal_cmd <='0';
            charg_cmd <= '0' ;
            decal_data <= '0';
            clk_enable <='0';
            measure_done <='0';
            ADC_CONVST <='0';
            ECHANT <='0';
            IF dec3 = '1' THEN
                NextState <= trame ;
            ELSE
                NextState <= TCONV ;
            END IF ; 
            
        WHEN trame =>
            decal_cmd <='1';
            charg_cmd <= '0' ;
            decal_data <= '1';
            clk_enable <='1';
            measure_done <='0';
            ADC_CONVST <='0';
            ECHANT <='0';
            IF dec4 = '1' THEN
                NextState <= mesure_faite ;
            ELSE
                NextState <= trame ;
            END IF ; 
		  
        WHEN mesure_faite =>
            decal_cmd <='0';
            charg_cmd <= '1' ;
            decal_data <= '0';
            clk_enable <='0';
            measure_done <='1';
            ADC_CONVST <='0';
            ECHANT <='0';
            NextState <= attenteFE ; 
		  
   END CASE;
   END PROCESS StateMachine_entree;     

end behavior;
 

	