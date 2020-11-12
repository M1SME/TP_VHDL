library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity decodeur is
    port 
    (
        Clk_I       :   in  std_logic;
		ARst_N_I    :   in std_logic;
		Cpt10      :   in std_logic_vector(3 downto 0);
		segments      :   out std_logic_vector(6 downto 0)


	);
end entity decodeur;



architecture rtl of decodeur is

 


begin

	pdecodeur: process(Clk_I,ARst_N_I)
    begin
    if ARst_N_I = '0' then
		--- signaux reset ---
		segments <= "1111111";
		elsif  Clk_I = '1' and Clk_I'event then
		
				 
				 if Cpt10 = 0 then 
					segments <= "1000000";
				 end if;
				  if Cpt10 = 1 then 
					segments <= "1111001";
				 end if;
				  if Cpt10 = 2 then 
					segments <= "0100100";
				 end if;
				 if Cpt10 = 3 then 
					segments <= "0110000";
				 end if;
				 if Cpt10 = 4 then 
					segments <= "0011001";
				 end if;
				if Cpt10 = 5 then 
					segments <= "0010010";
				 end if;
				if Cpt10 = 6 then 
					segments <= "0000010";
				 end if;
				if Cpt10 = 7 then 
					segments <= "1111000";
				 end if;
				 if Cpt10 = 8 then 
					segments <= "0000000";
				 end if;
				 if Cpt10 = 9 then 
					segments <= "0010000";
				 end if;
				 
		end if;
	

  end process pdecodeur;
  
	
end architecture rtl;
