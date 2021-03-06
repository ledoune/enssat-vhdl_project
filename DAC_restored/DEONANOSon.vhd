-- Structurel du projet son sur carte DEO NANO
-- contenant les deux interfaces avec les convertisseurs
-- reliées par un simple registre

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

library work;
use work.son.all;

entity de0nanoson is
    generic (
        ram_address_width    : integer := 16;
        ram_data_width       : integer := 12;
--        counter_min_value   : integer := 0;
        counter_max_value   : integer := 2**16 - 1;
    -- frequencies shouldn't be changed without changing ram clocks
        freq_ADC_DAC        : integer := 10_000;
        freq_trt            : integer := 10_000
    );
	port (
		clk             : in std_logic;
		ADC_CONVST      : out std_logic;        -- impulsion = start la conversion
		ADC_SCK         : out std_logic;        -- data clock SCK SPI
		ADC_SDI         : out std_logic;        -- data input SDI SPI(configuration de l ADC, par exemple channel à mesurer)
		ADC_SDO	        : in std_logic;         -- data output SDO SPI (envoie la valeur numérique bit par bit)
		ECHANTE         : out std_logic;        -- impulsion = start la conversion entrée pour observation
		ECHANTS         : out std_logic;        -- impulsion = start la conversion en sortie pour observation
		measure_done    : out std_logic;        -- indique si la conversion est finie
--		start_trait     : out std_logic;        -- pour observation
--		fin_trait       : out std_logic;        -- pour observation
		button_rst      : in std_logic;         -- active low reset
		SCL             : inout std_logic;      -- bus I2C vers CNA
		SDA             : inout std_logic;      -- bus I2C vers CNA
--      SCLcopie        : inout std_logic;      -- pour observation
--      SDAcopie        : inout std_logic;      -- pour observation

        led_acq_cnt_read    : out std_logic;
        led_acq_cnt_write   : out std_logic;
        led_out_cnt_read    : out std_logic;
        led_out_cnt_write   : out std_logic;

        button_acq      : in std_logic;         -- active low
        button_trt      : in std_logic;
        button_res      : in std_logic
    );
end de0nanoson;

architecture structurelle of de0nanoson is

component ADC2 is
    port (
        rstb                : in std_logic;                                 -- reset asynchrone général
        clk                 : in std_logic;
        measure_ch          : in std_logic_vector (2 downto 0);             --canal à mesurer (entre 0 et 7)
        measure_done        : out std_logic;                                --indique si la conversion est finie
        measure_dataread    : out std_logic_vector (NbitCAN-1 downto 0);    --la valeur numérique du signal analogique (sur 12 bits)
        ADC_CONVST          : out std_logic;                                --impulsion = start la conversion
        ADC_SCK             : out std_logic;                                --data clock du bus SPI
        ADC_SDI             : out std_logic;                                --data input (configuration de l ADC, par exemple channel à mesurer)
        ADC_SDO	            : in std_logic;                                 --data output (envoie la valeur numérique bit par bit)
        ECHANT              : out std_logic                                 --impulsion = identique a ADC_CONVST pour observation sur le connecteur GPIO
    );
end component ADC2;

component DAC IS
    generic (
        input_clk :  integer := 50_000_000;                                 --input clock speed from user logic in Hz
        bus_clk   :  integer := 400_000);                                   --speed the i2c bus (scl) will run at in Hz
    port (
        Tnum      :  in      std_logic_vector ( NbitCNA-1 downto 0);        -- entrée à convertir
        clk       :  in      std_logic;                                     --system clock
        reset_n   :  in      std_logic;                                     --active low reset
        ena       :  in      std_logic;                                     --latch in command
        sda       :  inout   std_logic;                                     --serial data output of i2c bus
        scl       :  inout   std_logic);                                    --serial clock output of i2c bus
end component DAC;

component block_v1 is
    generic (
        ram_address_width    : integer := ram_address_width;
        ram_data_width       : integer := ram_data_width;
--        counter_min_value   : integer := counter_min_value;
        counter_max_value   : integer := counter_max_value;
        freq_ADC_DAC        : integer := freq_ADC_DAC;
        freq_trt            : integer := freq_trt
    );
    port (
        clk                 : in std_logic;

        measure_done         : in std_logic;
        dac_enable              : out std_logic;

        data_in             : in std_logic_vector;
        data_out            : out std_logic_vector;

        led_signals         : out std_logic_vector(0 to 3);

        button_rst          : in std_logic;
        button_acq          : in std_logic;
        button_trt          : in std_logic;
        button_res          : in std_logic
    );
end component block_v1;

component block_v2 is
    generic (
        ram_address_width    : integer := ram_address_width;
        ram_data_width       : integer := ram_data_width;
--        counter_min_value   : integer := counter_min_value;
        counter_max_value   : integer := counter_max_value;
        freq_ADC_DAC        : integer := freq_ADC_DAC;
        freq_trt            : integer := freq_trt
    );
    port (
        clk                 : in std_logic;

        measure_done         : in std_logic;
        dac_enable              : out std_logic;

        data_in             : in std_logic_vector;
        data_out            : out std_logic_vector;

        led_signals         : out std_logic_vector(0 to 3);

        button_rst          : in std_logic;
        button_acq          : in std_logic;
        button_trt          : in std_logic;
        button_res          : in std_logic
    );
end component block_v2;

signal smeasure_done    : std_logic;
signal s_dac_enable     : std_logic;
signal sdataADC         : std_logic_vector(NbitCAN-1 downto 0);            -- signal d'entrée converti
signal sdataDAC         : std_logic_vector(NbitCNA-1 downto 0);          -- entrée à convertir
signal leds             : std_logic_vector(0 to 3);

begin

    instance_ADC2 : ADC2 port map (button_rst,clk,"000",smeasure_done,sdataADC,ADC_CONVST,ADC_SCK,ADC_SDI,ADC_SDO,ECHANTE);

    -- debug thingy : turns on a led if button_rst goes to 0 due to another button
--    process (button_res, button_acq, button_rst)
--        variable pressed : std_logic;
--    begin
--        if (button_res = '0') then
--            pressed := '0';
--            led_acq_cnt_read <= '0'; led_acq_cnt_write <= '0'; led_out_cnt_read <= '0'; led_out_cnt_write <= '0';
--        end if;
--        if (button_acq = '0') then
--            led_out_cnt_write <= '1';
--            pressed := '1';
--        else
--            led_out_cnt_write <= '0';
--        end if;
--        if (button_rst = '0' and pressed = '1') then
--            led_acq_cnt_read <= '1';
--        elsif (button_rst = '0') then
--            led_acq_cnt_write <= '1';
--        else
--            led_acq_cnt_write <= '0';
--        end if;
--    end process;

--    instance_block_v1 : block_v1 port map (clk, smeasure_done, s_dac_enable, sdataADC, sdataDAC, leds,
--                                           button_rst, button_acq, button_trt, button_res);

    instance_block_v2 : block_v2 port map (clk, smeasure_done, s_dac_enable, sdataADC, sdataDAC, leds,
                                           button_rst, button_acq, button_trt, button_res);
  -- leds
    led_acq_cnt_read    <= leds(0);
    led_acq_cnt_write   <= leds(1);
    led_out_cnt_read    <= leds(2);
    led_out_cnt_write   <= leds(3);

    instance_DAC : DAC port map (sdataDAC,clk,button_rst, s_dac_enable,SDA,SCL);




    -- positionnement des signaux soit pour observation, soit non utilisés pour l'instant
    measure_done  <= smeasure_done;
--    SCLcopie <= SCL;
--    SDAcopie <= SDA;
    ECHANTS <= smeasure_done;
--    start_trait <= '1';
--    fin_trait <= '1';

end structurelle ;
