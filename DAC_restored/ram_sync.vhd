library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ram_sync is
    generic (
        address_width    : integer := 6;
        data_width       : integer := 12
    );
    port (
        clk             : in std_logic;
        write_enable    : in std_logic;
        read_address    : in unsigned(address_width - 1 downto 0);
        write_address   : in unsigned(address_width - 1 downto 0);
        data_in         : in std_logic_vector(data_width - 1 downto 0);
        data_out        : out std_logic_vector(data_width - 1 downto 0)
    );
end entity ram_sync;

architecture RTL of ram_sync is
--    type ram_type is array (0 to 2**address_length - 1) of std_logic_vector(data_range)
    type ram_type is array(2**address_width - 1 downto 0) of std_logic_vector(data_width - 1 downto 0);
    signal ram : ram_type;
--    signal rd_address : std_logic_vector(address_length);
--    signal wr_address : std_logic_vector(address_length);

begin
    ram_sync_proc : process(clk)
    begin
        if rising_edge(clk) then
            if (write_enable = '1') then
                ram(to_integer(write_address)) <= data_in;
            end if;
            data_out <= ram(to_integer(read_address));
        end if;
    end process;
end RTL;
