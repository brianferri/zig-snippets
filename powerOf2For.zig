const std = @import("std");

const UTypes = .{
    u1,
    u2,
    u3,
    u4,
    u5,
    u6,
    u7,
    u8,
    u9,
    u10,
    u11,
    u12,
    u13,
    u14,
    u15,
    u16,
};

inline fn powerOf2For(x: u64) type {
    if (x == 0) return u1;
    comptime {
        var tmp = x - 1;
        tmp |= tmp >> 1;
        tmp |= tmp >> 2;
        tmp |= tmp >> 4;
        tmp |= tmp >> 8;
        tmp |= tmp >> 16;
        return UTypes[std.math.log2(tmp + 1)];
    }
}

test powerOf2For {
    try std.testing.expect(powerOf2For(0) == u1);
    try std.testing.expect(powerOf2For(1) == u1);
    try std.testing.expect(powerOf2For(2) == u2);
    try std.testing.expect(powerOf2For(4) == u3);
    try std.testing.expect(powerOf2For(8) == u4);
    try std.testing.expect(powerOf2For(16) == u5);
    try std.testing.expect(powerOf2For(32) == u6);
    try std.testing.expect(powerOf2For(64) == u7);
    try std.testing.expect(powerOf2For(128) == u8);
    try std.testing.expect(powerOf2For(256) == u9);
    try std.testing.expect(powerOf2For(512) == u10);
    try std.testing.expect(powerOf2For(1024) == u11);
    try std.testing.expect(powerOf2For(2048) == u12);
    // ...
}
