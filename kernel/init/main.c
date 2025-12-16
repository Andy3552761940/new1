#include <stddef.h>
#include "drivers/serial.h"

static const char *BOOT_BANNER = "[kernel] boot: serial output ready\\r\\n";

void kernel_main(void) {
    serial_init();
    serial_write_string(BOOT_BANNER);
}
