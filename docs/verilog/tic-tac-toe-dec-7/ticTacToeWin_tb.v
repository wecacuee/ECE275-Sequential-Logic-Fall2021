`timescale 1ns/100ps
module ticTacToeWin_tb();

reg [8:0] grid_state_marked;
reg [8:0] grid_state_x;
wire someone_won;
wire player_x_won;



ticTacToeWin win(.grid_state_marked(grid_state_marked), 
        .grid_state_x(grid_state_x), 
        .someone_won(someone_won),
        .player_x_won(player_x_won));

initial begin
    
    $monitor("%3d\n%03b\n%03b\n%03b\n sw: %b, xw: %b", 
        $time,
        grid_state_x[8:6],
        grid_state_x[5:3],
        grid_state_x[2:0],
        someone_won, player_x_won);
        
    // xxx
    // ooo
    // ___
    grid_state_marked = 9'b111_111_000;
    grid_state_x = 9'b111_000_000;
    #20 begin
        // xxx
        // o__
        // ___
        grid_state_marked = 9'b111_100_100;
        grid_state_x = 9'b011_000_000;
    end
    #40 begin
        // xxx
        // ox_
        // o_x
        grid_state_marked = 9'b111_110_101;
        grid_state_x = 9'b111_010_001;
    end
end




endmodule