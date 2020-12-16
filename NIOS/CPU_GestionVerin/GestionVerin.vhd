library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.numeric_std;
use ieee.std_logic_unsigned.all;


entity GestionVerin is
    port 
    (
         clk                          :     in  std_logic;
         reset_n                      :     in std_logic ;
         Write_n                      :     in std_logic;
			Data_IN                      :     in std_logic;
			out_PWM 							  :     out std_logic;
			clk_adc							  :     out std_logic;
			out_sens							  :     out std_logic;
			cs_n								  :     out std_logic;
			
			chipselect 						  :     in std_logic;
			readdata  						  :     out std_logic_vector (31 downto 0);
			writedata                   : in std_logic_vector (31 downto 0);
			address                     : std_logic_vector (2 downto 0)
			
			
         
    );
end entity GestionVerin;



architecture rtl of GestionVerin is

-- Signaux AVALON  -- 

signal freq  : std_logic_vector (15 downto 0);
signal duty  : std_logic_vector (15 downto 0);
signal butee_g  : std_logic_vector (15 downto 0);
signal butee_d  : std_logic_vector (15 downto 0);
signal config  : std_logic_vector (4 downto 0);
signal Angle_barre  : std_logic_vector (11 downto 0);

-- Signaux internes -- 
signal raz_n      			       : std_logic;  
signal enable_pwm      			    : std_logic;  
signal sens_rotation					 : std_logic;
signal fin_course_d					 : std_logic;
signal fin_course_g      			 : std_logic;  

signal counter                    : std_logic_vector( 12 downto 0);
signal pwm_on                     : std_logic;
signal pwm 								 : std_logic;

-- Signaux generation horloge --

signal   cpt1Mhz 							: std_logic_vector(7 downto 0);
signal	en1Mhz       					: std_logic;

signal   cpt100ms                   : std_logic_vector(31 downto 0);
signal   start_conv 						: std_logic;

--Signaux MEF ADC --

Type states is (MEFwait, MEFLaunchAcq);
signal NextState      : states; 
signal CurrentState   : states;
signal DataIN_CAN     : std_logic_vector(11 downto 0);
signal cptDATA 		 : std_logic_vector(7 downto 0);
signal endAcq 			 : std_logic ;


Begin 


-- GESTION PWM --- 
divide: process (clk, reset_n)
begin
	   	if reset_n = '0' then
				counter <= (others => '0');
			elsif clk'event and clk = '1' then
			--if control(1) ='1' then
			if counter >= freq then
				counter <= (others => '0');
			else
				counter <= counter + 1;
			end if;
			--end if;
		end if;
		end process divide;
		
compare: process (clk, reset_n)
		begin
	  if reset_n = '0' then
				pwm_on <= '1';
		elsif clk'event and clk = '1' then
		if counter >= duty then
			pwm_on <= '0';
		elsif counter = 0 then
			pwm_on <= '1';
		end if;
	 end if;
end process compare;
PWM <= pwm_on;




-- GESTION BUTEES --- 

-- a revoir 
butees: process (clk, reset_n)
	
begin
	  if reset_n = '0' then
			
		elsif clk'event and clk = '1' then
			if sens_rotation = '0' then 
				fin_course_d <= '0';
				fin_course_g <= '1';
				if angle_barre < butee_g then 
					out_PWM <= PWM;
				else
					out_PWM <= '0';
				end if;
			elsif sens_rotation = '1' then 
				fin_course_d <= '1';
				fin_course_g <= '0';
				if angle_barre < butee_d then 
					out_PWM <= PWM;
				else
					out_PWM <= '0';
				end if;
			
			end if;
		end if;
		
end process butees;



-- Horloge 1Mhz --- 


p1Mhz: process (clk, reset_n)
	
begin
	  if reset_n = '0' then
			cpt1Mhz <=  (others => '0');
			en1Mhz <= '0';
		elsif clk'event and clk = '1' then
			cpt1Mhz <= cpt1Mhz +1 ;
			if(cpt1Mhz <= 25)then 
			clk_adc <= '0';
			elsif ( cpt1Mhz > 25)then 
			clk_adc <= '1';
			end if;
			if(cpt1Mhz = 50) then 
				en1Mhz <= '1';
				cpt1Mhz <=  (others => '0');
			else 
				en1Mhz <= '0';
			end if;
		end if;
		
end process p1Mhz;



p100ms: process (clk, reset_n)
	
begin
	  if reset_n = '0' then
			cpt100ms <=  (others => '0');
			start_conv <= '0';
		elsif clk'event and clk = '1' then
			cpt100ms <= cpt100ms +1 ;
			if(cpt100ms = 5000000) then 
				start_conv <= '1';
				cpt100ms <=  (others => '0');
			else 
				start_conv <= '0';
			end if;
		end if;
		
end process p100ms;


-- MEF RECEPTION 


NextState  <=  MEFLaunchAcq  when  (CurrentState = MEFWait) and (start_conv = '1')  else 
				   MEFWait   when  (CurrentState = MEFLaunchAcq ) and  (endAcq = '1') else
				CurrentState;

 -- Actions RECEPTION --



cs_n <= '0' when ((CurrentState = MEFLaunchAcq)) else '1';

-- ACTUALISATION CURRENT STATE RECEPTION
pactualisation : Process(Clk, reset_n)
Begin 

	if reset_n = '0' then 
	   CurrentState <= MEFWait;

	elsif Clk'event and Clk = '1' and en1Mhz = '1' then 
		CurrentState <= NextState;
	end if;

end process pactualisation;


-- Registre a decalage
pRshift : Process(Clk, reset_n)
Begin 

	if reset_n = '0' then 
	  
			cptDATA <= (others => '0');
			DataIN_CAN <= (others => '0' );
			endAcq <= '0';
	elsif Clk'event and Clk = '1' and en1Mhz = '1' and currentState = MEFLaunchAcq then

			cptDATA <= cptDATA + 1;
			if(cptDATA >=2)then 
				DataIN_CAN <= Data_IN & DataIN_CAN(11 downto 1);
			end if;
			if(cptDATA >= 14) then 
			cptDATA <= (others => '0');
			angle_barre <= DataIN_CAN;
			endAcq  <= '1';
			else  
			endAcq <= '0';
			end if;
	
	end if;

end process pRshift;















  -- ECRITURE SUR LE BUS AVALON  --- 
process_write: process (clk, reset_n )
	begin
		if reset_n  = '0' then
			raz_n <= '0';
			freq <= (others => '0');
			duty <= (others => '0');
			butee_g <= (others => '0');
			butee_d <= (others => '0');
			enable_pwm <= '0';
			sens_rotation <= '0';

			
		elsif clk'event and clk = '1' then
		if chipselect ='1' and write_n = '0' then
		if address = "000" then
		  
			 freq  <= writedata(15 downto 0);
		end if;
		if address = "001" then
			duty <= writedata(15 downto 0);
		end if;
		if address = "010" then
			butee_g <= writedata(15 downto 0);
		end if;
		if address = "011" then
			butee_d <= writedata(15 downto 0);
		end if;
		if address = "100" then
			raz_n <= writedata(0);
			enable_pwm <= writedata(1);
			sens_rotation <= writedata(2);
		--	fin_course_d <= writedata(3);
		--	fin_course_g <= writedata(4);
		end if;
	end if;
end if;
end process process_write;
-- FIN ECRITURE SUR LE BUS AVALON  --- 




--  LECTURE SUR LE BUS AVALON  --- 
process_Read: PROCESS(address)
	BEGIN
		case address is
			when "000" => readdata <= X"0000"   & freq(15 downto 0)    ;
			when "001" => readdata <= X"0000"   & duty(15 downto 0)    ;
			when "010" => readdata <= X"0000"   & butee_g(15 downto 0) ;
			when "011" => readdata <= X"0000"   & butee_d(15 downto 0) ;
			when "100" => readdata <= X"000000" & "000"  &  fin_course_g & fin_course_d  & sens_rotation  & enable_pwm &   raz_n;
			when "110" => readdata <= X"00000" & Angle_barre;
			
			when others => readdata <= (others => '0');
			end case;
END PROCESS process_Read ;

--FIN  LECTURE SUR LE BUS AVALON  ---



end architecture rtl;
