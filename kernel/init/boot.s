.set MBOOT2_MAGIC, 0xE85250D6
.set MBOOT_ARCH, 0

.section .multiboot
.align 8
header_start:
    .long MBOOT2_MAGIC
    .long MBOOT_ARCH
    .long header_end - header_start
    .long -(MBOOT2_MAGIC + MBOOT_ARCH + (header_end - header_start))
    .short 0
    .short 0
    .long 8
header_end:

.section .text
.global _start
.type _start, @function
_start:
    cli
    lea stack_top(%rip), %rsp
    call kernel_main
halt:
    hlt
    jmp halt

.section .bss
.align 16
stack_bottom:
    .skip 16384
stack_top:
