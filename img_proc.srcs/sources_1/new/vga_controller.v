`timescale 1ns/1ns

module vga_controller(pixel_clock, reset, pixel_rgb, h_sync, v_sync, display, hpos, vpos, red, green, blue);
    parameter THADDR = 640, //H addresable video length
              THFP   =  16, //H front porch
              THS    =  96, //H sync time 
              THBP   =  48, //H back porch
              THBD   =   0, //H left/right border
              TVADDR = 480, //V addresable bideo length
              TVFP   =  10, //V front porch
              TVS    =   2, //V sync time
              TVBP   =  33, //V back porch
              TVBD   =   0, //V top/bottom border
              H_POL  =   0, //0 - negative polarity (sync on 0), 1 - positive polarity (sync on 1)
              V_POL  =   0, //0 - neg, 1 - pos
              C_SIZE =   9; //Counter no of bits
            
    input pixel_clock, reset;
    input [11:0] pixel_rgb;
    output h_sync, v_sync, display;
    output reg [C_SIZE:0] hpos, vpos;
    output [3:0] red, green, blue;   
    
    reg h_sync_ff, h_sync_nxt, v_sync_ff, v_sync_nxt, display_ff, display_nxt;
    reg [3:0] red_ff, red_nxt, green_ff, green_nxt, blue_ff, blue_nxt;
    reg [C_SIZE:0] h_counter_ff, h_counter_nxt, v_counter_ff, v_counter_nxt, hpos_nxt, vpos_nxt;

    assign h_sync = h_sync_ff;
    assign v_sync = v_sync_ff;
    assign display = display_ff;
    assign red    = red_ff;
    assign green  = green_ff;
    assign blue   = blue_ff;

    always @ (*) begin
        h_sync_nxt    = h_sync_ff;
        v_sync_nxt    = v_sync_ff;
        display_nxt   = display_ff;
        red_nxt       = red_ff;
        green_nxt     = green_ff;
        blue_nxt      = blue_ff;
        h_counter_nxt = h_counter_ff;
        v_counter_nxt = v_counter_ff;
        
        //Horizontal sync
        if ((h_counter_ff >= THBD + THADDR + THBD + THFP) && (h_counter_ff < THBD + THADDR + THBD + THFP + THS)) begin
            h_sync_nxt = H_POL;
        end
        else begin
            h_sync_nxt = !H_POL;
        end
        
        //Vertical sync
        if ((v_counter_ff >= TVBD + TVADDR + TVBD + TVFP) && (v_counter_ff < TVBD + TVADDR + TVBD + TVFP + TVS)) begin
            v_sync_nxt = V_POL;
        end
        else begin
            v_sync_nxt = !V_POL;
        end

        //Counters update
        if (h_counter_ff == THBD + THADDR + THBD + THFP + THS + THBP - 1) begin
            h_counter_nxt = 'b0;
            v_counter_nxt = v_counter_ff + 1'b1;
        end
        else begin
            h_counter_nxt = h_counter_ff + 1'b1;
        end
        
        if (v_counter_ff == TVBD + TVADDR + TVBD + TVFP + TVS + TVBP) begin
            v_counter_nxt = 'b0;
        end
        
        if ((h_counter_ff >= THBD) && (h_counter_ff < THBD + THADDR) && (v_counter_ff >= TVBD) && (v_counter_ff < TVBD + TVADDR)) begin
            //At display area
            display_nxt = 1;
            hpos_nxt  = h_counter_ff - THBD;
            vpos_nxt  = v_counter_ff - TVBD;
            red_nxt   = pixel_rgb[11:8];
            green_nxt = pixel_rgb[7:4];
            blue_nxt  = pixel_rgb[3:0];
        end
        else begin
            //Outside display area (sync period)
            display_nxt = 0;
            hpos_nxt = 0;
            vpos_nxt = 0;
            red_nxt   = 4'b0;
            green_nxt = 4'b0;
            blue_nxt  = 4'b0;
        end
    end

    always @ (posedge pixel_clock or posedge reset) begin
        if (!reset) begin
            h_sync_ff    <= 1'b0;
            v_sync_ff    <= 1'b0;
            display_ff   <= 0;
            hpos         <= 0;
            vpos         <= 0;
            red_ff       <= 4'b0;
            green_ff     <= 4'b0;
            blue_ff      <= 4'b0;
            h_counter_ff <=  'b0;
            v_counter_ff <=  'b0;
        end
        else begin
            h_sync_ff    <= h_sync_nxt;
            v_sync_ff    <= v_sync_nxt;
            display_ff   <= display_nxt;
            hpos         <= hpos_nxt;
            vpos         <= vpos_nxt;
            red_ff       <= red_nxt;
            green_ff     <= green_nxt;
            blue_ff      <= blue_nxt;
            h_counter_ff <= h_counter_nxt;
            v_counter_ff <= v_counter_nxt;
        end
    end
endmodule