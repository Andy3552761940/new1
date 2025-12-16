#include "kernel/io.h"
#include "drivers/serial.h"

#define COM1_PORT 0x3F8

static int serial_is_transmit_fifo_empty(void) {
    return inb(COM1_PORT + 5) & 0x20;
}

void serial_init(void) {
    outb(COM1_PORT + 1, 0x00);
    outb(COM1_PORT + 3, 0x80);
    outb(COM1_PORT + 0, 0x03);
    outb(COM1_PORT + 1, 0x00);
    outb(COM1_PORT + 3, 0x03);
    outb(COM1_PORT + 2, 0xC7);
    outb(COM1_PORT + 4, 0x0B);
}

void serial_write_char(char c) {
    while (!serial_is_transmit_fifo_empty()) {
        __asm__ volatile ("pause");
    }
    outb(COM1_PORT, (uint8_t)c);
}

void serial_write(const char *buffer, size_t length) {
    for (size_t i = 0; i < length; ++i) {
        serial_write_char(buffer[i]);
    }
}

void serial_write_string(const char *str) {
    if (!str) {
        return;
    }

    while (*str) {
        serial_write_char(*str++);
    }
}
