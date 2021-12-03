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
module ticTacToeCore
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

output reg [8:0] grid_state_marked;
output reg [8:0] grid_state_x;
output reg player_x_turn;
output reg someone_won;
output reg player_x_won;
output reg errno;


wire next_player_x_turn;
wire next_someone_won;
wire next_player_x_won;

ticTacToeWin win(.grid_state_marked(grid_state_marked), 
                 .grid_state_x(grid_state_x), 
                 .someone_won(next_someone_won),
                 .player_x_won(next_player_x_won));

always @(posedge CLOCK or negedge reset_n) begin
    if (!reset_n) begin
        grid_state_marked = 9'b0;
        grid_state_x      = 9'b0;
        player_x_turn     = 1'b0;
        someone_won       = 1'b0;
        player_x_won      = 1'b0;
		  errno  		     = 1'b0;
	 end
	 else if (player_enter) begin
		  if (grid_state_marked[player_input_cursor]) begin
				errno = 1'b1;
		  end
		  else begin
				grid_state_marked[player_input_cursor] = 1'b1;
				grid_state_x[player_input_cursor] 		= player_x_turn;
				player_x_turn 									= ~player_x_turn;
		  end
    end
	 else begin
        someone_won = next_someone_won;
        player_x_won = next_player_x_won;
    end
end
    
endmodule