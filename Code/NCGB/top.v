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
    output GB_RST,
    //input GB_RST,
    //RAM&ROM Interface
    output [22:14] ROM_A,
    output [16:13] RAM_A,
    output ROM_CS,
    output RAM_CS,
    output DDIR,
    output DEBUG
    );

reg [8:0] rom_bank = 9'b000000001;
reg [3:0] ram_bank = 4'b0;
reg ram_en = 1'b0; // RAM Access Enable

//reg bank_mask_wen = 1'b0; // Write Enable for Bank Mask
reg game_sel_en = 1'b0;
reg [1:0] game_sel;

assign GB_RST = 1;

wire rom_addr_en;//RW Address in ROM range
wire ram_addr_en;//RW Address in RAM range

wire [15:0] gb_addr;

assign gb_addr[15:12] = GB_A[15:12];
assign gb_addr[11:0] = 12'b0;

assign rom_addr_en =  (gb_addr >= 16'h0000)&(gb_addr <= 16'h7FFF); //Request Addr in ROM range
assign ram_addr_en =  (gb_addr >= 16'hA000)&(gb_addr <= 16'hBFFF); //Request Addr in RAM range
assign rom_addr_lo =  (gb_addr >= 16'h0000)&(gb_addr <= 16'h3FFF); //Request Addr in LoROM range

assign ROM_CS = ((rom_addr_en) & (GB_RST == 1)) ? 0 : 1; //ROM output enable
assign RAM_CS = ((ram_addr_en) & (ram_en) & (GB_RST == 1)) ? 0 : 1; //RAM output enable

wire [22:14] rom_a_pre;
assign rom_a_pre[22:14] = rom_addr_lo ? 9'b0 : rom_bank[8:0];
wire [16:13] ram_a_pre;
assign ram_a_pre[16:13] = ram_bank[3:0];

assign ROM_A[22:21] = (game_sel_en) ? (game_sel[1:0]) : (rom_a_pre[22:21]);
assign ROM_A[20] = ((game_sel_en)&&(game_sel[1:0] == 2'b00)) ? (1'b1) : (rom_a_pre[20]);
assign ROM_A[19:14] = rom_a_pre[19:14];  
assign RAM_A[16:15] = (game_sel_en) ? (game_sel[1:0]) : (ram_a_pre[16:15]);
assign RAM_A[14:13] = ram_a_pre[14:13];

//LOW: GB->CART, HIGH: CART->GB
// ADDR_EN GB_WR DIR
// 0       x     L
// 1       H     H
// 1       L     L
//assign DDIR = (((rom_addr_en) | (ram_addr_en))&(GB_WR)) ? 1 : 0;
// (ROM_CS = 0 | RAM_CS = 0) & RD = 0 -> output, otherwise, input
assign DDIR = (((!ROM_CS) | (!RAM_CS)) & (!GB_RD)) ? 1 : 0;

wire rom_bank_lo_clk;
wire rom_bank_hi_clk;
wire ram_bank_clk;
wire ram_en_clk;
wire bank_mask_clk;
assign rom_bank_lo_clk = (!GB_WR) & (gb_addr == 16'h2000);
assign rom_bank_hi_clk = (!GB_WR) & (gb_addr == 16'h3000);
assign ram_bank_clk = (!GB_WR) & ((gb_addr == 16'h4000) | (gb_addr == 16'h5000));
assign ram_en_clk = (!GB_WR) & ((gb_addr == 16'h0000) | (gb_addr == 16'h1000));
assign bank_mask_clk = (!GB_WR) & (gb_addr == 16'h7000);

always@(negedge rom_bank_lo_clk)
begin
    rom_bank[7:0] <= GB_D[7:0];
end

always@(negedge rom_bank_hi_clk)
begin
    rom_bank[8] <= GB_D[0];
end

always@(negedge ram_bank_clk)
begin
    ram_bank[3:0] <= GB_D[3:0];
end

always@(negedge ram_en_clk)
begin
    ram_en <= (GB_D[3:0] == 4'hA) ? 1 : 0; //A real MBC only care about low bits
end

always@(negedge bank_mask_clk)
begin
    if (game_sel_en == 1'b1) begin
        game_sel[1:0] <= GB_D[1:0];
    end
    else
    begin
        if (GB_D[3:0] == 4'hA) // magic number for bank switch
            game_sel_en <= 1'b1;
    end
end

endmodule
