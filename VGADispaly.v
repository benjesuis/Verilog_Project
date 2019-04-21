module vga_display(
  input rst,
  input clk,

  output [2:0]R,
  output [2:0]G,
  output [1:0]B,
  output HS,
  output VS,
  output reg light
);
  
   
  wire [10:0] hcount, vcount; // hcount is line position, vcount is screen position
  wire blank;
  wire clk_25Mhz;
  
  clock_divider clk_div_25 (
   .clock_in(clk),
   .reset(rst),
   .clock_out(clk_25Mhz)
  );

  vga_controller_640_60 vc(
    .rst(rst),
	 .pixel_clk(clk_25Mhz),
	 .HS(HS),
	 .VS(VS),
	 .hcounter(hcount),
	 .vcounter(vcount),
	 .blank(blank)
  );


  always @(posedge clk_25Mhz) begin
    light <= ~blank;
  end
		  
  assign R[2] = {3{(hcount >0) & (hcount < 640) & (vcount > 0) & (vcount < 480) ? 1:0}};
  assign R[1:0] = {0};
  assign G[2:0] = {0};
  assign B[1:0] = {0};

 
endmodule
