module pixel_decoder(
	input clock,
	input vsync,
	input href,
	input [7:0] data,
	output reg p_valid = 0,
	output [11:0] p_data,
	output reg f_done = 0
);

    reg state = 0;
    reg [1:0] axis = 0;
    reg [3:0] y, u, v;

    assign p_data = { y, u, v };
	
	always @(posedge clock)
	begin
        if (state) begin
            state <= !vsync;
		    f_done <= vsync;
			p_valid <= href & (axis%2);
			if (href) begin
                axis <= axis + 1;
				case (axis)
				    0: 
				        u = data[7:4];
					1:
					    y = data[7:4];
					2:
					    v = data[7:4];
					3:
					    y = data[7:4];
			    endcase
			end
		end
        else begin
			state <= !vsync;
			f_done <= 0;
			p_valid <= 0;
			axis <= 0;				
		end
	end
endmodule