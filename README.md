# Minimal Kernel Skeleton

This repository bootstraps a tiny multiboot2-capable x86_64 kernel that prints a banner over the first serial port when launched with QEMU. It also lays out a modular directory structure for future kernel components.

## Prerequisites

Install the following toolchain components (cross versions preferred):

- `x86_64-elf-gcc`, `x86_64-elf-ld`, `x86_64-elf-objcopy`
- `qemu-system-x86_64`
- Optional: `grub-mkrescue` for building an ISO image

If your cross compiler uses a different prefix, override `CROSS_PREFIX` when invoking `make`.

## Building

```bash
make
# or specify a different toolchain prefix
CROSS_PREFIX=aarch64-elf- make  # example
```

The build creates `build/kernel.elf`.

## Running in QEMU

Use the provided convenience target to boot the kernel and pipe serial output to your terminal:

```bash
make run
```

Expected serial output:

```
[kernel] boot: serial output ready
```

If you prefer to craft a bootable ISO, install `grub-mkrescue` and run:

```bash
make iso
```

## Repository Layout

- `kernel/init`: Boot assembly and initialization code
- `kernel/mm`: Future memory management code
- `kernel/process`: Future process/thread management code
- `drivers`: Device drivers (currently serial)
- `fs`: Filesystem components
- `include`: Kernel headers
- `linker.ld`: Linker script placing the kernel at 1 MiB
- `Makefile`: Build, run, and ISO helper targets

## Debugging

Launch QEMU with a GDB stub by appending flags to the `run` rule. For example:

```bash
qemu-system-x86_64 -kernel build/kernel.elf -serial stdio -s -S
# then in another terminal
x86_64-elf-gdb build/kernel.elf
```

Set breakpoints at `_start` or `kernel_main` to step through early boot.
