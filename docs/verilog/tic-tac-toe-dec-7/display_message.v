module display_message #(
    parameter MSG_LENGTH = 6,
    parameter char_width = 32,
    parameter char_height = 32,
    parameter INIT_F = ""
)(
    input [10:0] X_pix,
    input [10:0] Y_pix,
    input [0:8*MSG_LENGTH-1] MSG,
    input [10:0] msg_x,
    input [10:0] msg_y,
    input [11:0] char_color,
    input [11:0] text_bg_color,
    input [11:0] prev_layer_color,
    output [11:0] pixel_color
);
wire [12*(MSG_LENGTH+1)-1:0] color_per_char_layer;
assign color_per_char_layer[12*1-1:0] = prev_layer_color;

genvar charidx;
generate 
for (charidx = 0; charidx < MSG_LENGTH; charidx = charidx + 1) begin: msg
    draw_ascii #(
        .INIT_F(INIT_F)
    ) cellchar (
            .X_pix(X_pix),
            .Y_pix(Y_pix),
            .char(MSG[8*charidx +: 8]),
            .char_x(msg_x + charidx * char_width), 
            .char_y(msg_y),
            .char_width(char_width),
            .char_height(char_height),
            .char_color(char_color),
            .char_bg_color(text_bg_color),
            .bg_color(color_per_char_layer[12*charidx+11 -: 12]),
            .pixel_color(color_per_char_layer[12*charidx+23 -: 12])
    );
end
endgenerate

assign pixel_color = color_per_char_layer[12*(MSG_LENGTH+1)-1 -: 12];

endmodule