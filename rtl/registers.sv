`include "params.svh"

module registers(
	input         clk,

	input  [ 4:0] rs1_addr,
	output [31:0] rs1,
	input  [ 4:0] rs2_addr,
	output [31:0] rs2,

	input         we,
	input  [ 4:0] rd_addr,
	input  [31:0] rd
);
	logic [31:0] mem [1:31];

	assign rs1 = rs1_addr==0 ? 0 : mem[rs1_addr];
	assign rs2 = rs2_addr==0 ? 0 : mem[rs2_addr];

	always @(posedge clk) if (we&&(rd_addr!=0)) mem[rd_addr] <= rd;
endmodule
