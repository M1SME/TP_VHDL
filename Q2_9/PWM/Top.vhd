library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity Top is
    port 
    (
        Clk_I       :   in  std_logic;
		Pwm		    :   out  std_logic;
		ARst_N_I    :   in std_logic;
		clk_O		: out std_logic


	);
end entity Top;



architecture rtl of Top is

 signal sigClk_pwm	:	std_logic;
 constant  freq 		:	integer:=5; ---ajuster freq
 constant  duty		:	integer:=25;
 signal pwm_Oo	:	std_logic;
 
 -- DIV --
 signal clk_Oo		: std_logic;
 signal cpt			:	std_logic_vector(15 downto 0);

-- DUTY --
 signal cpt_duty	:	std_logic_vector(7 downto 0);
 signal clk_duty_Oo	:	std_logic;
 signal cpt_duty_f  :std_logic_vector(7 downto 0);




   
begin

-- Premier Bloc --

   pdiv: process(Clk_I,ARst_N_I)
   begin
   if ARst_N_I = '0' then
		cpt <= "0000000000000000";
		else if rising_edge(Clk_I) then
			cpt <= cpt + 1;
			if cpt >= (freq*1000) then  -- à reprendre 
				clk_Oo <= not(clk_Oo) ;
				cpt <= (others => '0') ;
			end if;
		end if;
	end if;

    end process pdiv;
	clk_O <= clk_Oo;
	
	
-- Second Bloc --

   pduty: process(clk_Oo,ARst_N_I)
   begin
   if ARst_N_I = '0' then
		cpt_duty <= "00000000";
		cpt_duty_f <="00000000";
	elsif  clk_Oo = '1' and clk_Oo'event then
			cpt_duty <= cpt_duty + 1;
			cpt_duty_f <= cpt_duty_f + 1;
			if cpt_duty <= duty   then 
				clk_duty_Oo <= '1' ;
			elsif cpt_duty > duty and cpt_duty_f <100    then 
				clk_duty_Oo <= '0' ;
				end if;
			if cpt_duty_f >= 100 then 
			cpt_duty_f <= "00000000";
			cpt_duty <= "00000000";
		end if;

		end if;


    end process pduty;
	Pwm <= clk_duty_Oo;


	
end architecture rtl;
