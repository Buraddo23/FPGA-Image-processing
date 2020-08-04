`timescale 1ns / 1ps

module conv_tb();
    reg clock;
    reg rst;
    reg grayscale; 
    reg [3:0] shift;
    reg signed [3:0] kc_1, kc_2, kc_3, kc_4, kc_5, kc_6, kc_7, kc_8, kc_9;
    reg [23:0] p1, p2, p3, p4, p5, p6, p7, p8, p9;
    wire [23:0] dout;

    always
    begin
        clock = 1'b1;
        #3;
        clock = 1'b0;
        #3;
    end
    
    initial
    begin
        rst = 0;
        #10;
        rst = 1;
        shift = 0;
        grayscale = 1;
        kc_1 = 0;
        kc_2 = -4'b1;
        kc_3 = 0;
        kc_4 = -4'b1;
        kc_5 = 4'd4;
        kc_6 = -4'b1;
        kc_7 = 0;
        kc_8 = -4'b1;
        kc_9 = 0;

        p1 = 24'hAAAAAA;
        p2 = 24'h80ABAB;
        p3 = 24'hACACAC;
        p4 = 24'hADADAD;
        p5 = 24'h555555;
        p6 = 24'h565656;
        p7 = 24'h545454;
        p8 = 24'h555555;
        p9 = 24'h666666;
    end
        
    convolution UUT(
        .clk(clock),
        .reset(rst),
        .shift(shift),
        .grayscale(grayscale),
        .kc_1(kc_1),
        .kc_2(kc_2),
        .kc_3(kc_3),
        .kc_4(kc_4),
        .kc_5(kc_5),
        .kc_6(kc_6),
        .kc_7(kc_7),
        .kc_8(kc_8),
        .kc_9(kc_9),
        .pixel_1(p1),
        .pixel_2(p2),
        .pixel_3(p3),
        .pixel_4(p4),
        .pixel_5(p5),
        .pixel_6(p6),
        .pixel_7(p7),
        .pixel_8(p8),
        .pixel_9(p9),
        .data_out(dout)
    );
endmodule
