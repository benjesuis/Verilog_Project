module clock_divider (
  input clock_in,
  input reset,
  output reg clock_out
);

reg [1:0] count;

always@(posedge clock_in or posedge reset) begin
  if(reset) begin
    count <= 2'b00;
  end else begin
    count <= count + 1'b1;
  end
end

always@(posedge clock_in or posedge reset) begin
  if(reset) begin
    clock_out <= 1'b0;
  end else begin
    clock_out <= count[1];
  end
end

endmodule

