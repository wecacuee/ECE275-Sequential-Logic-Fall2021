// tic_tac_toe_core
// This module is responsible for maintaining game state and progressing the game for every input.
// 
// clk: take input at the rising edge of the clock
// player_input_cursor: For every move player_input_cursor provides a number between 1'h0 1'h9 
//                         indicating the cell to be updated be marked.
// Game state consists of 4parts: 
//  (1) grid_state_x: which cells of grid which are X's and which O's. 
//  (2) grid_state_fill: which cells of grid are marked, which are empty. 
//  (3) player_x_turn: Whether it is player X's turn or player O's turn.
//  (4) player_x_win: Whether the game is undecided, draw, player X won or player O won.
module old_ticTacToeCore
(
	CLOCK, 
	player_enter, 
	reset_n, 
	player_input_cursor, 
	grid_state_marked, 
	grid_state_x, 
	player_x_turn, 
	someone_won,
    player_x_won,
    errno
);
input wire CLOCK;
input wire player_enter;
input wire reset_n;
input wire [3:0] player_input_cursor;
input wire player_x_turn;

input wire [8:0] grid_state_marked;
input wire [8:0] grid_state_x;
output reg someone_won;
output reg player_x_won;
output reg errno;



always @(posedge CLOCK or negedge reset_n) begin
    if (!reset_n) begin

	 end
	 else begin
    end
end
    
endmodule