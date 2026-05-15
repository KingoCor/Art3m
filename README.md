# Art3m - RV32IM Processor in SystemVerilog

This project is an educational implementation of the **RV32IM** (32-bit RISC-V with Integer and Multiplication/Division extensions) processor core, written in SystemVerilog. It includes a complete development and simulation environment, as well as a demo program that runs on the core and outputs to a seven-segment display.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Building](#building)
- [Simulation](#simulation)
- [FPGA Deployment](#fpga-deployment)
- [Demo Program](#demo-program)

## Prerequisites

- **Simulation**:
  - [Icarus Verilog (iverilog)](http://iverilog.icarus.com/)
  - [surfer](https://surfer-project.org/) (for waveform viewing, optional)
  - [RISC-V GNU Toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain) (for compiling the demo program)
- **FPGA (optional)**:
  - Xilinx Vivado (for synthesis and bitstream generation)
  - Nexys A7

## Building

Clone the repository
```bash
git clone https://github.com/KingoCor/Art3m.git
cd Art3m
```

Build everything (firmware + testbench)
```bash
make
```

## Simulation

The testbench (`tb_top.sv`) instantiates the CPU and runs the program loaded from `sim/program.mem`.

To run simulation:
```bash
make sim
```

To run simulation and open waveform: 
```
make sim_wave
```

The Makefile sets `WAVEFORM_VIEWER := surfer` by default. You can override this variable to use your preferred waveform viewer (e.g., gtkwave, vcd-viewer, etc.) by changing the assignment or passing it during the make invocation:
```bash
make WAVEFORM_VIEWER=gtkwave sim_wave
```

## FPGA Deployment

The provided constraints target the **Digilent Nexys A7**, but RTL itself has minimal board-specific logic.

### Using the included Nexys A7 constraints
1. Open the project in Xilinx Vivado.
2. Add all `.sv`, `.svh`  files from `rtl/` and `program.mem` from `sim/`.
3. Add the constraints file `constraints/pinout.xdc` (pre-configured for Nexys A7's seven-segment display and clock).
4. Generate the bitstream and program the board.

### Porting to another FPGA board
- Replace `constraints/pinout.xdc` with your board's pin mapping.
- If your board uses a different seven-segment display interface (e.g., common anode vs. common cathode, or different multiplexing), you may need to adjust `rtl/seven_segment_controller.sv`.
- The top-level module uses an active-low reset (`nrst`). Ensure your board's reset button is mapped correctly.
- No other changes are required - the CPU core and memory are independent of the physical hardware.

## Demo Program

The firmware (`prog/main.c`) implements a simple trial division algorithm to check for primality. It continuously tests integers starting from 2, and whenever a prime number is found, it displays the value on the seven‑segment display.

The program is compiled with the RV32IM toolchain and linked to run from address `0x0000`, using `0x1000` as the start of RAM.
