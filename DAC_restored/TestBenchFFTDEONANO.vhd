LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
library work;
use work.ALL;
use work.FFT.all;

ENTITY TEST_BENCH_FFTDEONANO IS
END TEST_BENCH_FFTDEONANO;

ARCHITECTURE behavior OF TEST_BENCH_FFTDEONANO IS

COMPONENT fftdeonano IS
  PORT (
  clk       :  IN      STD_LOGIC;  
  ADC_CONVST       : out std_logic ;  --impulsion = start la conversion
  ADC_SCK          : out std_logic ;  --data clock
  ADC_SDI          : out std_logic ;  --data input (channel à mesurer)
  ADC_SDO	         : in std_logic  ;  --data output (envoie la valeur numérique bit par bit)
  ECHANTE           : out std_logic ;  --impulsion = start la conversion pour observation 
  ECHANTS           : out std_logic ;
  measure_done     : out std_logic ;  --indique si la conversion est finie
  start_fft         : out std_logic ;  --pour observation
  fin_fft         : out std_logic ;  --pour observation
  BP0       :  IN      STD_LOGIC;                    --active low reset
  SCL : INOUT STD_LOGIC;
  SDA   : INOUT  STD_LOGIC   
  );
END COMPONENT fftdeonano;  

  SIGNAL  srstb, sclk      :  STD_LOGIC;                   
  SIGNAL  sADC_SDO   :  STD_LOGIC :='1' ;             
  SIGNAL  smeasure_ch       :  STD_LOGIC_VECTOR(2 downto 0) :="001" ;   
  SIGNAL  smeasure_dataread       :  STD_LOGIC_VECTOR(NbitCAN-1 downto 0);
  SIGNAL  smeasure_done,sADC_CONVST,sADC_SCK,sADC_SDI,sECHANTE,sECHANTS       :  STD_LOGIC;                 
  SIGNAL  sdata_ram_sortie    :   Std_Logic_Vector(NbitCAN-1 downto 0);
  SIGNAL  sadd_ram_sortie    :  Std_Logic_Vector(EXP-1 downto 0);
        
  SIGNAL  sSCL,sSDA       :  Std_Logic;
  SIGNAL  sstart_fft,sfin_fft    :  Std_logic;                 


BEGIN
   instance_FFTDENANO : fftdeonano PORT MAP ( sclk,sADC_CONVST,sADC_SCK,sADC_SDI,sADC_SDO,sECHANTE,sECHANTS,smeasure_done,sstart_fft,sfin_fft,srstb,sSCL,sSDA );
	
   horloge : PROCESS -- horloge à 50 MHZ => 20 ns
	BEGIN
		sclk<='0';
		wait for 10 ns;
		sclk <='1';
		wait for 10 ns;
		-- génere sans arrêt une horloge
		
	END PROCESS horloge;
	
	
	reset :PROCESS 
	BEGIN
	 srstb <= '0';
	 wait for 25 ns ;
	 srstb <= '1';
	 wait;
	END PROCESS reset;
	
	trame : PROCESS
	BEGIN
	smeasure_ch <= "001" ;
	sADC_SDO <='1';
	wait for 1680 ns ;
	sADC_SDO <='0';
	wait for 40 ns ;
	sADC_SDO <='1';
	wait for 220 ns ;
	sADC_SDO <='0';
	wait for 25 ns ;

   wait for 9900 ns ;
   sADC_SDO <='0';
	wait for 100 ns ;
	sADC_SDO <='1';
	wait for 25 ns ;
	sADC_SDO <='0';
	wait for 25 ns ;

   wait for 9900 ns ;
   sADC_SDO <='0';
	wait for 50 ns ;
	sADC_SDO <='1';
	wait for 25 ns ;
	sADC_SDO <='0';
        wait for 50 ns ;
	sADC_SDO <='1';
	wait for 25 ns ;

        sADC_SDO <='0';
	

	wait; 
	END PROCESS trame;
	
--	fincalcul: PROCESS
--	BEGIN
--	sfin_fft <= '0';
--	wait for 153 us;
--	sfin_fft <= '1';
--	wait;
--	END PROCESS;
	
	
	
END behavior;