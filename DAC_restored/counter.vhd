library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity counter is
    generic (
        freq : integer := 50_000_000;
        max : integer := 63
    );
    port (
        clk : in std_logic;
        reset : in std_logic;
        enable : in std_logic;
        low_value : in unsigned(integer(floor(log2(real(max)))) downto 0);
        high_value : in unsigned(integer(floor(log2(real(max)))) downto 0);
        output : out unsigned(integer(floor(log2(real(max)))) downto 0)
    );
end entity;

architecture RTL of counter is
    constant div : integer := 50_000_000 / freq;
begin
    process (clk)
        variable cycles : unsigned(integer(floor(log2(real(div)))) downto 0);
        variable count : unsigned(integer(floor(log2(real(max)))) downto 0);
    begin
        if (rising_edge(clk)) then
            if (reset = '1') then
                cycles := (others => '0');
                count := low_value;
            elsif (enable = '1') then
                cycles := cycles + 1;
                if (cycles = div) then
                    cycles := (others => '0');
                    if (count = high_value) then
                        count := low_value;
                    else
                        count := count + 1;
                    end if;
                end if;
            end if;
        end if;

        output <= count;
    end process;
end;

