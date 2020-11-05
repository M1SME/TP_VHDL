-- boussole_0.vhd

-- This file was auto-generated as part of a generation operation.
-- If you edit it your changes will probably be lost.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity boussole_0 is
	port (
		clk           : in  std_logic                     := '0';             --          clock.clk
		reset_n       : in  std_logic                     := '0';             --          reset.reset_n
		chipselect    : in  std_logic                     := '0';             -- avalon_slave_0.chipselect
		write_n       : in  std_logic                     := '0';             --               .write_n
		writedata     : in  std_logic_vector(31 downto 0) := (others => '0'); --               .writedata
		readdata      : out std_logic_vector(31 downto 0);                    --               .readdata
		address       : in  std_logic_vector(1 downto 0)  := (others => '0'); --               .address
		Leds          : out std_logic_vector(7 downto 0);                     --    conduit_end.export
		IN_PWM_COMPAS : in  std_logic                     := '0'              --               .export
	);
end entity boussole_0;

architecture rtl of boussole_0 is
	component boussole is
		port (
			clk           : in  std_logic                     := 'X';             -- clk
			reset_n       : in  std_logic                     := 'X';             -- reset_n
			chipselect    : in  std_logic                     := 'X';             -- chipselect
			write_n       : in  std_logic                     := 'X';             -- write_n
			writedata     : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			readdata      : out std_logic_vector(31 downto 0);                    -- readdata
			address       : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- address
			Leds          : out std_logic_vector(7 downto 0);                     -- export
			IN_PWM_COMPAS : in  std_logic                     := 'X'              -- export
		);
	end component boussole;

begin

	boussole_0 : component boussole
		port map (
			clk           => clk,           --          clock.clk
			reset_n       => reset_n,       --          reset.reset_n
			chipselect    => chipselect,    -- avalon_slave_0.chipselect
			write_n       => write_n,       --               .write_n
			writedata     => writedata,     --               .writedata
			readdata      => readdata,      --               .readdata
			address       => address,       --               .address
			Leds          => Leds,          --    conduit_end.export
			IN_PWM_COMPAS => IN_PWM_COMPAS  --               .export
		);

end architecture rtl; -- of boussole_0
