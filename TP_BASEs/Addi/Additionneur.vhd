library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity Additionneur is
    port 
    (
    
     ARst_N_I    :   in std_logic;
     Clk_I         :   in std_logic;
     Valeur1	 : in std_logic_vector(2 downto 0);
     Valeur2	 : in std_logic_vector(2 downto 0);  
     Leds_O      :   out std_logic_vector(2 downto 0)	
    );
end entity Additionneur;



architecture rtl of Additionneur is

	

    begin
   
  Add: process(Clk_I, ARst_N_I)

  begin
   
    
    if ARst_N_I = '0' then
  	Leds_O <= "000";
    elsif  rising_edge(Clk_I) then
    
	         Leds_O <= Valeur1 + Valeur2 ;

  end if;
  end process Add;


   
end architecture rtl;