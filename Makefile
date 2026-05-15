RTL_SOURCE := $(wildcard rtl/*.sv rtl/*.svh)
INCLUDE := -I rtl
TB_SOURCE := sim/tb_top.sv
WAVEFORM_VIEWER := surfer

all: compile_sim program.mem

compile_sim: $(RTL_SOURCE) $(TB_SOURCE)
	iverilog -g2012 $(RTL_SOURCE) $(TB_SOURCE) $(INCLUDE) -o sim/sim.vvp

program.mem:
	cd prog && make
	mv prog/main.hex sim/program.mem

sim: compile_sim program.mem
	cd sim && vvp sim.vvp

sim_wave: sim
	$(WAVEFORM_VIEWER) sim/tb.vcd
