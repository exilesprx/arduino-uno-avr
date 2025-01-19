const std = @import("std");
const microzig = @import("microzig");
const ArduinoBoard = @import("arduino-board.zig").ArduinoBoard;
const PortB = @import("portb.zig").PortB;

pub fn main() !void {
    var port = ArduinoBoard{ .portb = PortB.init(microzig.chip.peripherals.PORTB, 5, true) };

    while (true) {
        port.toggle();
        delay(100);
    }
}

/// delay - busy wait for a number of milliseconds
fn delay(ms: u16) void {
    for (0..ms) |_| {
        microzig.core.experimental.debug.busy_sleep(1_000);
    }
}
