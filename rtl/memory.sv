`include "params.svh"

module memory(
	input                          clk,
	input                          en,

	input        [`ADDR_WIDTH-1:0] addr1,
	input        [`ADDR_WIDTH-1:0] addr2,
	input        [`ADDR_WIDTH-1:0] addr3,

	input        [            3:0] we,
	input        [           31:0] din1,

	output logic [           31:0] dout1,
	output logic [           31:0] dout2,
	output logic [           31:0] dout3
);
	(* ram_style = "block" *) logic [31:0] mem [0:(1<<(`ADDR_WIDTH-2))-1];
	initial $readmemh("program.mem", mem);

	wire [`ADDR_WIDTH-1:2] addr1_word = addr1[`ADDR_WIDTH-1:2];
	wire [`ADDR_WIDTH-1:2] addr2_word = addr2[`ADDR_WIDTH-1:2];
	wire [`ADDR_WIDTH-1:2] addr3_word = addr3[`ADDR_WIDTH-1:2];

	always @(posedge clk) if (en) begin
		if (we[0]) mem[addr1_word][ 7: 0] <= din1[ 7: 0];
		if (we[1]) mem[addr1_word][15: 8] <= din1[15: 8];
		if (we[2]) mem[addr1_word][23:16] <= din1[23:16];
		if (we[3]) mem[addr1_word][31:24] <= din1[31:24];
		dout1 <= mem[addr1_word];
		dout2 <= mem[addr2_word];
		dout3 <= mem[addr3_word];
	end
endmodule
