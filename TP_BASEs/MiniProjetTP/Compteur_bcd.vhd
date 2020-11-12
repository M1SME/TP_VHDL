library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity compteur_bcd is
    port 
    (
        Clk_I       :   in  std_logic;
		Cpt      :   out std_logic_vector(3 downto 0);
		ARst_N_I    :   in std_logic

	);
end entity compteur_bcd;



architecture rtl of compteur_bcd is

 signal Cpt_interne :   STD_LOGIC_VECTOR (3 downto 0) ;


begin

	pCpt: process(Clk_I,ARst_N_I)
    begin
    if ARst_N_I = '0' then
		Cpt_interne <= "0000";
		elsif  Clk_I = '1' and Clk_I'event then
		
				 Cpt_interne <= Cpt_interne + 1 ;
				 if Cpt_interne >= 9 then 
					Cpt_interne <= "0000";

				end if;
		end if;
	Cpt <= Cpt_interne;

  end process pCpt;
  
	
end architecture rtl;
