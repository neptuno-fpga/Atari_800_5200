--
-- Multicore 2 / Multicore 2+
--
-- Copyright (c) 2017-2020 - Victor Trucco
--
-- All rights reserved
--
-- Redistribution and use in source and synthezised forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
-- Redistributions of source code must retain the above copyright notice,
-- this list of conditions and the following disclaimer.
--
-- Redistributions in synthesized form must reproduce the above copyright
-- notice, this list of conditions and the following disclaimer in the
-- documentation and/or other materials provided with the distribution.
--
-- Neither the name of the author nor the names of other contributors may
-- be used to endorse or promote products derived from this software without
-- specific prior written permission.
--
-- THIS CODE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
-- THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
-- PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.
--
-- You are responsible for any legal issues arising from your use of this code.
--
		
-- pll_acore_reconfig.vhd

-- Generated using ACDS version 16.1 196

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pll_acore_reconfig is
	port (
		mgmt_clk          : in  std_logic                     := '0';             --          mgmt_clk.clk
		mgmt_reset        : in  std_logic                     := '0';             --        mgmt_reset.reset
		mgmt_waitrequest  : out std_logic;                                        -- mgmt_avalon_slave.waitrequest
		mgmt_read         : in  std_logic                     := '0';             --                  .read
		mgmt_write        : in  std_logic                     := '0';             --                  .write
		mgmt_readdata     : out std_logic_vector(31 downto 0);                    --                  .readdata
		mgmt_address      : in  std_logic_vector(5 downto 0)  := (others => '0'); --                  .address
		mgmt_writedata    : in  std_logic_vector(31 downto 0) := (others => '0'); --                  .writedata
		reconfig_to_pll   : out std_logic_vector(63 downto 0);                    --   reconfig_to_pll.reconfig_to_pll
		reconfig_from_pll : in  std_logic_vector(63 downto 0) := (others => '0')  -- reconfig_from_pll.reconfig_from_pll
	);
end entity pll_acore_reconfig;

architecture rtl of pll_acore_reconfig is
	component altera_pll_reconfig_top is
		generic (
			device_family       : string  := "";
			ENABLE_MIF          : boolean := false;
			MIF_FILE_NAME       : string  := "";
			ENABLE_BYTEENABLE   : boolean := false;
			BYTEENABLE_WIDTH    : integer := 4;
			RECONFIG_ADDR_WIDTH : integer := 6;
			RECONFIG_DATA_WIDTH : integer := 32;
			reconf_width        : integer := 64;
			WAIT_FOR_LOCK       : boolean := true
		);
		port (
			mgmt_clk          : in  std_logic                     := 'X';             -- clk
			mgmt_reset        : in  std_logic                     := 'X';             -- reset
			mgmt_waitrequest  : out std_logic;                                        -- waitrequest
			mgmt_read         : in  std_logic                     := 'X';             -- read
			mgmt_write        : in  std_logic                     := 'X';             -- write
			mgmt_readdata     : out std_logic_vector(31 downto 0);                    -- readdata
			mgmt_address      : in  std_logic_vector(5 downto 0)  := (others => 'X'); -- address
			mgmt_writedata    : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			reconfig_to_pll   : out std_logic_vector(63 downto 0);                    -- reconfig_to_pll
			reconfig_from_pll : in  std_logic_vector(63 downto 0) := (others => 'X'); -- reconfig_from_pll
			mgmt_byteenable   : in  std_logic_vector(3 downto 0)  := (others => 'X')  -- byteenable
		);
	end component altera_pll_reconfig_top;

begin

	pll_acore_reconfig_inst : component altera_pll_reconfig_top
		generic map (
			device_family       => "Cyclone V",
			ENABLE_MIF          => false,
			MIF_FILE_NAME       => "pll_acore.mif",
			ENABLE_BYTEENABLE   => false,
			BYTEENABLE_WIDTH    => 4,
			RECONFIG_ADDR_WIDTH => 6,
			RECONFIG_DATA_WIDTH => 32,
			reconf_width        => 64,
			WAIT_FOR_LOCK       => true
		)
		port map (
			mgmt_clk          => mgmt_clk,          --          mgmt_clk.clk
			mgmt_reset        => mgmt_reset,        --        mgmt_reset.reset
			mgmt_waitrequest  => mgmt_waitrequest,  -- mgmt_avalon_slave.waitrequest
			mgmt_read         => mgmt_read,         --                  .read
			mgmt_write        => mgmt_write,        --                  .write
			mgmt_readdata     => mgmt_readdata,     --                  .readdata
			mgmt_address      => mgmt_address,      --                  .address
			mgmt_writedata    => mgmt_writedata,    --                  .writedata
			reconfig_to_pll   => reconfig_to_pll,   --   reconfig_to_pll.reconfig_to_pll
			reconfig_from_pll => reconfig_from_pll, -- reconfig_from_pll.reconfig_from_pll
			mgmt_byteenable   => "0000"             --       (terminated)
		);

end architecture rtl; -- of pll_acore_reconfig