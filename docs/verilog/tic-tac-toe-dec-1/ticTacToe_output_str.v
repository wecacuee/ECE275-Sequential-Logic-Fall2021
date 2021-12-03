//
module ticTacToe_output_str
    (
        current_cell, 
        player_x_turn,
        someone_won,
        player_x_won,
        errno,
        SEG7_4
);

input wire [3:0] current_cell;
input wire        player_x_turn;
input wire        someone_won;
input wire        player_x_won;
input wire        errno;

output wire [7*4-1:0] SEG7_4;

genvar segidx;
reg     [8*4-1:0]   ASCII4;                 // ASCII 3 to display

//==================================================================
//  Structural coding
//==================================================================


//==================================================================
// Non-sythesizeable code
//==================================================================
always @(current_cell or player_x_turn or someone_won or player_x_won or errno) begin

    
    if (errno) begin
        $display("ERR");
    end else if (someone_won) begin
            $display((player_x_won) ? "XWON" : "OWON");
    end else begin
            $display({(player_x_turn) ? "X " : "O ", 4'h0, current_cell});
    end
end

endmodule