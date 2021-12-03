module testtop(
input 	   clk_50,
input 	   reset_n,
input      [3:0] ball_position_initial_x,
input      [3:0] ball_position_initial_y,
input      [3:0] ball_velocity_x,
input 	   [3:0] ball_velocity_y,
output reg [3:0] ball_position_x,
output reg [3:0] ball_position_y
);

always @(posedge clk_50 or negedge reset_n)
	if (!reset_n) begin
		ball_position_x = ball_position_initial_x;
		ball_position_y = ball_position_initial_y;
	end
	else begin	
		ball_position_x = ball_position_x + ball_velocity_x;
     	ball_position_y = ball_position_y + ball_velocity_y;
	end
endmodule


module ball_pos_to_grid(
    input clk_50,
    input [3:0] ball_position_x, 
    input [3:0] ball_position_y,
    output reg [16*8*16-1:0] grid
);
    integer x, y;
    always @(posedge clk_50) begin
        for (y = 0; y < 16; y = y + 1) begin
            for (x = 0; x < 16; x = x + 1) begin
                grid[y*16*8 + x*8 + 7 -: 8] = 
                    ((x == ball_position_x) && (y == ball_position_x)) ? "o" : "_";
            end
        end
    end
endmodule


`timescale 1ns / 1ps
module testbench();
		reg [3:0] ball_position_initial_x;
		reg [3:0] ball_position_initial_y;
		reg [3:0] ball_velocity_x;
		reg [3:0] ball_velocity_y;
		reg clk_50;
		reg reset_n;
		wire [3:0] ball_position_x;
		wire [3:0] ball_position_y;
        wire [16*8*16-1:0] grid;
		testtop test (clk_50,
			      reset_n,
			      ball_position_initial_x, 
			      ball_position_initial_y, 
			      ball_velocity_x, 
			      ball_velocity_y, 
			      ball_position_x,
			      ball_position_y);
        ball_pos_to_grid bptg(
            clk_50,
            ball_position_x, 
            ball_position_y,
            grid);
		initial
        
		begin
                $monitor("time:%03d\n15:%16s\n14:%16s\n13:%16s\n12:%16s\n11:%16s\n10:%16s\n09:%16s\n08:%16s\n07:%16s\n06:%16s\n05:%16s\n04:%16s\n03:%16s\n02:%16s\n01:%16s\n00:%16s\n",
      	          $time,
                  grid[16*8*16-1 -:16*8],
                  grid[16*8*15-1 -:16*8],
                  grid[16*8*14-1 -:16*8],
                  grid[16*8*13-1 -:16*8],
                  grid[16*8*12-1 -:16*8],
                  grid[16*8*11-1 -:16*8],
                  grid[16*8*10-1 -:16*8],
                  grid[16*8*09-1 -:16*8],
                  grid[16*8*08-1 -:16*8],
                  grid[16*8*07-1 -:16*8],
                  grid[16*8*06-1 -:16*8],
                  grid[16*8*05-1 -:16*8],
                  grid[16*8*04-1 -:16*8],
                  grid[16*8*03-1 -:16*8],
                  grid[16*8*02-1 -:16*8],
                  grid[16*8*01-1 -:16*8]
                );
				ball_position_initial_x <= 4'b0000; 
				ball_position_initial_y <= 4'b0000; 
				ball_velocity_x <= 4'b0001; 
				ball_velocity_y <= 4'b0001;
				clk_50 <= 1'b0;
				
				// Create a negative edge on reset_n at #1
				// and normalize the reset signal to 1 after a clock cycle (#10).
				reset_n <= 1'b1;
				#1 reset_n <= 1'b0;
				#9 reset_n <= 1'b1;
		end
		always #5 clk_50 = ~clk_50;
endmodule

