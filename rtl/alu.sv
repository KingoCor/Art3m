`include "instructions.svh"

module alu (
	input        [ 6:0] opcode,
	input        [ 2:0] funct3,
	input        [ 6:0] funct7,

	input        [31:0] pc,
	input        [31:0] rs1,
	input        [31:0] rs2,
	input        [31:0] imm,

	output logic        write_rd,
	output logic [31:0] rd
);
	always_comb begin
		write_rd = 1;
		rd = 0;

		if (opcode==`OPCODE_OP_IMM) begin
				 if (funct3==`FUNCT3_ADDI ) rd = rs1+imm; 
			else if (funct3==`FUNCT3_SLTI ) rd = $signed(rs1)<$signed(imm); 
			else if (funct3==`FUNCT3_SLTIU) rd = rs1<imm;
			else if (funct3==`FUNCT3_ANDI ) rd = rs1&imm; 
			else if (funct3==`FUNCT3_ORI  ) rd = rs1|imm; 
			else if (funct3==`FUNCT3_XORI ) rd = rs1^imm; 
			else if (funct3==`FUNCT3_SLLI && funct7==`FUNCT7_SLLI) rd = rs1<<imm; 
			else if (funct3==`FUNCT3_SRLI && funct7==`FUNCT7_SRLI) rd = rs1>>imm; 
			else if (funct3==`FUNCT3_SRAI && funct7==`FUNCT7_SRAI) rd = rs1>>>imm; 
			else write_rd = 0;
		end
		else if (opcode==`OPCODE_AUIPC) rd = pc+imm;
		else if (opcode==`OPCODE_LUI)   rd = imm;
		else if (opcode==`OPCODE_OP) begin
				 if (funct3==`FUNCT3_ADD    && funct7==`FUNCT7_ADD   ) rd = rs1+rs2; 
			else if (funct3==`FUNCT3_SLT    && funct7==`FUNCT7_SLT   ) rd = $signed(rs1)<$signed(rs2); 
			else if (funct3==`FUNCT3_SLTU   && funct7==`FUNCT7_SLTU  ) rd = rs1<rs2;
			else if (funct3==`FUNCT3_AND    && funct7==`FUNCT7_AND   ) rd = rs1&rs2; 
			else if (funct3==`FUNCT3_OR     && funct7==`FUNCT7_OR    ) rd = rs1|rs2; 
			else if (funct3==`FUNCT3_XOR    && funct7==`FUNCT7_XOR   ) rd = rs1^rs2; 
			else if (funct3==`FUNCT3_SLL    && funct7==`FUNCT7_SLL   ) rd = rs1<<rs2; 
			else if (funct3==`FUNCT3_SRL    && funct7==`FUNCT7_SRL   ) rd = rs1>>rs2; 
			else if (funct3==`FUNCT3_SUB    && funct7==`FUNCT7_SUB   ) rd = $signed(rs1)-$signed(rs2); 
			else if (funct3==`FUNCT3_SRA    && funct7==`FUNCT7_SRA   ) rd = rs1>>>rs2; 
			else if (funct3==`FUNCT3_MUL    && funct7==`FUNCT7_MUL   ) rd = rs1*rs2;
			else if (funct3==`FUNCT3_MULH   && funct7==`FUNCT7_MULH  ) rd = 64'($signed(rs1))*64'($signed(rs2))>>32;
			else if (funct3==`FUNCT3_MULHSU && funct7==`FUNCT7_MULHSU) rd = 64'($signed(rs1))*64'(rs2)>>32;
			else if (funct3==`FUNCT3_MULHU  && funct7==`FUNCT7_MULHU ) rd = 64'(rs1)*64'(rs2)>>32;
			else if (funct3==`FUNCT3_DIV    && funct7==`FUNCT7_DIV   ) rd = $signed(rs1)/$signed(rs2);
			else if (funct3==`FUNCT3_DIVU   && funct7==`FUNCT7_DIVU  ) rd = rs1/rs2;
			else if (funct3==`FUNCT3_REM    && funct7==`FUNCT7_REM   ) rd = $signed(rs1)%rs2;
			else if (funct3==`FUNCT3_REMU   && funct7==`FUNCT7_REMU  ) rd = rs1%rs2;
			else write_rd = 0;
		end
		else write_rd = 0;
	end
endmodule
