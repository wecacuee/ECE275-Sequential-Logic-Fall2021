module testtop(
input 	   clk_50,
input 	   reset_n,
input      ball_position_initial_x,
input      ball_position_initial_y,
input      ball_velocity_x,
input 	   ball_velocity_y,
output reg ball_position_x,
output reg ball_position_y
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
		reg ball_position_initial_x;
		reg ball_position_initial_y;
		reg ball_velocity_x;
		reg ball_velocity_y;
		reg clk_50;
		reg reset_n;
		wire ball_position_x;
		wire ball_position_y;
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

				ball_position_initial_x <= 1'b0; 
				ball_position_initial_y <= 1'b0; 
				ball_velocity_x <= 1'b1; 
				ball_velocity_y <= 1'b1;
				clk_50 <= 1'b0;
				
				// Create a negative edge on reset_n at #1
				// and normalize the reset signal to 1 after a clock cycle (#10).
				reset_n <= 1'b1;
				#1 reset_n <= 1'b0;
				#9 reset_n <= 1'b1;
		end
		always #5 clk_50 = ~clk_50;
endmodule

