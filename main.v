`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:12:25 04/24/2015 
// Design Name: 
// Module Name:    main 
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
module main(clk, reset, switches, audio_reset_b, leds,
				ac97_sdata_out, ac97_sdata_in,
            ac97_synch, ac97_bit_clock,
				NbtnU, NbtnC, NbtnR, NbtnL, NbtnD,

				hw_zio_pin,	hw_rzq_pin,	hw_ram_rasn, hw_ram_casn,
				hw_ram_wen,	hw_ram_ck, hw_ram_ckn, hw_ram_cke,
				hw_ram_ldm,  hw_ram_odt,  hw_ram_udm,  hw_ram_ldqs_n,
				hw_ram_ldqs_p, hw_ram_udqs_n, hw_ram_udqs_p, hw_ram_ba,
				hw_ram_dq, hw_ram_ad,
				
				D1, D2, D3, D4, rs, rw, en, memFull
				);

//---------------------Inputs/Outputs/Wires---------------------------------//
output  D1, D2, D3,
		  D4, rs, rw,
		  en, memFull;

output hw_ram_rasn;
output hw_ram_casn;
output hw_ram_wen;
output[2:0] hw_ram_ba;
output hw_ram_udm;
output hw_ram_ldm;
output hw_ram_ck;
output hw_ram_ckn;
output hw_ram_cke;
output hw_ram_odt;
output[12:0] hw_ram_ad;

inout hw_ram_udqs_p;
inout hw_ram_udqs_n;
inout hw_ram_ldqs_p;
inout hw_ram_ldqs_n;
inout[15:0] hw_ram_dq;
inout hw_rzq_pin;
inout hw_zio_pin;

input clk, reset;
input [7:0] switches;
input ac97_sdata_in, ac97_bit_clock;
input NbtnU, NbtnC, NbtnR, NbtnL, NbtnD;
wire btnU, btnC, btnR, btnL, btnD;
inout audio_reset_b, ac97_sdata_out, ac97_synch;
output [7:0] leds;

wire clkout, rdy, rd_data_pres;
reg write_enable, read_request, read_ack;
wire ready;
wire [7:0] audio_in_data;
reg [7:0] audio_out_data;
wire [25:0] max_ram_address;
wire [4:0] volume;

wire [7:0] data_out;
reg [7:0] data_in;

reg [25:0] address = 0;
reg [25:0] addressEnd = 0;
reg [25:0] message0End = 0;
reg [25:0] message1End = 0;
reg [25:0] message2End = 0;
reg [25:0] message3End = 0;
reg [25:0] message4End = 0;
reg message0Valid = 0;
reg message1Valid = 0;
reg message2Valid = 0;
reg message3Valid = 0;
reg message4Valid = 0;
reg readyToRead = 0;
reg recording = 0;
reg skipping = 0;

reg memfull_flag = 0;
assign memFull = memfull_flag;

//------------------------Module Instantiations---------------------------------//

LCD myLCD( .clkout(clkout), .reset(~reset), .btnL(btnL), .btnR(btnR),
				.btnC(btnC), .btnU(btnU), .btnD(btnD), .D1(D1), .D2(D2),
				.D3(D3), .D4(D4), .rs(rs), .rw(rw), .en(en), .memFull(memFull),
				.message0Valid(message0Valid), .message1Valid(message1Valid),
				.message2Valid(message2Valid), .message3Valid(message3Valid),
				.message4Valid(message4Valid), .skipping(skipping)
			  );

debounce deb1(.reset(~reset), .clk(clkout), .noisy(NbtnU), .clean(btnU));
debounce deb2(.reset(~reset), .clk(clkout), .noisy(NbtnD), .clean(btnD));
debounce deb3(.reset(~reset), .clk(clkout), .noisy(NbtnC), .clean(btnC));
debounce deb4(.reset(~reset), .clk(clkout), .noisy(NbtnL), .clean(btnL));
debounce deb5(.reset(~reset), .clk(clkout), .noisy(NbtnR), .clean(btnR));

ac97audio ac97audio(.clock_100mhz(clkout), .reset(~reset), .volume(volume),
							.audio_in_data(audio_in_data), .audio_out_data(audio_out_data),
							.ready(ready),	.audio_reset_b(audio_reset_b),
							.ac97_sdata_out(ac97_sdata_out), .ac97_sdata_in(ac97_sdata_in),
							.ac97_synch(ac97_synch), .ac97_bit_clock(ac97_bit_clock));

ram_interface_wrapper RAM(		
									.address(address),     
									.data_in(data_in), 
									.write_enable(write_enable), 
									.read_request(read_request), 
									.read_ack(read_ack),     
									.data_out(data_out), 
									.reset(~reset), 
									.clk(clk), 
									
									.hw_ram_rasn(hw_ram_rasn), 
									.hw_ram_casn(hw_ram_casn),
									.hw_ram_wen(hw_ram_wen), 
									.hw_ram_ba(hw_ram_ba), 
									.hw_ram_udqs_p(hw_ram_udqs_p), 
									.hw_ram_udqs_n(hw_ram_udqs_n), 
									.hw_ram_ldqs_p(hw_ram_ldqs_p), 
									.hw_ram_ldqs_n(hw_ram_ldqs_n), 
									.hw_ram_udm(hw_ram_udm), 
									.hw_ram_ldm(hw_ram_ldm), 
									.hw_ram_ck(hw_ram_ck), 
									.hw_ram_ckn(hw_ram_ckn), 
									.hw_ram_cke(hw_ram_cke), 
									.hw_ram_odt(hw_ram_odt),
									.hw_ram_ad(hw_ram_ad), 
									.hw_ram_dq(hw_ram_dq), 
									.hw_rzq_pin(hw_rzq_pin), 
									.hw_zio_pin(hw_zio_pin), 
									
									.clkout(clkout),  
									.sys_clk(clkout), 
									.rdy(rdy),         
									.rd_data_pres(rd_data_pres),        
									.max_ram_address(max_ram_address)); 

//---------------------------Assigning and FSM-------------------------------//

assign volume[4:3] = switches[7:6];
assign leds[7:6] = switches[7:6];//address[25:20];
assign leds[4:2] = message;
assign leds[5:5] = recording;
//assign leds[7:2] = address[25:20];

parameter doNothing = 6'b000000;
parameter play = 6'b000001;
parameter record = 6'b000010;
parameter delete = 6'b000011;
parameter deleteAll = 6'b000100;
parameter waitState = 6'b000101;
parameter menuNav = 6'b000110;
parameter upWait = 6'b000111;
parameter centerWait = 6'b001000;
parameter downWait = 6'b001001;
parameter playWait = 6'b001010;
parameter recordWait = 6'b001011;
parameter messageSel = 6'b001100;
parameter uSel = 6'b001101;
parameter dSel = 6'b001110;
parameter cSel = 6'b001111;
parameter pause = 6'b010000;
parameter pause_wait = 6'b010001;
parameter hold = 6'b010010;
parameter read2 = 6'b010011;
parameter read3 = 6'b010100;
parameter record2 = 6'b010101;
parameter startRead = 6'b010110;
parameter record3 = 6'b010111;
parameter record1 = 6'b011000;
parameter skip = 6'b011001;
parameter skipWait = 6'b011010;
parameter readReady = 6'b011011;
parameter deleteWait = 6'b011100;
parameter delDWait = 6'b011101;
parameter delUWait = 6'b011110;
parameter delCWait = 6'b011111;
parameter displayMemFull = 6'b100000;

reg [5:0] state = doNothing;
reg [2:0] message = 0;
reg [2:0] recordToMessage = 0;
reg [1:0] keepTrack = 0;
reg [2:0] keepTrackDelete = 0;
reg [2:0] trackDelete = 0;
reg [1:0] trackMessage = 0;
reg [1:0] trackMode = 0;
reg [1:0] modeSelected;
reg diff = 0;

reg pause_flag = 0;
//----flags

reg record_flag = 0;
reg play_flag = 0;
reg delete_flag = 0;
reg deleteall_flag = 0;
reg displayMessage0 = 0;
reg displayMessage1 = 0;
reg displayMessage2 = 0;
reg displayMessage3 = 0;
reg displayMessage4 = 0;
//----endflags

//reg [4:0] agent1 = state1;

reg [9:0] delay = 10'b0;
reg [9:0] delay2 = 10'b0;

assign leds[1:0] = trackMode;

always @(posedge clkout) begin
	if (!reset) begin
		state <= doNothing;
		//outputs
		write_enable <= 0; 
		read_request <= 0;
		
		keepTrack <= 0;
		trackMode <= 0;
		message <= 0;
		
		//----flags
		memfull_flag <= 0;
		record_flag <= 0;
		play_flag <= 0;
		delete_flag <= 0;
		deleteall_flag <= 0;
		displayMessage0 <= 0;
		displayMessage1 <= 0;
		displayMessage2 <= 0;
		displayMessage3 <= 0;
		displayMessage4 <= 0;
		//----endflags
		
	end
	else if (rdy) begin
		case (state)
			////////////////////////////////////////////////////////////
			doNothing: begin
				if (btnD) begin
					state <= downWait;
				end
				else if (btnU) begin
					state <= upWait;
				end
				else if (btnC) begin
					state <= centerWait;
				end
				else state <= doNothing;
				//output
				address <= 0;
				write_enable <= 0; 
				read_request <= 0;
				keepTrack <= 0;
				message <= 0;
				delay <= 0;
				delay2 <= 0;

				//----flags
				if (trackMode == 2'd0) begin
					play_flag <= 1;
					memfull_flag <= 0;
					record_flag <= 0;
					delete_flag <= 0;
					deleteall_flag <= 0;
					displayMessage0 <= 0;
					displayMessage1 <= 0;
					displayMessage2 <= 0;
					displayMessage3 <= 0;
					displayMessage4 <= 0;
				end
				else if (trackMode == 2'd1) begin
					record_flag <= 1;
					memfull_flag <= 0;
					play_flag <= 0;
					delete_flag <= 0;
					deleteall_flag <= 0;
					displayMessage0 <= 0;
					displayMessage1 <= 0;
					displayMessage2 <= 0;
					displayMessage3 <= 0;
					displayMessage4 <= 0;
				end
				else if (trackMode == 2'd2) begin
					delete_flag <= 1;
					memfull_flag <= 0;
					record_flag <= 0;
					play_flag <= 0;
					deleteall_flag <= 0;
					displayMessage0 <= 0;
					displayMessage1 <= 0;
					displayMessage2 <= 0;
					displayMessage3 <= 0;
					displayMessage4 <= 0;
				end
				else if (trackMode == 2'd3) begin
					deleteall_flag <= 1;
					memfull_flag <= 0;
					record_flag <= 0;
					play_flag <= 0;
					delete_flag <= 0;
					displayMessage0 <= 0;
					displayMessage1 <= 0;
					displayMessage2 <= 0;
					displayMessage3 <= 0;
					displayMessage4 <= 0;
				end	
				//----endflags
				
			end
			////////////////////////////////////////////////////////////
			menuNav: begin
				if (keepTrack == 0) begin
					if (trackMode == 0)
						trackMode <= 0;
					else
						trackMode <= trackMode - 1'b1;
					state <= doNothing;
				end
				if (keepTrack == 1) begin
					if (trackMode == 2'b11)
						trackMode <= 2'b11;
					else
						trackMode <= trackMode + 1'b1;
					state <= doNothing;
				end
				if (keepTrack == 2'b10) begin
					modeSelected <= trackMode;
					if (trackMode == 0)
						state <= play;
					else if (trackMode == 1)
						state <= record;
					else if (trackMode == 2)
						state <= deleteWait;
					else if (trackMode == 3)
						state <= deleteAll;
				end
				//output
				write_enable <= 0;
				read_request <= 0;
				memfull_flag <= 0;
				pause_flag <= 0;
			end
			////////////////////////////////////////////////////////////
			upWait: begin
				if (!btnU) begin
					state <= menuNav;
				end
				else state <= upWait;
				//output
				write_enable <= 0;
				read_request <= 0;
				memfull_flag <= 0;
				keepTrack <= 2'b01;
			end
			////////////////////////////////////////////////////////////
			downWait: begin
				if (!btnD) begin
					state <= menuNav;
				end
				else state <= downWait;
				//output
				write_enable <= 0;
				read_request <= 0;
				memfull_flag <= 0;
				keepTrack <= 2'b00;
			end
			////////////////////////////////////////////////////////////
			centerWait: begin
				if (!btnC) begin
					state <= menuNav;
				end
				else state <= centerWait;
				//output
				write_enable <= 0;
				read_request <= 0;
				memfull_flag <= 0;
				keepTrack <= 2'b10;
			end
			////////////////////////////////////////////////////////////
			play: begin
				if (btnU) begin
					state <= uSel;
				end
				else if (btnD) begin
					state <= dSel;
				end
				else if (btnC) begin
					state <= cSel;
				end
				else if (btnL) begin
					state <= doNothing;
				end
				else state <= play;
				read_request <= 0;
				
			end
			
			playWait: begin
				if (message == 0 && message0Valid) begin
					address <= 26'd0;
					addressEnd <= message0End;//26'd13421770;
					readyToRead <= 1;
				end
				else if (message == 1 && message1Valid) begin
					address <= 26'd13421775;
					addressEnd <= message1End;//26'd26843545;
					readyToRead <= 1;
				end
				else if (message == 2 && message2Valid) begin
					address <= 26'd26843550;
					addressEnd <= message2End;//26'd40265320;
					readyToRead <= 1;
				end
				else if (message == 3 && message3Valid) begin
					address <= 26'd40265325;
					addressEnd <= message3End;//26'd53687095;
					readyToRead <= 1;
				end
				else if (message == 4 && message4Valid) begin
					address <= 26'd53687100;
					addressEnd <= message4End;//26'd67108860;
					readyToRead <= 1;
				end

				state <= readReady;
				
				if (message == 0) begin
					play_flag <= 0;
					memfull_flag <= 0;
					record_flag <= 0;
					delete_flag <= 0;
					deleteall_flag <= 0;
					displayMessage0 <= 1;
					displayMessage1 <= 0;
					displayMessage2 <= 0;
					displayMessage3 <= 0;
					displayMessage4 <= 0;
				end
				else if (message == 1) begin
					record_flag <= 0;
					memfull_flag <= 0;
					play_flag <= 0;
					delete_flag <= 0;
					deleteall_flag <= 0;
					displayMessage0 <= 0;
					displayMessage1 <= 1;
					displayMessage2 <= 0;
					displayMessage3 <= 0;
					displayMessage4 <= 0;
				end
				else if (message == 3'd2) begin
					delete_flag <= 0;
					memfull_flag <= 0;
					record_flag <= 0;
					play_flag <= 0;
					deleteall_flag <= 0;
					displayMessage0 <= 0;
					displayMessage1 <= 0;
					displayMessage2 <= 1;
					displayMessage3 <= 0;
					displayMessage4 <= 0;
				end
				else if (message == 3'd3) begin
					deleteall_flag <= 0;
					memfull_flag <= 0;
					record_flag <= 0;
					play_flag <= 0;
					delete_flag <= 0;
					displayMessage0 <= 0;
					displayMessage1 <= 0;
					displayMessage2 <= 0;
					displayMessage3 <= 1;
					displayMessage4 <= 0;
				end
				else if (message == 3'd4) begin
					deleteall_flag <= 0;
					memfull_flag <= 0;
					record_flag <= 0;
					play_flag <= 0;
					delete_flag <= 0;
					displayMessage0 <= 0;
					displayMessage1 <= 0;
					displayMessage2 <= 0;
					displayMessage3 <= 0;
					displayMessage4 <= 1;
				end
			end
			
			readReady: begin
				if (readyToRead) begin
					state <= startRead;
					readyToRead <= 0;
				end
				else state <= play;
			end
			
			startRead: begin
				if (btnC) begin
					state <= pause;
					read_request <= 0;
					diff <= 0;
					read_ack <= 0;
				end
				else if (btnL) begin
					read_request <= 0;
					diff <= 0;
					state <= play;
					read_ack <= 0;
				end
				else if (btnR) begin
					read_request <= 0;
					diff <= 0;
					state <= skipWait;
					read_ack <= 0;
				end
				else begin
					state <= read2;
					read_request <= 1;
					read_ack <= 0;
				end
			end
			
			read2: begin
				if (btnC) begin
					state <= pause;
					read_request <= 0;
					diff <= 0;
					read_ack <= 0;
				end
				else if (btnL) begin
					read_request <= 0;
					diff <= 0;
					state <= play;
					read_ack <= 0;
				end
				else if (btnR) begin
					read_request <= 0;
					diff <= 0;
					state <= skipWait;
					read_ack <= 0;
				end
				else begin
					read_request <= 0;
					state <= read3;
				end
			end
			
			read3: begin
				if (rd_data_pres) begin
					audio_out_data <= data_out;
					//delay2 <= delay2 + 1;
					if (address < addressEnd) begin
						if (ready) begin//delay2 == 801) begin
							read_ack <= 1'b1;
							state <= startRead;
							address <= address + 1;
							delay2 <= 0;
						end
					end
					else begin
						state <= play;
						read_ack <= 0;
						read_request <= 0;
					end
				end
			end
			//---------------------------------skip---------------------
			skipWait: begin
				if (!btnR) begin
					state <= skip;
				end
				else state <= skipWait;
			end
			skip: begin
				if (message == 3'd0) begin
					if (message1Valid) begin
						message <= 3'd1;
						state <= playWait;
					end
					else if (message2Valid) begin
						message <= 3'd2;
						state <= playWait;
					end
					else if (message3Valid) begin
						message <= 3'd3;
						state <= playWait;
					end
					else if (message4Valid) begin
						message <= 3'd4;
						state <= playWait;
					end
					else state <= play;
				end
				else if (message == 3'd1) begin
					if (message2Valid) begin
						message <= 3'd2;
						state <= playWait;
					end
					else if (message3Valid) begin
						message <= 3'd3;
						state <= playWait;
					end
					else if (message4Valid) begin
						message <= 3'd4;
						state <= playWait;
					end
					else state <= play;
				end
				else if (message == 3'd2) begin
					if (message3Valid) begin
						message <= 3'd3;
						state <= playWait;
					end
					else if (message4Valid) begin
						message <= 3'd4;
						state <= playWait;
					end
					else state <= play;
				end
				else if (message == 3'd3) begin
					if (message4Valid) begin
						message <= 3'd4;
						state <= playWait;
					end
					else state <= play;
				end
				else if (message == 3'd4) begin
					state <= play;
				end
			end
			////////////////////////////////////////////////////////////
			pause: begin
				if (!btnC) begin
					pause_flag <= 1;
					state <= pause_wait;
				end
				else state <= pause;
				read_request <= 0;
			end
			
			pause_wait: begin
				if (btnC) begin
					state <= cSel;
					diff <= 1;
					pause_flag <= 0;
					read_request <= 0;
				end
				else state <= pause_wait;
			end
			////////////////////////////////////////////////////////////
			uSel: begin
				if (!btnU) begin
					state <= messageSel;
				end
				else state <= uSel;
				//output
				read_request <= 0;
				memfull_flag <= 0;
				trackMessage <= 1;
			end
			dSel: begin
				if (!btnD) begin
					state <= messageSel;
				end
				else state <= dSel;
				//output
				read_request <= 0;
				memfull_flag <= 0;
				trackMessage <= 0;
			end
			cSel: begin
				if (!btnC) begin
					if (diff) begin
						//diff <= 0;
						state <= startRead;//playWait;
					end
					if (!diff) begin
						state <= messageSel;
						read_request <= 0;
						memfull_flag <= 0;
						trackMessage <= 2;
					end
				end
				else state <= cSel;
			end
			
			messageSel: begin
				if (trackMessage == 0) begin
					if (message == 0)
						message <= 0;
					else
						message <= message - 1'b1;
					state <= play;
				end
				else if (trackMessage == 1) begin
					if (message == 4)
						message <= 4;
					else
						message <= message + 1'b1;
					state <= play;
				end
				else if (trackMessage == 2'b10) begin
					read_request <= 0;
					state <= playWait;
					read_ack <= 0;
				end
				
			end
			////////////////////////////////////////////////////////////
			record: begin
				if (!message0Valid) begin
					address <= 26'd0;
					write_enable <= 0;
					state <= record1;
					recordToMessage <= 0;
					memfull_flag <= 0;
				end
				else if (!message1Valid) begin
					address <= 26'd13421775;
					write_enable <= 0;
					state <= record1;
					recordToMessage <= 1;
					memfull_flag <= 0;
				end
				else if (!message2Valid) begin
					address <= 26'd26843550;
					write_enable <= 0;
					state <= record1;
					recordToMessage <= 3'd2;
					memfull_flag <= 0;
				end
				else if (!message3Valid) begin
					address <= 26'd40265325;
					write_enable <= 0;
					state <= record1;
					recordToMessage <= 3'd3;
					memfull_flag <= 0;
				end
				else if (!message4Valid) begin
					address <= 26'd53687100;
					write_enable <= 0;
					state <= record1;
					recordToMessage <= 3'd4;
					memfull_flag <= 0;
				end
				else begin
					state <= displayMemFull;
					memfull_flag <= 1;
					write_enable <= 0;
				end
				play_flag <= 0;
				record_flag <= 0;
				delete_flag <= 0;
				deleteall_flag <= 0;
				displayMessage0 <= 0;
				displayMessage1 <= 0;
				displayMessage2 <= 0;
				displayMessage3 <= 0;
				displayMessage4 <= 0;
			end
			record1: begin
				write_enable <= 1;
				data_in <= audio_in_data;
				state <= recordWait;
			end
			//record2: begin
			//	write_enable <= 0;
			//	state <= recordWait;
			//end
			recordWait: begin
				write_enable <= 0;
					//delay <= delay + 1'b1;
					if (ready) begin//delay == 800) begin
						address <= address + 1;
						state <= record3;
						delay <= 0;
					end
			end
			record3: begin
				if (btnL) begin
					state <= doNothing;
					if (recordToMessage == 3'd0) begin
						message0End <= address;
						message0Valid <= 1;
					end
					if (recordToMessage == 3'd1) begin
						message1End <= address;
						message1Valid <= 1;
					end
					if (recordToMessage == 3'd2) begin
						message2End <= address;
						message2Valid <= 1;
					end
					if (recordToMessage == 3'd3) begin
						message3End <= address;
						message3Valid <= 1;
					end
					if (recordToMessage == 3'd4) begin
						message4End <= address;
						message4Valid <= 1;
					end
				end
				else if (recordToMessage <= 0 && address == 26'd13421770) begin
					state <= doNothing;
					message0Valid <= 1;
					message0End <= address;
				end
				else if (recordToMessage <= 1 && address == 26'd26843545) begin
					state <= doNothing;
					message1Valid <= 1;
					message1End <= address;
				end
				else if (recordToMessage <= 2 && address == 26'd40265320) begin
					state <= doNothing;
					message2Valid <= 1;
					message2End <= address;
				end
				else if (recordToMessage <= 3 && address == 26'd53687095) begin
					state <= doNothing;
					message3Valid <= 1;
					message3End <= address;
				end
				else if (recordToMessage <= 4 && address == 26'd67108860) begin
					state <= doNothing;
					message4Valid <= 1;
					message4End <= address;
				end
				else state <= record1;
			end
			//---------------deleteAll---------------------------------------
			deleteAll: begin
					message0Valid <= 0;
					message1Valid <= 0;
					message2Valid <= 0;
					message3Valid <= 0;
					message4Valid <= 0;
					state <= doNothing;
			end
			//-------------------delete---------------------------------------
			deleteWait: begin
				if (btnD) begin
					state <= delDWait;
				end
				else if (btnU) begin
					state <= delUWait;
				end
				else if (btnC) begin
					state <= delCWait;
				end
				else if (btnL) begin
					state <= doNothing;
				end
				else state <= deleteWait;
				
				if (trackDelete == 0) begin
					play_flag <= 0;
					memfull_flag <= 0;
					record_flag <= 0;
					delete_flag <= 0;
					deleteall_flag <= 0;
					displayMessage0 <= 1;
					displayMessage1 <= 0;
					displayMessage2 <= 0;
					displayMessage3 <= 0;
					displayMessage4 <= 0;
				end
				else if (trackDelete == 1) begin
					record_flag <= 0;
					memfull_flag <= 0;
					play_flag <= 0;
					delete_flag <= 0;
					deleteall_flag <= 0;
					displayMessage0 <= 0;
					displayMessage1 <= 1;
					displayMessage2 <= 0;
					displayMessage3 <= 0;
					displayMessage4 <= 0;
				end
				else if (trackDelete == 3'd2) begin
					delete_flag <= 0;
					memfull_flag <= 0;
					record_flag <= 0;
					play_flag <= 0;
					deleteall_flag <= 0;
					displayMessage0 <= 0;
					displayMessage1 <= 0;
					displayMessage2 <= 1;
					displayMessage3 <= 0;
					displayMessage4 <= 0;
				end
				else if (trackDelete == 3'd3) begin
					deleteall_flag <= 0;
					memfull_flag <= 0;
					record_flag <= 0;
					play_flag <= 0;
					delete_flag <= 0;
					displayMessage0 <= 0;
					displayMessage1 <= 0;
					displayMessage2 <= 0;
					displayMessage3 <= 1;
					displayMessage4 <= 0;
				end
				else if (trackDelete == 3'd4) begin
					deleteall_flag <= 0;
					memfull_flag <= 0;
					record_flag <= 0;
					play_flag <= 0;
					delete_flag <= 0;
					displayMessage0 <= 0;
					displayMessage1 <= 0;
					displayMessage2 <= 0;
					displayMessage3 <= 0;
					displayMessage4 <= 1;
				end
				
			end
			
			delDWait: begin
				if (!btnD) begin
					state <= delete;
				end
				else state <= delDWait;
				keepTrackDelete <= 0;
			end
			delUWait: begin
				if (!btnU) begin
					state <= delete;
				end
				else state <= delUWait;
				keepTrackDelete <= 1;
			end
			delCWait: begin
				if (!btnC) begin
					state <= delete;
				end
				else state <= delCWait;
				keepTrackDelete <= 3'd2;
			end
			
			delete: begin
				if (keepTrackDelete == 0) begin
					if (trackDelete == 0)
						trackDelete <= 0;
					else
						trackDelete <= trackDelete - 1'b1;
					state <= deleteWait;
				end
				if (keepTrackDelete == 1) begin
					if (trackDelete == 3'd4)
						trackDelete <= 3'd4;
					else
						trackDelete <= trackDelete + 1'b1;
					state <= deleteWait;
				end
				if (keepTrackDelete == 2'b10) begin
					if (trackDelete == 0) begin
						message0Valid <= 0;
						state <= deleteWait;
					end
					else if (trackDelete == 1) begin
						message1Valid <= 0;
						state <= deleteWait;
					end
					else if (trackDelete == 3'd2) begin
						message2Valid <= 0;
						state <= deleteWait;
					end
					else if (trackDelete == 3'd3) begin
						message3Valid <= 0;
						state <= deleteWait;
					end
					else if (trackDelete == 3'd4) begin
						message4Valid <= 0;
						state <= deleteWait;
					end
				end
			end
			//-------------------end delete----------------------
			displayMemFull: begin
				//delay <= delay + 1;
				if (btnL) begin//delay == 30) begin
					state <= doNothing;
					//delay <= 0;
				end
				else state <= displayMemFull;
				memfull_flag <= 1;
			end
		endcase
	end
	if (state == record1 || state == recordWait || state == record3) begin
		recording <= 1;
	end
	else recording <= 0;
	if (state == skip || state == skipWait)
		skipping <= 1;
	else skipping <= 0;
end 

endmodule
