
module make_box(
    input [10:0]       X_pix, 
    input [10:0]       Y_pix,
    input [10:0]       box_x, // [x, y, width, height]
    input [10:0]       box_y, 
    input [10:0]       box_width,
    input [10:0]       box_height,
    input [11:0]      box_color, 
    input [11:0]      bg_color,
    output [11:0]     pixel_color
    );

    assign pixel_color = (box_x <= X_pix && (X_pix < (box_x + box_width))
                          && box_y <= Y_pix && (Y_pix < (box_y + box_height)))
                         ? box_color
                         : bg_color;

endmodule
