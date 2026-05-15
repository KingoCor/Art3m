`include "params.svh"

module cpu (
	input                    clk,
	input                    rst,

	output [           31:0] pc_next,
	input  [           31:0] inst,

	output [`ADDR_WIDTH-1:0] mem_addr,
	output [            3:0] mem_we,
	output [           31:0] mem_din,
	input  [           31:0] mem_dout
);
	wire  [ 6:0] opcode; 
	wire  [ 2:0] funct3;
	wire  [ 6:0] funct7;
	wire  [ 4:0] rs1_addr, rs2_addr, rd_addr;
	wire  [31:0] rs1, rs2, imm;
	logic write_rd;
	logic [31:0] rd;

	logic pc_en;
	wire  [31:0] pc;
	wire  write_pc_rd;
	wire  [31:0] pc_rd;

	wire write_alu_rd;
	wire [31:0] alu_rd;

	wire write_mem_rd;
	wire [31:0] mem_rd;

	// state
	enum logic[1:0] {
		START,
		RUNNING,
		LOAD_REG
	} state, next_state;

	always_comb begin
		next_state = RUNNING;
		if (state==RUNNING && write_mem_rd) next_state = LOAD_REG;
	end

	always_ff @(posedge clk) begin
		if (rst) state<=START;
		else     state<=next_state;
	end

	// instruction decoding
	instruction_decoder inst_decoder (
		.inst(inst),
		.opcode(opcode),
		.funct3(funct3),
		.funct7(funct7),
		.rd(rd_addr),
		.rs1(rs1_addr),
		.rs2(rs2_addr),
		.imm(imm)
	);

	// pc
	always_comb begin
		pc_en = 1;
			 if (state==START) pc_en = 0;
		else if (state==RUNNING && write_mem_rd) pc_en = 0;
	end

	pc_controller pc_controller_i (
		.clk(clk),
		.rst(rst),
		.en(pc_en),
		.opcode(opcode),
		.funct3(funct3),
		.rs1(rs1),
		.rs2(rs2),
		.imm(imm),
		.write_rd(write_pc_rd),
		.rd(pc_rd),
		.pc(pc),
		.pc_next(pc_next)
	);
		
	// registers
	always_comb begin
		write_rd = write_alu_rd||write_pc_rd||(state==LOAD_REG);
		rd = 0;

			 if (state==LOAD_REG) rd = mem_rd;
		else if (   write_alu_rd) rd = alu_rd;
		else if (    write_pc_rd) rd = pc_rd;
	end

	registers regs(
		.clk(clk),
		.rs1_addr(rs1_addr),
		.rs1(rs1),
		.rs2_addr(rs2_addr),
		.rs2(rs2),
		.we(write_rd),
		.rd_addr(rd_addr),
		.rd(rd)
	);

	// alu
	alu alu_i(
		.opcode(opcode),
		.funct3(funct3),
		.funct7(funct7),
		.pc(pc),
		.rs1(rs1),
		.rs2(rs2),
		.imm(imm),
		.write_rd(write_alu_rd),
		.rd(alu_rd)
	);

	// memory
	memory_controller memory_controller_i (
		.opcode(opcode),
		.funct3(funct3),
		.rs1(rs1),
		.rs2(rs2),
		.imm(imm),
		.mem_addr(mem_addr),
		.mem_we(mem_we),
		.mem_din(mem_din),
		.mem_dout(mem_dout),
		.write_rd(write_mem_rd),
		.rd(mem_rd)
	);
endmodule
