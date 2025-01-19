const std = @import("std");
const microzig = @import("microzig");

const ArduinoBoard = union(enum) {
    portb: PortB,

    pub fn toggle(self: *ArduinoBoard) void {
        switch (self.*) {
            .portb => |*case| case.toggle(),
        }
    }
};

const PortB = struct {
    port: *volatile microzig.chip.types.peripherals.PORT.PORTB,
    pin: u3,

    pub fn init(port: *volatile microzig.chip.types.peripherals.PORT.PORTB, pin: comptime_int, output: bool) PortB {
        const self = PortB{
            .port = port,
            .pin = pin,
        };

        self.port.DDRB |= (@as(u8, @intFromBool(output)) << pin);
        self.port.PORTB = 0x00;

        return self;
    }

    pub fn toggle(self: *PortB) void {
        self.port.PINB |= (@as(u8, 1) << self.pin);
    }
};

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
