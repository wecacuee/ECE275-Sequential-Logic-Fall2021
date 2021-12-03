module testtop(
input ball_position_x,
input ball_position_y,
input ball_velocity_x,
input ball_velocity_y
output reg ball_position_x,
output reg ball_position_y
);

always @(posedge clk_50)
	begin	
		ball_position_x = ball_position_x + ball_velocity_x;
     ball_position_y = ball_position_y + ball_velocity_y;
endmodule


`timescale 1ns / 1ps
module testbench();
		reg ball_position_x;
		reg ball_position_y;
		reg ball_velocity_x;
		reg ball_velocity_y;
		wire ball_position_x;
		wire ball_position_y;
		testtop test (ball_position_x,ball_position_y,ball_velocity_x,ball_velocity_y,ball_position_x,ball_position_y);
		initial
		begin
				ball_position_x <= 0; ball_position_y <=0; ball_velocity_x <=1; ball_velocity_y <=1;   
				#10 ball_position_x <= 0; ball_position_y <=0; ball_velocity_x <=1; ball_velocity_y <=1;
				#10 ball_position_x <= 0; ball_position_y <=0; ball_velocity_x <=1; ball_velocity_y <=1;
				#20 ball_position_x <= 0; ball_position_y <=0; ball_velocity_x <=1; ball_velocity_y <=1;
				#20 ball_position_x <= 0; ball_position_y <=0; ball_velocity_x <=1; ball_velocity_y <=1;
		end
endmodule

