`timescale 1ns/1ns
module midterm2_tb();
	reg clk; // define a reg (ff)
	reg [3:0] count; // define 4 reg count
	reg X;
	wire	Z; // input and output
	wire Resetn = 1;

	initial begin
		clk = 0;
		count = 4'h0;
		$monitor($time,,, "Z = %b", Z);
		$display("Z = %b", Z);
		X = 'b0;
	end
	
	always #5 clk = ~clk; // Every 5ns
	always @(posedge clk) begin
		case (count) 	// X= 0 1 0 1 0 1 1 0 1 0 1
			('h0): X = 'b0;
			('h1): X = 'b1;
			('h2): X = 'b0;
			('h3): X = 'b1;
			('h4): X = 'b0;
			('h5): X = 'b1;
			('h6): X = 'b1;
			('h7): X = 'b0;
			('h8): X = 'b1;
			('h9): X = 'b0;
			('hA): X = 'b1;
			default begin 
				X = 'b0;
				$finish;
			end
		endcase
		count = count + 1;
	end


	midterm2 MOT(.Clock(clk), .Resetn(Resetn), .X(X), .Z(Z)); // MOT = module under test
	
endmodule // midterm2_tb