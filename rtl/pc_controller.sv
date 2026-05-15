`include "instructions.svh"

module pc_controller (
	input               clk,
	input               rst,
	input               en,

	input        [ 6:0] opcode,
	input        [ 2:0] funct3,

	input        [31:0] rs1,
	input        [31:0] rs2,
	input        [31:0] imm,

	output logic        write_rd,
	output logic [31:0] rd,

	output logic [31:0] pc,
	output logic [31:0] pc_next
);
	wire eq = rs1==rs2;
	wire lt = $signed(rs1)<$signed(rs2);
	wire ltu = rs1<rs2;

	always_comb begin
		pc_next = pc+32'd4;
		write_rd = 0;
		rd = 0;

		if (~en) pc_next = pc;
		else if (opcode==`OPCODE_JAL) begin
			pc_next = pc+imm;
			write_rd = 1;
			rd = pc+32'd4;
		end
		else if (opcode==`OPCODE_JALR) begin
			pc_next = rs1+imm;
			pc_next[0] = 0;
			write_rd = 1;
			rd = pc+32'd4;
		end
		else if (opcode==`OPCODE_BRANCH) begin

			     if (funct3==`FUNCT3_BEQ  &&   eq) pc_next = pc+imm;	
            else if (funct3==`FUNCT3_BNE  &&  ~eq) pc_next = pc+imm; 
            else if (funct3==`FUNCT3_BLT  &&   lt) pc_next = pc+imm; 
            else if (funct3==`FUNCT3_BGE  &&  ~lt) pc_next = pc+imm; 
            else if (funct3==`FUNCT3_BLTU &&  ltu) pc_next = pc+imm;
            else if (funct3==`FUNCT3_BGEU && ~ltu) pc_next = pc+imm;
		end
	end

	always_ff @(posedge clk) begin
			 if (rst) pc<=0;
		else if ( en) pc<=pc_next;
	end
endmodule
