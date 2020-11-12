library IEEE; 
use IEEE.std_logic_1164.all;



entity Top is
    port(A, B, Clk : in  std_logic; 
         S,: out std_logic); 
end Top; 




architecture rtl of Top is
begin
    
    process(Clk)
    Begin 
    
    if( Rising_Edge(Clk)) then 
    
    
    else 
    
    end if; 
    
  
    
    
end rtl;