const std = @import("std");
const microzig = @import("microzig");

const MicroBuild = microzig.MicroBuild(.{
    .avr = true,
});

pub fn build(b: *std.Build) void {
    const mz_dep = b.dependency("microzig", .{});
    const mb = MicroBuild.init(b, mz_dep) orelse return;

    const available_targets = [_]Targets{
        .{ .target = mb.ports.avr.boards.arduino.nano, .name = "arduino-nano", .file = "src/main.zig" },
        .{ .target = mb.ports.avr.boards.arduino.uno_rev3, .name = "arduino-uno", .file = "src/main.zig" },
    };

    for (available_targets) |t| {
        const fw = mb.add_firmware(.{
            .name = t.name,
            .target = t.target,
            .optimize = .ReleaseSmall,
            .root_source_file = b.path(t.file),
        });

        mb.install_firmware(fw, .{});
        mb.install_firmware(fw, .{ .format = .elf });
    }
}

const Targets = struct {
    target: *const microzig.Target,
    name: []const u8,
    file: []const u8,
};
