module de0_debouncer_ctr
	(
		//// Source: de0_bebounce_cnt.v Downloaded from: http://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=364&PartNo=4
		////////////////////	Clock Input	 	////////////////////	 
		CLOCK_50,						//	50 MHz
		// CLOCK_50_2,						//	50 MHz
		////////////////////	Push Button		////////////////////
		ORG_BUTTON,						//	Pushbutton[2:0]
		////////////////////	7-SEG Dispaly	////////////////////
		HEX0_D,							//	Seven Segment Digit 0
		HEX1_D,							//	Seven Segment Digit 1
		HEX2_D,							//	Seven Segment Digit 2
		HEX3_D							//	Seven Segment Digit 3
	);
//// Source: de0_bebounce_cnt.v Downloaded from: http://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=364&PartNo=4
////////////////////////	Clock Input	 	////////////////////////
input			CLOCK_50;				//	50 MHz
// input			CLOCK_50_2;				//	50 MHz
////////////////////////	Push Button		////////////////////////
input	[2:0]	ORG_BUTTON;				//	Pushbutton[2:0]
////////////////////////	7-SEG Dispaly	////////////////////////
output	[6:0]	HEX0_D;					//	Seven Segment Digit 0
output	[6:0]	HEX1_D;					//	Seven Segment Digit 1
output	[6:0]	HEX2_D;					//	Seven Segment Digit 2
output	[6:0]	HEX3_D;					//	Seven Segment Digit 3

//==================================================================
//  REG/WIRE declarations
//==================================================================

wire            reset_n;        		// Reset
wire            BUTTON[0:2];		// Button after debounce

wire    			negedge_button_1;      		// Counter for Button[1]
wire    			negedge_button_2;      		// Counter for Button[2]

wire   [8*4-1:0]  	ASCII_4;					// 4 ASCII characters to display
wire   [7*4-1:0]     SEG7_4;              // 4 7-SEG to display

reg    [7:0] 	counter;        		// 8-bit counter
reg       		out_BUTTON_1;   		// Button1 Register output
reg       		out_BUTTON_2;   		// Button2 Register output
genvar debounce_idx;
genvar asc_seg_idx;
//==================================================================
//  Structural coding
//==================================================================
assign HEX3_D = SEG7_4[7*4-1 -: 7];
assign HEX2_D = SEG7_4[7*3-1 -: 7];
assign HEX1_D = SEG7_4[7*2-1 -: 7];
assign HEX0_D = SEG7_4[7*1-1 -: 7];

generate
	for (debounce_idx = 0; debounce_idx < 3; debounce_idx = debounce_idx + 1) begin: button_debouncer_gen
		// This is BUTTON[debounce_idx] Debounce Circuit //
		button_debouncer	button_debouncer_inst(
		.clk     (CLOCK_50),
		.rst_n   (1'b1),
		.data_in (ORG_BUTTON[debounce_idx]),
		.data_out(BUTTON[debounce_idx])			
		);
	end
endgenerate

generate
	for (asc_seg_idx = 0; asc_seg_idx < 4; asc_seg_idx = asc_seg_idx + 1) begin: asc_seg_gen
	// This is SEG[asc_seg_idx] Display//
	asc_to_7seg	SEG(
					 .bin   (ASCII_4[8*asc_seg_idx+7 -: 8]),
					 .seg   (SEG7_4[7*asc_seg_idx+6 -: 7])
					 );
	end
endgenerate

// Convert 8-bit binary to 2-digit hex display
assign ASCII_4 = {16'b0, 4'b0, counter[7:4], 4'b0, counter[3:0]};
assign reset_n   = BUTTON[0]; 			 		 
assign negedge_button_1 = ((BUTTON[1] == 0) && (out_BUTTON_1 == 1)) ? 1'b1: 1'b0; // negedge button 1 
assign negedge_button_2 = ((BUTTON[2] == 0) && (out_BUTTON_2 == 1)) ? 1'b1: 1'b0; // negedge button 2

//====================================================================
// After debounce output with register
//====================================================================
always @ (posedge CLOCK_50 )
	begin
		out_BUTTON_1 <= BUTTON[1];
		out_BUTTON_2 <= BUTTON[2];
	end

//====================================================================
// Display process
//====================================================================
always @ (posedge CLOCK_50 or negedge reset_n)
	begin
		if(!reset_n)
			begin
				counter <= 8'h00;
			end
		else begin
				if(negedge_button_2)
					begin
						counter <= counter +1'd1;
					end
				else if(negedge_button_1)
					 begin
						counter <= counter - 1'd1;
					 end
				else begin
					counter <= counter;
				end
		 end
	end
endmodule