// Input module 
module ticTacToe_input_old
    (
        CLOCK_50,
        reset_n_in,
		  BUTTON,
        grid_state_marked,
		  reset_out,
        cell_cursor,
		  cell_enter
        );
input wire CLOCK_50;
input wire reset_n_in;
input wire [2:0] BUTTON;
input wire [8:0] grid_state_marked;

output reg [3:0] cell_cursor;
output wire cell_enter;
output wire reset_out;        		// Reset


wire  [2:1]		negedge_button;    	// Counter for Button[1]
reg   [2:1]		prev_BUTTON;   		// Button1 Register output


reg  [3:0] i;
reg  [3:0] steps;
wire [3:0] cell_cursor_dec;


//====================================================================
// Display process
//====================================================================

assign reset_out   = BUTTON[0]; 			 		 
assign negedge_button = (~BUTTON[2:1] & prev_BUTTON); // negedge button 1 

assign next_valid_cell = negedge_button[1];
assign cell_enter = negedge_button[2];
assign cell_cursor_dec = (cell_cursor == 4'b0000) ? 4'b1000 : cell_cursor - 1; // loop around to 8 after 0

//====================================================================
// After debounce output with register
//====================================================================

always @ (posedge CLOCK_50 or negedge reset_out)
    begin
        if(!reset_out)
            begin
                cell_cursor <= 8'h00;
            end
        else begin
					 if (grid_state_marked == 9'b111_111_111) begin
						  cell_cursor <= cell_cursor_dec;
                end else if (next_valid_cell | grid_state_marked[cell_cursor]) begin
                    cell_cursor <= cell_cursor_dec;
                end else begin
                    cell_cursor <= cell_cursor;
                end
					 
					 prev_BUTTON <= BUTTON[2:1];
        end
    end
endmodule