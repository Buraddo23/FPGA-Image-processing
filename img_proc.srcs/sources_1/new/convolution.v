`timescale 1ns / 1ps

module convolution(
    input clk,
    input reset,
    input grayscale,
    input [3:0] shift,
    input signed [3:0] kc_1,
    input signed [3:0] kc_2,
    input signed [3:0] kc_3,
    input signed [3:0] kc_4,
    input signed [3:0] kc_5,
    input signed [3:0] kc_6,
    input signed [3:0] kc_7,
    input signed [3:0] kc_8,
    input signed [3:0] kc_9,
    input [23:0] pixel_1,
    input [23:0] pixel_2,
    input [23:0] pixel_3,
    input [23:0] pixel_4,
    input [23:0] pixel_5,
    input [23:0] pixel_6,
    input [23:0] pixel_7,
    input [23:0] pixel_8,
    input [23:0] pixel_9,
    output [23:0] data_out
);  
    wire signed [12:0] py1,py2,py3,py4,py5,py6,py7,py8,py9;
    wire signed [12:0] pu1,pu2,pu3,pu4,pu5,pu6,pu7,pu8,pu9;
    wire signed [12:0] pv1,pv2,pv3,pv4,pv5,pv6,pv7,pv8,pv9;
    reg signed [14:0] new_y, new_u, new_v;
    
    assign py1 = pixel_1[23:16];
    assign py2 = pixel_2[23:16];
    assign py3 = pixel_3[23:16];
    assign py4 = pixel_4[23:16];
    assign py5 = pixel_5[23:16];
    assign py6 = pixel_6[23:16];
    assign py7 = pixel_7[23:16];
    assign py8 = pixel_8[23:16];
    assign py9 = pixel_9[23:16];
    
    assign pu1 = pixel_1[15:8];
    assign pu2 = pixel_2[15:8];
    assign pu3 = pixel_3[15:8];
    assign pu4 = pixel_4[15:8];
    assign pu5 = pixel_5[15:8];
    assign pu6 = pixel_6[15:8];
    assign pu7 = pixel_7[15:8];
    assign pu8 = pixel_8[15:8];
    assign pu9 = pixel_9[15:8];
    
    assign pv1 = pixel_1[7:0];
    assign pv2 = pixel_2[7:0];
    assign pv3 = pixel_3[7:0];
    assign pv4 = pixel_4[7:0];
    assign pv5 = pixel_5[7:0];
    assign pv6 = pixel_6[7:0];
    assign pv7 = pixel_7[7:0];
    assign pv8 = pixel_8[7:0];
    assign pv9 = pixel_9[7:0];
    
    assign data_out = {new_y[7:0], new_u[7:0], new_v[7:0]};
    
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            new_y = 0;
            new_u = 128;
            new_v = 128;
        end else begin
            new_y = (kc_1 * py1 +
                    kc_2 * py2 +
                    kc_3 * py3 +
                    kc_4 * py4 +
                    kc_5 * py5 +
                    kc_6 * py6 +
                    kc_7 * py7 +
                    kc_8 * py8 +
                    kc_9 * py9) >>> shift;
            
            if (new_y <= 0)
                new_y = 0;
            else if (new_y >= 255)
                new_y = 255;
            
            if (~grayscale) begin
                new_u = (kc_1 * pu1 +
                        kc_2 * pu2 +
                        kc_3 * pu3 +
                        kc_4 * pu4 +
                        kc_5 * pu5 +
                        kc_6 * pu6 +
                        kc_7 * pu7 +
                        kc_8 * pu8 +
                        kc_9 * pu9) >>> shift;
                    
                new_v = (kc_1 * pv1 +
                        kc_2 * pv2 +
                        kc_3 * pv3 +
                        kc_4 * pv4 +
                        kc_5 * pv5 +
                        kc_6 * pv6 +
                        kc_7 * pv7 +
                        kc_8 * pv8 +
                        kc_9 * pv9) >>> shift;
                
                if (new_u <= 0)
                    new_u = 0;
                else if (new_u >= 255)
                    new_u = 255;
                
                if (new_v <= 0)
                    new_v = 0;
                else if (new_v >= 255)
                    new_v = 255;
            end else begin
                new_u = 128;
                new_v = 128;
            end
        end
    end
endmodule
