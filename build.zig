const std = @import("std");
const microzig = @import("microzig");

const MicroBuild = microzig.MicroBuild(.{
    .avr = true,
});

const Targets = struct {
    target: *const microzig.Target,
    name: []const u8,
    file: []const u8,
};

pub fn build(b: *std.Build) void {
    const mz_dep = b.dependency("microzig", .{});
    const mb = MicroBuild.init(b, mz_dep) orelse return;

    const available_targets = [_]Targets{
        // .{ .target = mb.ports.avr.boards.arduino.nano, .name = "arduino-nano", .file = "src/main.zig" },
        .{ .target = mb.ports.avr.boards.arduino.uno_rev3, .name = "arduino-uno", .file = "src/main.zig" },
    };

    for (available_targets) |t| {
        const fw = mb.add_firmware(.{
            .name = t.name,
            .target = t.target,
            .optimize = .ReleaseSmall,
            .root_source_file = b.path(t.file),
        });

        mb.install_firmware(fw, .{ .format = .elf });

        const target = b.standardTargetOptions(.{});
        const exe = b.addTest(.{
            .name = "tests",
            .root_source_file = b.path("src/main.zig"),
            .target = target,
        });

        exe.root_module.addImport("microzig", fw.core_mod);

        const run_exe = b.addRunArtifact(exe);
        const run_tests = b.step("test", "Run tests");
        run_tests.dependOn(&run_exe.step);
    }
}
