library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_block_v2 is
end tb_block_v2;

architecture behavior of tb_block_v2 is
    component block_v2
        generic(
            ram_address_width    : integer := 16;
            ram_data_width       : integer := 12;
            counter_max_value   : integer := 2**16 - 1;
            freq_ADC_DAC        : integer := 10_000;
            freq_trt            : integer := 10_000
        );
        port (
            clk                 : in std_logic;

            measure_done         : in std_logic;
            dac_enable          : out std_logic;

            data_in             : in std_logic_vector;
            data_out            : out std_logic_vector;

            led_signals         : out std_logic_vector(0 to 3);

            button_rst          : in std_logic;
            button_acq          : in std_logic;
            button_trt          : in std_logic;
            button_res          : in std_logic
        );
    end component;

    constant clk_period :           time := 20 ns;

    signal clk                      : std_logic;

    signal measure_done             : std_logic;
    signal dac_enable               : std_logic;

    signal data_in                  : std_logic_vector (11 downto 0);
    signal data_out                 : std_logic_vector (11 downto 0) := (others => '0');

    signal leds                     : std_logic_vector(0 to 3);

    signal button_rst               : std_logic := '1';
    signal button_acq               : std_logic := '1';
    signal button_trt               : std_logic := '1';
    signal button_res               : std_logic := '1';

begin
    v2 : block_v2 port map (
            clk,
            measure_done,
            dac_enable,
            data_in,
            data_out,
            leds,
            button_rst,
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

    measure_proc : process
    begin
        measure_done <= '0';
        wait for 50 us;
        measure_done <= '1';
        wait for 50 us;
    end process;

    data_in <= (others => '1');

    test_proc : process
    begin
        button_rst <= '0';
        button_acq <= '1';
        button_trt <= '1';
        button_res <= '1';
        wait for 10 ms;

        button_rst <= '1';
        button_acq <= '1';
        button_trt <= '1';
        button_res <= '1';
        wait for 10 ms;

        button_rst <= '1';
        button_acq <= '0';
        button_trt <= '1';
        button_res <= '1';
        wait for 100 ms;

        button_rst <= '1';
        button_acq <= '1';
        button_trt <= '1';
        button_res <= '1';
        wait for 10 ms;

        button_rst <= '1';
        button_acq <= '1';
        button_trt <= '0';
        button_res <= '1';
        wait for 10 ms;

        button_rst <= '1';
        button_acq <= '1';
        button_trt <= '1';
        button_res <= '1';
        wait for 100 ms;

        button_rst <= '1';
        button_acq <= '1';
        button_trt <= '1';
        button_res <= '0';
        wait for 10 ms;

        button_rst <= '1';
        button_acq <= '1';
        button_trt <= '1';
        button_res <= '1';
        wait for 100 ms;

        wait;
    end process;
end;


