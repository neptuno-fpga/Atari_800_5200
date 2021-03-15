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
		
-- ===================================================================================
-- Package / Component definition
-- ===================================================================================

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

PACKAGE sin_cos_pkg IS
  COMPONENT sin_cos
  PORT(
    -- Clock
    clk      : IN  STD_LOGIC;
    clk_ena  : IN  STD_LOGIC;
    -- Sine computation
    sin_ph   : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
    sin_amp  : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
    sin_out  : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
    -- Cosine computation
    cos_ph   : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
    cos_amp  : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
    cos_out  : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
  );
  END COMPONENT;
END PACKAGE;

-- ===================================================================================
-- Entity / Architecture definition
-- ===================================================================================

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY sin_cos IS
  PORT(
    -- Clock
    clk      : IN  STD_LOGIC;
    clk_ena  : IN  STD_LOGIC;
    -- Sine computation
    sin_ph   : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
    sin_amp  : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
    sin_out  : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
    -- Cosine computation
    cos_ph   : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
    cos_amp  : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
    cos_out  : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
  );
END sin_cos;

ARCHITECTURE rtl OF sin_cos IS

  COMPONENT sin_rom IS
  PORT
  (
    clock     : IN STD_LOGIC;
    enable    : IN STD_LOGIC := '1';
    address_a : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
    address_b : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
    q_a       : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    q_b       : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
  END COMPONENT sin_rom;

  SIGNAL sin_val    : STD_LOGIC_VECTOR(8 DOWNTO 0);
  SIGNAL cos_val    : STD_LOGIC_VECTOR(8 DOWNTO 0);
  SIGNAL sin_ph_dly : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL cos_ph_dly : STD_LOGIC_VECTOR(4 DOWNTO 0);

BEGIN

  sin_inst : sin_rom
  PORT MAP
  (
    clock                  => clk,
    enable                 => clk_ena,
    address_a(10 DOWNTO 3) => sin_amp,
    address_a(2)           => sin_ph(2) XOR sin_ph(3),
    address_a(1)           => sin_ph(1) XOR sin_ph(3),
    address_a(0)           => sin_ph(0) XOR sin_ph(3),
    q_a                    => sin_val(7 DOWNTO 0),
    address_b(10 DOWNTO 3) => cos_amp,
    address_b(2)           => cos_ph(2) XOR (NOT cos_ph(3)),
    address_b(1)           => cos_ph(1) XOR (NOT cos_ph(3)),
    address_b(0)           => cos_ph(0) XOR (NOT cos_ph(3)),
    q_b                    => cos_val(7 DOWNTO 0)
  );
  sin_val(8) <= '0';
  cos_val(8) <= '0';
  
  -- Delayed phase for output generation
  sin_ph_dly <= sin_ph WHEN rising_edge(clk);
  cos_ph_dly <= cos_ph WHEN rising_edge(clk);

  -- Output generation using sine and cosine symetries
  sin_cos_gen:
  FOR i IN 0 TO 8 GENERATE
    sin_out(i) <= sin_val(i) XOR sin_ph_dly(4);
    cos_out(i) <= cos_val(i) XOR cos_ph_dly(3) XOR cos_ph_dly(4);
  END GENERATE;

END rtl;