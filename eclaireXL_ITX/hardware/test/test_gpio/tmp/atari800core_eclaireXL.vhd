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
		
---------------------------------------------------------------------------
-- (c) 2013 mark watson
-- I am happy for anyone to use this for non-commercial use.
-- If my vhdl files are used commercially or otherwise sold,
-- please contact me for explicit permission at scrameta (gmail).
-- This applies for source and binary form and derived works.
---------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all; 
use ieee.numeric_std.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_MISC.all;

LIBRARY work;

ENTITY atari800core_eclaireXL IS 
	PORT
	(
		CLOCK_5 :  IN  STD_LOGIC;

		PS2CLK :  IN  STD_LOGIC;
		PS2DAT :  IN  STD_LOGIC;

		GPIOA :  INOUT  STD_LOGIC_VECTOR(35 DOWNTO 0);
		GPIOB :  INOUT  STD_LOGIC_VECTOR(35 DOWNTO 0);
		GPIOC:  INOUT  STD_LOGIC_VECTOR(35 DOWNTO 0);

		DRAM_BA_0 :  OUT  STD_LOGIC;
		DRAM_BA_1 :  OUT  STD_LOGIC;
		DRAM_CS_N :  OUT  STD_LOGIC;
		DRAM_RAS_N :  OUT  STD_LOGIC;
		DRAM_CAS_N :  OUT  STD_LOGIC;
		DRAM_WE_N :  OUT  STD_LOGIC;
		DRAM_LDQM :  OUT  STD_LOGIC;
		DRAM_UDQM :  OUT  STD_LOGIC;
		DRAM_CLK :  OUT  STD_LOGIC;
		DRAM_CKE :  OUT  STD_LOGIC;
		DRAM_ADDR :  OUT  STD_LOGIC_VECTOR(12 DOWNTO 0);
		DRAM_DQ :  INOUT  STD_LOGIC_VECTOR(15 DOWNTO 0);

		SD_WRITEPROTECT : IN STD_LOGIC;
		SD_DETECT : IN STD_LOGIC;
		SD_DAT1 : OUT STD_LOGIC;
		SD_DAT0 :  IN  STD_LOGIC;
		SD_CLK :  OUT  STD_LOGIC;
		SD_CMD :  OUT  STD_LOGIC;
		SD_DAT3 :  OUT  STD_LOGIC;
		SD_DAT2 : OUT STD_LOGIC;

		--VGA_VS :  OUT  STD_LOGIC;
		--VGA_HS :  OUT  STD_LOGIC;
		--VGA_B :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		--VGA_G :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		--VGA_R :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		TMDS :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);

		VGA_BLANK_N : OUT STD_LOGIC;
		VGA_CLK : OUT STD_LOGIC;
		
		AUDIO_LEFT : OUT STD_LOGIC;
		AUDIO_RIGHT : OUT STD_LOGIC;

		USB2DM: INOUT STD_LOGIC;
		USB2DP: INOUT STD_LOGIC;
		USB1DM: INOUT STD_LOGIC;
		USB1DP: INOUT STD_LOGIC;
		
		ADC_SDA: INOUT STD_LOGIC;
		ADC_SCL: INOUT STD_LOGIC
	);
END atari800core_eclaireXL;

ARCHITECTURE vhdl OF atari800core_eclaireXL IS 

component hq_dac
port (
  reset :in std_logic;
  clk :in std_logic;
  clk_ena : in std_logic;
  pcm_in : in std_logic_vector(19 downto 0);
  dac_out : out std_logic
);
end component;

component pll
	port (
		refclk   : in  std_logic := '0'; --  refclk.clk
		rst      : in  std_logic := '0'; --   reset.reset
		outclk_0 : out std_logic;        -- outclk0.clk
		outclk_1 : out std_logic;        -- outclk1.clk
		outclk_2 : out std_logic;        -- outclk2.clk
		outclk_3 : out std_logic;        -- outclk3.clk
		locked   : out std_logic         --  locked.export
	);
end component;


-- SYSTEM
SIGNAL CLK : STD_LOGIC;
SIGNAL CLK_114 : STD_LOGIC;
SIGNAL SVIDEO_ECS_CLK : STD_LOGIC;
SIGNAL PLL_LOCKED : STD_LOGIC;

-- GPIO test
signal count_reg : std_logic_vector(18 downto 0);
signal count_next : std_logic_vector(18 downto 0);
signal shift_reg : std_logic_vector(35 downto 0);
signal shift_next : std_logic_vector(35 downto 0);
signal shift_trigger : std_logic;

BEGIN 

pllinstance : pll
PORT MAP(refclk => CLOCK_5,
		 outclk_0 => CLK_114,
		 outclk_1 => CLK,
		 outclk_2 => DRAM_CLK,
		 outclk_3 => SVIDEO_ECS_CLK,
		 locked => PLL_LOCKED);


DRAM_CS_N <= '1';
DRAM_BA_0 <= 'Z';
DRAM_BA_1 <= 'Z';
DRAM_RAS_N <= 'Z';
DRAM_CAS_N <= 'Z';
DRAM_WE_N <= 'Z';
DRAM_LDQM <= 'Z';
DRAM_UDQM <= 'Z';
DRAM_CKE <= 'Z';
DRAM_ADDR <= (others=>'Z');
DRAM_DQ <= (others=>'Z');

SD_DAT1 <= 'Z';
SD_DAT2 <= 'Z';
SD_DAT3 <= 'Z';
SD_CMD <= 'Z';
SD_CLK <= 'Z';

USB2DM <= 'Z';
USB2DP <= 'Z';
USB1DM <= 'Z';
USB1DP <= 'Z';
		
ADC_SDA <= 'Z';
ADC_SCL <= 'Z';

--VGA_VS <= 'Z';
--VGA_HS <= 'Z';
--VGA_B <= (others=>'Z');
--VGA_G <= (others=>'Z');
--VGA_R <= (others=>'Z');
VGA_BLANK_N <= '0';
VGA_CLK <= '0';
		
AUDIO_LEFT <= 'Z';
AUDIO_RIGHT <= 'Z';


process(clock_5,pll_locked)
begin
	if (pll_locked='0') then
		shift_reg(35 downto 1) <= (others=>'0');
		shift_reg(0) <= '1';
		count_reg <= (others=>'0');
	elsif (clock_5'event and clock_5='1') then
		shift_reg <= shift_next;
		count_reg <= count_next;
	end if;
end process;

process(shift_reg,shift_trigger)
begin
	shift_next <= shift_reg;
	if (shift_trigger='1') then
		shift_next(35 downto 0) <= shift_reg(34 downto 0)&shift_reg(35);
	end if;
end process;

process(count_reg)
begin
	count_next <= std_logic_vector(unsigned(count_reg)+1);
	shift_trigger <= and_reduce(count_reg);
end process;

--GPIOA <= shift_reg(35 downto 0);
GPIOB <= shift_reg(35 downto 0);
GPIOC <= shift_reg(35 downto 0);

TMDS <= shift_reg(7 downto 0);

GPIOA(35 downto 16) <= (others=>'0');
GPIOA(0) <= '0';
GPIOA(11 downto 5) <= (others=>'0');

GPIOA(4 downto 1) <= shift_reg(3 downto 0);
GPIOA(15 downto 12) <= shift_reg(7 downto 4);

END vhdl;
