// Implement the C for-loop
// for (i = 0; i < 10; i++)
//      x = x + y
// if (x < 0)
//     y = 0
// else
// 	   x = 0
`timescale 1ns/1ns // period of each step/round off each time
module cumsum(input wire clk, input wire reset, input wire [7:0] y, input wire [3:0] maxn, output reg [7:0] x);
reg [3:0] i;
always @(posedge clk)
	if (i == maxn || reset) begin
		i <= 4'b0;
		x <= 8'b0;
	end
	else begin
		i <= i + 1;
		x <= x + y;
	end

endmodule