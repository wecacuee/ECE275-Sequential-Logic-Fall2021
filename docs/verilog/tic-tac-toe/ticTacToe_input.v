// Input module 
module ticTacToe_input
	(
		CLOCK_50,
		reset_n,
		next_valid_cell,
		grid_state_marked,
		cell_cursor
		);
input wire CLOCK_50;
input wire next_valid_cell;
input wire reset_n;
input wire [8:0] grid_state_marked;

output reg [3:0] cell_cursor;
integer i;


//====================================================================
// Display process
//====================================================================
always @ (posedge CLOCK_50 or negedge reset_n)
	begin
		if(!reset_n)
			begin
				cell_cursor <= 8'h00;
			end
		else begin
				if (next_valid_cell) begin
						cell_cursor = cell_cursor - 1'b1;
						for (i = 7; i >= 0; i = i - 1) begin
							if (grid_state_marked[cell_cursor]) begin
								cell_cursor = cell_cursor - 1'b1;
							end
						end
					end
				else begin
						cell_cursor <= cell_cursor;
				end
		end
	end
endmodule