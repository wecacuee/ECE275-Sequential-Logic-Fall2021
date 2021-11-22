`timescale 1ns/1ns // period of each step/round off each time
module cumsum_for(clk, reset, y, maxn, x);
	input wire clk;
	input wire reset;
	input wire [7:0] y;
	input wire [3:0] maxn;
	output reg [7:0] x;
	integer i;
	always @(x, y) begin
		for (i = 0; i <= maxn; i = i+1) begin
			x = x + y;
		end
	end
	
	always @(i, reset) 
		if (i == maxn || reset)
			i = 0;
		
endmodule