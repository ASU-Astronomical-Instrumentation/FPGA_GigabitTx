library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package bus_multiplexer_pkg is
    type bus_array is array(natural range <>) of std_logic_vector;
end package;

----------------------------------------------------------------------------------
-- Author : R. Stephenson
-- Description : Data Buffer for incoming 8bit spectrum data to transmit. 
-- data structure assumes all bins are restructered into appropiate bytes,
-- data held until spectrum data and ethernet module is aviable. Reading and 
-- writing is symmetric.
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.bus_multiplexer_pkg.all;

entity data_buffer is
    generic(
        N   : integer := 8; -- input data width
        data_points  : integer := 9  -- BINS*PFB_bitwidth/8 "data points"
    );
    port(
        clk             : in std_logic;
        done            : in std_logic;
        rready,wready   : in std_logic;
        data_in         : in bus_array(0 to data_points)(N-1 downto 0);

        rwvalid         : out std_logic;
        data_out        : out bus_array(0 to data_points)(N-1 downto 0)
    );
end data_buffer;

architecture behavioral of data_buffer is 
    signal data_table : bus_array(0 to data_points)(N-1 downto 0) := (others=>(others=>'0'));
    signal loaded_data : std_logic := '0';

begin
    process (clk)
    begin
        if (clk'event and clk='1') then 
            if (loaded_data='0')then
                rwvalid<='1';
                --wvalid<='0';
                if (rready='1') then
                    loaded_data<='1';
                    data_table<=data_in;
                end if;
            else 
                rwvalid<='0';
                if (done='1') then
                    loaded_data<='0';
                    data_table<=(others=>(others=>'0'));
                elsif (wready='1') then
                    data_out <= data_table;
                else 
                    NULL;
                end if;
            end if;
        end if;
    end process;

    end behavioral;