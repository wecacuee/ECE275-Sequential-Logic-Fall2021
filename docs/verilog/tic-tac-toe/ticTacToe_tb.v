`timescale 1ns/1ns
module ticTacToe_tb();
reg clk;
reg resetn;
reg [8:0] player_x_input_seq;
reg [8:0] player_o_input_seq;
reg next_player_input_cell;

initial begin
	clk = 0;
	resetn = 0;
	#10 resetn = 1;
end

always #5 clk = ~clk;


ticTacToeCore ttt(
	.clk(clk),
	.resetn(resetn),
	.next_player_input_cell(next_player_input_cell));


endmodule