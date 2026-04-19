const std = @import("std");

// Prism dom.zig
// (c) Connor J. Link. All Rights Reserved.

pub const AttributePair = struct {
    key: []const u8,
    value: []const u8,
};

pub const ElementNode = struct {
    tag_name: []const u8,
    attributes: []AttributePair,
    children: []const *DOMNode,
};

pub const TextNode = struct {
    text: []const u8,
};

pub const DOMNode = union(enum) {
    Element: ElementNode,
    Text: TextNode,
};

pub fn parseHTML(html: []const u8) DOMNode {
    _ = html;
    return .{ .Text = .{ .text = "TODO" } };
}

pub fn querySelector(root: DOMNode, selector: []const u8, allocator: std.mem.Allocator) ![]DOMNode {
    _ = root;
    _ = selector;
    return allocator.alloc(DOMNode, 0);
}
