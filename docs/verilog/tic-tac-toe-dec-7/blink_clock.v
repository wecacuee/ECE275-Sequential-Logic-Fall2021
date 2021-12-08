module blink_clock
#(
    parameter counter_max = 30
    )(
    input CLOCK_60Hz, 
    output reg CLOCK_2Hz);
    
    reg [31:0] counter = 0;
    initial CLOCK_2Hz = 0;
    always @(posedge CLOCK_60Hz) 
        if (counter == counter_max) begin
            counter <= 0;
            CLOCK_2Hz = ~ CLOCK_2Hz;
        end
        else
            counter <= counter + 1;
    
endmodule