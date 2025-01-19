const microzig = @import("microzig");

pub const PortB = struct {
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
