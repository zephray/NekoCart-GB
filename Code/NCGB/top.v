`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:11:40 12/24/2017 
// Design Name: 
// Module Name:    top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module top(
    //Gameboy Interface
    input [15:12] GB_A,
    input [7:0] GB_D,
	 input GB_CS,
	 input GB_WR,
    input GB_RD,
	 input GB_RST,
	 //RAM&ROM Interface
    output [22:14] ROM_A,
    output [16:13] RAM_A,
    output ROM_CS,
    output RAM_CS
    );

reg [8:0] rom_bank;
reg [3:0] ram_bank;
reg ram_en; // RAM Access Enable

wire rom_addr_en;//RW Address in ROM range
wire ram_addr_en;//RW Address in RAM range

wire [15:0] gb_addr;

assign gb_addr[15:12] = GB_A[15:12];
assign gb_addr[11:0] = 12'b0;

assign rom_addr_en =  (gb_addr >= 16'h0000)&(gb_addr <= 16'h7FFF); //Request Addr in ROM range
assign ram_addr_en =  (gb_addr >= 16'hA000)&(gb_addr <= 16'hBFFF); //Request Addr in RAM range

assign ROM_CS = ((rom_addr_en) & (GB_RST == 1)) ? 0 : 1; //ROM output enable
assign RAM_CS = ((ram_addr_en) & (ram_en) & (GB_RST == 1)) ? 0 : 1; //RAM output enable

assign ROM_A[22:14] = rom_bank[8:0];
assign RAM_A[16:13] = ram_bank[3:0];

always@(negedge GB_WR, negedge GB_RST)
begin
  if (GB_RST==0)
  begin
    rom_bank[8:0] <= 9'b000000001;
    ram_bank[3:0] <= 4'b0;
    ram_en <= 1'b0;
  end
  else
  begin
    case (gb_addr)
      16'h0000, 16'h1000: ram_en <= (GB_D[7:0] == 8'h0A) ? 1 : 0;
      16'h2000: rom_bank[7:0] <= GB_D[7:0];
      16'h3000: rom_bank[8] <= GB_D[0];
      16'h4000, 16'h5000: ram_bank[3:0] <= GB_D[3:0];
    endcase
  end
end

endmodule
