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
  
*///
// data_io.v
//
// data_io for the MiST board
// http://code.google.com/p/mist-board/
//
// Copyright (c) 2014 Till Harbaum <till@harbaum.org>
// Copyright (c) 2015-2017 Sorgelig
// Copyright (c) 2019 György Szombathelyi
//
// This source file is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This source file is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
///////////////////////////////////////////////////////////////////////

module data_io
(
    // Global clock. It should be around 100MHz (higher is better).
    input             clk_sys,

    // Global SPI clock from ARM. 24MHz
    input             SPI_SCK,
    input             SPI_SS2,
    input             SPI_DI,

    // ARM -> FPGA download
    input             ioctl_wait,
    output reg        ioctl_download = 0, // signal indicating an active download
    output reg  [7:0] ioctl_index,        // menu index used to upload the file
    output reg        ioctl_wr = 0,
    output reg [24:0] ioctl_addr,
    output reg [15:0] ioctl_dout
);

///////////////////////////////   DOWNLOADING   ///////////////////////////////

localparam UIO_FILE_TX      = 8'h53;
localparam UIO_FILE_TX_DAT  = 8'h54;
localparam UIO_FILE_INDEX   = 8'h55;
// SPI receiver IO -> FPGA

reg       spi_receiver_strobe_r = 0;
reg       spi_transfer_end_r = 1;
reg [7:0] spi_byte_in;

// data_io has its own SPI interface to the io controller
// Read at spi_sck clock domain, assemble bytes for transferring to clk_sys
always@(posedge SPI_SCK or posedge SPI_SS2) begin

    reg  [6:0] sbuf;
    reg  [2:0] bit_cnt;

    if(SPI_SS2) begin
        spi_transfer_end_r <= 1;
        bit_cnt <= 0;
    end else begin
        spi_transfer_end_r <= 0;
        
        bit_cnt <= bit_cnt + 1'd1;

        if(bit_cnt != 7)
            sbuf[6:0] <= { sbuf[5:0], SPI_DI };

        // finished reading a byte, prepare to transfer to clk_sys
        if(bit_cnt == 7) begin
            spi_byte_in <= { sbuf, SPI_DI};
            spi_receiver_strobe_r <= ~spi_receiver_strobe_r;
        end
    end
end

always @(posedge clk_sys) begin

    reg        spi_receiver_strobe;
    reg        spi_transfer_end;
    reg        spi_receiver_strobeD;
    reg        spi_transfer_endD;
    reg  [7:0] acmd;
    reg  [2:0] abyte_cnt;   // counts bytes
    reg [24:0] addr;
    reg        wr_int;
    reg        clkrefD;
    reg        hi;

    //synchronize between SPI and sys clock domains
    spi_receiver_strobeD <= spi_receiver_strobe_r;
    spi_receiver_strobe <= spi_receiver_strobeD;
    spi_transfer_endD <= spi_transfer_end_r;
    spi_transfer_end <= spi_transfer_endD;

    if (~spi_transfer_endD & spi_transfer_end) begin
        abyte_cnt <= 3'd0;
    end else if (spi_receiver_strobeD ^ spi_receiver_strobe) begin
        if(~&abyte_cnt) abyte_cnt <= abyte_cnt + 1'd1;

        if(abyte_cnt == 0) begin
            acmd <= spi_byte_in;
            hi <= 0;
        end else begin
            case (acmd)
                UIO_FILE_TX: begin
                // prepare 
                    if(spi_byte_in) begin
                        addr <= 25'h804000;
                        ioctl_download <= 1; 
                    end else begin
                        ioctl_addr <= addr;
                        ioctl_download <= 0;
                    end
                end

                // transfer
                UIO_FILE_TX_DAT: begin
                    ioctl_addr <= addr;
                    if (hi) ioctl_dout[15:8] <= spi_byte_in; else ioctl_dout[7:0] <= spi_byte_in;
                    hi <= ~hi;
                    if (hi) wr_int <= 1;
                end

                // expose file (menu) index
                UIO_FILE_INDEX: ioctl_index <= spi_byte_in;
            endcase
        end
    end

    ioctl_wr <= 0;
    if (wr_int & ~ioctl_wait) begin
        addr <= addr + 2'd2;
        ioctl_wr <= 1;
        wr_int <= 0;
    end
end

endmodule
