module ticTacToeCore
    (
          CLOCK,
          reset_n_in,
		  BUTTON,
          grid_state_marked,
          grid_state_x,
		  reset_out,
          cell_cursor,
		  cell_enter,
		  next_valid_cell,
          player_x_turn,
          someone_won,
          player_x_won,
          errno
     );
input wire CLOCK;
input wire reset_n_in;
input wire [2:0] BUTTON;

output reg [3:0] cell_cursor;
output wire cell_enter;
output wire reset_out;        		// Reset
output reg [8:0] grid_state_marked;
output reg [8:0] grid_state_x;
output wire next_valid_cell;
output reg player_x_turn;

output wire someone_won;
output wire player_x_won;
output reg errno;

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



ticTacToeWin win(.grid_state_marked(grid_state_marked), 
                 .grid_state_x(grid_state_x), 
                 .someone_won(someone_won),
                 .player_x_won(player_x_won));

//====================================================================
// Move cursor based on grid_state_marked
//====================================================================

always @ (posedge CLOCK or negedge reset_out)
    begin
        if(!reset_out)
            begin
                cell_cursor <= 8'h00;
                player_x_turn  <= 1'b0;
                
                grid_state_marked = 9'b000_000_000;
                grid_state_x      = 9'b000_000_000;
                errno  		      = 1'b0;
            end
        else begin
            if (grid_state_marked == 9'b111_111_111 || someone_won) begin
                  cell_cursor <= cell_cursor;
            end
            else if (next_valid_cell | grid_state_marked[cell_cursor]) begin
                cell_cursor <= cell_cursor_dec;
            end 
            else if (cell_enter) begin
                player_x_turn = ~player_x_turn;
                grid_state_marked[cell_cursor] = 1'b1;
                grid_state_x[cell_cursor] = player_x_turn;
            end
            else begin
                cell_cursor <= cell_cursor;
             end
             
             prev_BUTTON <= BUTTON[2:1];
        end
    end
endmodule
