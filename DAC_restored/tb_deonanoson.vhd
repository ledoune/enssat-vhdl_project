library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity tb_deonanoson is
end tb_deonanoson;

architecture behavior of tb_deonanoson is
    component de0nanoson
        generic(
            ram_address_size    : integer := 6;
            ram_data_size       : integer := 12;
            counter_max_value   : integer := 2**6 - 1
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
            start_trait     : out std_logic;        -- pour observation
            fin_trait       : out std_logic;        -- pour observation
            button_rst      : in std_logic;         -- active low reset
            SCL             : inout std_logic;      -- bus I2C vers CNA
            SDA             : inout std_logic;      -- bus I2C vers CNA
--            SCLcopie        : inout std_logic;      -- pour observation
--            SDAcopie        : inout std_logic;      -- pour observation

            led_acq_cnt_read    : out std_logic;
            led_acq_cnt_write   : out std_logic;
            led_out_cnt_read    : out std_logic;
            led_out_cnt_write   : out std_logic;

            button_acq      : in std_logic;         -- active low
            button_trt      : in std_logic;
            button_res      : in std_logic
        );
    end component;

    constant clk_period :           time := 20 ns;

    signal clk                      : std_logic;

    signal ADC_CONVST           : std_logic;        -- impulsion = start la conversion
    signal ADC_SCK              : std_logic;        -- data clock SCK SPI
    signal ADC_SDI              : std_logic;        -- data input SDI SPI(configuration de l ADC, par exemple channel à mesurer)
    signal ADC_SDO	            : std_logic;         -- data output SDO SPI (envoie la valeur numérique bit par bit)
    signal ECHANTE              : std_logic;        -- impulsion = start la conversion entrée pour observation
    signal ECHANTS              : std_logic;        -- impulsion = start la conversion en sortie pour observation
    signal measure_done         : std_logic;        -- indique si la conversion est finie
    signal start_trait          : std_logic;        -- pour observation
    signal fin_trait            : std_logic;        -- pour observation
    signal button_rst           : std_logic;         -- active low reset
    signal SCL                  : std_logic;      -- bus I2C vers CNA
    signal SDA                  : std_logic;      -- bus I2C vers CNA
--    signal SCLcopie             : std_logic;      -- pour observation
--    signal SDAcopie             : std_logic;      -- pour observation

    signal led_acq_cnt_read     : std_logic;
    signal led_acq_cnt_write    : std_logic;
    signal led_out_cnt_read     : std_logic;
    signal led_out_cnt_write    : std_logic;

    signal button_acq           : std_logic;         -- active low
    signal button_trt           : std_logic;
    signal button_res           : std_logic;

begin
    deonanoson : de0nanoson port map (
        clk,

        ADC_CONVST,
        ADC_SCK,
        ADC_SDI,
        ADC_SDO,
        ECHANTE,
        ECHANTS,
        measure_done,
        start_trait,
        fin_trait,
        button_rst,
        SCL,
        SDA,
--        SCLcopie,
--        SDAcopie,

        led_acq_cnt_read,
        led_acq_cnt_write,
        led_out_cnt_read,
        led_out_cnt_write,

        button_acq,
        button_trt,
        button_res
    );

    clk_proc : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    test_proc : process
    begin
        button_rst <= '1';
        button_acq <= '1';
        button_trt <= '1';
        button_res <= '1';
        wait for 100 ns;

        button_rst <= '0';
        button_acq <= '1';
        button_trt <= '1';
        button_res <= '1';
        wait for 100 ns;

        button_rst <= '1';
        button_acq <= '0';
        button_trt <= '1';
        button_res <= '1';
        wait for 100 ns;

        button_rst <= '1';
        button_acq <= '1';
        button_trt <= '0';
        button_res <= '1';
        wait for 100 ns;

        button_rst <= '1';
        button_acq <= '1';
        button_trt <= '1';
        button_res <= '0';
        wait for 100 ns;

        button_rst <= '1';
        button_acq <= '1';
        button_trt <= '1';
        button_res <= '1';
        wait for 100 ns;

        wait;
    end process;
end;


