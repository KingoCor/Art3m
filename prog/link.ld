OUTPUT_ARCH("riscv")
ENTRY(_start)

MEMORY {
    rom (rx)  : ORIGIN = 0x0000, LENGTH = 4K
    ram (rw) : ORIGIN = 0x1000, LENGTH = 4K
}

SECTIONS
{
    .text : {
		*(.text.init)
        *(.text)
        *(.text.*)
    } > rom

    .rodata : {
        *(.rodata)
        *(.rodata.*)
    } > rom

    .data : {
        *(.data)
        *(.data.*)
    } > ram

    .bss : {
        *(.bss)
        *(.bss.*)
		. = ALIGN(4);
		_stack_top = .;
		. = . + 0x0400;
    } > ram
}
