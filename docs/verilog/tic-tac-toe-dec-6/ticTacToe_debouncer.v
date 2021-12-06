module ticTacToe_debouncer
	(
		CLOCK,
		ORG_BUTTON,
		BUTTON
	);
////////////////////////	Clock Input	 	////////////////////////
input			CLOCK;				//	50 MHz
////////////////////////	Push Button		////////////////////////
input	[2:0]	ORG_BUTTON;				//	Pushbutton[2:0]
output wire [2:0] BUTTON;			// Button after debounce


genvar bdci;
//==================================================================
//  Structural coding
//==================================================================

generate
	for (bdci = 0; bdci < 3; bdci = bdci + 1) begin : button_debouncer_gen
		// This is BUTTON[i] Debounce Circuit //
		button_debouncer	button_debouncer_inst0(
			.clk     (CLOCK),
			.rst_n   (1'b1),
			.data_in (ORG_BUTTON[bdci]),
			.data_out(BUTTON[bdci])			
		);
	end
endgenerate

	
endmodule