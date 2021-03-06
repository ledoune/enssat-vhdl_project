library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_counter is
end tb_counter;

architecture behavior of tb_counter is
    component counter
        generic (
            freq : integer := 25_000_000;
            max : integer := 2**4 - 1
        );
        port (
            clk                     : in std_logic;

            reset                   : in std_logic;
            enable                  : in std_logic;
            low_value               : in unsigned;
            high_value              : in unsigned;
            output                  : out unsigned
        );
    end component;

    constant clk_period :           time := 20 ns;

    signal clk                      : std_logic;

    signal reset                    : std_logic := '0';
    signal enable                   : std_logic := '0';
    signal low_value                : unsigned(3 downto 0);
    signal high_value               : unsigned(3 downto 0);
    signal output                   : unsigned(3 downto 0);
begin
    cnt : counter port map (
            clk,
            reset,
            enable,
            low_value,
            high_value,
            output
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
        low_value   <= (3 => '0', others => '1');
        high_value  <= (1 => '1', others => '0');
        reset <= '1';
        enable <= '0';
        wait for 1000 ns;
    
        reset <= '0';
        enable <= '1';
        wait for 1000 ns;
        
        reset <= '0';
        enable <= '0';
        wait for 1000 ns;

        reset <= '0';
        enable <= '1';
        wait for 1000 ns;
        
        enable <= '0';

        wait;
    end process;
end;


