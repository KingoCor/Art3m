module seven_segment_controller (
	input               clk,
	input               rst,

	input        [31:0] in,

	output logic [ 7:0] seg_en,
	output logic [ 6:0] seg
);
	logic [3:0] n;

	always_comb begin
		case(seg_en)
			8'b1111_1110: n = in[ 3: 0];
			8'b1111_1101: n = in[ 7: 4];
			8'b1111_1011: n = in[11: 8];
			8'b1111_0111: n = in[15:12];
			8'b1110_1111: n = in[19:16];
			8'b1101_1111: n = in[23:20];
			8'b1011_1111: n = in[27:24];
			8'b0111_1111: n = in[31:28];
			default:      n = '0;
		endcase

		case(n)
			4'h0: seg = 7'b0_00_0_00_1;
			4'h1: seg = 7'b1_00_1_11_1;
			4'h2: seg = 7'b0_01_0_01_0;
			4'h3: seg = 7'b0_00_0_11_0;
			4'h4: seg = 7'b1_00_1_10_0;
			4'h5: seg = 7'b0_10_0_10_0;
			4'h6: seg = 7'b0_10_0_00_0;
			4'h7: seg = 7'b0_00_1_11_1;
			4'h8: seg = 7'b0_00_0_00_0;
			4'h9: seg = 7'b0_00_0_10_0;
			4'ha: seg = 7'b0_00_1_00_0;
			4'hb: seg = 7'b1_10_0_00_0;
			4'hc: seg = 7'b0_11_0_00_1;
			4'hd: seg = 7'b1_00_0_01_0;
			4'he: seg = 7'b0_11_0_00_0;
			4'hf: seg = 7'b0_11_1_00_0;
		endcase
	end
	
	always_ff @(posedge clk) begin
		if (rst) seg_en <= 8'b1111_1110;
		else     seg_en <= {seg_en[6:0],seg_en[7]};
	end

endmodule
