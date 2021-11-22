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
//  (4) player_x_win: Whether the game is undecided, draw, player X won or player O won
module ticTacToeWin(grid_state_marked, grid_state_x, 
			someone_won,
		     	player_x_won);
input wire [8:0] grid_state_marked;
input wire [8:0] grid_state_x;
output reg someone_won;
output reg player_x_won;
integer r, c, d;
reg x, o;

always @(grid_state_marked, grid_state_x) begin

	// Check rows
	for (r = 0; r < 3; r = r + 1) begin
		x = 0;
		o = 0;
		for (c = 0; c < 3; c = c + 1) begin
			x = x & grid_state_marked[r*3 + c] & grid_state_x[r*3 + c];
			o = o & grid_state_marked[r*3 + c] & ~grid_state_x[r*3 + c];
		end
		if (x) begin
			someone_won = 1;
			player_x_won = 1;
		end
		if (o) begin
			someone_won = 1;
			player_x_won = 0;
		end
	end

	// Check columns
	for (c = 0; c < 3; c = c + 1) begin
		x = 0;
		o = 0;
		for (r = 0; r < 3; r = r + 1) begin
			x = x & grid_state_marked[r*3 + c] & grid_state_x[r*3 + c];
			o = o & grid_state_marked[r*3 + c] & ~grid_state_x[r*3 + c];
		end
		if (x) begin
			someone_won = 1;
			player_x_won = 1;
		end
		if (o) begin
			someone_won = 1;
			player_x_won = 0;
		end
	end

	// Check diagonal
	x = 0;
	o = 0;
	for (d = 0; d < 3; d = d + 1) begin
		x = x & grid_state_marked[d*3 + d] & grid_state_x[d*3 + d];
		o = o & grid_state_marked[d*3 + d] & ~grid_state_x[d*3 + d];
	end
	if (x) begin
		someone_won = 1;
		player_x_won = 1;
	end
	if (o) begin
		someone_won = 1;
		player_x_won = 0;
	end
	// Check diagonal 2
	x = 0;
	o = 0;
	for (d = 0; d < 3; d = d + 1) begin
		x = x & grid_state_marked[d*3 + (2-d)] & grid_state_x[d*3 + (2-d)];
		o = o & grid_state_marked[d*3 + (2-d)] & ~grid_state_x[d*3 + (2-d)];
	end
	if (x) begin
		someone_won = 1;
		player_x_won = 1;
	end
	if (o) begin
		someone_won = 1;
		player_x_won = 0;
	end
end
endmodule