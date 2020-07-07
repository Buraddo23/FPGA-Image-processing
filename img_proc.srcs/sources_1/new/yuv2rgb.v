`timescale 1ns / 1ps

module yuv2rgb(
    input clock,
    input [23:0] yuv_data,
    output [11:0] rgb_data
);
    reg [7:0] red, green, blue;
    wire [7:0] y, u, v;
    
    assign rgb_data = {red[7:4], green[7:4], blue[7:4]};
    assign y = yuv_data[23:16];
    assign u = yuv_data[15:8] - 128;
    assign v = yuv_data[7:0] - 128;
    
    always @(clock) begin
        red <= y + v + (v>>2) + (v>>3) + (v>>5);
        green <= y - ((u>>2) + (u>>4) + (u>>5)) - ((v>>1) + (v>>3) + (v>>4) + (v>>5));
        blue <= y + u + (u>>1) + (u>>2) + (u>>6);
    end
endmodule
