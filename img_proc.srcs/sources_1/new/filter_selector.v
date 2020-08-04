`timescale 1ns / 1ps

module filter_selector(
    input [1:0] filter_sel,
    output grayscale,
    output [3:0] shift,
    output signed [3:0] kc_1,
    output signed [3:0] kc_2,
    output signed [3:0] kc_3,
    output signed [3:0] kc_4,
    output signed [3:0] kc_5,
    output signed [3:0] kc_6,
    output signed [3:0] kc_7,
    output signed [3:0] kc_8,
    output signed [3:0] kc_9
);
    assign {kc_1, kc_2, kc_3, kc_4, kc_5, kc_6, kc_7, kc_8, kc_9} = filter_sel==0 ? {4'b0, 4'b0, 4'b0, 4'b0, 4'b1, 4'b0, 4'b0, 4'b0, 4'b0} : 
                                                                    filter_sel==1 ? {4'b0, -4'b1, 4'b0, -4'b1, 4'd4, -4'b1, 4'b0, -4'b1, 4'b0} : 
                                                                    filter_sel==2 ? {4'b0, -4'b1, 4'b0, -4'b1, 4'd5, -4'b1, 4'b0, -4'b1, 4'b0} : 
                                                                                    {4'b1, 4'd2, 4'b1, 4'd2, 4'd4, 4'd2, 4'b1, 4'd2, 4'b1};
                                                                                    
    assign grayscale = filter_sel==1 ? 1'b1 : 1'b0;
                                                                                    
    assign shift = filter_sel==0 ? 4'b0 : 
                   filter_sel==1 ? 4'b0 : 
                   filter_sel==2 ? 4'b0 : 
                                   4'd4;
endmodule
