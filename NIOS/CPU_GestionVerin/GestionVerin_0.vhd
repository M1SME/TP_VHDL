-- GestionVerin_0.vhd

-- This file was auto-generated as part of a generation operation.
-- If you edit it your changes will probably be lost.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity GestionVerin_0 is
	port (
		clk        : in  std_logic                     := '0';             --          clock.clk
		reset_n    : in  std_logic                     := '0';             --          reset.reset_n
		Write_n    : in  std_logic                     := '0';             -- avalon_slave_0.write_n
		chipselect : in  std_logic                     := '0';             --               .chipselect
		readdata   : out std_logic_vector(31 downto 0);                    --               .readdata
		writedata  : in  std_logic_vector(31 downto 0) := (others => '0'); --               .writedata
		address    : in  std_logic_vector(2 downto 0)  := (others => '0'); --               .address
		Data_IN    : in  std_logic                     := '0';             --    conduit_end.export
		out_PWM    : out std_logic;                                        --               .export
		clk_adc    : out std_logic;                                        --               .export
		out_sens   : out std_logic;                                        --               .export
		cs_n       : out std_logic                                         --               .export
	);
end entity GestionVerin_0;

architecture rtl of GestionVerin_0 is
	component GestionVerin is
		port (
			clk        : in  std_logic                     := 'X';             -- clk
			reset_n    : in  std_logic                     := 'X';             -- reset_n
			Write_n    : in  std_logic                     := 'X';             -- write_n
			chipselect : in  std_logic                     := 'X';             -- chipselect
			readdata   : out std_logic_vector(31 downto 0);                    -- readdata
			writedata  : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			address    : in  std_logic_vector(2 downto 0)  := (others => 'X'); -- address
			Data_IN    : in  std_logic                     := 'X';             -- export
			out_PWM    : out std_logic;                                        -- export
			clk_adc    : out std_logic;                                        -- export
			out_sens   : out std_logic;                                        -- export
			cs_n       : out std_logic                                         -- export
		);
	end component GestionVerin;

begin

	gestionverin_0 : component GestionVerin
		port map (
			clk        => clk,        --          clock.clk
			reset_n    => reset_n,    --          reset.reset_n
			Write_n    => Write_n,    -- avalon_slave_0.write_n
			chipselect => chipselect, --               .chipselect
			readdata   => readdata,   --               .readdata
			writedata  => writedata,  --               .writedata
			address    => address,    --               .address
			Data_IN    => Data_IN,    --    conduit_end.export
			out_PWM    => out_PWM,    --               .export
			clk_adc    => clk_adc,    --               .export
			out_sens   => out_sens,   --               .export
			cs_n       => cs_n        --               .export
		);

end architecture rtl; -- of GestionVerin_0
