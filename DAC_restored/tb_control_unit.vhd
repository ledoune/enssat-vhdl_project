library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity tb_control_unit is
end tb_control_unit;

architecture behavior of tb_control_unit is
    component control_unit
        generic (
            ram_address_width : integer := 16
        );
        port (
            clk                     : in std_logic;

            button_rst              : in std_logic;
            button_acq              : in std_logic;
            button_trt              : in std_logic;
            button_out              : in std_logic;

            acq_cnt_read_value      : in unsigned(ram_address_width - 1 downto 0);
            acq_cnt_write_value     : in unsigned(ram_address_width - 1 downto 0);
            out_cnt_read_value      : in unsigned(ram_address_width - 1 downto 0);
            out_cnt_write_value     : in unsigned(ram_address_width - 1 downto 0);

            sample_start            : out unsigned(ram_address_width - 1 downto 0);
            sample_stop             : out unsigned(ram_address_width - 1 downto 0);
        
            acq_ram_write_enable    : out std_logic;
            out_ram_write_enable    : out std_logic;

            cnt_reset_signals       : out std_logic_vector(0 to 3);
            cnt_enable_signals      : out std_logic_vector(0 to 3);
        );
    end component;

    constant clk_period :           time := 20 ns;

    signal clk                      : std_logic;

    signal button_rst               : std_logic;
    signal button_acq               : std_logic;
    signal button_trt               : std_logic;
    signal button_out               : std_logic;

    signal acq_ram_write_enable     : std_logic;
    signal out_ram_write_enable     : std_logic;

    signal cnt_reset_signals        : std_logic_vector(0 to 3);
    signal cnt_enable_signals       : std_logic_vector(0 to 3);

    signal sample_start : unsigned(ram_address_width - 1 downto 0);
    signal sample_stop : unsigned(ram_address_width - 1 downto 0);

    signal acq_cnt_read_value : unsigned(ram_address_width - 1 downto 0);
    signal acq_cnt_write_value : unsigned(ram_address_width - 1 downto 0);
    signal out_cnt_read_value : unsigned(ram_address_width - 1 downto 0);
    signal out_cnt_write_value : unsigned(ram_address_width - 1 downto 0);
begin
    ctr_unit : control_unit port map (
            clk,

            button_rst,
            button_acq,
            button_trt,
            button_out,

            acq_ram_write_enable,
            out_ram_write_enable,

            cnt_reset_signals,
            cnt_enable_signals
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
        button_out <= '1';
        wait for 100 ns;
        
        button_rst <= '0';
        button_acq <= '1';
        button_trt <= '1';
        button_out <= '1';
        wait for 100 ns;
        
        button_rst <= '1';
        button_acq <= '0';
        button_trt <= '1';
        button_out <= '1';
        wait for 100 ns;

        button_rst <= '1';
        button_acq <= '1';
        button_trt <= '0';
        button_out <= '1';
        wait for 100 ns;

        button_rst <= '1';
        button_acq <= '1';
        button_trt <= '1';
        button_out <= '0';
        wait for 100 ns;

        button_rst <= '1';
        button_acq <= '1';
        button_trt <= '1';
        button_out <= '1';
        wait for 100 ns;

        wait;
    end process;
end;


