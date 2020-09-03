library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity Top is
    port 
    (
    
     ARst_N_I    :   in std_logic;
     Clk_I        :   in std_logic;
     Led		: out std_logic
    
    
    );
end entity Top;



architecture rtl of Top is

signal Clk1Hz : std_logic ;

    begin
   
 Add: process(Clk1Hz, ARst_N_I)

  begin
   
    
    if ARst_N_I = '0' then
  	Led <= '0';
    elsif  rising_edge(Clk_I) then
    
	         Leds <= Valeur1 + Valeur2 ;

  end if;
  end process Add;
   

  U0_div : entity work.div
  port map
  (
      Clk_O         =>  Clk1Hz,
      Clk_I         =>  Clk_I
  );

   
end architecture rtl;