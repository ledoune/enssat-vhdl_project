library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity block_v1 is
    generic(
        ram_address_size    : integer := 6;
        ram_data_size       : integer := 12;
--        counter_min_value   : integer := 0;
        counter_max_value   : integer := 2**6 - 1;
        freq_ADC_DAC        : integer := 10_000;
        freq_trt            : integer := 50_000_000
    );
    port (
        clk                 : in std_logic;

        measure_done        : in std_logic;
        dac_enable          : out std_logic;

        data_in             : in std_logic_vector;
        data_out            : out std_logic_vector;

        led_signals         : out std_logic_vector(0 to 3);

        button_rst          : in std_logic;
        button_acq          : in std_logic;
        button_trt          : in std_logic;
        button_res          : in std_logic
    );

end block_v1;

architecture struct of block_v1 is
    -- acquisition ram and associated counters
    component ram_sync is
        generic (
            address_size    : integer := ram_address_size;
            data_size       : integer := ram_data_size
        );
        port (
            clk             : in std_logic;
            write_enable    : in std_logic;
            read_address    : in unsigned;
            write_address   : in unsigned;
            data_in         : in std_logic_vector;
            data_out        : out std_logic_vector
        );
    end component ram_sync;

    component counter is
        generic (
--            min             : integer := counter_min_value;
            freq            : integer := 50_000_000;
            max             : integer := counter_max_value
        );
        port (
            clk             : in std_logic;
            reset           : in std_logic;
            enable          : in std_logic;
            low_value       : in unsigned;
            high_value      : in unsigned;
            output          : out unsigned
        );
    end component counter;

    component control_unit is
        generic (
            ram_address_size        : integer := ram_address_size
        );
        port (
            clk                     : in std_logic;

            button_rst              : in std_logic;
            button_acq              : in std_logic;
            button_trt              : in std_logic;
            button_res              : in std_logic;

            acq_cnt_read_value      : in unsigned;
            acq_cnt_write_value     : in unsigned;
            out_cnt_read_value      : in unsigned;
            out_cnt_write_value     : in unsigned;

            sample_start            : out unsigned;
            sample_stop             : out unsigned;


            acq_ram_write_enable    : out std_logic;
            out_ram_write_enable    : out std_logic;

            cnt_reset_signals       : out std_logic_vector(0 to 3);
            cnt_enable_signals      : out std_logic_vector(0 to 3)
        );
    end component control_unit;

-- signals between components
    -- command signals from uc
    signal s_uc_acq_ram_write_enable    : std_logic;
    signal s_uc_out_ram_write_enable    : std_logic;
    signal s_uc_cnt_resets              : std_logic_vector(0 to 3);
    signal s_uc_cnt_enables             : std_logic_vector(0 to 3);

    signal s_uc_cnt_sample_start        : unsigned(ram_address_size - 1 downto 0);
    signal s_uc_cnt_sample_stop         : unsigned(ram_address_size - 1 downto 0);

    -- data signals
    signal s_acq_write      : unsigned(ram_address_size - 1 downto 0);
    signal s_acq_read       : unsigned(ram_address_size - 1 downto 0);

    signal s_out_read       : unsigned(ram_address_size - 1 downto 0);
    signal s_out_write      : unsigned(ram_address_size - 1 downto 0);

    signal s_data           : std_logic_vector(ram_data_size - 1 downto 0);

    constant acq_write_max  : unsigned(ram_address_size - 1 downto 0) := (others => '1'); -- ALED TELLEMENT DE TEMPS PERDU A TROUVER QUE JE SUIS CON
    constant divider : integer := (50_000_000 / 400_000);
begin
    acq_ram : ram_sync port map (clk, s_uc_acq_ram_write_enable, s_acq_read, s_acq_write, data_in, s_data);
    acq_cnt_read : counter
        generic map(freq_trt, counter_max_value)
        port map (clk, s_uc_cnt_resets(0), s_uc_cnt_enables(0), s_uc_cnt_sample_start, s_uc_cnt_sample_stop, s_acq_read);
    acq_cnt_write : counter
        generic map(freq_ADC_DAC, counter_max_value)
        port map (clk, s_uc_cnt_resets(1), s_uc_cnt_enables(1), s_uc_cnt_sample_start, acq_write_max, s_acq_write);

    out_ram : ram_sync port map (clk, s_uc_out_ram_write_enable, s_out_read, s_out_write, s_data, data_out);
    out_cnt_read : counter
        generic map (freq_ADC_DAC, counter_max_value)
        port map (clk, s_uc_cnt_resets(2), s_uc_cnt_enables(2), s_uc_cnt_sample_start, s_uc_cnt_sample_stop, s_out_read);
    out_cnt_write : counter
        generic map (freq_trt, counter_max_value)
        port map (clk, s_uc_cnt_resets(3), s_uc_cnt_enables(3), s_uc_cnt_sample_start, s_uc_cnt_sample_stop, s_out_write);

    ctr_unit : control_unit port map (
        clk, button_rst, button_acq, button_trt, button_res,
        s_acq_read,
        s_acq_write,
        s_out_read,
        s_out_write,
        s_uc_cnt_sample_start,
        s_uc_cnt_sample_stop,
        s_uc_acq_ram_write_enable,
        s_uc_out_ram_write_enable,
        s_uc_cnt_resets,
        s_uc_cnt_enables
    );

    led_signals <= s_uc_cnt_enables;
    -- led_signals <= std_logic_vector(s_uc_cnt_sample_stop(13 downto 10));
    -- led_signals <= std_logic_vector(s_acq_write(13 downto 10));

    process (clk, button_rst)
        variable cycle_enable : integer range 0 to 39;              -- number of cycles at 400kHz
        variable data_clk_cycle : integer range 0 to divider - 1;   -- number of cycles at 50MHz
    begin
        if (button_rst = '0') then
            cycle_enable := 0;
            data_clk_cycle := 0;
        elsif (rising_edge(clk)) then
            if (data_clk_cycle = divider - 1) then
                data_clk_cycle := 0;
                if (cycle_enable = 39) then
                    cycle_enable := 0;
                else
                    cycle_enable := cycle_enable + 1;
                end if;
            else
                data_clk_cycle := data_clk_cycle + 1;
            end if;
        end if;
        if (cycle_enable < 29) then
            dac_enable <= '1';
        else
            dac_enable <= '0';
        end if;
    end process;

end struct;
