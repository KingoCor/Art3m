`include "instructions.svh"

module instruction_decoder (
	input  [31:0] inst,

	output logic [ 6:0] opcode,
	output logic [ 2:0] funct3,
	output logic [ 6:0] funct7,
	output logic [ 4:0] rd,
	output logic [ 4:0] rs1,
	output logic [ 4:0] rs2,

	output logic [31:0] imm
);
	enum logic [2:0] {
		INST_TYPE_R,
		INST_TYPE_I,
		INST_TYPE_S,
		INST_TYPE_B,
		INST_TYPE_U,
		INST_TYPE_J
	} inst_type;

	always_comb begin
		opcode = inst[6:0];
		rd = inst[11:7];
		funct3 = inst[14:12];
		rs1 = inst[19:15];
		rs2 = inst[24:20];
		funct7 = inst[31:25];

		case (opcode)
			`OPCODE_LOAD:   inst_type = INST_TYPE_I;
			`OPCODE_STORE:  inst_type = INST_TYPE_S; 
			`OPCODE_BRANCH: inst_type = INST_TYPE_B;
			`OPCODE_JALR:   inst_type = INST_TYPE_I;  
			`OPCODE_JAL:    inst_type = INST_TYPE_J;   
			`OPCODE_OP_IMM: inst_type = INST_TYPE_I;
			`OPCODE_OP:     inst_type = INST_TYPE_R;    
			`OPCODE_AUIPC:  inst_type = INST_TYPE_U; 
			`OPCODE_LUI:    inst_type = INST_TYPE_U;   
			default:        inst_type = INST_TYPE_R;
		endcase

		case (inst_type) 
			INST_TYPE_I: imm = {{21{inst[31]}},inst[30:25],inst[24:21],inst[20]};
			INST_TYPE_S: imm = {{21{inst[31]}},inst[30:25],inst[11:8],inst[7]};
			INST_TYPE_B: imm = {{20{inst[31]}},inst[7],inst[30:25],inst[11:8],1'b0};
			INST_TYPE_U: imm = {inst[31],inst[30:20],inst[19:12],12'b0};
			INST_TYPE_J: imm = {{11{inst[31]}},inst[19:12],inst[20],inst[30:25],inst[24:21],1'b0};
			default:     imm = 0;
		endcase
	end

endmodule
