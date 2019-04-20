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
	 output [6:0] seven_out
    );
	 
wire slower_clock;
	reg [1:0] count;
	reg [6:0] encoding;
	reg [4:0] seven_in_reg;
	wire [4:0] seven_in;
	initial begin // Initial block , used for correct simulations
		AN = 4'b1110;
		//seven_in = 0;
		count = 0;
	end
	

//binary_to_segment disp0(seven_in,seven_out);		//translate to 7 LED values
clk_divider clkdiv(clk, reset, slower_clock);

//Always block
always @(*) begin
		case(seven_in)
			5'b00000 : encoding = 7'b0000001; // 0 uncomment, testing purposes
			5'b00001 : encoding = 7'b1001111; // 1
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
			default : encoding = 7'b0110110;
		endcase
		
	end
	assign seven_out = encoding;
	
// Also count value is operating in very  high frequency? Think about how to fix it!
always @(posedge slower_clock) begin
	count <= count + 1;
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
assign seven_in = seven_in_reg;

endmodule
