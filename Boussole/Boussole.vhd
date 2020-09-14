library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity boussole is
    port 
    (
        CLK_50M         :   in  std_logic;
        RAZ_N           :   in  std_logic;
        IN_PWM_COMPAS   :   in std_logic;
        continu			:   in std_logic;
        start_stop      :   in std_logic;
        
        DATA_VALID      :   out std_logic;
        OUT_1s          :   out std_logic;
        DATA_Compas     :   out std_logic_vector(8 downto 0)
         
    );
end entity boussole;



architecture rtl of boussole is


 constant  angle		:	integer:=365;
 Type etats is (Etatcontinu, Etatmonocoup );
 signal EtatPresent : etats;
 signal EtatSuivant : etats; 
 signal  Acquisition : std_logic;
 signal  Acquisition1s : std_logic;
  signal CLK_1Hz : std_logic;
 signal Clk1000Hz: std_logic;
 signal  cpt     :  std_logic_vector(8 downto 0);
  signal  cptHigth     :  std_logic_vector(8 downto 0);
signal PWM_HIGHT      :  std_logic;

begin

-- Machine ETATs 

      EtatSuivant  <=  Etatmonocoup  when  (EtatPresent = Etatcontinu) and (continu = '0')  else 
				        Etatcontinu   when  (EtatPresent = Etatmonocoup ) and  (continu = '1') else
	  EtatPresent;

 Acquisition  <= '1'  when ((EtatPresent = Etatmonocoup )and (start_stop = '1')) else '0';
 Acquisition1s  <= '1'  when (EtatPresent = Etatcontinu ) else '0';
--Fifo1RdEn <= '1' when ((EtatPresent = un) and ( dFifo1Empty ='0'))    else '0';
--dataTX_EN <= ddFifo1RdEn;



MEF : Process(CLK_50M ,RAZ_N)
Begin 
  if RAZ_N = '0' then
		EtatPresent <= Etatmonocoup;
		-- INIT 
	elsif CLK_50M'event and CLK_50M = '1' then 
		EtatPresent <= EtatSuivant;
	end if;

end process MEF;

-- Fin Machine ETATs 





pAcquisition : Process(CLK_50M, Acquisition, RAZ_N)
Begin 
  if RAZ_N = '0' then
		data_valid <= '0';
		-- INIT 
		elsif  ((CLK_50M = '1' and CLK_50M'event) and (Acquisition = '1')) then
	
			data_valid <= '1';
		
	end if;
end process pAcquisition;



pAcquisition1s : Process(CLK_1Hz,RAZ_N, Clk1000Hz )
Begin 
  if RAZ_N = '0' then
			data_valid <= '0';
		-- INIT 
		elsif  ((CLK_1Hz = '1' and CLK_1Hz'event) and Acquisition1s = '1') then
			
		data_valid <= '1';

	end if;
end process pAcquisition1s;








DetectFrontM : Process(RAZ_N, IN_PWM_COMPAS )
Begin 
  if RAZ_N = '0' then
			PWM_HIGHT <= '0';
		elsif  ((IN_PWM_COMPAS = '1' and IN_PWM_COMPAS'event)) then
		PWM_HIGHT <= '1';
		elsif  ((IN_PWM_COMPAS = '0' and IN_PWM_COMPAS'event)) then
		PWM_HIGHT <= '0';
		
	end if;
end process DetectFrontM;




Calcul : Process(RAZ_N, Clk1000Hz )
Begin 
  if RAZ_N = '0' then
			DATA_Compas <= (others => '0');

		-- INIT 
	
		elsif (Clk1000Hz = '1' and Clk1000Hz'event) then
			cpt <= cpt +1;
			if(PWM_HIGHT <= '1') then 
			cptHigth <= cptHigth +1;
			end if;
			if(cpt > 36)then 
		--	DATA_Compas <= 10/to_integer(signed(cptHigth)); a reprendre 
			cpt <= (others => '0');
			cptHigth <= (others => '0');
			end if;

	end if;
end process Calcul;




-- Components

  U0_div : entity work.diviseur
  port map
  (
      Clk_O         =>  Clk1Hz,
      Clk_I         =>  CLK_50M
  );
  
    U0_div : entity work.diviseur1ms
  port map
  (
      Clk_O         =>  Clk1000Hz,
      Clk_I         =>  CLK_50M
  );


end architecture rtl;
