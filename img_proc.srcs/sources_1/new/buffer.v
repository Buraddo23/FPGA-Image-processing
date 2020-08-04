`timescale 1ns / 1ps

module buffer(
    input clk,
    input reset,
    input [23:0] din,
    output [23:0] pixel_1,
    output [23:0] pixel_2,
    output [23:0] pixel_3,
    output [23:0] pixel_4,
    output [23:0] pixel_5,
    output [23:0] pixel_6,
    output [23:0] pixel_7,
    output [23:0] pixel_8,
    output [23:0] pixel_9
);
    reg [23:0] shift_reg[0:1282];
    integer i;
    
    assign pixel_1 = shift_reg[1282];
    assign pixel_2 = shift_reg[1281];
    assign pixel_3 = shift_reg[1280];
    assign pixel_4 = shift_reg[642];
    assign pixel_5 = shift_reg[641];
    assign pixel_6 = shift_reg[640];
    assign pixel_7 = shift_reg[2];
    assign pixel_8 = shift_reg[1];
    assign pixel_9 = shift_reg[0];
    
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            for (i = 0; i < 1283; i = i+1)
                shift_reg[i] <= 0;
        end else begin
            for (i = 1; i < 1283; i=i+1)
                shift_reg[i] <= shift_reg[i-1];
            shift_reg[0] <= din;
        end
    end
endmodule
