// Design a Mealy sequential circuit which investigates an input sequence X and which will produce an output
// of Z = 1 for any input sequence ending in 0101 provided that the sequence 110 has never occurred.
// Example:
// 	X= 0 1 0 1 0 1 1 0 1 0 1
// 	Z= 0 0 0 1 0 1 0 0 0 0 0
// Notice that the circuit does not reset to the start state when an output of Z = 1 occurs.
module midterm2 (Clock, Resetn, X, Z);
input Clock, Resetn, X;
output reg Z = 'b0;
parameter [3:1] S0 = 3'b000, S1 = 3'b001, 
		S2 = 3'b010, S3 = 3'b011,
		S4 = 3'b100, S5 = 3'b101;
reg [3:1] y = S0, Y = S0;

// Define the next state combinational circuit
always @(X, y)
	case (y)
	S0: begin
		Y = ~X ? S1 : S4;
		Z = 'b0;
	end
	S1: begin
		Y = ~X ? S1 : S2;
		Z = 'b0;
	end
	S2: begin
		Y = ~X ? S3 : S5;
		Z = 'b0;
	end
	S3: begin
		Y = ~X ? S1 : S2;
		Z = (X == 'b1);
	end
	S4: begin
		Y = ~X ? S1 : S5;
		Z = 'b0;
	end
	S5: begin
		Y = ~X ? S5 : S5;
		Z = 'b0;
	end
	default: 
	begin 
		Y = 2'bxx;
		// Define output
		Z = 'bx;
	end
	endcase

	
	// Define the sequential block
always @(negedge Resetn, posedge Clock)
	if (Resetn == 0) y <= S0;
	else y <= Y;
endmodule