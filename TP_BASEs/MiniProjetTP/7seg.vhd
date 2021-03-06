library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity decodeur is
    port 
    (
        Clk_I       :   in  std_logic;
		Cpt      :   in std_logic_vector(3 downto 0);
		ARst_N_I    :   in std_logic;
		Cpt      :   in std_logic_vector(3 downto 0);
		7segments      :   out std_logic_vector(6 downto 0)


	);
end entity decodeur;



architecture rtl of 7seg is

 


begin

	pdecodeur: process(Clk_I,ARst_N_I)
    begin
    if ARst_N_I = '0' then
		--- signaux reset ---
		7segments <= "1111111";
		elsif  Clk_I = '1' and Clk_I'event then
		
				 
				 if Cpt = "0" then 
					7segments <= "1000000";
				 end if;
				  if Cpt = "1" then 
					7segments <= "1111100";
				 end if;
				  if Cpt = "2" then 
					7segments <= "0010010";
				 end if;
				 if Cpt = "3" then 
					7segments <= "0011000";
				 end if;
				 if Cpt = "4" then 
					7segments <= "0101100";
				 end if;
				if Cpt = "5" then 
					7segments <= "0001001";
				 end if;
				if Cpt = "6" then 
					7segments <= "0000001";
				 end if;
				if Cpt = "7" then 
					7segments <= "1011100";
				 end if;
				 if Cpt = "8" then 
					7segments <= "0000000";
				 end if;
				 if Cpt = "9" then 
					7segments <= "0001000";
				 end if;
				 
		end if;
	

  end process pdecodeur;
  
	
end architecture decodeur;
