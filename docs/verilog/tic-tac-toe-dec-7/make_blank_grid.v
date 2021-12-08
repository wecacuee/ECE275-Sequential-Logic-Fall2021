module make_blank_grid
#(
  parameter [10:0] box_width = 80,
  parameter [10:0] box_height = 80,
  parameter [10:0] box_margin = 20,
  parameter [10:0] grid_offset = 100
)(
  
    input [10:0]       X_pix, 
    input [10:0]       Y_pix,
    input [11:0]      box_color, 
    input [11:0]      bg_color,
    output [11:0]     pixel_color
);
endmodule