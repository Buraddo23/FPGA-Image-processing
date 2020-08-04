`timescale 1ns / 1ps

module top(
    input sys_clk, 
    input rst,
    input sel1,
    input sel2,
    
    inout cam_siod_io,
    output cam_cfg_done, 
    output cam_sioc_o, 
    output cam_xclk,
    
    input cam_vsync, 
    input cam_href, 
    input cam_pclk,
    input [7:0] cam_din,  
     
    output h_sync, 
    output v_sync,
    output [3:0] red, 
    output [3:0] green, 
    output [3:0] blue
);    

    wire clk24, vga_clk;
    
    wire cam_pixel_valid, cam_frame_done;
    wire [23:0] cam_pixel_data, dout;
    wire [23:0] p1, p2, p3, p4, p5, p6, p7, p8, p9;
    wire [11:0] cam_rgb, mem_out;
    
    wire [9:0] hpos, vpos;
    wire display_area;
    
    wire [1:0] filter_sel;
    wire grayscale;
    wire [3:0] shift;
    wire signed [3:0] kc_1, kc_2, kc_3, kc_4, kc_5, kc_6, kc_7, kc_8, kc_9;    
    
    reg [18:0] cam_pixel_counter = 0, cpc = 0;
    
    assign filter_sel = {sel2, sel1};
    
    clk_wiz_0 clk_wiz_0 (
        .reset(~rst),
        .clk_in1(sys_clk),
        .clk_out1(clk24),
        .clk_out2(vga_clk)
    );
    
    oddr_0 oddr_0 (
        .clk_in(clk24),
        .clk_out(cam_xclk)
    );
    
    /*ila_0 ila (
        .clk(sys_clk),
        .probe0(cam_pixel_data),
        .probe1(cam_din),
        .probe2(p1),
        .probe3(p4),
        .probe4(p7)
    );*/

    CameraSetup CameraSetup (
        .clk_i(clk24), 
		.rst_i(rst), 
		.done(cam_cfg_done), 
		.sioc_o(cam_sioc_o), 
		.siod_io(cam_siod_io)
    );
    
    pixel_decoder pixel_decoder (
       .clock(cam_pclk),
	   .vsync(cam_vsync),
	   .href(cam_href),
	   .data(cam_din),
	   .p_valid(cam_pixel_valid),
	   .p_data(cam_pixel_data),
	   .f_done(cam_frame_done)
    );
    
    buffer sh_reg(
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
    
    filter_selector filter_selector(
        .filter_sel(filter_sel),
        .grayscale(grayscale),
        .shift(shift),
        .kc_1(kc_1),
        .kc_2(kc_2),
        .kc_3(kc_3),
        .kc_4(kc_4),
        .kc_5(kc_5),
        .kc_6(kc_6),
        .kc_7(kc_7),
        .kc_8(kc_8),
        .kc_9(kc_9)
    );
    
    convolution conv(
        .clk(sys_clk),
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
    
    yuv2rgb yuv2rgb (
        .clock(sys_clk),
        .yuv_data(dout),
        .rgb_data(cam_rgb)
    );
    
    blk_mem_gen_0 memory (
        .clka(cam_pclk),
        .ena(cam_cfg_done),
        .wea(cam_pixel_valid),
        .addra(cam_pixel_counter),
        .dina(cam_rgb),
        .clkb(vga_clk),
        .enb(display_area),
        .addrb(vpos*640+hpos),
        .doutb(mem_out)
    );
    
    vga_controller vga_control (
        .pixel_clock(vga_clk),
        .reset(rst),
        .pixel_rgb(mem_out), 
        .h_sync(h_sync), 
        .v_sync(v_sync), 
        .display(display_area),
        .hpos(hpos), 
        .vpos(vpos),
        .red(red), 
        .green(green), 
        .blue(blue)
    );
    
    always @(*)
    begin
        cpc = cam_pixel_counter;
        if (cam_pixel_valid)
            cpc = cam_pixel_counter + 1;
    end
    
    always @(posedge cam_pclk)
    begin
        if (~rst|cam_frame_done) begin
            cam_pixel_counter <= 0;
        end
        else
            cam_pixel_counter <= cpc;
    end
endmodule