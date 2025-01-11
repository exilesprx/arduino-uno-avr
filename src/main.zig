const std = @import("std");
const microzig = @import("microzig");

const port = microzig.chip.peripherals.PORTB;

pub fn main() !void {
    port.DDRB |= (1 << 5); // set to output
    port.PORTB |= 0x00; // turn light off

    while (true) {
        delay(2_000);
        port.PINB |= (1 << 5);
    }
}

/// delay - busy wait for a number of milliseconds
fn delay(ms: u16) void {
    for (0..ms) |_| {
        microzig.core.experimental.debug.busy_sleep(1_000);
    }
}
