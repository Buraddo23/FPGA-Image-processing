`timescale 1ns / 1ps

module buffer_tb();
    reg cam_pixel_valid;
    reg rst;
    reg [11:0] cam_pixel_data;
    wire [11:0] p1, p2, p3, p4, p5, p6, p7, p8, p9;

    buffer UUT(
        .clk(cam_pixel_valid),
        .reset(rst),
        .din(cam_pixel_data),
        .pixel_1(p1),
        .pixel_2(p2),
        .pixel_3(p3),
        .pixel_4(p4),
        .pixel_5(p5),
        .pixel_6(p6),
        .pixel_7(p7),
        .pixel_8(p8),
        .pixel_9(p9)
    );
endmodule
