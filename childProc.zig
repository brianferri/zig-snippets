const std = @import("std");

fn exec(command: []const []const u8) std.process.Child.RunError!std.process.Child.RunResult {
    return std.process.Child.run(.{
        .allocator = std.heap.page_allocator,
        .argv = command,
    }) catch |e| {
        std.log.err("Failed to execute command: {!}", .{e});
        return e;
    };
}

/// $ zig build-exe childProc.zig
/// $ ./childProc echo 'Hello World'
pub fn main() !void {
    const args = try std.process.argsAlloc(std.heap.page_allocator);
    defer std.process.argsFree(std.heap.page_allocator, args);
    const out = try exec(args[1..]);
    std.log.info("Child process exited with out: {s}", .{out.stdout});
}
