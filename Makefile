CROSS_PREFIX ?= x86_64-elf-
CC := $(CROSS_PREFIX)gcc
LD := $(CROSS_PREFIX)ld
AS := $(CC)
OBJCOPY := $(CROSS_PREFIX)objcopy

BUILD_DIR := build
KERNEL := $(BUILD_DIR)/kernel.elf
ISO := $(BUILD_DIR)/kernel.iso

CFLAGS := -Wall -Wextra -Werror -ffreestanding -fno-stack-protector -fno-pic -m64 -mcmodel=kernel -mno-red-zone -nostdinc -nostdlib -std=c11
CFLAGS += -Iinclude
LDFLAGS := -nostdlib -T linker.ld
ASFLAGS := $(CFLAGS)

C_SOURCES := $(shell find kernel drivers -name '*.c')
ASM_SOURCES := $(shell find kernel -name '*.s')

C_OBJECTS := $(patsubst %,$(BUILD_DIR)/%.o,$(C_SOURCES))
ASM_OBJECTS := $(patsubst %,$(BUILD_DIR)/%.o,$(ASM_SOURCES))

OBJECTS := $(C_OBJECTS) $(ASM_OBJECTS)

.PHONY: all clean run qemu gdb iso

all: $(KERNEL)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/%.c.o: %.c | $(BUILD_DIR)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/%.s.o: %.s | $(BUILD_DIR)
	@mkdir -p $(dir $@)
	$(AS) $(ASFLAGS) -c $< -o $@

$(KERNEL): $(OBJECTS) linker.ld | $(BUILD_DIR)
	$(LD) $(LDFLAGS) $(OBJECTS) -o $@

run: $(KERNEL)
	qemu-system-x86_64 -kernel $(KERNEL) -serial stdio -display none

qemu: run

iso: $(KERNEL)
	mkdir -p $(BUILD_DIR)/iso/boot/grub
	cp $(KERNEL) $(BUILD_DIR)/iso/boot/kernel.elf
	printf 'set default=0\\nset timeout=0\\nmenuentry "kernel" {\\n    multiboot2 /boot/kernel.elf\\n    boot\\n}\\n' > $(BUILD_DIR)/iso/boot/grub/grub.cfg
	grub-mkrescue -o $(ISO) $(BUILD_DIR)/iso

clean:
	rm -rf $(BUILD_DIR)
