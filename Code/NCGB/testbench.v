`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:20:52 01/14/2018
// Design Name:   top
// Module Name:   C:/Users/ZephRay/Documents/GitHub/NekoCart-GB/Code/NCGB/testbench.v
// Project Name:  NCGB
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testbench;

	// Inputs
	reg [15:12] GB_A;
	reg [7:0] GB_D;
	reg GB_CS;
	reg GB_WR;
	reg GB_RD;
	reg GB_RST;

	// Outputs
	wire [22:14] ROM_A;
	wire [16:13] RAM_A;
	wire ROM_CS;
	wire RAM_CS;
	wire DDIR;
	wire DEBUG;

	// Instantiate the Unit Under Test (UUT)
	top uut (
		.GB_A(GB_A), 
		.GB_D(GB_D), 
		.GB_CS(GB_CS), 
		.GB_WR(GB_WR), 
		.GB_RD(GB_RD), 
		.GB_RST(GB_RST), 
		.ROM_A(ROM_A), 
		.RAM_A(RAM_A), 
		.ROM_CS(ROM_CS), 
		.RAM_CS(RAM_CS), 
		.DDIR(DDIR), 
		.DEBUG(DEBUG)
	);

	initial begin
		// Initialize Inputs
		GB_A = 0;
		GB_D = 0;
		GB_CS = 1;
		GB_WR = 1;
		GB_RD = 1;
		GB_RST = 0;

		// Wait 100 ns for global reset to finish
		#100;
		
		GB_RST = 1;
        
		// Add stimulus here
		GB_A[15:12] = 4'h02;
		GB_D[7:0] = 8'h4C;
		#10;
		GB_WR = 0;
		#10;
		GB_WR = 1;
		#10;
		

	end
      
endmodule

