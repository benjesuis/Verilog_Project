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
			4'b0000 : encoding <= 7'b1111110;
			4'b0001 : encoding <= 7'b0110000;
			4'b0010 : encoding <= 7'b1101101;
			4'b0011 : encoding <= 7'b1111001;
			4'b0100 : encoding <= 7'b0110011;
			4'b0101 : encoding <= 7'b1011011;
			4'b0110 : encoding <= 7'b1011111;
			4'b0111 : encoding <= 7'b1110000;
			4'b1000 : encoding <= 7'b1111111;
			4'b1001 : encoding <= 7'b1110011;
			default : encoding <= 7'b0000001;
		endcase
	end
	
	assign seven_out = encoding;

endmodule
