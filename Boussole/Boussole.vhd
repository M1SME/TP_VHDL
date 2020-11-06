library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.numeric_std;
use ieee.std_logic_unsigned.all;


entity boussole is
    port 
    (
         clk             :     in  std_logic;
         reset_n         :     in std_logic ;
         IN_PWM_COMPAS   :     in std_logic;
			Leds            :     out std_logic_vector (7 downto 0);
			
			-- SIGNAUX DE DEBUGAGE --
      -- continu			 :     in std_logic;
      -- start_stop      :     in std_logic;
      -- DATA_VALID      :     out std_logic;
      -- OUT_1s          :     out std_logic;
		-- debug_pwm 	    :   	 out std_logic;
      -- ETat_HIGHT	    :	    out std_logic;
      -- ETAT_LOW        :	    out std_logic   
     
       
		-- Interface BUS AVALON ---
		   chipselect, write_n : in std_logic;
			writedata : in std_logic_vector (31 downto 0);
			readdata : out std_logic_vector (31 downto 0);
		 	address: std_logic_vector (1 downto 0)
         
    );
end entity boussole;



architecture rtl of boussole is



   signal  Acquisition        : std_logic;
   signal  Acquisition1s      : std_logic;
   signal  CLK_1Hz            : std_logic;
   signal  Clk1000Hz          : std_logic;
   signal  cptHigth           : std_logic_vector(7 downto 0);
 --signal  PWM_HIGHT          : std_logic;
   signal  dataok             : std_logic;
   signal  ok1s               : std_logic;
   signal  DATA_Compas        : std_logic_vector(7 downto 0);
	signal  DATA_CompasV       : std_logic_vector(7 downto 0);
	signal  data_valid         : std_logic;
   signal  PWM_Hight          : std_logic;
 
 -- debug 
  constant freq 		         :	integer:=5; ---ajuster freq
  constant duty		         :	integer:=20;
 -- signal IN_PWM_COMPAS      :  std_logic;

 
 --BUS AVALON
  signal   start_stop         : std_logic ;
  signal   Clk1Hzevent        : std_logic ;
  signal   continu		    	: std_logic;
  signal   RegistreCtrl       : std_logic_vector(2 downto 0);
  signal   DATA_valid_vector  : std_logic_vector(8 downto 0);

begin

-- GESTION DE DATA_VALID --

Acquisition1s <= '1' when ((continu  = '1')) else '0';
Acquisition <='1' when ((continu  = '0')and (start_stop = '1')) else '0';

ok1s <= '1' when (CLK_1Hz = '1' and  Acquisition1s = '1') else '0'; 
data_valid <=  '1' when (ok1s='1' or Acquisition = '1') else '0';

-- FIN GESTION DE DATA_VALID --





-- GESTION DE DATA_COMPAS  --- 

Calcul : Process(reset_n , Clk1000Hz, IN_PWM_COMPAS )
Begin 
  if reset_n  = '0' then
			DATA_Compas <= (others => '0');

	
		elsif (Clk1000Hz = '1' and Clk1000Hz'event) then
			
			if( IN_PWM_COMPAS = '1' ) then 
			cptHigth <= cptHigth +1;
			end if;
			if( IN_PWM_COMPAS = '0' ) then 
			DATA_compas <= cptHigth ;
			cptHigth <= (others => '0');
			end if;

	end if;
end process Calcul;

-- FIN GESTION DE DATA_COMPAS  --- 




-- ACTUALISATION DATA_COMPAS  --- 
pACTU_SORTIE: process (clk, reset_n )
	begin
		if reset_n  = '0' then
			DatA_CompasV <= (others => '0');
		elsif clk'event and clk = '1' then
		
		if data_VALID ='1'  then
			DatA_CompasV <= datA_Compas;
	end if;
end if;
end process pACTU_SORTIE;
-- FIN ACTUALISATION DATA_COMPAS  --- 


-- DEBUGAGE SUR LES LEDS CARTE DE0 NAO  -- 
  Leds <= DATA_VALID &  datA_CompasV(6 downto 0);
  

  
  
  
  -- ECRITURE SUR LE BUS AVALON  --- 
process_write: process (clk, reset_n )
	begin
		if reset_n  = '0' then
			RegistreCtrl <= (others => '0');
		elsif clk'event and clk = '1' then
		if chipselect ='1' and write_n = '0' then
		if address = "00" then
			continu <= writedata(1);
			start_stop <= writedata(2);
		end if;
	end if;
end if;
end process process_write;
-- FIN ECRITURE SUR LE BUS AVALON  --- 




--  LECTURE SUR LE BUS AVALON  --- 
process_Read: PROCESS(address)
	BEGIN
		case address is
			when "00" => readdata <= X"0000000" & "0" & start_stop &continu  & "0"   ;
			when "01" => readdata <= X"00000" & "000" & DATA_VALID &  datA_CompasV(7 downto 0) ;
			when others => readdata <= (others => '0');
			end case;
END PROCESS process_Read ;
--  LECTURE SUR LE BUS AVALON  --- 





-- Components

  U0_div1 : entity work.diviseur
  port map
  (
      Clk_O         =>  CLK_1Hz,
      Clk_I         =>  clk
  );
  
    U0_div1000 : entity work.diviseur1ms
  port map
  (
      Clk_O         =>  Clk1000Hz,
      Clk_I         =>  clk
  );

  -- debug 
  
 --     DU0_PWM : entity work.pwm
  --port map
  --(
  --     Clk_I       => clk,
--		Pwm		    => IN_PWM_COMPAS,
--		ARst_N_I    =>RAZ_N,
		--freq 		=>freq,
 --       duty		=>duty
--  );


--debug_pwm <= IN_PWM_COMPAS;
end architecture rtl;
