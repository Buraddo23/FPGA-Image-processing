`timescale 1ns / 1ps

module yuv2rgb(
    input enable,
    input clock,
    input [11:0] yuv_data,
    output [11:0] rgb_data
);
    reg signed [5:0] red, green, blue;
    wire signed [4:0] y, u, v;
    
    assign rgb_data = enable ? {red[3:0], green[3:0], blue[3:0]} : yuv_data;
    assign y = yuv_data[11:8];
    assign u = yuv_data[7:4] - 8;
    assign v = yuv_data[3:0] - 8;
    
    always @(posedge clock or posedge enable) begin
        if (enable) begin
            red = y + v + (v>>>2) + (v>>>3);
            green = y - (u>>>2) - ((v>>>1) + (v>>>3));
            blue = y + u + (u>>>1) + (u>>>2);
            
            if (red <= 0)
                red = 0;
            else if (red >= 15)
                red = 15;
                
            if (green <= 0)
                green = 0;
            else if (green >= 15)
                green = 15;
                
            if (blue <= 0)
                blue = 0;
            else if (blue >= 15)
                blue = 15;
        end
    end
endmodule
