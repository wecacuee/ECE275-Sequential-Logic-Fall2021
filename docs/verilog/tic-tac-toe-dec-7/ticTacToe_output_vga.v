module ticTacToe_output_vga
#(
  parameter [11:0] background_color = 12'h0_0_0,
  parameter [11:0] player_x_color = 12'hF_0_0,
  parameter [11:0] player_o_color = 12'h0_F_0,
  parameter [11:0] grid_color = 12'hF_F_F,
  parameter [10:0] box_width = 80,
  parameter [10:0] box_height = 80,
  parameter [10:0] box_margin = 10,
  parameter [10:0] grid_offset = 100
)(
  input [0:0] CLOCK,
  input [0:0] reset_n,
  input [0:0] next_valid_cell,
  input [3:0] current_cell,
  input [0:0] enter_current_cell,
  input [8:0] grid_state_marked,
  input [8:0] grid_state_x,
  input [0:0] player_x_turn,
  input [0:0] someone_won,
  input [0:0] player_x_won,
  input [0:0] errno,
  output [0:0] VGA_HS,       // VGA H_SYNC
  output [0:0] VGA_VS,       // VGA V_SYNC
  output [3:0] VGA_R,        // VGA Red[3:0]
  output [3:0] VGA_G,      	 // VGA Green[3:0]
  output [3:0] VGA_B,       	 // VGA Blue[3:0]
  output [0:0] pixel_clk
  );

wire [11:0]     pixel_color;
// Each box forms a layer. There are 10 layers, 1 per box in grid + 1 background
wire [10*12-1:0] color_per_layer; 

wire [10:0]	X_pix;
wire [10:0]	Y_pix;
wire        H_visible;
wire        V_visible;

wire CLOCK_5Hz;

localparam [9:0] box_x_offset = box_width + 2*box_margin;
localparam [9:0] box_y_offset = box_height + 2*box_margin;

assign color_per_layer[12*0+11 -: 12] = background_color;
assign pixel_color = color_per_layer[12*10-1 -: 12]; // topmost color

// Make a slower clock for blinking
blink_clock bclk(.CLOCK_50MHz(CLOCK), 
                 .CLOCK_5Hz(CLOCK_5Hz));
                 
// Convert pixel_color at X_pix, Y_pix -> VGA_*
DE0_VGA tto_vga
(
	 .clk_50(CLOCK),
     .pixel_color(pixel_color), 
     .VGA_BUS_R(VGA_R), 
     .VGA_BUS_G(VGA_G), 
     .VGA_BUS_B(VGA_B), 
     .VGA_HS(VGA_HS), 
     .VGA_VS(VGA_VS), 
     .X_pix(X_pix), 
     .Y_pix(Y_pix), 
     .H_visible(H_visible), 
     .V_visible(V_visible), 
     .pixel_clk(pixel_clk) 
);

genvar cellidx;
generate
for (cellidx = 0; cellidx < 9; cellidx = cellidx + 1) begin: drawgrid
    integer celly = cellidx / 3;
    integer cellx = cellidx % 3;
    wire [11:0] prev_layer_color = color_per_layer[12*cellidx+11 -: 12];
    wire [11:0] after_outer_box;
    make_box outer_box(
              .X_pix(X_pix),
              .Y_pix(Y_pix),
              .box_x(box_x_offset*(2-cellx) + grid_offset), 
              .box_y(box_y_offset*(2-celly) + grid_offset),
              .box_width(box_x_offset),
              .box_height(box_y_offset),
              .box_color(grid_color),
              .bg_color(prev_layer_color),
              .pixel_color(after_outer_box)
    );
    make_box cellbox(
              .X_pix(X_pix),
              .Y_pix(Y_pix),
              .box_x(box_x_offset*(2-cellx) + grid_offset + box_margin), 
              .box_y(box_y_offset*(2-celly) + grid_offset + box_margin),
              .box_width(box_width),
              .box_height(box_height),
              .box_color(
                    (grid_state_marked[cellidx]) 
                    ? ((grid_state_x[cellidx]) ? player_x_color : player_o_color)
                    : (cellidx == current_cell) 
                    ? ((CLOCK_5Hz) 
                        ? ((!player_x_turn) ? player_x_color : player_o_color)
                        : background_color)
                    : background_color),
              .bg_color(after_outer_box),
              .pixel_color(color_per_layer[12*(cellidx+1)+11 -: 12])
    );
end
endgenerate

endmodule
