const PortB = @import("portb.zig").PortB;

pub const ArduinoBoard = union(enum) {
    portb: PortB,

    pub fn toggle(self: *ArduinoBoard) void {
        switch (self.*) {
            .portb => |*case| case.toggle(),
        }
    }
};
