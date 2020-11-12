library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.numeric_std;
use ieee.std_logic_unsigned.all;


entity NMEA_Interface is
    port 
    (
         clk                         :     in  std_logic;
         reset_n                     :     in std_logic ;
         Rx_Pin                      :     in std_logic;
			--Tx_Pin                    :     out std_logic;
			
			
			--    Debug Pins      --
			LEDs                        :      out std_logic_vector(7 downto 0);
			--Clk4800		             :      out std_logic
			
			
			-- Interface BUS AVALON ---
		   chipselect, write_n         : in std_logic;
			writedata                   : in std_logic_vector (31 downto 0);
			readdata                    : out std_logic_vector (31 downto 0);
		 	address                     : std_logic_vector (2 downto 0)
         
    );
end entity NMEA_Interface;



architecture rtl of NMEA_Interface is

-- Signaux diviseur horloge 50M to 4800 Hz -- 
signal cptDivide : std_logic_vector (31 downto 0);
signal En4800Hz  : std_logic ;

-- Signaux Machine a état reception -- 

Type states is (MEFwait, MEFwrite);
signal NextState      : states; 
signal CurrentState   : states;
signal StartBIT       : std_logic;
signal StopBIT        : std_logic;
signal Attente_start  : std_logic;
signal Ecriture8DAta  : std_logic;

-- Signaux diviseur horloge 50M to 4800 Hz -- 
signal data : std_logic_vector (7 downto 0);


-- ReadDataIN signaux --
signal  cptwitedata      :  std_logic_vector (4 downto 0);
signal  Data_IN          :  std_logic_vector (7 downto 0);  
signal  TRAME            :  std_logic_vector( 31 downto 0); 

--  Interface AVALLON --
signal  fin_transmit, start_stop, raz_n      :  std_logic;
signal  synchro, centaine, dizaine, unite    :  std_logic_vector(7 downto 0);



Begin 



-- MEF RECEPTION 


NextState  <=  MEFwrite  when  (CurrentState = MEFWait) and (StartBIT = '1')  else 
				   MEFWait   when  (CurrentState = MEFwrite ) and  (StopBIT = '1') else
				CurrentState;

 -- Actions --
Attente_start <='1' when ((CurrentState = MEFWait)) else '0';
Ecriture8DAta <= '1' when ((CurrentState = MEFwrite)) else '0';
--BufferRxReady <= '1' when (CurrentState = FifoWrite) and (Rx_DV = '0')   else '0';
--Fifo2WrEn <= '1' when ((CurrentState = FifoWrite) or(NextState = FifoWrite)) and (Rx_DV = '1') else '0' ;



-- ACTUALISATION CURRENT STATE
pactualisation : Process(Clk, reset_n)
Begin 

	if reset_n = '0' then 
	   CurrentState <= MEFWait;

	elsif Clk'event and Clk = '1' then 
		CurrentState <= NextState;
	end if;

end process pactualisation;


-- GESTION RS232 Bit start
pstartbit : Process(Clk, reset_n)
Begin 

	if reset_n = '0' then 
	  StartBIT <=  '0';

	elsif Clk'event and Clk = '1' then 
		--if(En4800Hz = '1' ) then 
		
				if( Rx_Pin = '0' and Attente_start = '1' ) then 
						StartBIT <=  '1';
				else 
					StartBIT <=  '0';
				end if;
		--end if;
	end if;

end process pstartbit ;


-- GESTION RS232 ecriture data
pwritedata : Process(Clk, reset_n)
Begin 

	if reset_n = '0' then 
	  cptwitedata <=  (others => '0');
	  Data_IN <= (others => '0');
	  TRAME  <= (others => '0');


	elsif Clk'event and Clk = '1' then 
		if(En4800Hz = '1' and Ecriture8DAta = '1' ) then 
		
			cptwitedata <=  cptwitedata +1 ;
			if(cptwitedata = "1001" and Rx_Pin = '1') then 
					cptwitedata <= (others => '0');
					StopBIT <= '1';
					
					TRAME <= Data_IN(7 downto 0) & TRAME(31 downto 8) ;
			end if;
			
			if(cptwitedata < "1001") then 
					Data_IN <=  Rx_Pin & Data_IN(7 downto 1);
					
			end if;

		
		else 
			Data_IN <=  Data_IN ;
			cptwitedata <= cptwitedata;
			StopBIT <= '0';
		
			
		end if;
	end if;

end process pwritedata  ;


LEDs <= TRAME(7 downto 0);

































  -- ECRITURE SUR LE BUS AVALON  --- 
process_write: process (clk, reset_n )
	begin
		if reset_n  = '0' then
			raz_n <= '0';
			start_stop <= '0';
			fin_transmit <= '0';
			synchro <= (others => '0');
			unite <= (others => '0');
			centaine <= (others => '0');
			dizaine <= (others => '0');
		elsif clk'event and clk = '1' then
		if chipselect ='1' and write_n = '0' then
		if address = "000" then
		   raz_n <= writedata(0);
			start_stop <= writedata(1);
			fin_transmit <= writedata(2);
		end if;
		if address = "001" then
			synchro <= writedata(7 downto 0);
		end if;
		if address = "010" then
			centaine <= writedata(7 downto 0);
		end if;
		if address = "011" then
			dizaine <= writedata(7 downto 0);
		end if;
		if address = "100" then
			unite <= writedata(7 downto 0);
		end if;
	end if;
end if;
end process process_write;
-- FIN ECRITURE SUR LE BUS AVALON  --- 




--  LECTURE SUR LE BUS AVALON  --- 
process_Read: PROCESS(address)
	BEGIN
		case address is
			when "000" => readdata <= X"0000000" & "0" & fin_transmit &start_stop  & raz_n  ;
			when "001" => readdata <= X"000000" &  TRAME(7 downto 0)  ;
			when "010" => readdata <= X"000000" &  TRAME(15 downto 8) ;
			when "011" => readdata <= X"000000" &  TRAME(23 downto 16)  ;
			when "100" => readdata <= X"000000" &  TRAME(31 downto 24)   ;
			
			when others => readdata <= (others => '0');
			end case;
END PROCESS process_Read ;

--FIN  LECTURE SUR LE BUS AVALON  ---









-- Process diviseur horloge 50M to 4800 Hz -- 
pDivide50Mto4800Hz : Process(reset_n ,  clk )
Begin 
  if reset_n  = '0' then
			-- set signaux to 0
			En4800Hz <= '0' ;
			cptDivide <= (others => '0') ;
	   elsif startBIT = '1' and (clk = '1' and clk'event) then 
	      cptDivide <=  "00000000000000000010100010101010";
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
