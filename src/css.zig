const std = @import("std");

// Prism css.zig
// (c) Connor J. Link. All Rights Reserved.

pub const LengthValue = struct {
    value: f32,
    unit: []const u8,
};

pub const ColorValue = struct {
    value: []const u8,
};

pub const KeywordValue = struct {
    value: []const u8,
};

pub const CSSValue = union(enum) {
    Length: LengthValue,
    Color: ColorValue,
    Keyword: KeywordValue,
};
