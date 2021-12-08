`timescale 1ns/1ns
module ticTacToeCore_tb();
reg clk;
reg reset_n;


// 8 7 6
// 5 4 3
// 2 1 0
// 1000 111 110
// 101  100 011
// 010  001 000
reg [4*7-1:0] input_seq;
integer      input_seq_cursor;
reg  [3:0]   player_input_cursor;
reg          player_enter;
reg          player_enter_delayed;
reg  [7:0]   counter_player_enter; // 256

wire [8:0]   grid_state_marked;
wire [8:0]   grid_state_x;
wire         player_x_turn;
wire         someone_won;
wire         player_x_won;
wire         errno;
wire [9*8:1] ttt_grid;


ticTacToeCore ttt(
    .CLOCK(clk),
    .player_enter(player_enter),
    .reset_n(reset_n),
    .player_input_cursor(player_input_cursor),
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

    clk = 1'b0;
    reset_n = 1'b0;
    #5 reset_n = 1'b1;
    player_enter = 1'b0;
    
    $monitor("time:%3d\n reset_n: %b\n move:%04b\n%s\n%s\n%s\n sw: %b, xw: %b", 
        $time,
        reset_n,
        player_input_cursor,
        ttt_grid[9*8 -: 3*8],
        ttt_grid[6*8 -: 3*8],
        ttt_grid[3*8 -: 3*8],
        someone_won, player_x_won);
end


always #5 clk = ~clk;


always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        counter_player_enter = 8'b0;
        
        // Sequence of moves
        input_seq = 28'b1000_0100_0000_0010_0110_0011_0111;
        input_seq_cursor = 27;
        player_input_cursor = input_seq[input_seq_cursor -:4];
    end else begin
        if (counter_player_enter == 8'hFF) begin
            player_enter = 1'b1;
        end else if (player_enter == 1'b1) begin
            player_enter = 1'b0; 
        end
        counter_player_enter = counter_player_enter + 1'b1;
    end
end

always @(posedge clk or negedge reset_n) begin
    player_enter_delayed <= player_enter;
    if (player_enter_delayed) begin
        if (errno) begin
            $display("error");
            reset_n = 0;
            #5 reset_n = 1;
        end else if (someone_won) begin
            $display("player %s won", player_x_won ? "x" : "o");
        end else begin
            input_seq_cursor = input_seq_cursor - 4;
            player_input_cursor = input_seq[input_seq_cursor -:4];
        end
        $display("time:%3d\n reset_n: %b\n move:%04b\n%s\n%s\n%s\n sw: %b, xw: %b", 
            $time,
            reset_n,
            player_input_cursor,
            ttt_grid[9*8 -: 3*8],
            ttt_grid[6*8 -: 3*8],
            ttt_grid[3*8 -: 3*8],
            someone_won, player_x_won);
    end
end

endmodule