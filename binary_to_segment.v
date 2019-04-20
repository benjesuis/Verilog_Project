`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:05:11 04/03/2019 
// Design Name: 
// Module Name:    binary_to_segment 
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
module binary_to_segment(seven_in, seven_out);
	input [4:0]seven_in;
	output [6:0]seven_out;
	reg [6:0]encoding;

	always @(*) begin
		case(seven_in)
			5'b00000 : encoding <= 7'b0000001; // 0
			5'b00001 : encoding <= 7'b1001111; // 1
			5'b00010 : encoding <= 7'b0010010; // 2
			5'b00011 : encoding <= 7'b0000110; // 3
			5'b00100 : encoding <= 7'b1001100; // 4
			5'b00101 : encoding <= 7'b0100100; // 5
			5'b00110 : encoding <= 7'b0100000; // 6
			5'b00111 : encoding <= 7'b0001111; // 7
			5'b01000 : encoding <= 7'b0000000; // 8
			5'b01001 : encoding <= 7'b0000100; // 9
			5'b01010 : encoding <= 7'b0110001; // C
			5'b01011 : encoding <= 7'b1110001; // L 
			5'b01100 : encoding <= 7'b0100100; // S 
			5'b01101 : encoding <= 7'b1000010; // d 
			5'b01110 : encoding <= 7'b0000001; // 0 
			5'b01111 : encoding <= 7'b0011000; // P 
			5'b10000 : encoding <= 7'b0110000; // E
			5'b10001 : encoding <= 7'b1101010; // n 
			5'b10010 : encoding <= 7'b1111110; // - (tire)
			5'b10011 : encoding <= 7'b1111111; // blank
		endcase
	end
	
	assign seven_out = encoding;

endmodule
