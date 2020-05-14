library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity tb_ram_sync is
    generic (
        address_width :              integer := 6;
        data_width :                 integer := 12
    );
end tb_ram_sync;

architecture behavior of tb_ram_sync is
--    component ram_async
--        generic (
--            address_width :          integer := address_width;
--            data_width :             integer := data_width
--        );
--        port (
--            write_enable :          in std_logic;
--            read_address :          in std_logic_vector;
--            write_address :         in std_logic_vector;
--            data_in :               in std_logic_vector;
--            data_out :              out std_logic_vector
--        );
--    end component;
--

    component ram_sync
        generic (
            address_width :          integer := address_width;
            data_width :             integer := data_width
        );
        port (
            clk :                   in std_logic;
            write_enable :          in std_logic;
            read_address :          in std_logic_vector;
            write_address :         in std_logic_vector;
            data_in :               in std_logic_vector;
            data_out :              out std_logic_vector
        );
    end component;

    constant clk_period :           time := 20 ns;

    signal clk :                    std_logic;
    signal write_enable :           std_logic;
    signal read_address :           std_logic_vector(address_width - 1 downto 0) := (others => '0');
    signal write_address :          std_logic_vector(address_width - 1 downto 0) := (others => '0');
    signal data_in :                std_logic_vector(data_width - 1 downto 0) := (others => '0');

    signal data_out :               std_logic_vector(data_width - 1 downto 0);

begin
--    async : ram_async 
--    generic map (address_width => address_width, data_width => data_width)
--    port map (
--        write_enable => write_enable,
--        read_address => read_address,
--        write_address => write_address,
--        data_in => data_in,
--        data_out => data_out
--    );

    sync : ram_sync 
    generic map (address_width => address_width, data_width => data_width)
    port map (
        clk => clk,
        write_enable => write_enable,
        read_address => read_address,
        write_address => write_address,
        data_in => data_in,
        data_out => data_out
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
        write_enable <= '0';
        write_address <= (0 => '1', others => '0');
        read_address <= (others => '0');
        data_in <= (others => '1');

        wait for 100 ns;

        write_enable <= '0';
        for i in 0 to 5 loop
            read_address <= read_address + "000001";
            write_address <= write_address + "000001";
            data_in <= data_in - x"001";
            wait for clk_period * 5;
        end loop;

        write_enable <= '1';
        for i in 0 to 5 loop
            read_address <= read_address + "000001";
            write_address <= write_address + "000001";
            data_in <= data_in - x"001";
            wait for clk_period * 5;
        end loop;

        write_enable <= '0';

        wait;
    end process;
end;


