.section .text.init
.globl _start

_start:
    la   sp, _stack_top
    jal  ra, main

_halt:
    j    _halt
