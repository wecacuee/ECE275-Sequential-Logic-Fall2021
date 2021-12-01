// Modified from 
// de0_debouncing_ctr.v: http://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=364&PartNo=4
module DE0_TOP
	(
		//// Source: de0_bebounce_cnt.v Downloaded from: http://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=364&PartNo=4
		////////////////////	Clock Input	 	////////////////////	 
		CLOCK_50,						//	50 MHz
		// CLOCK_50_2,						//	50 MHz
		////////////////////	Push Button		////////////////////
		ORG_BUTTON,						//	Pushbutton[2:0]
		////////////////////	7-SEG Dispaly	////////////////////
		HEX0_D,							//	Seven Segment Digit 0
		// HEX0_DP,							//	Seven Segment Digit DP 0
		HEX1_D,							//	Seven Segment Digit 1
		// HEX1_DP,							//	Seven Segment Digit DP 1
		HEX2_D,							//	Seven Segment Digit 2
		// HEX2_DP,							//	Seven Segment Digit DP 2
		HEX3_D							//	Seven Segment Digit 3
		// HEX3_DP,							//	Seven Segment Digit DP 3
		////////////////////	VGA		////////////////////////////
		// VGA_HS,							//	VGA H_SYNC
		// VGA_VS,							//	VGA V_SYNC
		// VGA_R,   						//	VGA Red[3:0]
		// VGA_G,	 						//	VGA Green[3:0]
		// VGA_B  						//	VGA Blue[3:0]
	);
//// Source: de0_bebounce_cnt.v Downloaded from: http://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=364&PartNo=4
////////////////////////	Clock Input	 	////////////////////////
input			CLOCK_50;				//	50 MHz
// input			CLOCK_50_2;				//	50 MHz
////////////////////////	Push Button		////////////////////////
input	[2:0]	ORG_BUTTON;				//	Pushbutton[2:0]
////////////////////////	7-SEG Dispaly	////////////////////////
output	[6:0]	HEX0_D;					//	Seven Segment Digit 0
// output			HEX0_DP;					//	Seven Segment Digit DP 0
output	[6:0]	HEX1_D;					//	Seven Segment Digit 1
// output			HEX1_DP;					//	Seven Segment Digit DP 1
output	[6:0]	HEX2_D;					//	Seven Segment Digit 2
// output			HEX2_DP;					//	Seven Segment Digit DP 2
output	[6:0]	HEX3_D;					//	Seven Segment Digit 3
// output			HEX3_DP;					//	Seven Segment Digit DP 3
////////////////////////	VGA			////////////////////////////
// output			VGA_HS;					//	VGA H_SYNC
// output			VGA_VS;					//	VGA V_SYNC
// output	[3:0]	VGA_R;   				//	VGA Red[3:0]
// output	[3:0]	VGA_G;	 				//	VGA Green[3:0]
// output	[3:0]	VGA_B;   				//	VGA Blue[3:0]

//==================================================================
//  REG/WIRE declarations
//==================================================================

wire            reset_n;        		// Reset
wire            BUTTON[0:2];			// Button after debounce

wire    			negedge_button_1;    // Counter for Button[1]
wire    			negedge_button_2;    // Counter for Button[2]

wire    [3:0] 	next_valid_cell;   // 4-bit counter
wire 			   enter_current_cell;  // press enter

reg       		out_BUTTON_1;   		// Button1 Register output
reg       		out_BUTTON_2;   		// Button2 Register output

wire    [3:0] input_cell_cursor;
wire 	  [8:0] grid_state_marked;
wire 	  [8:0] grid_state_x;
wire 			  player_x_turn; 
wire 			  someone_won; 
wire 			  player_x_won;
wire 		     errno;

genvar bdci;
//==================================================================
//  Structural coding
//==================================================================

generate
	for (bdci = 0; bdci < 3; bdci = bdci + 1) begin : button_debouncer_gen
		// This is BUTTON[i] Debounce Circuit //
		button_debouncer	button_debouncer_inst0(
			.clk     (CLOCK_50),
			.rst_n   (1'b1),
			.data_in (ORG_BUTTON[bdci]),
			.data_out(BUTTON[bdci])			
		);
	end
endgenerate

ticTacToeCore ttt(
	.clk(enter_current_cell),
	.resetn(reset_n),
	.next_player_input_cell(input_cell_cursor),
	.grid_state_marked(grid_state_marked),
	.grid_state_x(grid_state_x), 
	.player_x_turn(player_x_turn), 
	.someone_won(someone_won),
	.player_x_won(player_x_won),
	.errno(errno));
	
ticTacToe_input tti(
	.CLOCK_50(CLOCK_50),
	.reset_n(reset_n),
	.next_valid_cell(next_valid_cell),
	.grid_state_marked(grid_state_marked),
	.cell_cursor(input_cell_cursor)
);

ticTacToe_7seg_output tto_7seg(
	.current_cell(input_cell_cursor),
	.player_x_turn(player_x_turn),
	.someone_won(someone_won),
	.player_x_won(player_x_won),
	.errno(errno),
	.SEG7_4({HEX3_D, HEX2_D, HEX1_D, HEX0_D})
);

assign reset_n   = BUTTON[0]; 			 		 
assign negedge_button_1 = ((BUTTON[1] == 0) && (out_BUTTON_1 == 1)) ? 1'b1: 1'b0; // negedge button 1 
assign negedge_button_2 = ((BUTTON[2] == 0) && (out_BUTTON_2 == 1)) ? 1'b1: 1'b0; // negedge button 2
assign next_valid_cell = negedge_button_1;
assign enter_current_cell = negedge_button_2;

//====================================================================
// After debounce output with register
//====================================================================
always @ (posedge CLOCK_50 )
	begin
		out_BUTTON_1 <= BUTTON[1];
		out_BUTTON_2 <= BUTTON[2];
	end

endmodule