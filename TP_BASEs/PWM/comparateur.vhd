library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity Comparateur is
    port 
    (
        Clk_I       :   in  std_logic;
		Cpt         :   in std_logic_vector(15 downto 0);
		Clk_O       :   out  std_logic;
		ARst_N_I    :   in std_logic

	);
end entity Comparateur;



architecture rtl of Comparateur is

 signal sigClk_O :    std_logic;

begin

	pCpt: process(Clk_I,ARst_N_I)
    begin
    if ARst_N_I = '0' then
		sigClk_O <= "00000000000000000";
		elsif  Clk_I = '1' and Clk_I'event then
		
				sigClk_O <= Cpt mod Cpt ;
				
		end if;
	Clk_O <= sigClk_O;

  end process pCpt;
  
	
end architecture rtl;
