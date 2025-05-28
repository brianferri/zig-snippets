const std = @import("std");
const c = std.c;

pub fn sig_int(gpa: *std.heap.GeneralPurposeAllocator(.{})) void {
    std.log.info("\nSIG_INT caught, cleaning up...", .{});
    _ = gpa.deinit();
    std.process.exit(2);
}

pub fn setAbortSignalHandler(comptime signal: u6, comptime f: anytype, args: anytype) !void {
    const Context = struct {
        var data: @TypeOf(args) = undefined;
    };
    Context.data = args;

    const internal = struct {
        fn trampoline(_: c_int) callconv(.C) void {
            @call(.auto, f, Context.data);
        }
    };

    const sa = std.posix.Sigaction{
        .handler = .{ .handler = internal.trampoline },
        .mask = 0,
        .flags = 0,
    };

    std.posix.sigaction(signal, &sa, null);
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    try setAbortSignalHandler(std.c.SIG.INT, sig_int, .{&gpa});

    // Test the functionality of passing arguments by triggering the GPA's leak detection on SIGINT
    const u32_ptr = try allocator.create(u32);
    _ = u32_ptr;

    while (true) {} // User should CTRL+C manually to trigger the "test"
}
