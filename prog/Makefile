PREFIX = riscv64-elf-
ARCH   = rv32im
ABI    = ilp32
LINKER = link.ld

AS = $(PREFIX)as
CC = $(PREFIX)gcc
LD = $(PREFIX)ld
OBJCOPY = $(PREFIX)objcopy

CFLAGS = -march=$(ARCH) -mabi=$(ABI) -nostartfiles -nostdlib -g
ASFLAGS = -march=$(ARCH) -mabi=$(ABI)

.INTERMEDIATE: init.o

init.o: init.s
	$(AS) $(ASFLAGS) -o $@ $<

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

%.elf: %.o link.ld init.o
	$(LD) -m elf32lriscv -T $(LINKER) -o $@ init.o $<

%.hex: %.elf
	$(OBJCOPY) -O verilog --verilog-data-width=4 $< $@

clean:
	rm -f *.o *.elf *.hex
