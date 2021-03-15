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
  
*///////////////////////////////////////////////////////////////////////
////                                                              ////
//// usbSlaveCyc2Wrap_usb1t11.v                                           ////
////                                                              ////
//// This file is part of the usbhostslave opencores effort.
//// <http://www.opencores.org/cores//>                           ////
////                                                              ////
//// Module Description:                                          ////
////   Top level module wrapper. 
////                                                              ////
//// To Do:                                                       ////
//// 
////                                                              ////
//// Author(s):                                                   ////
//// - Steve Fielding, sfielding@base2designs.com                 ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2008 Steve Fielding and OPENCORES.ORG          ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE. See the GNU Lesser General Public License for more  ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from <http://www.opencores.org/lgpl.shtml>                   ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
`include "timescale.v"


module usbSlaveCyc2Wrap_usb1t11(
  clk_i, 
  rst_i,
  address_i, 
  data_i, 
  data_o, 
  we_i, 
  strobe_i,
  ack_o,
  irq, 
  usbClk,
  USBWireVPin,
  USBWireVMin,
  USBWireVPout,
  USBWireVMout,
  USBWireOE_n,
  USBFullSpeed,
  USBDPlusPullup,
  USBDMinusPullup,
  vBusDetect
   );

input clk_i;
input rst_i;
input [7:0] address_i; 
input [7:0] data_i; 
output [7:0] data_o; 
input we_i; 
input strobe_i;
output ack_o;
output irq; 
input usbClk;
input USBWireVPin /* synthesis useioff=1 */;
input USBWireVMin /* synthesis useioff=1 */;
output USBWireVPout /* synthesis useioff=1 */;
output USBWireVMout /* synthesis useioff=1 */;
output USBWireOE_n /* synthesis useioff=1 */;
output USBFullSpeed /* synthesis useioff=1 */;
output USBDPlusPullup;
output USBDMinusPullup;
input vBusDetect;

wire clk_i;
wire rst_i;
wire [7:0] address_i; 
wire [7:0] data_i; 
wire [7:0] data_o; 
wire irq;
wire usbClk;
wire USBWireDataOutTick;
wire USBWireDataInTick;
wire USBFullSpeed;

//internal wiring 
wire slaveSOFRxedIntOut; 
wire slaveResetEventIntOut; 
wire slaveResumeIntOut; 
wire slaveTransDoneIntOut;
wire slaveNAKSentIntOut;
wire slaveVBusDetIntOut;
wire USBWireCtrlOut;
wire [1:0] USBWireDataIn;
wire [1:0] USBWireDataOut;


assign irq = slaveSOFRxedIntOut | slaveResetEventIntOut |
             slaveResumeIntOut | slaveTransDoneIntOut |
             slaveNAKSentIntOut | slaveVBusDetIntOut;

assign USBWireDataIn = {USBWireVPin, USBWireVMin};
assign {USBWireVPout, USBWireVMout} = USBWireDataOut;
assign USBWireOE_n = ~USBWireCtrlOut;

//Parameters declaration: 
defparam usbSlaveInst.EP0_FIFO_DEPTH = 64;
defparam usbSlaveInst.EP0_FIFO_ADDR_WIDTH = 6;
defparam usbSlaveInst.EP1_FIFO_DEPTH = 64;
defparam usbSlaveInst.EP1_FIFO_ADDR_WIDTH = 6;
defparam usbSlaveInst.EP2_FIFO_DEPTH = 64;
defparam usbSlaveInst.EP2_FIFO_ADDR_WIDTH = 6;
defparam usbSlaveInst.EP3_FIFO_DEPTH = 64;
defparam usbSlaveInst.EP3_FIFO_ADDR_WIDTH = 6;
usbSlave usbSlaveInst (
  .clk_i(clk_i),
  .rst_i(rst_i),
  .address_i(address_i),
  .data_i(data_i),
  .data_o(data_o),
  .we_i(we_i),
  .strobe_i(strobe_i),
  .ack_o(ack_o),
  .usbClk(usbClk),
  .slaveSOFRxedIntOut(slaveSOFRxedIntOut),
  .slaveResetEventIntOut(slaveResetEventIntOut),
  .slaveResumeIntOut(slaveResumeIntOut),
  .slaveTransDoneIntOut(slaveTransDoneIntOut),
  .slaveNAKSentIntOut(slaveNAKSentIntOut),
  .slaveVBusDetIntOut(slaveVBusDetIntOut),
  .USBWireDataIn(USBWireDataIn),
  .USBWireDataInTick(USBWireDataInTick),
  .USBWireDataOut(USBWireDataOut),
  .USBWireDataOutTick(USBWireDataOutTick),
  .USBWireCtrlOut(USBWireCtrlOut),
  .USBFullSpeed(USBFullSpeed),
  .USBDPlusPullup(USBDPlusPullup),
  .USBDMinusPullup(USBDMinusPullup),
  .vBusDetect(vBusDetect)
);


endmodule

  
  




