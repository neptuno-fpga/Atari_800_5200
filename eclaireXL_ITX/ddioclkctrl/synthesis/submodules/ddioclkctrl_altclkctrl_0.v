/*
  
   Multicore 2 / Multicore 2+
  
   Copyright (c) 2017-2020 - Victor Trucco

  
   All rights reserved
  
   Redistribution and use in source and synthezised forms, with or without
   modification, are permitted provided that the following conditions are met:
  
   Redistributions of source code must retain the above copyright notice,
   this list of conditions and the following disclaimer.
  
   Redistributions in synthesized form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
  
   Neither the name of the author nor the names of other contributors may
   be used to endorse or promote products derived from this software without
   specific prior written permission.
  
   THIS CODE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
   AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
   THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
   PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE
   LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
   INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
   ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   POSSIBILITY OF SUCH DAMAGE.
  
   You are responsible for any legal issues arising from your use of this code.
  
*///altclkctrl CBX_SINGLE_OUTPUT_FILE="ON" CLOCK_TYPE="AUTO" DEVICE_FAMILY="Cyclone V" ENA_REGISTER_MODE="double register" USE_GLITCH_FREE_SWITCH_OVER_IMPLEMENTATION="OFF" clkselect ena inclk outclk
//VERSION_BEGIN 16.1 cbx_altclkbuf 2016:10:19:21:26:20:SJ cbx_cycloneii 2016:10:19:21:26:20:SJ cbx_lpm_add_sub 2016:10:19:21:26:20:SJ cbx_lpm_compare 2016:10:19:21:26:20:SJ cbx_lpm_decode 2016:10:19:21:26:20:SJ cbx_lpm_mux 2016:10:19:21:26:20:SJ cbx_mgl 2016:10:19:22:10:30:SJ cbx_nadder 2016:10:19:21:26:20:SJ cbx_stratix 2016:10:19:21:26:20:SJ cbx_stratixii 2016:10:19:21:26:20:SJ cbx_stratixiii 2016:10:19:21:26:20:SJ cbx_stratixv 2016:10:19:21:26:20:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



// Copyright (C) 2016  Intel Corporation. All rights reserved.
//  Your use of Intel Corporation's design tools, logic functions 
//  and other software and tools, and its AMPP partner logic 
//  functions, and any output files from any of the foregoing 
//  (including device programming or simulation files), and any 
//  associated documentation or information are expressly subject 
//  to the terms and conditions of the Intel Program License 
//  Subscription Agreement, the Intel Quartus Prime License Agreement,
//  the Intel MegaCore Function License Agreement, or other 
//  applicable license agreement, including, without limitation, 
//  that your use is for the sole purpose of programming logic 
//  devices manufactured by Intel and sold by Intel or its 
//  authorized distributors.  Please refer to the applicable 
//  agreement for further details.



//synthesis_resources = cyclonev_clkena 1 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  ddioclkctrl_altclkctrl_0_sub
	( 
	clkselect,
	ena,
	inclk,
	outclk) /* synthesis synthesis_clearbox=1 */;
	input   [1:0]  clkselect;
	input   ena;
	input   [3:0]  inclk;
	output   outclk;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
	tri0   [1:0]  clkselect;
	tri1   ena;
	tri0   [3:0]  inclk;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

	wire  wire_sd2_outclk;
	wire  wire_sd1_outclk;
	wire  [1:0]  clkselect_wire;
	wire  [3:0]  inclk_wire;

	cyclonev_clkselect   sd2
	( 
	.clkselect(clkselect_wire),
	.inclk(inclk_wire),
	.outclk(wire_sd2_outclk));
	cyclonev_clkena   sd1
	( 
	.ena(ena),
	.enaout(),
	.inclk(wire_sd2_outclk),
	.outclk(wire_sd1_outclk));
	defparam
		sd1.clock_type = "Auto",
		sd1.ena_register_mode = "double register",
		sd1.lpm_type = "cyclonev_clkena";
	assign
		clkselect_wire = {clkselect},
		inclk_wire = {inclk},
		outclk = wire_sd1_outclk;
endmodule //ddioclkctrl_altclkctrl_0_sub
//VALID FILE // (C) 2001-2016 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.



// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module  ddioclkctrl_altclkctrl_0  (
    ena,
    clkselect,
    inclk0x,
    inclk1x,
    inclk2x,
    inclk3x,
    outclk);

    input    ena;
    input  [1:0]  clkselect;
    input    inclk0x;
    input    inclk1x;
    input    inclk2x;
    input    inclk3x;
    output   outclk;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
    tri1     ena;
    tri0 [1:0]  clkselect;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

    wire  sub_wire0;
    wire  outclk;
    wire  sub_wire1;
    wire [3:0] sub_wire2;
    wire  sub_wire3;
    wire  sub_wire4;
    wire  sub_wire5;

    assign  outclk = sub_wire0;
    assign  sub_wire1 = inclk0x;
    assign sub_wire2[3:0] = {sub_wire5, sub_wire4, sub_wire3, sub_wire1};
    assign  sub_wire3 = inclk1x;
    assign  sub_wire4 = inclk2x;
    assign  sub_wire5 = inclk3x;

    ddioclkctrl_altclkctrl_0_sub  ddioclkctrl_altclkctrl_0_sub_component (
                .clkselect (clkselect),
                .ena (ena),
                .inclk (sub_wire2),
                .outclk (sub_wire0));

endmodule