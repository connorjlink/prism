const std = @import("std");
const font = @import("font.zig");
const dom = @import("dom.zig");
const css = @import("css.zig");
const js = @import("js.zig");
const definitions = @import("definitions.zig");

// Prism main.zig
// (c) Connor J. Link. All Rights Reserved.

const Application = struct {
    name: []const u8,
    version: []const u8,
    logo: []const u8,

    pub fn init() Application {
        return .{
            .name = "Prism",
            .version = "0.0.1",
            .logo = "(c) Connor J. Link. All Rights Reserved.",
        };
    }
};

const AspectRatio: f32 = 16.0 / 9.0;
const WindowHeight: u32 = 720;

const Window = struct {
    width: u32,
    height: u32,
    application: Application,

    pub fn init() Window {
        return .{
            .width = @as(u32, @intFromFloat(AspectRatio * @as(f32, @floatFromInt(WindowHeight)))),
            .height = WindowHeight,
            .application = Application.init(),
        };
    }
};

pub fn main() !void {

    _ = font.FontAtlasFileSize;
    _ = dom.DOMNode;
    _ = css.CSSValue;
    _ = js.JSInterpreter;

    try definitions.writeError("Hello, world!\n");
}
