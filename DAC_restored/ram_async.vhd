library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ram_async is
    generic (
        address_size :    integer := 6;
        data_size :       integer := 12
    );
    port (
        write_enable :    in std_logic;
        read_address :    in std_logic_vector(address_size - 1 downto 0);
        write_address :   in std_logic_vector(address_size - 1 downto 0);
        data_in :         in std_logic_vector(data_size - 1 downto 0);
        data_out :        out std_logic_vector(data_size - 1 downto 0)
    );
end entity ram_async;

architecture RTL of ram_async is
--    type ram_type is array (0 to 2**address_length - 1) of std_logic_vector(data_range);
    type ram_type is array(2**address_size - 1 downto 0) of std_logic_vector(data_size - 1 downto 0);
    signal ram : ram_type;
--    signal rd_address : std_logic_vector(address_length);
--    signal wr_address : std_logic_vector(address_length);

begin
    ram_async_proc : process(write_enable, write_address, data_in)
    begin
        if (write_enable = '1') then
            ram(to_integer(unsigned(write_address))) <= data_in;
        end if;
        data_out <= ram(to_integer(unsigned(read_address)));
    end process;
end RTL;
