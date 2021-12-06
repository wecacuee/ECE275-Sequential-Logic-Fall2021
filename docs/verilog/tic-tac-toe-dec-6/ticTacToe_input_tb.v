// Test ticTacToe_Core along with debouncing
`timescale 1ns/1ns
module ticTacToe_input_tb();
    reg CLOCK_50;

    ////////////////////////    Push Button     ////////////////////////
    reg   [2:0]   ORG_BUTTON;             //  Pushbutton[2:0]
    wire   [2:0]   NEXT_ORG_BUTTON;

    //==================================================================
    //  REG/WIRE declarations
    //==================================================================

    reg           reset_n;                // Reset
    wire          BUTTON[0:2];            // Button after debounce

    wire          negedge_button_1;       // Counter for Button[1]
    wire          negedge_button_2;       // Counter for Button[2]

    wire          next_valid_cell;        // move to next valid cell signal
    wire          enter_current_cell;     // press enter

    reg           out_BUTTON_1;           // Button1 Register output
    reg           out_BUTTON_2;           // Button2 Register output

    wire    [3:0] input_cell_cursor;
    wire    [8:0] grid_state_marked;
    wire    [8:0] grid_state_x;
    wire          player_x_turn; 
    wire          someone_won; 
    wire          player_x_won;
    wire          errno;

    // 8 7 6
    // 5 4 3
    // 2 1 0
    // 1000 111 110
    // 101  100 011
    // 010  001 000
    reg [4*7-1:0] input_seq;
    reg unsigned [4:0] input_seq_cursor;
    wire unsigned [4:0] next_input_seq_cursor;
    reg [3:0] next_player_input_cell;
    reg initial_reset;

    parameter button_press_cycles = 21'd100100;
    reg [20:0] counter;
    
    wire [9*8:1] ttt_grid;

    genvar bdci;
    //==================================================================
    //  Structural coding
    //==================================================================

    generate
        for (bdci = 0; bdci < 3; bdci = bdci + 1) begin : button_debouncer_gen
            // This is BUTTON[i] Debounce Circuit //
            button_debouncer    button_debouncer_inst0(
                .clk     (CLOCK_50),
                .rst_n   (reset_n),
                .data_in (ORG_BUTTON[bdci]),
                .data_out(BUTTON[bdci])         
            );
        end
    endgenerate

    ticTacToeCore ttt(
        .clk(enter_current_cell),
        .resetn(BUTTON[0]),
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

    ticTacToe_output_str tto_7seg(
        .current_cell(input_cell_cursor),
        .player_x_turn(player_x_turn),
        .someone_won(someone_won),
        .player_x_won(player_x_won),
        .errno(errno),
        .SEG7_4()
    );
    

    ticTacToeToStr tostr(
        .grid_state_marked(grid_state_marked),
        .grid_state_x(grid_state_x),
        .ttt_grid(ttt_grid));

    // assign reset_n   = BUTTON[0];
    assign negedge_button_1 = ((BUTTON[1] == 0) && (out_BUTTON_1 == 1)) ? 1'b1: 1'b0; // negedge button 1 
    assign negedge_button_2 = ((BUTTON[2] == 0) && (out_BUTTON_2 == 1)) ? 1'b1: 1'b0; // negedge button 2
    assign next_valid_cell = negedge_button_1;
    assign enter_current_cell = negedge_button_2;

    //====================================================================
    // After debounce output with register
    //====================================================================
    always #10 CLOCK_50 = ~CLOCK_50; // 20ns period = 1e9/20 Hz = 50e6 Hz = 50Mz

    always @(posedge CLOCK_50 ) begin
            out_BUTTON_1 <= BUTTON[1];
            out_BUTTON_2 <= BUTTON[2];
    end

    //====================================================================
    // Initial block
    //====================================================================
    // Simulator inputs
    initial begin
        CLOCK_50 = 0;
        reset_n = 0;
        #40 reset_n = 1;
        // Sequence of moves
        input_seq = 28'h8402637;
        input_seq_cursor = 27;
        $monitor("time:%3d\n move:%04b\n%s\n%s\n%s\n sw: %b, xw: %b", 
                $time,
                input_cell_cursor,
                ttt_grid[9*8 -: 3*8],
                ttt_grid[6*8 -: 3*8],
                ttt_grid[3*8 -: 3*8],
                someone_won, player_x_won);
    end

    always @(negedge reset_n) begin
        if (!reset_n) begin
            // Sequence of moves
            input_seq = 28'h8402637;
            input_seq_cursor = 5'b11011;
        end
    end

    
    wire [3:0] desired_cursor_pos = input_seq[input_seq_cursor -: 4];
    wire is_correct_cursor_pos = (input_cell_cursor == desired_cursor_pos);
    assign next_input_seq_cursor = (is_correct_cursor_pos) ? input_seq_cursor - 4: input_seq_cursor;
    // press enter if the cell_cursor is at the desired input_seq
    press_button_for_n_cycles button2(CLOCK_50, button_press_cycles, is_correct_cursor_pos, NEXT_ORG_BUTTON[2]);
    // press next if the cell_cursor is not at the desired input_seq
    press_button_for_n_cycles button1(CLOCK_50, button_press_cycles, ~is_correct_cursor_pos, NEXT_ORG_BUTTON[1]);
    press_button_for_n_cycles button0(CLOCK_50, button_press_cycles, reset_n, NEXT_ORG_BUTTON[0]);


    always @(posedge CLOCK_50) begin
        ORG_BUTTON <= NEXT_ORG_BUTTON;
        input_seq_cursor <= next_input_seq_cursor;
        
        if (errno) begin
            $display("error");
        end

        if (someone_won) begin
            $display("player %s won", player_x_won ? "x" : "o");
        end
    end


endmodule


// 
module press_button_for_n_cycles(CLOCK_50, N, button_press, button);
    input wire CLOCK_50;
    input wire [20:0] N;
    input wire button_press;
    reg prev_button_press;
    reg [20:0] counter = 21'd0;
    output wire button;
    wire [20:0] full_cycles;
    assign full_cycles = N + N;
    
    // Structural design
    assign button = (counter < N) ? 1'b1 : 1'b0;

    // Procedural design
    always @(posedge CLOCK_50) begin
        prev_button_press <= button_press;
        counter = counter + 1'b1;
        if ((counter >= full_cycles) & button_press | (~prev_button_press & button_press)) begin
            counter = 21'd0;
        end
    end

endmodule