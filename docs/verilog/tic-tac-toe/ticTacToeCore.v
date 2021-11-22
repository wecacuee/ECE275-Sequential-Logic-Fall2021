// tic_tac_toe_core
// This module is responsible for maintaining game state and progressing the game for every input.
// 
// clk: take input at the rising edge of the clock
// next_player_input_cell: For every move next_player_input_cell provides a number between 1'h0 1'h9 
// 						   indicating the cell to be updated be marked.
// Game state consists of 3 parts: 
//  (1) grid_state_x: which cells of grid which are X's and which O's. 
//  (2) grid_state_fill: which cells of grid are marked, which are empty. 
//  (3) player_x_turn: Whether it is player X's turn or player O's turn.
//  (4) player_x_win: Whether the game is undecided, draw, player X won or player O won.
module ticTacToeCore(clk, resetn, next_player_input_cell, grid_state_marked, grid_state_x, 
		     player_x_turn, 
		     someone_won,
		     player_x_won,
		     errno);
input wire clk;
input wire resetn;
input wire [3:0] next_player_input_cell;
output reg [8:0] grid_state_marked;
output reg [8:0] grid_state_x;
output reg player_x_turn;
output reg someone_won;
output reg player_x_won;
output reg errno;

reg [8:0] next_grid_state_marked;
reg [8:0] next_grid_state_x;
reg next_player_x_turn;
wire next_someone_won;
wire next_player_x_won;

always @(next_player_input_cell) begin
	next_grid_state_marked = grid_state_marked;
	next_grid_state_x = grid_state_x;
	next_player_x_turn = ~player_x_turn;
	if (grid_state_marked[next_player_input_cell]) begin
		errno = 1;
	end else begin
		next_grid_state_marked[next_player_input_cell] = 1;
		next_grid_state_x[next_player_input_cell] = player_x_turn;
	end
end



ticTacToeWin win(.grid_state_marked(next_grid_state_marked), 
						.grid_state_x(next_grid_state_x), 
						.someone_won(next_someone_won),
						.player_x_won(next_player_x_won));



always @(posedge clk, negedge resetn) begin
	if (~resetn) begin
		grid_state_marked = 9'b0;
		grid_state_x = 9'b0;
		player_x_turn = 0;
		someone_won = 0;
		player_x_won = 0;
	end else begin
		grid_state_marked = next_grid_state_marked;
		grid_state_x = next_grid_state_x;
		player_x_turn = next_player_x_turn;
		someone_won = next_someone_won;
		player_x_won = next_player_x_won;
	end
end
	
endmodule