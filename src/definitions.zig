const std = @import("std");

// Prism definitions.zig
// (c) Connor J. Link. All Rights Reserved.

pub fn errorStream() std.Io.File {
    return std.Io.File.stderr();
}

pub fn writeError(message: []const u8) !void {
    // TODO: finish the error handler writing
    _ = message;
}
