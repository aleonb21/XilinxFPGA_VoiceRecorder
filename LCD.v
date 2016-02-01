`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:46:10 04/27/2015 
// Design Name: 
// Module Name:    LCD 
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
module LCD( clkout, reset, btnL, btnR,
				btnC, btnU, btnD, D1, D2,
				D3, D4, rs, rw, en, memFull,
				message0Valid, message1Valid,
				message2Valid, message3Valid,
				message4Valid, skipping
			  );
input message0Valid, message1Valid,
		message2Valid, message3Valid,
		message4Valid, skipping;
input clkout, reset, memFull;
input btnC, btnU, btnD, btnL, btnR;
output reg D1, D2, D3, D4, rs, rw, en;

reg [26:0] delay = 0;
reg [5:0] agent = welcome;
reg [5:0] welcAgent = state1;
//reg [3:0] init = fnt1;
reg [3:0] trackDisplay = 0;
reg [6:0] display = 0;
reg [6:0] current = 0;
reg [6:0] current1 = 0;
reg [6:0] current2 = 0;
reg [6:0] current3 = 0;
reg [6:0] current4 = 0;
reg [6:0] current5 = 0;
reg [6:0] current6 = 0;
reg [6:0] current7 = 0;
reg [6:0] current8 = 0;
reg [6:0] current9 = 0;
reg [6:0] current10 = 0;
reg [31:0] fiveCounter = 0;
reg doit = 1;

reg playOrDelete = 0;

parameter [5:0] initialize = 6'b000000;
parameter [5:0] welcome = 6'b000001;
parameter [5:0] play = 6'b000010;
parameter [5:0] record = 6'b000011;
parameter [5:0] delete = 6'b000100;
parameter [5:0] deleteAll = 6'b000101;
parameter [5:0] message1 = 6'b000110; 
parameter [5:0] message2 = 6'b000111;
parameter [5:0] message3 = 6'b001000;
parameter [5:0] message4 = 6'b001001;
parameter [5:0] message5 = 6'b001010;
parameter [5:0] memfull_state = 6'b001011;
parameter [5:0] entry1 = 6'b001100;
parameter [5:0] entry2 = 6'b001101;

parameter [5:0] state1 = 6'b000001;
parameter [5:0] state2 = 6'b000010;
parameter [5:0] state3 = 6'b000011;
parameter [5:0] state4 = 6'b000100;
parameter [5:0] state5 = 6'b000101;
parameter [5:0] state6 = 6'b000110;
parameter [5:0] state7 = 6'b000111;
parameter [5:0] state8 = 6'b001000;
parameter [5:0] state9 = 6'b001001;
parameter [5:0] state10 = 6'b001010;
parameter [5:0] state11 = 6'b001011;
parameter [5:0] state12 = 6'b001100;
parameter [5:0] state13 = 6'b001101;
parameter [5:0] state14 = 6'b001110;
parameter [5:0] state15 = 6'b001111;
parameter [5:0] state16 = 6'b010000;

always @(posedge clkout) begin
	if (reset) begin
		display <= 0;
	end
	else begin
		case (agent)
			welcome: begin
				case (current)
					7'd0: display <= 6'b000110;
					7'd1: display <= 6'b000010;
					
					7'd2: display <= 6'b000000;
					7'd3: display <= 6'b001111;
					
					7'd4: display <= 6'b000000;
					7'd5: display <= 6'b000001;
					
					7'd6: display <= 6'b000000;
					7'd7: display <= 6'b000110;
					
					7'd8: display <= 6'b010101;//W
					7'd9: display <= 6'b010111;
					
					7'd10: display <= 6'b010110;//e
					7'd11: display <= 6'b010101;
					
					7'd12: display <= 6'b010110;//l
					7'd13: display <= 6'b011100;
					
					7'd14: display <= 6'b010110;//c
					7'd15: display <= 6'b010011;
					
					7'd16: display <= 6'b010110;//o
					7'd17: display <= 6'b011111;
					
					
					7'd18: display <= 6'b010110;//m
					7'd19: display <= 6'b011101;
					
					7'd20: display <= 6'b010110;//e
					7'd21: display <= 6'b010101;
					
						
					7'd22: display <= 6'b010010;//!
					7'd23: display <= 6'b010001;
					
					7'd24: begin
						fiveCounter <= fiveCounter + 1;
							if (fiveCounter == 30'd500000000) begin
								agent <= play;
								doit <= 1;
								current <= 7'd0;
								fiveCounter <= 0;
							end
							else if (btnR) begin
								agent <= play;
								doit <= 1;
								current <= 7'd0;
							end
							else begin
								current <= 7'd24;
								agent <= welcome;
								doit <= 0;
							end
						display <= 000000;
						//display <= 001100;
					end
				endcase
			end
			play: begin
			playOrDelete = 1;
				case (current1)
					7'd0: display <= 6'b000110;
					7'd1: display <= 6'b000010;
					
					7'd2: display <= 6'b000000;
					7'd3: display <= 6'b001111;
					
					7'd4: display <= 6'b000000;
					7'd5: display <= 6'b000001;
					
					7'd6: display <= 6'b000000;
					7'd7: display <= 6'b000110;
					
					7'd8: display <= 6'b010101;//P
					7'd9: display <= 6'b010000;
					
					7'd10: display <= 6'b010110;//l
					7'd11: display <= 6'b011100;
					
					7'd12: display <= 6'b010110;//a
					7'd13: display <= 6'b010001;
					
					7'd14: display <= 6'b010111;//y
					7'd15: display <= 6'b011001;
					
					7'd16: display <= 6'b010010;//
					7'd17: display <= 6'b010000;
					
					7'd18: begin
						if (btnU) begin
							agent <= record;
							doit <= 1;
							current1 <= 7'd0;
						end
						else if (btnC) begin
							agent <= message1;
							doit <= 1;
							current1 <= 7'd0;
						end
						else begin
							current1 <= 7'd18;
							doit <= 0;
						end
						display <= 000000;
					end
				endcase
			end
			record: begin
			
				case (current2)
					7'd0: display <= 6'b000110;
					7'd1: display <= 6'b000010;
					
					7'd2: display <= 6'b000000;
					7'd3: display <= 6'b001111;
					
					7'd4: display <= 6'b000000;
					7'd5: display <= 6'b000001;
					
					7'd6: display <= 6'b000000;
					7'd7: display <= 6'b000110;
					
					7'd8: display <= 6'b010101;//R
					7'd9: display <= 6'b010010;
					
					7'd10: display <= 6'b010110;//e
					7'd11: display <= 6'b010101;
					
					7'd12: display <= 6'b010110;//c
					7'd13: display <= 6'b010011;
					
					7'd14: display <= 6'b010110;//o
					7'd15: display <= 6'b011111;
					
					7'd16: display <= 6'b010111;//r
					7'd17: display <= 6'b010010;
					
					7'd18: display <= 6'b010110;//d
					7'd19: display <= 6'b010100;
					
					7'd20: begin
						if (btnU) begin
							agent <= delete;
							doit <= 1;
							current2 <= 7'd0;
						end
						else if (btnD) begin
							agent <= play;
							doit <= 1;
							current2 <= 7'd0;
						end
						else if (memFull) begin
							agent <= memfull_state;
							doit <= 1;
							current2 <= 7'd0;
						end
						else if (btnL) begin
									agent <= record;
									doit <= 1;
									current2 <= 7'd0;
								end
						else begin
							current2 <= 7'd20;
							doit <= 0;
						end
						display <= 000000;
					end
				endcase
			end
			delete: begin
			playOrDelete = 0;
				case (current3)
					7'd0: display <= 6'b000110;
					7'd1: display <= 6'b000010;
					
					7'd2: display <= 6'b000000;
					7'd3: display <= 6'b001111;
					
					7'd4: display <= 6'b000000;
					7'd5: display <= 6'b000001;
					
					7'd6: display <= 6'b000000;
					7'd7: display <= 6'b000110;
					
					7'd8: display <= 6'b010100;//D
					7'd9: display <= 6'b010100;
					
					7'd10: display <= 6'b010110;//e
					7'd11: display <= 6'b010101;
					
					7'd12: display <= 6'b010110;//l
					7'd13: display <= 6'b011100;
					
					7'd14: display <= 6'b010110;//e
					7'd15: display <= 6'b010101;
					
					7'd16: display <= 6'b010111;//t
					7'd17: display <= 6'b010100;
					
					7'd18: display <= 6'b010110;//e
					7'd19: display <= 6'b010101;
					
					7'd20: begin
						if (btnU) begin
							agent <= deleteAll;
							doit <= 1;
							current3 <= 7'd0;
						end
						else if (btnD) begin
							agent <= record;
							doit <= 1;
							current3 <= 7'd0;
						end
						else if (btnC) begin
							agent <= message1;
							doit <= 1;
							current3 <= 7'd0;
						end
						else if (btnL) begin
									agent <= play;
									doit <= 1;
									current3 <= 7'd0;
								end
						else begin
							current3 <= 7'd20;
							doit <= 0;
						end
						display <= 000000;
					end
				endcase
			end
				memfull_state: begin
				case (current4)
					7'd0: display <= 6'b000110;
					7'd1: display <= 6'b000010;
					
					7'd2: display <= 6'b000000;
					7'd3: display <= 6'b001111;
					
					7'd4: display <= 6'b000000;
					7'd5: display <= 6'b000001;
					
					7'd6: display <= 6'b000000;
					7'd7: display <= 6'b000110;
					
					7'd8: display <= 6'b010100;//M
					7'd9: display <= 6'b011101;
					
					7'd10: display <= 6'b010110;//e
					7'd11: display <= 6'b010101;
					
					7'd12: display <= 6'b010110;//m
					7'd13: display <= 6'b011101;
					
					7'd14: display <= 6'b010110;//o
					7'd15: display <= 6'b011111;
					
					7'd16: display <= 6'b010111;//r
					7'd17: display <= 6'b010010;
					
					7'd18: display <= 6'b010111;//y
					7'd19: display <= 6'b011001;
					
					7'd20: display <= 6'b010010;//
					7'd21: display <= 6'b010000;
					
					7'd22: display <= 6'b010100;//F
					7'd23: display <= 6'b010110;
					
					7'd24: display <= 6'b010111;//u
					7'd25: display <= 6'b010101;
					
					7'd26: display <= 6'b010110;//l
					7'd27: display <= 6'b011100;
					
					7'd28: display <= 6'b010110;//l
					7'd29: display <= 6'b011100;
					
					7'd30: begin
						fiveCounter <= fiveCounter + 1;
							if (fiveCounter == 30'd500000000) begin
								agent <= record;
								doit <= 1;
								current4 <= 7'd0;
								fiveCounter <= 0;
							end
							else if (btnL) begin
								agent <= record;
								doit <= 1;
								current4 <= 7'd0;
								fiveCounter <= 0;
							end
							else begin
								current4 <= 7'd30;
								doit <= 0;
							end
						display <= 000000;
						//display <= 001100;
					end
				endcase
			end
			deleteAll: begin
				case (current5)
					7'd0: display <= 6'b000110;
					7'd1: display <= 6'b000010;
					
					7'd2: display <= 6'b000000;
					7'd3: display <= 6'b001111;
					
					7'd4: display <= 6'b000000;
					7'd5: display <= 6'b000001;
					
					7'd6: display <= 6'b000000;
					7'd7: display <= 6'b000110;
					
					7'd8: display <= 6'b010100;//D
					7'd9: display <= 6'b010100;
					
					7'd10: display <= 6'b010110;//e
					7'd11: display <= 6'b010101;
					
					7'd12: display <= 6'b010110;//l
					7'd13: display <= 6'b011100;
					
					7'd14: display <= 6'b010110;//e
					7'd15: display <= 6'b010101;
					
					7'd16: display <= 6'b010111;//t
					7'd17: display <= 6'b010100;
					
					7'd18: display <= 6'b010110;//e
					7'd19: display <= 6'b010101;
					
					7'd20: display <= 6'b010010;//
					7'd21: display <= 6'b010000;
					
					7'd22: display <= 6'b010100;//A
					7'd23: display <= 6'b010001;
					
					7'd24: display <= 6'b010110;//l
					7'd25: display <= 6'b011100;
					
					7'd26: display <= 6'b010110;//l
					7'd27: display <= 6'b011100;
					
					
					7'd28: begin
								if (btnU) begin
									agent <= play;
									doit <= 1;
									current5 <= 7'd0;
								end///////////
								else if (btnC) begin
									agent <= deleteAll;
									doit <= 1;
									current5 <= 7'd0;
								end////////////
								else if (btnD) begin
									agent <= delete;
									doit <= 1;
									current5 <= 7'd0;
								end ///////////
								else if (btnL) begin
									agent <= play;
									doit <= 1;
									current5 <= 7'd0;
								end
								else begin
									current5 <= 7'd28;
									doit <= 0;
								end///////////
						display <= 000000;
					end//////////////// End of d28 begin
				endcase ////// End of Delete all case
			end///////////End of begin
			message1: begin
				case (current6)
					7'd0: display <= 6'b000110;
					7'd1: display <= 6'b000010;
					
					7'd2: display <= 6'b000000;
					7'd3: display <= 6'b001111;
					
					7'd4: display <= 6'b000000;
					7'd5: display <= 6'b000001;
					
					7'd6: display <= 6'b000000;
					7'd7: display <= 6'b000110;
				
					7'd8: display <= 6'b011111;//spaceInv
					7'd9: display <= 6'b011100;
					
					7'd10: display <= 6'b010010;//asterisk
					7'd11: display <= 6'b011010;
				
					7'd12: display <= 6'b010100;//M
					7'd13: display <= 6'b011101;
					
					7'd14: display <= 6'b010110;//e
					7'd15: display <= 6'b010101;
					
					7'd16: display <= 6'b010111;//s
					7'd17: display <= 6'b010011;
					
					7'd18: display <= 6'b010111;//s
					7'd19: display <= 6'b010011;
					
					7'd20: display <= 6'b010110;//a
					7'd21: display <= 6'b010001;
					
					7'd22: display <= 6'b010110;//g
					7'd23: display <= 6'b010111;
					
					7'd24: display <= 6'b010110;//e
					7'd25: display <= 6'b010101;
					
					7'd26: display <= 6'b010011;//1
					7'd27: display <= 6'b010001;
					
						7'd28: begin
								if (btnU) begin
									agent <= message2;
									doit <= 1;
									current6 <= 7'd0;
								end
								else if (btnD) begin
									agent <= message1;
									doit <= 1;
									current6 <= 7'd0;
								end
								else if (btnL && ~playOrDelete) begin
									agent <= delete;
									doit <= 1;
									current6 <= 7'd0;
								end
								else if (btnL && playOrDelete) begin
									agent <= play;
									doit <= 1;
									current6 <= 7'd0;
								end
								else if (skipping) begin
									if (message1Valid)
										agent <= message2;
									else if (message2Valid)
										agent <= message3;
									else if (message3Valid)
										agent <= message4;
									else if (message4Valid)
										agent <= message5;
									doit <= 1;
									current6 <= 7'd0;
								end
								else begin
									current6 <= 7'd28;
									doit <= 0;
								end
								display <= 000000;
							end
				endcase // End of case wrapper
			end
			message2: begin
				case (current7)
					7'd0: display <= 6'b000110;
					7'd1: display <= 6'b000010;
					
					7'd2: display <= 6'b000000;
					7'd3: display <= 6'b001111;
					
					7'd4: display <= 6'b000000;
					7'd5: display <= 6'b000001;
					
					7'd6: display <= 6'b000000;
					7'd7: display <= 6'b000110;
				
					7'd8: display <= 6'b011111;//spaceInv
					7'd9: display <= 6'b011100;
					
					7'd10: display <= 6'b010010;//asterisk
					7'd11: display <= 6'b011010;
				
					7'd12: display <= 6'b010100;//M
					7'd13: display <= 6'b011101;
					
					7'd14: display <= 6'b010110;//e
					7'd15: display <= 6'b010101;
					
					7'd16: display <= 6'b010111;//s
					7'd17: display <= 6'b010011;
					
					7'd18: display <= 6'b010111;//s
					7'd19: display <= 6'b010011;
					
					7'd20: display <= 6'b010110;//a
					7'd21: display <= 6'b010001;
					
					7'd22: display <= 6'b010110;//g
					7'd23: display <= 6'b010111;
					
					7'd24: display <= 6'b010110;//e
					7'd25: display <= 6'b010101;
					
					7'd26: display <= 6'b010011;//2
					7'd27: display <= 6'b010010;
					
						7'd28: begin
								if (btnU) begin
									agent <= message3;
									doit <= 1;
									current7 <= 7'd0;
								end
								else if (btnD) begin
									agent <= message1;
									doit <= 1;
									current7 <= 7'd0;
								end
								else if (btnL && ~playOrDelete) begin
									agent <= delete;
									doit <= 1;
									current7 <= 7'd0;
								end
								else if (btnL && playOrDelete) begin
									agent <= play;
									doit <= 1;
									current7 <= 7'd0;
								end
								else if (skipping) begin
									if (message2Valid)
										agent <= message3;
									else if (message3Valid)
										agent <= message4;
									else if (message4Valid)
										agent <= message5;
									doit <= 1;
									current7 <= 7'd0;
								end
								else begin
									current7 <= 7'd28;
									doit <= 0;
								end
								display <= 000000;
							end
				endcase // End of case wrapper
			end
			message3: begin
				case (current8)
					7'd0: display <= 6'b000110;
					7'd1: display <= 6'b000010;
					
					7'd2: display <= 6'b000000;
					7'd3: display <= 6'b001111;
					
					7'd4: display <= 6'b000000;
					7'd5: display <= 6'b000001;
					
					7'd6: display <= 6'b000000;
					7'd7: display <= 6'b000110;
				
					7'd8: display <= 6'b011111;//spaceInv
					7'd9: display <= 6'b011100;
					
					7'd10: display <= 6'b010010;//asterisk
					7'd11: display <= 6'b011010;
				
					7'd12: display <= 6'b010100;//M
					7'd13: display <= 6'b011101;
					
					7'd14: display <= 6'b010110;//e
					7'd15: display <= 6'b010101;
					
					7'd16: display <= 6'b010111;//s
					7'd17: display <= 6'b010011;
					
					7'd18: display <= 6'b010111;//s
					7'd19: display <= 6'b010011;
					
					7'd20: display <= 6'b010110;//a
					7'd21: display <= 6'b010001;
					
					7'd22: display <= 6'b010110;//g
					7'd23: display <= 6'b010111;
					
					7'd24: display <= 6'b010110;//e
					7'd25: display <= 6'b010101;
					
					7'd26: display <= 6'b010011;//3
					7'd27: display <= 6'b010011;
					
						7'd28: begin
								if (btnU) begin
									agent <= message4;
									doit <= 1;
									current8 <= 7'd0;
								end
								else if (btnD) begin
									agent <= message2;
									doit <= 1;
									current8 <= 7'd0;
								end
								else if (btnL && ~playOrDelete) begin
									agent <= delete;
									doit <= 1;
									current8 <= 7'd0;
								end
								else if (btnL && playOrDelete) begin
									agent <= play;
									doit <= 1;
									current8 <= 7'd0;
								end
								else if (skipping) begin
									if (message3Valid)
										agent <= message4;
									else if (message4Valid)
										agent <= message5;
									doit <= 1;
									current7 <= 7'd0;
								end
								else begin
									current8 <= 7'd28;
									doit <= 0;
								end
								display <= 000000;
							end
				endcase // End of case wrapper
			end
			message4: begin
				case (current9)
					7'd0: display <= 6'b000110;
					7'd1: display <= 6'b000010;
					
					7'd2: display <= 6'b000000;
					7'd3: display <= 6'b001111;
					
					7'd4: display <= 6'b000000;
					7'd5: display <= 6'b000001;
					
					7'd6: display <= 6'b000000;
					7'd7: display <= 6'b000110;
				
					7'd8: display <= 6'b011111;//spaceInv
					7'd9: display <= 6'b011100;
					
					7'd10: display <= 6'b010010;//asterisk
					7'd11: display <= 6'b011010;
				
					7'd12: display <= 6'b010100;//M
					7'd13: display <= 6'b011101;
					
					7'd14: display <= 6'b010110;//e
					7'd15: display <= 6'b010101;
					
					7'd16: display <= 6'b010111;//s
					7'd17: display <= 6'b010011;
					
					7'd18: display <= 6'b010111;//s
					7'd19: display <= 6'b010011;
					
					7'd20: display <= 6'b010110;//a
					7'd21: display <= 6'b010001;
					
					7'd22: display <= 6'b010110;//g
					7'd23: display <= 6'b010111;
					
					7'd24: display <= 6'b010110;//e
					7'd25: display <= 6'b010101;
					
					7'd26: display <= 6'b010011;//4
					7'd27: display <= 6'b010100;
					
						7'd28: begin
								if (btnU) begin
									agent <= message5;
									doit <= 1;
									current9 <= 7'd0;
								end
								else if (btnD) begin
									agent <= message3;
									doit <= 1;
									current9 <= 7'd0;
								end
								else if (btnL && ~playOrDelete) begin
									agent <= delete;
									doit <= 1;
									current9 <= 7'd0;
								end
								else if (btnL && playOrDelete) begin
									agent <= play;
									doit <= 1;
									current9 <= 7'd0;
								end
								else if (skipping) begin
									if (message4Valid)
										agent <= message5;
									doit <= 1;
									current7 <= 7'd0;
								end
								else begin
									current9 <= 7'd28;
									doit <= 0;
								end
								display <= 000000;
							end
				endcase // End of case wrapper
			end
			message5: begin
				case (current10)
					7'd0: display <= 6'b000110;
					7'd1: display <= 6'b000010;
					
					7'd2: display <= 6'b000000;
					7'd3: display <= 6'b001111;
					
					7'd4: display <= 6'b000000;
					7'd5: display <= 6'b000001;
					
					7'd6: display <= 6'b000000;
					7'd7: display <= 6'b000110;
				
					7'd8: display <= 6'b011111;//spaceInv
					7'd9: display <= 6'b011100;
					
					7'd10: display <= 6'b010010;//asterisk
					7'd11: display <= 6'b011010;
				
					7'd12: display <= 6'b010100;//M
					7'd13: display <= 6'b011101;
					
					7'd14: display <= 6'b010110;//e
					7'd15: display <= 6'b010101;
					
					7'd16: display <= 6'b010111;//s
					7'd17: display <= 6'b010011;
					
					7'd18: display <= 6'b010111;//s
					7'd19: display <= 6'b010011;
					
					7'd20: display <= 6'b010110;//a
					7'd21: display <= 6'b010001;
					
					7'd22: display <= 6'b010110;//g
					7'd23: display <= 6'b010111;
					
					7'd24: display <= 6'b010110;//e
					7'd25: display <= 6'b010101;
					
					7'd26: display <= 6'b010011;//5
					7'd27: display <= 6'b010101;
					
						7'd28: begin
								if (btnU) begin
									agent <= message5;
									doit <= 1;
									current10 <= 7'd0;
								end
								else if (btnD) begin
									agent <= message4;
									doit <= 1;
									current10 <= 7'd0;
								end
								else if (btnL && ~playOrDelete) begin
									agent <= delete;
									doit <= 1;
									current10 <= 7'd0;
								end
								else if (btnL && playOrDelete) begin
									agent <= play;
									doit <= 1;
									current10 <= 7'd0;
								end
								else begin
									current10 <= 7'd28;
									doit <= 0;
								end
								display <= 000000;
							end
				endcase // End of case wrapper
			end
			
			
		
			//new state here
		endcase
	end
	
	delay <= delay + 1;
	if (delay == 26'd1008576 && doit) begin
		en <= 1;
		delay <= 0;
		if (agent == welcome && current < 5'd24) begin
			current <= current + 1;
		end
		
		if (agent == play && current1 < 5'd18) begin
			current1 <= current1 + 1;
		end
		
		if (agent == record && current2 < 5'd20) begin
			current2 <= current2 + 1;
		end
		
		if (agent == delete && current3 < 7'd20) begin
			current3 <= current3 + 1;
		end
		
		if (agent == memfull_state && current4 < 7'd30) begin
			current4 <= current4 + 1;
		end
		
		if (agent == deleteAll && current5 < 7'd28 ) begin
		current5 <= current5 + 1;
		end
		
		if (agent == message1 && current6 < 7'd28) begin
			if (!message0Valid) begin
				if (current6 == 5'd8 || current6 == 5'd7)
					current6 <= current6 + 1;
				else if (current6 == 5'd9) begin
					current6 <= 5'd12;
				end
				else current6 <= current6 + 1;
			end
			else if (current6 == 5'd7) begin
				current6 <= 5'd10;
			end
			else current6 <= current6 + 1;
		end
		
		if (agent == message2 && current7 < 7'd28) begin
			if (!message1Valid) begin
				if (current7 == 5'd8 || current7 == 5'd7)
					current7 <= current7 + 1;
				else if (current7 == 5'd9) begin
					current7 <= 5'd12;
				end
				else current7 <= current7 + 1;
			end
			else if (current7 == 5'd7) begin
				current7 <= 5'd10;
			end
			else current7 <= current7 + 1;
		end
		
		if (agent == message3 && current8< 7'd28) begin
			if (!message2Valid) begin
				if (current8 == 5'd8 || current8 == 5'd7)
					current8 <= current8 + 1;
				else if (current8 == 5'd9) begin
					current8 <= 5'd12;
				end
				else current8 <= current8 + 1;
			end
			else if (current8 == 5'd7) begin
				current8 <= 5'd10;
			end
			else current8 <= current8 + 1;
		end
		
		if (agent == message4 && current9 < 7'd28) begin
			if (!message3Valid) begin
				if (current9 == 5'd8 || current9 == 5'd7)
					current9 <= current9 + 1;
				else if (current9 == 5'd9) begin
					current9 <= 5'd12;
				end
				else current9 <= current9 + 1;
			end
			else if (current9 == 5'd7) begin
				current9 <= 5'd10;
			end
			else current9 <= current9 + 1;
		end
		
		if (agent == message5 && current10 < 7'd28) begin
			if (!message4Valid) begin
				if (current10 == 5'd8 || current10 == 5'd7)
					current10 <= current10 + 1;
				else if (current10 == 5'd9) begin
					current10 <= 5'd12;
				end
				else current10 <= current10 + 1;
			end
			else if (current10 == 5'd7) begin
				current10 <= 5'd10;
			end
			else current10 <= current10 + 1;
		end
		
	end
	else en <= 0;
	rw <= display[5];
	rs <= display[4];
	D4 <= display[3];
	D3 <= display[2];
	D2 <= display[1];
	D1 <= display[0];
end/////////////////End of clock



endmodule

/*===============================================================
					7'dXX: display <= 6'b010101;//P
					7'dXX: display <= 6'b010000;
					
					7'dXX: display <= 6'b010110;//l
					7'dXX: display <= 6'b011100;
					
					7'dXX: display <= 6'b010110;//a
					7'dXX: display <= 6'b010001;
					
					7'dXX: display <= 6'b010111;//y
					7'dXX: display <= 6'b011001;
					===============================================================*/
					
					/*===============================================================
					7'dXX: display <= 6'b010101;//R
					7'dXX: display <= 6'b010010;
					
					7'dXX: display <= 6'b010110;//e
					7'dXX: display <= 6'b010101;
					
					7'dXX: display <= 6'b010110;//c
					7'dXX: display <= 6'b010011;
					
					7'dXX: display <= 6'b010110;//o
					7'dXX: display <= 6'b011111;
					
					7'dXX: display <= 6'b010111;//r
					7'dXX: display <= 6'b010010;
					
					7'dXX: display <= 6'b010110;//d
					7'dXX: display <= 6'b010100;
					===============================================================*/
					
					/*===============================================================
					7'dXX: display <= 6'b010100;//D
					7'dXX: display <= 6'b010100;
					
					7'dXX: display <= 6'b010110;//e
					7'dXX: display <= 6'b010101;
					
					7'dXX: display <= 6'b010110;//l
					7'dXX: display <= 6'b011100;
					
					7'dXX: display <= 6'b010110;//e
					7'dXX: display <= 6'b010101;
					
					7'dXX: display <= 6'b010111;//t
					7'dXX: display <= 6'b010100;
					
					7'dXX: display <= 6'b010110;//e
					7'dXX: display <= 6'b010101;
					
					7'dXX: display <= 6'b010010;//SPACE
					7'dXX: display <= 6'b010000;
					
					7'dXX: display <= 6'b010100;//M
					7'dXX: display <= 6'b011101;
					
					7'dXX: display <= 6'b010110;//e
					7'dXX: display <= 6'b010101;
					
					7'dXX: display <= 6'b010111;//s
					7'dXX: display <= 6'b010011;
					
					7'dXX: display <= 6'b010111;//s
					7'dXX: display <= 6'b010011;
					
					7'dXX: display <= 6'b010110;//a
					7'dXX: display <= 6'b010001;
					
					7'dXX: display <= 6'b010110;//g
					7'dXX: display <= 6'b010111;
					
					7'dXX: display <= 6'b010110;//e
					7'dXX: display <= 6'b010101;
					===============================================================*/
					
					/*===============================================================
					7'dXX: display <= 6'b010100;//D
					7'dXX: display <= 6'b010100;
					
					7'dXX: display <= 6'b010110;//e
					7'dXX: display <= 6'b010101;
					
					7'dXX: display <= 6'b010110;//l
					7'dXX: display <= 6'b011100;
					
					7'dXX: display <= 6'b010110;//e
					7'dXX: display <= 6'b010101;
					
					7'dXX: display <= 6'b010111;//t
					7'dXX: display <= 6'b010100;
					
					7'dXX: display <= 6'b010110;//e
					7'dXX: display <= 6'b010101;
					
					7'dXX: display <= 6'b010010;//SPACE
					7'dXX: display <= 6'b010000;
					
					7'dXX: display <= 6'b0100100;//A
					7'dXX: display <= 6'b0100001;
					
					7'dXX: display <= 6'b010110;//l
					7'dXX: display <= 6'b011100;
					
					7'dXX: display <= 6'b010110;//l
					7'dXX: display <= 6'b011100;
					===============================================================*/
					
					/*===============================================================
					7'dXX: display <= 6'b010100;//M
					7'dXX: display <= 6'b011101;
					
					7'dXX: display <= 6'b010110;//e
					7'dXX: display <= 6'b010101;
					
					7'dXX: display <= 6'b010111;//s
					7'dXX: display <= 6'b010011;
					
					7'dXX: display <= 6'b010111;//s
					7'dXX: display <= 6'b010011;
					
					7'dXX: display <= 6'b010110;//a
					7'dXX: display <= 6'b010001;
					
					7'dXX: display <= 6'b010110;//g
					7'dXX: display <= 6'b010111;
					
					7'dXX: display <= 6'b010110;//e
					7'dXX: display <= 6'b010101;
					
					7'dXX: display <= 6'b010010;//SPACE
					7'dXX: display <= 6'b010000;
					
					7'dXX: display <= 6'b010011;// Number 1
					7'dXX: display <= 6'b010001;
					===============================================================*/
					
					/*===============================================================
					7'dXX: display <= 6'b010100;//M
					7'dXX: display <= 6'b011101;
					
					7'dXX: display <= 6'b010110;//e
					7'dXX: display <= 6'b010101;
					
					7'dXX: display <= 6'b010111;//s
					7'dXX: display <= 6'b010011;
					
					7'dXX: display <= 6'b010111;//s
					7'dXX: display <= 6'b010011;
					
					7'dXX: display <= 6'b010110;//a
					7'dXX: display <= 6'b010001;
					
					7'dXX: display <= 6'b010110;//g
					7'dXX: display <= 6'b010111;
					
					7'dXX: display <= 6'b010110;//e
					7'dXX: display <= 6'b010101;
					
					7'dXX: display <= 6'b010010;//SPACE
					7'dXX: display <= 6'b010000;
					
					7'dXX: display <= 6'b010011;// Number 2
					7'dXX: display <= 6'b010010;
					===============================================================*/
					
					/*===============================================================
					7'dXX: display <= 6'b010100;//M
					7'dXX: display <= 6'b011101;
					
					7'dXX: display <= 6'b010110;//e
					7'dXX: display <= 6'b010101;
					
					7'dXX: display <= 6'b010111;//s
					7'dXX: display <= 6'b010011;
					
					7'dXX: display <= 6'b010111;//s
					7'dXX: display <= 6'b010011;
					
					7'dXX: display <= 6'b010110;//a
					7'dXX: display <= 6'b010001;
					
					7'dXX: display <= 6'b010110;//g
					7'dXX: display <= 6'b010111;
					
					7'dXX: display <= 6'b010110;//e
					7'dXX: display <= 6'b010101;
					
					7'dXX: display <= 6'b010010;//SPACE
					7'dXX: display <= 6'b010000;
					
					7'dXX: display <= 6'b010011;// Number 3
					7'dXX: display <= 6'b010011;
					===============================================================*/
					
					/*===============================================================
					7'dXX: display <= 6'b010100;//M
					7'dXX: display <= 6'b011101;
					
					7'dXX: display <= 6'b010110;//e
					7'dXX: display <= 6'b010101;
					
					7'dXX: display <= 6'b010111;//s
					7'dXX: display <= 6'b010011;
					
					7'dXX: display <= 6'b010111;//s
					7'dXX: display <= 6'b010011;
					
					7'dXX: display <= 6'b010110;//a
					7'dXX: display <= 6'b010001;
					
					7'dXX: display <= 6'b010110;//g
					7'dXX: display <= 6'b010111;
					
					7'dXX: display <= 6'b010110;//e
					7'dXX: display <= 6'b010101;
					
					7'dXX: display <= 6'b010010;//SPACE
					7'dXX: display <= 6'b010000;
					
					7'dXX: display <= 6'b010011;// Number 4
					7'dXX: display <= 6'b010100;
					===============================================================*/
					
					/*===============================================================
					7'dXX: display <= 6'b010100;//M
					7'dXX: display <= 6'b011101;
					
					7'dXX: display <= 6'b010110;//e
					7'dXX: display <= 6'b010101;
					
					7'dXX: display <= 6'b010111;//s
					7'dXX: display <= 6'b010011;
					
					7'dXX: display <= 6'b010111;//s
					7'dXX: display <= 6'b010011;
					
					7'dXX: display <= 6'b010110;//a
					7'dXX: display <= 6'b010001;
					
					7'dXX: display <= 6'b010110;//g
					7'dXX: display <= 6'b010111;
					
					7'dXX: display <= 6'b010110;//e
					7'dXX: display <= 6'b010101;
					
					7'dXX: display <= 6'b010010;//SPACE
					7'dXX: display <= 6'b010000;
					
					7'dXX: display <= 6'b010011;// Number 5
					7'dXX: display <= 6'b010101;
					===============================================================*/

/*case (agent2)
		doNothing: begin
			//delay3 <= delay3 + 1;
			//if (delay3 == 4'd2) begin
				agent2 <= initialize;
			//	delay3 <= 0;
			//end
			//else agent2 <= doNothing;
		end
		initialize: begin
			case (init)
				fnt1: begin
					display <= 6'b000010;
					init <= fnt2;
				end
				fnt2: begin
					display <= 6'b000010;
					init <= fnt3;
				end
				fnt3: begin
					display <= 6'b000100;
					init <= disONOFF1;//wait1;
				end
				wait1: begin
					delay3 <= delay3 + 1'b1;
					if (delay3 == 1'b1) begin
						init <= disONOFF1;
						delay3 <= 0;
					end
					else init <= wait1;
				end
				disONOFF1: begin
					display <= 000000;
					init <= disONOFF2;
				end
				disONOFF2: begin
					display <= 001111;
					init <= disClr1;//wait2;
				end
				//wait2: begin
					//delay3 <= delay3 + 1'b1;
					//if (delay3 == 1'b1) begin
				//		init <= disClr1;
					//	delay3 <= 0;
					//end
					//else init <= wait2;
				//end
				disClr1: begin
					display <= 0000000;
					init <= disClr2;
				end
				disClr2: begin
					display <= 0000001;
					init <= entry1;//wait3;
				end
				//wait3: begin
					//delay3 <= delay3 + 1'b1;
					//if (delay3 == 3'b111) begin
					//	init <= entry1;
					//	delay3 <= 0;
					//end
					//else init <= wait3;
				//end
				entry1: begin
					display <= 0000000;
					init <= entry2;
				end
				entry2: begin
					display <= 0000111;
					init <= fnt1;
					if (trackDisplay == 0) begin
						agent2 <= welcome;
					end
					else if (trackDisplay == 1) begin
						agent2 <= welcome;
					end
				end
			endcase
		end
		welcome: begin
			case (welcAgent)
				state1: display[5:0] <= 010101;//W
				state2: display[5:0] <= 010111;
				
				state3: display[5:0] <= 010110;//e
				state4: display[5:0] <= 010101;
				
				state5: display[5:0] <= 010110;//l
				state6: display[5:0] <= 011100;
				
				state7: display[5:0] <= 010110;//c
				state8: display[5:0] <= 010011;
				
				state9: display[5:0] <= 010110;//o
				state10: display[5:0] <= 011111;
				
				state11: display[5:0] <= 010110;//m
				state12: display[5:0] <= 011101;
				
				state13: display[5:0] <= 010110;//e
				state14: display[5:0] <= 010101;
				
				state15: display[5:0] <= 010100;//!
				state16: display[5:0] <= 010001;					
			endcase
			welcAgent <= welcAgent + 1;
			if (welcAgent == 6'd16) begin
				welcAgent <= state1;
				agent2 <= welcome;
				trackDisplay <= 1;
			end
		end
		
	endcase*/
