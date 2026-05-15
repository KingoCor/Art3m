`timescale 1ns/1ps
`include "params.svh"

module tb;

    localparam CLK_HALF_PERIOD = 5;
    localparam RESET_CYCLES    = 3;

    reg  clk;
    reg  nrst;

    wire [15:0] led;

    top dut (
        .clk (clk),
        .nrst (nrst),
        .led (led)
    );

    always #CLK_HALF_PERIOD clk = ~clk;

    initial begin
        clk         = 0;
        nrst        = 0;
		repeat(RESET_CYCLES) @(posedge clk);
        nrst = 1;
    end

    /*
    initial begin
        #1000000;
		$finish;
    end
    */

    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);
    end

endmodule
