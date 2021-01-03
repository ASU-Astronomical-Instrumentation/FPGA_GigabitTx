library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package bus_multiplexer_pkg is
    type bus_array is array(natural range <>) of std_logic_vector;
end package;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.bus_multiplexer_pkg.all;

entity data_buffer_tb is
end data_buffer_tb;

architecture testbench of data_buffer_tb is 
    constant N   : integer := 8; -- input data width
    constant data_points  : integer := 4;  -- BINS*PFB_bitwidth/8 "data poin 

    signal clk              : std_logic;
    signal done             : std_logic;
    signal wready, rready   : std_logic;
    signal data_in          : bus_array(0 to data_points)(N-1 downto 0);
        
    signal wvalid,rvalid    : std_logic;
    signal data_out         : bus_array(0 to data_points)(N-1 downto 0);
    --signal empty            : std_logic;
    --signal full             : std_logic;   
    --signal fill_count       : std_logic_vector(N_specs downto 0);

    component data_buffer 
    generic(
        N   : integer := 8; -- input data width
        data_points  : integer := 5;  -- BINS*PFB_bitwidth/8 "data points"
    );
    port(
        clk             : in std_logic;
        done            : in std_logic;
        rready,wready   : in std_logic;
        data_in         : in bus_array(0 to data_points)(N-1 downto 0);

        rvalid,wvalid   : out std_logic;
        data_out        : out bus_array(0 to data_points)(N-1 downto 0)
    );
    end component;
begin

dut : data_buffer
generic map( N=>N, data_points=>data_points )
port map(
    clk         => clk,           
    done        => done,          
    rready      => rready,
    wready      => wready, 
    data_in     => data_in,       
    rvalid      => rvalid,
    wvalid      => wvalid, 
    data_out    => data_out          
);

clk_p : process
begin
    clk <= '0';
    wait for 7 ns;
    clk <= '1';
    wait for 7 ns;
end process;


------------------------------------------------------------------------------------
--
--  TESTBENCH STARTS HERE   
--
------------------------------------------------------------------------------------
main : process 

begin 
    --------------------------------------------------------------------------------------
    --  LOAD 2 READ 2
    --------------------------------------------------------------------------------------
    
    wready <= '0';
    rready <= '0';
    data_in<= (X"00",X"00",X"00",X"00",X"00");
    wait for 25 ns;
    
    
    data_in<= (X"c0",X"ff",X"ee",X"0f",X"f0");
    rready <= '1';
    wait for 11 ns;

    rready <= '0';
    wait for 11 ns;


    data_in<= (X"AB",X"BA",X"0A",X"ff",X"A0");
    rready <= '1';
    wait for 11 ns;
    
    wready <= '0';
    rready <= '0';
    wait for 11 ns;

    wready <= '1';
    rready <= '0';
    data_in<= (X"00",X"00",X"00",X"00",X"00");
    wait for 25 ns;

    wready <= '0';
    wait for 15 ns;
    wready <= '1';
    wait for 15 ns;
    
    rready <= '0';
    wready <= '0';

    data_in<= (X"00",X"00",X"00",X"00",X"00");

    wait;
end process;

end testbench;