`include "params.svh"

module top (
    input  logic       clk,
    input  logic       nrst,

	output logic [15:0] led
);
    wire rst = ~nrst;
    wire en = 1'b1;

    wire [31:0] pc, mem_addr, exp_mem_addr;
    wire [31:0] inst, mem_dout, exp_mem_dout;
    wire [31:0] mem_din;
    wire [3:0]  mem_we;

	assign exp_mem_addr = 32'hfffc;
	led_controller led_controller_i(
        .clk(clk),
        .rst(rst),
		.in (exp_mem_dout),
		.led(led)
	);
		
    memory mem_i (
        .clk   (clk),
        .en    (en),
        .addr1 (mem_addr),
        .addr2 (pc),
        .addr3 (exp_mem_addr),
        .we    (mem_we),
        .din1  (mem_din),
        .dout1 (mem_dout),
        .dout2 (inst),
        .dout3 (exp_mem_dout)
    );

    cpu cpu_i (
        .clk      (clk),
        .rst      (rst),
        .pc_next  (pc),
        .inst     (inst),
        .mem_addr (mem_addr),
        .mem_we   (mem_we),
        .mem_din  (mem_din),
        .mem_dout (mem_dout)
    );
endmodule
