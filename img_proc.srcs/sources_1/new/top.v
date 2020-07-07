`timescale 1ns / 1ps

module top(
    input sys_clk, 
    input rst,
    
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
    wire [23:0] cam_pixel_data;
    wire [11:0] cam_rgb;
    wire [11:0] mem_out;
    
    wire [9:0] hpos, vpos;
    wire display_area;
    
    reg [18:0] cam_pixel_counter = 0, cpc = 0;
    
    clk_wiz_0 clk_wiz_0 (
        .reset(~rst),
        .clk_in1(sys_clk),
        .clk_out1(clk24),
        .clk_out2(vga_clk)
    );
      
    /*ila_0 ila (
        .clk(sys_clk),
        .probe0(vga_clk),
        .probe1(pixel),
        .probe2(cam_pclk),
        .probe3(cam_pixel_valid),
        .probe4(cam_pixel_data),
        .probe5(cam_din)
    );*/

    CameraSetup CameraSetup (
        .clk_i(clk24), 
		.rst_i(rst), 
		.done(cam_cfg_done), 
		.sioc_o(cam_sioc_o), 
		.siod_io(cam_siod_io)
    );
 
    oddr_0 oddr_0 (
        .clk_in(clk24),
        .clk_out(cam_xclk)
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
    
    yuv2rgb yuv2rgb (
        .clock(sys_clk),
        .yuv_data(cam_pixel_data),
        .rgb_data(cam_rgb)
    );
    
    /*fifo_generator_0 fifo (
        .rst(rst^cam_cfg_done),
        .wr_clk(cam_pclk),
        .rd_clk(vga_clk),
        .din(cam_pixel_data),
        .wr_en(cam_cfg_done & cam_pixel_valid),
        .rd_en(display_area),
        .dout(pixel)
    );*/
    
    blk_mem_gen_0 memory (
        .clka(cam_pclk),
        .ena(cam_cfg_done),
        .wea(cam_cfg_done & cam_pixel_valid),
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