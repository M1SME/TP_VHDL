-- NMEA_Interface_0.vhd

-- This file was auto-generated as part of a generation operation.
-- If you edit it your changes will probably be lost.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity NMEA_Interface_0 is
	port (
		clk        : in  std_logic                     := '0';             --          clock.clk
		reset_n    : in  std_logic                     := '0';             --          reset.reset_n
		chipselect : in  std_logic                     := '0';             -- avalon_slave_0.chipselect
		write_n    : in  std_logic                     := '0';             --               .write_n
		writedata  : in  std_logic_vector(31 downto 0) := (others => '0'); --               .writedata
		readdata   : out std_logic_vector(31 downto 0);                    --               .readdata
		address    : in  std_logic_vector(2 downto 0)  := (others => '0'); --               .address
		Rx_Pin     : in  std_logic                     := '0';             --    conduit_end.export
		LEDs       : out std_logic_vector(7 downto 0);                     --               .export
		Tx_Pin     : out std_logic                                         --  conduit_end_1.export
	);
end entity NMEA_Interface_0;

architecture rtl of NMEA_Interface_0 is
	component NMEA_Interface is
		port (
			clk        : in  std_logic                     := 'X';             -- clk
			reset_n    : in  std_logic                     := 'X';             -- reset_n
			chipselect : in  std_logic                     := 'X';             -- chipselect
			write_n    : in  std_logic                     := 'X';             -- write_n
			writedata  : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			readdata   : out std_logic_vector(31 downto 0);                    -- readdata
			address    : in  std_logic_vector(2 downto 0)  := (others => 'X'); -- address
			Rx_Pin     : in  std_logic                     := 'X';             -- export
			LEDs       : out std_logic_vector(7 downto 0);                     -- export
			Tx_Pin     : out std_logic                                         -- export
		);
	end component NMEA_Interface;

begin

	nmea_interface_0 : component NMEA_Interface
		port map (
			clk        => clk,        --          clock.clk
			reset_n    => reset_n,    --          reset.reset_n
			chipselect => chipselect, -- avalon_slave_0.chipselect
			write_n    => write_n,    --               .write_n
			writedata  => writedata,  --               .writedata
			readdata   => readdata,   --               .readdata
			address    => address,    --               .address
			Rx_Pin     => Rx_Pin,     --    conduit_end.export
			LEDs       => LEDs,       --               .export
			Tx_Pin     => Tx_Pin      --  conduit_end_1.export
		);

end architecture rtl; -- of NMEA_Interface_0
