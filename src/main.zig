const std = @import("std");
const microzig = @import("microzig");

pub fn main() !void {
    const port = microzig.chip.peripherals.PORTB;
    const pin = 5;
    port.DDRB |= (1 << pin);
    port.PORTB = 0x00;

    while (true) {
        port.PINB |= (1 << pin);
        delay(2_000);
    }
}

/// delay - busy wait for a number of milliseconds
fn delay(ms: u16) void {
    for (0..ms) |_| {
        microzig.core.experimental.debug.busy_sleep(1_000);
    }
}
