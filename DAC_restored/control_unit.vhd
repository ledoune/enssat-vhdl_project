library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity control_unit is
    generic (
        ram_address_width    : integer := 6
    );
    port (
        clk                     : in std_logic;

        button_rst              : in std_logic;
        button_acq              : in std_logic;
        button_trt              : in std_logic;
        button_res              : in std_logic;

        acq_cnt_read_value      : in unsigned(ram_address_width - 1 downto 0);
        acq_cnt_write_value     : in unsigned(ram_address_width - 1 downto 0);
        out_cnt_read_value      : in unsigned(ram_address_width - 1 downto 0);
        out_cnt_write_value     : in unsigned(ram_address_width - 1 downto 0);

        sample_start            : out unsigned(ram_address_width - 1 downto 0);
        sample_stop             : out unsigned(ram_address_width - 1 downto 0);

        acq_ram_write_enable    : out std_logic;
        out_ram_write_enable    : out std_logic;
        -- bit order : acq_cnt_read / acq_cnt_write / out_cnt_read / out_cnt_write
        cnt_reset_signals       : out std_logic_vector(0 to 3);
        cnt_enable_signals      : out std_logic_vector(0 to 3)
    );
end control_unit;

architecture logic of control_unit is
    type state_type is (rdy, acq, trt, res, rst, async_rst);
    attribute syn_encoding : string;
    attribute syn_encoding of state_type : type is "sequential, safe";

    signal state : state_type;

    signal s_sample_start : unsigned(ram_address_width - 1 downto 0);
    signal s_sample_stop : unsigned(ram_address_width - 1 downto 0);
begin
    process (clk, button_rst) begin
        if button_rst = '0' then
            s_sample_start  <= (others => '0');
            -- s_sample_stop   <= (0 => '1', others => '0');
            s_sample_stop   <= (others => '0');
            state           <= async_rst;
        elsif (rising_edge(clk)) then
            case state is
                when rdy =>
                    if button_acq = '0' then
                        s_sample_start  <= (others => '0');
                        state           <= acq;
                    elsif button_trt = '0' then
                        s_sample_start  <= (others => '0');
                        s_sample_stop   <= acq_cnt_write_value;
                        -- s_sample_stop   <= (1 => '1', others => '0');
                        state           <= trt;
                    elsif button_res = '0' then
                        s_sample_start  <= (others => '0');
                        s_sample_stop   <= acq_cnt_write_value;
                        -- s_sample_stop   <= (2 => '1', others => '0');
                        state           <= res;
                    else
                        -- s_sample_stop   <= (3 => '1', others => '0');
                        state <= rdy;
                    end if;

                when acq =>
                    if button_acq = '0' then
                        state <= acq;
                    else
                        -- s_sample_stop   <= acq_cnt_write_value;
                        -- s_sample_stop   <= (others => '1');
                        state <= rst;
                    end if;

                when trt =>
                    if acq_cnt_read_value /= s_sample_stop then
                        state <= trt;
                    else
                        state <= rst;
                    end if;

                when res =>
                    if out_cnt_read_value /= s_sample_stop then
                        state <= res;
                    else
                        state <= rst;
                    end if;

                when async_rst =>
                    state <= rdy;
                when rst =>
                    state <= rdy;
            end case;
        end if;
    end process;

    process (state) begin
        case state is
            when rdy =>
                acq_ram_write_enable    <= '0';
                out_ram_write_enable    <= '0';
                cnt_enable_signals      <= "0000";
                -- cnt_enable_signals      <= std_logic_vector(s_sample_stop(3 downto 0));
                cnt_reset_signals       <= "0000";

            when acq =>
                acq_ram_write_enable    <= '1';
                out_ram_write_enable    <= '0';
                cnt_enable_signals      <= "0100";
                cnt_reset_signals       <= "0000";

            when trt =>
                acq_ram_write_enable    <= '0';
                out_ram_write_enable    <= '1';
                cnt_enable_signals      <= "1001";
                cnt_reset_signals       <= "0000";

            when res =>
                acq_ram_write_enable    <= '0';
                out_ram_write_enable    <= '0';
                cnt_enable_signals      <= "0010";
                cnt_reset_signals       <= "0000";

            when async_rst =>
                acq_ram_write_enable    <= '0';
                out_ram_write_enable    <= '0';
                cnt_enable_signals      <= "0000";
                -- cnt_enable_signals      <= std_logic_vector(s_sample_stop(3 downto 0));
                cnt_reset_signals       <= "1111";

            when rst =>
                acq_ram_write_enable    <= '0';
                out_ram_write_enable    <= '0';
                cnt_enable_signals      <= "0000";
                cnt_reset_signals       <= "1011";
                -- cnt_reset_signals       <= "0000";
        end case;
    end process;

    sample_start    <= s_sample_start;
    sample_stop     <= acq_cnt_write_value;
end logic;
