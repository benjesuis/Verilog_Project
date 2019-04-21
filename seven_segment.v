`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:11:06 04/07/2016 
// Design Name: 
// Module Name:    seven_segment 
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
module seven_segment(
    input clk,
	 input reset,
	 input [19:0] big_bin,
	 output reg [3:0] AN,
	 output [6:0] seven_out,
	 input isbackdoor
    );
	 
wire slower_clock;
	reg [1:0] count;
	integer count2;
	reg [6:0] encoding;
	reg [4:0] seven_in_reg;
	reg [7:0] scroll_period;
	reg [7:0] scroll_comp;
	reg [19:0] big_bin_scroll;
	wire [4:0] seven_in;
	initial begin // Initial block , used for correct simulations
		AN = 4'b1110;
		//seven_in = 0;
		scroll_comp = 8'b11111111;
		scroll_period = 8'b00000000;
		count = 0;
		count2 = 0;
		big_bin_scroll = 20'b10000010100001110100;
	end
	

//binary_to_segment disp0(seven_in,seven_out);		//translate to 7 LED values
clk_divider_CALIENTE clkdivSSD(clk, reset, slower_clock);

//Always block
always @(*) begin
		case(seven_in)
			5'b00000 : encoding = 7'b0000001; // 0 uncomment, testing purposes
			5'b00001 : encoding = 7'b1001111; // 1 and I
			5'b00010 : encoding = 7'b0010010; // 2
			5'b00011 : encoding = 7'b0000110; // 3
			5'b00100 : encoding = 7'b1001100; // 4
			5'b00101 : encoding = 7'b0100100; // 5
			5'b00110 : encoding = 7'b0100000; // 6
			5'b00111 : encoding = 7'b0001111; // 7
			5'b01000 : encoding = 7'b0000000; // 8
			5'b01001 : encoding = 7'b0000100; // 9
			5'b01010 : encoding = 7'b0110001; // C
			5'b01011 : encoding = 7'b1110001; // L 
			5'b01100 : encoding = 7'b0100100; // S 
			5'b01101 : encoding = 7'b1000010; // d 
			5'b01110 : encoding = 7'b0000001; // 0 
			5'b01111 : encoding = 7'b0011000; // P 
			5'b10000 : encoding = 7'b0110000; // E
			5'b10001 : encoding = 7'b1101010; // n 
			5'b10010 : encoding = 7'b1111110; // - (tire)
			5'b10011 : encoding = 7'b1111111; // blank
			5'b10100 : encoding = 7'b1001001; // 11
			5'b10101 : encoding = 7'b1110001; // L
			5'b10110 : encoding = 7'b1000001; // V
			default : encoding = 7'b0110110;
		endcase
		
	end
	assign seven_out = encoding;
	
// Also count value is operating in very  high frequency? Think about how to fix it!
always @(posedge slower_clock) begin
	count <= count + 1;
	
	if (isbackdoor == 1) begin
		case (count2)
			1 : big_bin_scroll = 20'b10011100111001110011; // ____
			2 : big_bin_scroll = 20'b10011100111001100001; // ___I
			3 : big_bin_scroll = 20'b10011100110000110011; // __I_
			4 : big_bin_scroll = 20'b10011000011001110101; // _I_L
			5 : big_bin_scroll = 20'b00001100111010101110; // I_LO
			6 : big_bin_scroll = 20'b10011101010111010110; // _LOV
			7 : big_bin_scroll = 20'b10101011101011010000; // LOVE
			8 : big_bin_scroll = 20'b01110101101000010011; // OVE_
			9 : big_bin_scroll = 20'b10110100001001110000; // VE_E
			10: big_bin_scroll = 20'b10000100111000001010; // E_EC
			11: big_bin_scroll = 20'b10011100000101000011; // _EC3
			12: big_bin_scroll = 20'b10000010100001100001; // EC31
			13: big_bin_scroll = 20'b01010000110000100001; // C311
			14: big_bin_scroll = 20'b00011000010000110011; // 311_
			15: big_bin_scroll = 20'b00001000011001110011; // 11__
			16: big_bin_scroll = 20'b100001100111001110011; // 1___
			default: big_bin_scroll = 20'b10011100111001110011; // ____
		endcase
	end
	else begin
		//big_bin = big_bin;
	end
	
	if (isbackdoor == 0) begin
		case (count)
		0: begin 
			AN <= 4'b1110;
			seven_in_reg <= big_bin[4:0];
		end
	 
		1: begin 
			AN <= 4'b1101;
			seven_in_reg <= big_bin[9:5];	
		end
		2: begin 
			AN <= 4'b1011;
			seven_in_reg <= big_bin[14:10];			
		end
		3: begin 
			AN <= 4'b0111;
			seven_in_reg <= big_bin[19:15];
		end
		endcase
	end
	else begin
				case (count)
		0: begin 
			AN <= 4'b1110;
			seven_in_reg <= big_bin_scroll[4:0];
		end
	 
		1: begin 
			AN <= 4'b1101;
			seven_in_reg <= big_bin_scroll[9:5];	
		end
		2: begin 
			AN <= 4'b1011;
			seven_in_reg <= big_bin_scroll[14:10];			
		end
		3: begin 
			AN <= 4'b0111;
			seven_in_reg <= big_bin_scroll[19:15];
		end
		endcase
	end
	
	scroll_period <= scroll_period + 8'b00000001;
	if (scroll_period == scroll_comp) begin
		count2 <= count2 + 1;
		scroll_period <= 8'b00000000;
	end
	if (count2 >= 17) begin
		count2 <= 0;
	end

end
assign seven_in = seven_in_reg;

endmodule
