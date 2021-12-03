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
		testtop test (clk_50,
			      reset_n,
			      ball_position_initial_x, 
			      ball_position_initial_y, 
			      ball_velocity_x, 
			      ball_velocity_y, 
			      ball_position_x,
			      ball_position_y);
		initial
		begin

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

