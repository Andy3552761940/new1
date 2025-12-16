#ifndef DRIVERS_SERIAL_H
#define DRIVERS_SERIAL_H

#include <stddef.h>

void serial_init(void);
void serial_write_char(char c);
void serial_write(const char *buffer, size_t length);
void serial_write_string(const char *str);

#endif // DRIVERS_SERIAL_H
