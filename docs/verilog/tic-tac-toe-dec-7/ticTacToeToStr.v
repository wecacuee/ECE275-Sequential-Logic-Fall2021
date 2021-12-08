// Converts ticTacToe grid to string
//  (1) grid_state_x: which cells of grid which are X's and which O's. 
//  (2) grid_state_fill: which cells of grid are marked, which are empty.
module ticTacToeToStr(grid_state_marked, grid_state_x, ttt_grid);
	input wire [8:0] grid_state_marked;
	input wire [8:0] grid_state_x;
	output reg [9*8:1] ttt_grid;
	integer gi;

always @(grid_state_marked, grid_state_x) begin
	for (gi = 9; gi >= 1; gi = gi - 1) begin
		ttt_grid[gi*8 -: 8] <= (grid_state_marked[gi-1]) ? (grid_state_x[gi-1] ? "x" : "o") : "_";
	end
end
endmodule