library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dflipflop is
    generic (
        data_width : integer := 12
    );
    port (
        clk : in std_logic;
        rst : in std_logic;
        D : in signed(data_width - 1 downto 0);
        Q : out signed(data_width - 1 downto 0)
    );
end dflipflop;

architecture behavior of dflipflop is begin
    process (clk, rst) begin
        if rst = '0' then
            Q <= (others => '0');
        elsif (rising_edge(clk)) then
            Q <= D;
        end if;
    end process;
end behavior;
