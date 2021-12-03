//
module ticTacToe_7seg_output
	(
		current_cell, 
		player_x_turn,
		someone_won,
		player_x_won,
		errno,
		SEG7_4
);

input wire [3:0] current_cell;
input wire 		  player_x_turn;
input wire 		  someone_won;
input wire 		  player_x_won;
input wire 		  errno;

output wire [7*4-1:0] SEG7_4;

genvar segidx;
reg 	[8*4-1:0]  	ASCII4;					// ASCII 3 to display


//==================================================================
//  Structural coding
//==================================================================

generate
	for (segidx = 0; segidx < 4; segidx  = segidx + 1) begin: asc_to_7seg_gen
		// This is SEG[i] Display//
		asc_to_7seg	SEG(
						.bin   (ASCII4[8*segidx+7 -:8]),
						.seg   (SEG7_4[7*segidx+6 -:7])
						);
	end
endgenerate
				 
always @(current_cell or player_x_turn or someone_won or player_x_won or errno) begin
	if (errno) begin
		ASCII4 <= "ERR";
	end else if (someone_won) begin
			ASCII4 <= (player_x_won) ? "XWON" : "OWON";
	end else begin
			ASCII4 <= {(player_x_turn) ? "X " : "O ", 4'h0, current_cell};
	end
end

endmodule