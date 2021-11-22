`timescale 1ns/1ns // period of each step/round off each time
module cumsum_tb();
wire [7:0] x;
reg [7:0] y;
reg [3:0] maxn;
reg reset;
reg clk;

initial begin
	$monitor($time,,,"clk=%b, reset=%b, x=%d", clk, reset, x);
	clk = 0;
	maxn = 4'b1001;
	y = 8'b10;
	reset <= 1;
	#10 reset <= 0;
end
always #5 clk = ~clk;


cumsum_for MOT(.clk(clk), .reset(reset), .y(y), .maxn(maxn), .x(x));
endmodule