module testtop(
input 	   clk_50,
input      ball_position_initial_x,
input      ball_position_initial_y,
input      ball_velocity_x,
input 	   ball_velocity_y,
output reg ball_position_x,
output reg ball_position_y
);

always @(posedge clk_50)
	begin	
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
		wire ball_position_x;
		wire ball_position_y;
		testtop test (ball_position_initial_x, 
			      ball_position_initial_y, 
			      ball_velocity_x, 
			      ball_velocity_y, 
			      ball_position_x,
			      ball_position_y);
		initial
		begin
				ball_position_initial_x <= 0; 
				ball_position_initial_y <=0; 
				ball_velocity_x <=1; 
				ball_velocity_y <=1;
		end
endmodule

