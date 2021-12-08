// draw ascii character
module draw_ascii
#(
    parameter WIDTH = 8,
    parameter INIT_F=""
)(
    input [10:0]       X_pix, 
    input [10:0]       Y_pix,
    input [7:0]        char,
    input [10:0]       char_x, // [x, y, width, height]
    input [10:0]       char_y, 
    input [10:0]       char_width,
    input [10:0]       char_height,
    input [11:0]       char_color, 
    input [11:0]       char_bg_color,
    input [11:0]       bg_color,
    output [11:0]      pixel_color
);
    wire [10:0] x_offset_pix = (X_pix - char_x);
    wire [2:0] x_offset = x_offset_pix / (char_width / WIDTH);

    wire [10:0] y_offset_pix = (Y_pix - char_y);
    wire [2:0] y_offset = y_offset_pix / (char_height / WIDTH);
    
    // Character table starts at Space " " or 8'h20;
    wire [7:0] char_offset = char - " ";
    wire [8:0] addr = {char_offset[5:0], y_offset[2:0]};

    wire [7:0] rowdata;
    rom_async  #(
        .WIDTH(WIDTH),
        .INIT_F(INIT_F)
    ) read_fonts (
        addr,
        rowdata
    );
    assign pixel_color = (char_x <=  X_pix && X_pix < (char_x + char_width)
                          && char_y <= Y_pix && Y_pix < (char_y + char_height))
                          ?  ((rowdata[3'b111-x_offset]) ? char_color : char_bg_color)
                          : bg_color;
endmodule