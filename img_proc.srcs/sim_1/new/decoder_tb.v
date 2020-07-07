`timescale 1ns / 1ps

module decoder_tb();
    reg clock;
    reg vsync;
    reg href;
    reg [7:0] data;
    wire p_valid;
    wire [11:0] p_data;
    wire f_done;
    
    integer i;

    always
    begin
        clock = 1'b1;
        #3;
        clock = 1'b0;
        #3;
    end
    
    always
    begin
        href = 0;
        #100;
        href = 1;
        for (i = 16; i < 100; i=i+1)
        begin
            data = i;
            #6;
        end
        href = 0;
        #100;
        vsync = 1;
        #6;
        vsync = 0;
    end
        
    pixel_decoder UUT (
        .clock(clock),
        .vsync(vsync),
        .href(href),
        .data_wires(data),
        .p_valid(p_valid),
        .p_data(p_data),
        .f_done(f_done)
    );
endmodule
