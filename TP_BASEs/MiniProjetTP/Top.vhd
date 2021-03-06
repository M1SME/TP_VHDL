library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity Top is
    port 
    (
    
     ARst_N_I    :   in std_logic;
     Clk_I        :   in std_logic;
     Led		: out std_logic;
     led_bcd    : out std_logic_vector(3 downto 0);
     segments      :   out std_logic_vector(6 downto 0)
    );
end entity Top;



architecture rtl of Top is

signal Clk1Hz : std_logic ;
signal Cpt10  :  std_logic_vector(3 downto 0);

    begin
   
 top: process(Clk_I, ARst_N_I)

  begin
   
    
    if ARst_N_I = '0' then
  	Led <= '0';
    elsif  rising_edge(Clk_I) then
    
	         Led <= Clk1Hz ;

  end if;
  end process top;
  
  U0_div : entity work.diviseur
  port map
  (
      Clk_O         =>  Clk1Hz,
      Clk_I         =>  Clk_I
  );
  
    U1_cpt : entity work.compteur_bcd
  port map
  (
	  ARst_N_I	=>	ARst_N_I,
      Clk_I         =>  Clk1Hz,
      Cpt         =>  Cpt10
  );
  
   
    led_bcd <=  Cpt10;
   Seg : entity work.decodeur 
    port map
    (
        Clk_I       => Clk1Hz ,
		ARst_N_I    =>   ARst_N_I,
		Cpt10      => Cpt10,
		segments    => segments
	);

   
end architecture rtl;