module led_controller # (
	parameter width = 4
) (
	input         clk,
	input         rst,

	input  [15:0] in,
	output [15:0] led
);
	logic [width-1:0] counter;

	always_ff @(posedge clk) begin
		if (rst) counter <= '0;
		else counter <= counter+1;
	end

	assign led[15:12] = in[15:12];
	assign led[11: 0] = counter==0 ? in[11:0] : '0;
endmodule
