library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_fir is
	generic (data_width : integer := 12);
end tb_fir;

architecture test of tb_fir is
    component fir is
        generic (data_width : integer := data_width);
        port (
            clk : in std_logic;
            rst : in std_logic;
            data_in : in std_logic_vector;
            data_out : out std_logic_vector
        );
    end component;

    constant clock_period : time := 100 us;

    signal clk : std_logic := '0';
    signal rst : std_logic := '1';
    signal din : std_logic_vector(data_width - 1 downto 0) := (others => '0');
    signal dout : std_logic_vector(data_width - 1 downto 0);

begin
    low_fir : fir port map(clk, rst, din, dout);

    clk_proc : process begin
        clk <= '0';
        wait for clock_period / 2;
        clk <= '1';
        wait for clock_period / 2;
    end process;

    test_proc : process begin
        rst <= '0';
        wait for clock_period;

        rst <= '1';
        wait for clock_period;

        din <= (data_width - 1 => '0', others => '1');
        wait for clock_period;

        din <= (others => '0');
        wait for clock_period * 100;

        wait;
    end process;
end test;
