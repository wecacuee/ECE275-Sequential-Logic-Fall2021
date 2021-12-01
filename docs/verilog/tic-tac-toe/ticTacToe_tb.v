`timescale 1ns/1ns
module ticTacToe_tb();
reg clk;
reg resetn;

// 8 7 6
// 5 4 3
// 2 1 0
// 1000 111 110
// 101  100 011
// 010  001 000
reg [4*7-1:0] input_seq;
integer input_seq_cursor;
reg [3:0] next_player_input_cell;

wire [8:0] grid_state_marked;
wire [8:0] grid_state_x;
wire player_x_turn;
wire someone_won;
wire player_x_won;
wire errno;
wire [9*8:1] ttt_grid;

ticTacToeCore ttt(
    .clk(clk),
    .resetn(resetn),
    .next_player_input_cell(next_player_input_cell),
    .grid_state_marked(grid_state_marked),
    .grid_state_x(grid_state_x), 
    .player_x_turn(player_x_turn), 
    .someone_won(someone_won),
    .player_x_won(player_x_won),
    .errno(errno));

ticTacToeToStr tostr(
    .grid_state_marked(grid_state_marked),
    .grid_state_x(grid_state_x),
    .ttt_grid(ttt_grid));

initial begin

    clk = 0;
    resetn = 0;
    #5 resetn = 1;
    
    $monitor("time:%3d\n resetn: %b\n move:%04b\n%s\n%s\n%s\n sw: %b, xw: %b", 
        $time,
        resetn,
        next_player_input_cell,
        ttt_grid[9*8 -: 3*8],
        ttt_grid[6*8 -: 3*8],
        ttt_grid[3*8 -: 3*8],
        someone_won, player_x_won);
end

always #5 clk = ~clk;

always @(negedge resetn) begin
    if (!resetn) begin
        // Sequence of moves
        input_seq = 28'b1000_0100_0000_0010_0110_0011_0111;
        input_seq_cursor = 27;
        next_player_input_cell = input_seq[input_seq_cursor -:4];
    end
end

always @(posedge clk) begin
    // Tried this: next_player_input_cell = input_seq[4*input_seq_cursor:4*input_seq_cursor-4];
    // Got this error: "Range must be bounded by constant expressions."
    // Fixed by this: https://stackoverflow.com/questions/25123924/verilog-range-must-be-bounded-by-constant-expression
    input_seq_cursor = (input_seq_cursor <= 4) ? input_seq_cursor : input_seq_cursor - 4;
    next_player_input_cell = input_seq[input_seq_cursor -:4];
    if (errno) begin
        $display("error");
        resetn = 0;
        #5 resetn = 1;
    end
    if (someone_won) begin
        $display("player %s won", player_x_won ? "x" : "o");
        resetn = 0;
        #5 resetn = 1;
    end
end



endmodule