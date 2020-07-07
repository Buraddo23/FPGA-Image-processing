`timescale 1ns / 1ps

module fifo_tb();
    reg rst;
    reg cam_pclk;
    reg vga_clk;
    reg [3:0] cam_pixel_data;
    reg cam_pixel_valid;
    reg display_area;
    wire [3:0] pixel;

    always
    begin
        cam_pclk = 1'b1;
        #3;
        cam_pclk = 1'b0;
        #3;
    end
    
    always
    begin
        vga_clk = 1'b1;
        #4;
        vga_clk = 1'b0;
        #4;
    end
    
    initial
    begin
        rst = 1;
        #100;
        rst = 0;
    end

    fifo_generator_0 UUT (
        .rst(rst),
        .wr_clk(cam_pclk),
        .rd_clk(vga_clk),
        .din(cam_pixel_data),
        .wr_en(cam_pixel_valid),
        .rd_en(display_area),
        .dout(pixel)
    );
endmodule
