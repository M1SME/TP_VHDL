library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.numeric_std;
use ieee.std_logic_unsigned.all;


entity NMEA_Emission is
    port 
    (
         clk                         :     in  std_logic;
         reset_n                     :     in std_logic ;
         Rx_Pin                      :     in std_logic;
			Tx_Pin                      :     out std_logic;
			
			
			--    Debug Pins      --
			LEDs                        :      out std_logic_vector(7 downto 0);
			--Clk4800		             :      out std_logic
			En1Hz 							 :      out std_logic
			

         
			);
end entity NMEA_Emission;



architecture rtl of NMEA_Emission is

-- Signaux diviseur horloge 50M to 4800 Hz -- 
signal cptDivide    			    : std_logic_vector (31 downto 0);
signal En4800Hz     			    : std_logic ;


-- Signaux diviseur horloge 50M to 1Hz -- 
signal Sig1Hz      			    : std_logic;  
signal cptDivide1Hz 			    : std_logic_vector (31 downto 0);

-- Signaux Machine a état emission -- 

Type states is (EmissionWait, EmissionWrite);
signal NextState     			 : states; 
signal CurrentState   			 : states;
signal LaunchEmission 			 : std_logic;
signal Emissionok     			 : std_logic;

-- Signaux diviseur horloge 50M to 4800 Hz -- 
signal data : std_logic_vector (7 downto 0);


-- Write signaux --
signal  cptwitedata     		 :  std_logic_vector (4 downto 0);
signal  Data_out         		 :  std_logic_vector (39 downto 0); 
signal  Trame_envoie				 : std_logic_vector(39 downto 0 );
signal  TRAME            		 :  std_logic_vector( 31 downto 0); 
signal  cptEmission      		 : std_logic_vector (8 downto 0);
signal  Lancement1Emission	    : std_logic ;
signal  SigLed1Hz          	 : std_logic;





Begin 



-- MEF EMISSION 

NextState  <=  EmissionWrite  when  (CurrentState = EmissionWait) and (LaunchEmission = '1')  else 
				   EmissionWait   when  (CurrentState = EmissionWrite ) and  (Emissionok = '1') else
				CurrentState;

 -- Actions MEF EMISSION  --

Lancement1Emission <= '1' when (CurrentState = EmissionWrite) else '0';

-- DEBUG MEF EMISSION
--LEDs  <=  SigLed1Hz & "0001111" when  (CurrentState = EmissionWait)  else 
--          SigLed1Hz & "1110000" when  (CurrentState = EmissionWrite) else ( others => '0');



-- ACTUALISATION CURRENT STATE EMISSION
pactualisation : Process(Clk, reset_n)
Begin 

	if reset_n = '0' then 
	   CurrentState <= EmissionWait;

	elsif Clk'event and Clk = '1' then 
		CurrentState <= NextState;
	end if;

end process pactualisation;



-- Preparation a l'emission
pprepaemission : Process(Clk, reset_n)
Begin 

	if reset_n = '0' then 
	   LaunchEmission <= '0';

	elsif Clk'event and Clk = '1' then 
	
			if Sig1Hz = '1' and (CurrentState = EmissionWait) then
			     LaunchEmission <= '1'; 
		   else 
				  LaunchEmission <= '0';
			end if;	
	end if;

end process pprepaemission;




Data_out <= "1011000010101100001010110000101011000010";
-- Emission
pemission : Process(Clk, reset_n)
Begin 

	if reset_n = '0' then 
          Tx_Pin <= '1';
			 cptEmission <= (others => '0');
			 Emissionok <= '0';
			 Trame_envoie <= ( others => '0');
		
	elsif Clk'event and Clk = '1' then 
		
		   if (CurrentState = EmissionWait) then  
				  Emissionok <= '0';
				  
			elsif(Lancement1Emission = '1' and En4800Hz = '1' ) then 
					cptEmission <= cptEmission +1;
				
					if cptEmission > "00101001"  then
							cptEmission <= (others => '0');
							Emissionok <= '1';
							Tx_Pin <= '1';
							Trame_envoie <= Data_out;
				  else 
				     Tx_Pin <= Trame_envoie(0);
				     Trame_envoie <= "1" & Trame_envoie(39 downto 1);

					end if;
			end if;

	end if;

end process pemission;

























-- Process diviseur horloge 50M to  1Hz -- 
pDivide50Mto1Hz : Process(reset_n ,  clk )
Begin 
  if reset_n  = '0' then
			-- set signaux to 0
			Sig1Hz <= '0' ;
			cptDivide1Hz <= (others => '0') ;
	
		elsif (clk = '1' and clk'event) then
			
			cptDivide1Hz <= cptDivide1Hz + 1;
			
			if cptDivide1Hz > 50000000 then 
					Sig1Hz <= '1' ;
						SigLed1Hz <= not SigLed1Hz;
					--Sig1Hz <= not Sig1Hz ;
					cptDivide1Hz <= (others => '0') ;
					
			else 
				   Sig1Hz <= '0';
			end if;
			
	end if;
		
end process pDivide50Mto1Hz;

-- DEBUG 
--En1Hz <= Sig1Hz;









-- Process diviseur horloge 50M to 4800 Hz -- 
pDivide50Mto4800Hz : Process(reset_n ,  clk )
Begin 
  if reset_n  = '0' then
			-- set signaux to 0
			En4800Hz <= '0' ;
			cptDivide <= (others => '0') ;
	   --elsif startBIT = '1' and (clk = '1' and clk'event) then 
	    --  cptDivide <=  "00000000000000000010100010101010";
		   --cptDivide <=  (others => '0');
	
		elsif (clk = '1' and clk'event) then
			
			cptDivide <= cptDivide + 1;
			
			if cptDivide >= 10417 then 
					En4800Hz <= '1' ;
					cptDivide <= (others => '0') ;
		   else 
					En4800Hz <= '0' ;
			end if;
			
	end if;
		
end process pDivide50Mto4800Hz;









end architecture rtl;
