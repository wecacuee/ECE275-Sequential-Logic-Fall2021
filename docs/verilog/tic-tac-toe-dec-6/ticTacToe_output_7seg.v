module ticTacToe_output_7seg
		(
		CLOCK,
		reset_n,
		next_valid_cell,
		current_cell,
		enter_current_cell,
		grid_state_marked,
		player_x_turn,
		someone_won,
		player_x_won,
		errno,
		SEG7_4
);
input wire 		  CLOCK;
input wire	     reset_n;
input wire 		  next_valid_cell;
input wire [3:0] current_cell;
input wire 		  enter_current_cell;
input wire [8:0] grid_state_marked;
input wire 		  player_x_turn;
input wire 		  someone_won;
input wire 		  player_x_won;
input wire 		  errno;

output wire [7*4-1:0] SEG7_4;

genvar segidx;
wire [8*4-1:0]  	ASCII4;					// ASCII 3 to display
reg entered_current_cell;
reg  [3:0] last_cell_entered;
reg last_player_x_entered;
reg  [7:0] cell_buffer;
wire [7:0] player;
reg [7:0] counter;
wire [8*4-1:0] ASCII4_counter;



//==================================================================
//  Structural coding
//==================================================================
assign player = (player_x_turn) ? "X" : "O";
assign ASCII4 = (!reset_n) ? "Rst "
                   : (errno) ? "Err "
				   : (grid_state_marked == 9'b111_111_111 && !someone_won)
					? "DRAW"
					: (someone_won)
					? ((player_x_won) ? "XVIC" : "OVIC")
					: (entered_current_cell)
					? {last_player_x_entered ? "X" : "O", "E ", 4'b0, last_cell_entered}
					: {player, "C ", 4'b0, current_cell};
assign ASCII4_counter = {16'b0, 4'b0, counter[7:4], 4'b0, counter[3:0]};
                   

generate
	for (segidx = 0; segidx < 4; segidx  = segidx + 1) begin: asc_to_7seg_gen
		// This is SEG[i] Display//
		asc_to_7seg	SEG(
						.bin   (ASCII4[8*segidx+7 -:8]),
						.seg   (SEG7_4[7*segidx+6 -:7])
						);
	end
endgenerate


always @(posedge CLOCK or negedge reset_n) begin
	if (!reset_n) begin
		entered_current_cell = 1'b0;
		last_cell_entered = 4'b1111;
		cell_buffer = 8'b1111_1111;
		last_player_x_entered = 1'b0;
        counter = 8'b0;
	end
	else begin
		if (enter_current_cell) begin
			entered_current_cell = 1'b1;
			last_cell_entered = current_cell;
			last_player_x_entered = player_x_turn;
            counter = counter - 8'b1;
		end
		if (next_valid_cell) begin
			entered_current_cell = 1'b0;
            counter = counter + 8'b1;
		end
	end
end
endmodule