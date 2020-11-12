library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity diviseur is
    port 
    (
        Clk_I       :   in  std_logic;
        Clk_O       :   out std_logic
    );
end entity diviseur;



architecture rtl of diviseur is

    signal cpt :   STD_LOGIC_VECTOR (25 downto 0) ;
	signal clk_Oo : std_logic ;


begin

    pdiv: process(Clk_I)
    begin
        if rising_edge(Clk_I) then
              cpt <= cpt + 1;
			if cpt >= 25000000 then 
            clk_Oo <= not(clk_Oo) ;
            cpt <= (others => '0') ;
			end if;
        end if;
    end process pdiv;
	clk_O <= clk_Oo;
	
end architecture rtl;
