----------------------------------------------------------------------------------
-- Author : R. Stephenson
-- Description : Data Buffer for incoming 8bit spectrum data to transmit. 
-- data structure assumes all bins are restructered into appropiate bytes,
-- data held until spectrum data and ethernet module is aviable. 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity data_buffer is
    generic(
        N : integer := 8;
    );
    port(
        clk 
        sclr
        data
    );
end data_buffer;

architecture Behavioral of data_buffer is 

begin


    end Behavioral;