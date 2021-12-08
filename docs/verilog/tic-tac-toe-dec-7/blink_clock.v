module blink_clock
#(
    parameter counter_max = 5_000_000
    )(
    input CLOCK_50MHz, 
    output reg CLOCK_5Hz);
    
    reg [31:0] counter = 0;
    initial CLOCK_5Hz = 0;
    always @(posedge CLOCK_50MHz) 
        if (counter == counter_max) begin
            counter <= 0;
            CLOCK_5Hz = ~ CLOCK_5Hz;
        end
        else
            counter <= counter + 1;
    
endmodule