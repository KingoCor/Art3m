`include "params.svh"
`include "instructions.svh"

module memory_controller (
	input        [            6:0] opcode,
	input        [            2:0] funct3,

	input        [           31:0] rs1,
	input        [           31:0] rs2,
	input        [           31:0] imm,

	output logic [`ADDR_WIDTH-1:0] mem_addr,
	output logic [            3:0] mem_we,
	output logic [           31:0] mem_din,
	input        [           31:0] mem_dout,

	output logic                   write_rd,
	output logic [           31:0] rd
);
	always_comb begin
		mem_addr = rs1+imm;
		mem_we = 4'b0000;
		mem_din = rs2;
		write_rd = 0;
		rd = 0;

		if (opcode==`OPCODE_LOAD) begin
			write_rd = 1;
			     if (funct3==`FUNCT3_LB) rd = {{24{mem_dout[ 7]}},mem_dout[ 7:0]};
			else if (funct3==`FUNCT3_LH) rd = {{16{mem_dout[16]}},mem_dout[15:0]};
			else if (funct3==`FUNCT3_LW) rd = mem_dout;
			else write_rd = 0;
		end
		else if (opcode==`OPCODE_STORE) begin
			     if (funct3==`FUNCT3_SB) mem_we = 4'b0001;
			else if (funct3==`FUNCT3_SH) mem_we = 4'b0011;
			else if (funct3==`FUNCT3_SW) mem_we = 4'b1111;
		end
	end

endmodule
