const std = @import("std");

// Prism font.zig
// (c) Connor J. Link. All Rights Reserved.

// quadratic bezier curve only
pub const Spline = struct {
    start_x: f32,
    start_y: f32,
    control_x: f32,
    control_y: f32,
    end_x: f32,
    end_y: f32,
};

pub const Glyph = struct {
    character: u21,
    width: u32,
    height: u32,
    splines: []Spline,
};

pub const FontParser = struct {
    font_path: []const u8,
    glyphs: std.ArrayList(Glyph),

    pub fn init(allocator: std.mem.Allocator, font_path: []const u8) FontParser {
        return .{
            .font_path = font_path,
            .glyphs = std.ArrayList(Glyph).init(allocator),
        };
    }

    pub fn deinit(self: *FontParser) void {
        self.glyphs.deinit();
    }
};

pub const Cursor = struct {
    x: u32,
    y: u32,
};

pub const AtlasEntry = struct {
    character: u21,
    x: u32,
    y: u32,
    width: u32,
    height: u32,
};

pub const FontType = enum {
    Regular,
    Bold,
    Italic,
    BoldItalic,
};

pub const Atlas = struct {
    entries: []AtlasEntry,
    width: u32,
    height: u32,
    typeface: []const u8,
    font_type: FontType,
};

pub const FontRenderer = struct {
    cursor: Cursor = .{ .x = 0, .y = 0 },
    typeface: []const u8 = "",
    font_type: FontType = .Regular,

    pub fn withCursor(self: *FontRenderer, cursor: Cursor) *FontRenderer {
        self.cursor = cursor;
        return self;
    }

    pub fn withTypeface(self: *FontRenderer, typeface: []const u8) *FontRenderer {
        self.typeface = typeface;
        return self;
    }

    pub fn withFontType(self: *FontRenderer, font_type: FontType) *FontRenderer {
        self.font_type = font_type;
        return self;
    }

    pub fn renderCharacter(self: *FontRenderer, character: u21) void {
        _ = self;
        _ = character;
        // TODO
    }

    pub fn renderString(self: *FontRenderer, s: []const u8, maximum_width: u32) void {
        _ = maximum_width;
        for (s) |ch| {
            self.renderCharacter(@as(u21, ch));
        }
    }

    pub fn rasterizeGlyph(self: *FontRenderer, character: u21) !void {
        _ = self;
        _ = character;
        // TODO: create scratch atlas file + mmap + spawn java process in Zig.
    }
};

pub const FontAtlasFileSize: usize = 10 * 1024 * 1024;
