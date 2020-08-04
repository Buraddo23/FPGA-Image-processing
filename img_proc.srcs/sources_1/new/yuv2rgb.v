`timescale 1ns / 1ps

module yuv2rgb(
    input clock,
    input [23:0] yuv_data,
    output [11:0] rgb_data
);
    reg signed [9:0] red, green, blue;
    wire signed [8:0] y, u, v;
    
    assign rgb_data = {red[7:4], green[7:4], blue[7:4]};
    assign y = yuv_data[23:16];
    assign u = yuv_data[15:8] - 128;
    assign v = yuv_data[7:0] - 128;
    
    always @(posedge clock) begin
        red = y + v + (v>>>2) + (v>>>3);
        green = y - (u>>>2) - ((v>>>1) + (v>>>3));
        blue = y + u + (u>>>1) + (u>>>2);
        
        if (red <= 0)
            red = 0;
        else if (red >= 255)
            red = 255;
            
        if (green <= 0)
            green = 0;
        else if (green >= 255)
            green = 255;
            
        if (blue <= 0)
            blue = 0;
        else if (blue >= 255)
            blue = 255;
    end
endmodule
