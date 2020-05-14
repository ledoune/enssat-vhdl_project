library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fir is
    generic (
        -- coeff_width : integer := 16;
        data_width : integer := 12
    );
    port (
        clk : in std_logic;
        rst : in std_logic;
        data_in : in std_logic_vector(data_width - 1 downto 0);
        data_out : out std_logic_vector(data_width - 1 downto 0)
    );
end fir;

architecture behavior of fir is
    component dflipflop is
        generic (
            data_width : integer := data_width
        );
        port (
            clk : in std_logic;
            rst : in std_logic;
            D : in signed;
            Q : out signed
        );
    end component;

    constant coeff_width : integer := 16;
    constant taps : integer := 33;

    type coeff_type is array(1 to taps) of signed(coeff_width - 1 downto 0);
-- 33 coeffs, cutoff = 1000Hz, transition = 1000-1500Hz, ripple = 5dB, att = 60 dB
    constant coeff : coeff_type :=
    (
        to_signed(74, coeff_width),
        to_signed(240, coeff_width),
        to_signed(503, coeff_width),
        to_signed(832, coeff_width),
        to_signed(1090, coeff_width),
        to_signed(1138, coeff_width),
        to_signed(836, coeff_width),
        to_signed(189, coeff_width),
        to_signed(-653, coeff_width),
        to_signed(-1349, coeff_width),
        to_signed(-1519, coeff_width),
        to_signed(-853, coeff_width),
        to_signed(696, coeff_width),
        to_signed(2872, coeff_width),
        to_signed(5129, coeff_width),
        to_signed(6834, coeff_width),
        to_signed(7465, coeff_width),
        to_signed(6834, coeff_width),
        to_signed(5129, coeff_width),
        to_signed(2872, coeff_width),
        to_signed(696, coeff_width),
        to_signed(-853, coeff_width),
        to_signed(-1519, coeff_width),
        to_signed(-1349, coeff_width),
        to_signed(-653, coeff_width),
        to_signed(189, coeff_width),
        to_signed(836, coeff_width),
        to_signed(1138, coeff_width),
        to_signed(1090, coeff_width),
        to_signed(832, coeff_width),
        to_signed(503, coeff_width),
        to_signed(240, coeff_width),
        to_signed(74, coeff_width)

        -- coeffs as double
        -- 0.0022553604244301617
        -- 0.007321994259929821
        -- 0.015344169596167693
        -- 0.025376356928283144
        -- 0.03326239482342369
        -- 0.034740740949577416
        -- 0.025525855088562668
        -- 0.005757233948153424
        -- -0.019915760070680782
        -- -0.041167230063980195
        -- -0.04636029548018214
        -- -0.026026758330116494
        -- 0.02125275585762174
        -- 0.08765083258376268
        -- 0.15651467579079673
        -- 0.2085588162898505
        -- 0.22782887128827817
        -- 0.2085588162898505
        -- 0.15651467579079673
        -- 0.08765083258376268
        -- 0.02125275585762174
        -- -0.026026758330116494
        -- -0.04636029548018214
        -- -0.041167230063980195
        -- -0.019915760070680782
        -- 0.005757233948153424
        -- 0.025525855088562668
        -- 0.034740740949577416
        -- 0.03326239482342369
        -- 0.025376356928283144
        -- 0.015344169596167693
        -- 0.007321994259929821
        -- 0.0022553604244301617
    );

    type shift_reg_type is array (0 to taps - 1) of signed(data_width - 1 downto 0);
    type mult_res_type is array (0 to taps - 1) of signed(data_width + coeff_width - 1 downto 0);
    type add_res_type is array (0 to taps - 1) of signed(data_width + coeff_width - 1 downto 0);
    signal shift_reg : shift_reg_type;
    signal mult_res : mult_res_type;
    signal add_res : add_res_type;

begin
    shift_reg(0) <= signed(data_in);
    mult_res(0) <= signed(data_in) * coeff(1);
    add_res(0) <= signed(data_in) * coeff(1);
    filter_gen:
    for i in 0 to taps - 2 generate begin
        dff_unit : dflipflop port map (clk, rst, shift_reg(i), shift_reg(i+1));
        mult_res(i+1) <= shift_reg(i+1) * coeff(i+2);
        add_res(i+1) <= add_res(i) + mult_res(i+1);
    end generate filter_gen;

    process (clk) begin
        if (rising_edge(clk)) then
            -- RTFM : resize keeps the right most bits :))))))
            data_out <= std_logic_vector(add_res(taps - 1)(data_width + coeff_width - 1 downto coeff_width));
        end if;
    end process;
end behavior;


