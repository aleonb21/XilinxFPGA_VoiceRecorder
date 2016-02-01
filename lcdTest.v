`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:30:32 04/27/2015
// Design Name:   LCD
// Module Name:   C:/Users/Angel/Desktop/newWorking/lcdTest.v
// Project Name:  audio
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: LCD
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module lcdTest;

	// Inputs
	reg clkout;
	reg reset;
	reg btnL;
	reg btnR;
	reg btnC;
	reg btnU;
	reg btnD;

	// Outputs
	wire D1;
	wire D2;
	wire D3;
	wire D4;
	wire rs;
	wire rw;
	wire en;

	// Instantiate the Unit Under Test (UUT)
	LCD uut (
		.clkout(clkout), 
		.reset(reset), 
		.btnL(btnL), 
		.btnR(btnR), 
		.btnC(btnC), 
		.btnU(btnU), 
		.btnD(btnD), 
		.D1(D1), 
		.D2(D2), 
		.D3(D3), 
		.D4(D4), 
		.rs(rs), 
		.rw(rw), 
		.en(en)
	);

	always begin
		clkout = 0;
		#18;
		clkout = 1;
		#18;
	end

	initial begin
		// Initialize Inputs
		
		reset = 0;
		btnL = 0;
		btnR = 0;
		btnC = 0;
		btnU = 0;
		btnD = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

