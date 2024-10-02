const std = @import("std");
const log = std.log.scoped(.@"saral/context");
const rl = @import("raylib");

const Color = rl.Color;
const Text = @import("text.zig");
const Rect = @import("rect.zig");

x: f32,
y: f32,
max_width: f32,
max_height: f32,
text_style: Text.Style = .{},

const Self = @This();
pub fn rect(
    self: *const Self,
    options: Rect.Options,
) void {
    const x = switch (options.position) {
        .absolute => |pos| pos.x,
        .aligned => |pos| switch (pos.horizontal) {
            .start => 0,
            .end => self.max_width - options.width,
            .center => (self.max_width / 2) - (options.width / 2),
        },
    };
    std.debug.assert(x >= 0);
    std.debug.assert(x + options.width <= self.max_width);
    const y = switch (options.position) {
        .absolute => |pos| pos.y,
        .aligned => |pos| switch (pos.vertical) {
            .start => 0,
            .end => self.max_height - options.height,
            .center => (self.max_height / 2) - (options.height / 2),
        },
    };
    std.debug.assert(y >= 0);
    std.debug.assert(y + options.height <= self.max_height);
    Rect.render(
        self.x + x,
        self.y + y,
        &options,
    );

    var new_ctx = Self{
        .x = self.x + x,
        .y = self.y + y,
        .max_width = options.width,
        .max_height = options.height,
        .text_style = self.text_style,
    };
    if (options.child) |f| {
        f(&new_ctx);
    }
}

pub inline fn text(
    self: *const Self,
    options: Text.Options,
) void {
    return Text.render(
        self.x,
        self.y,
        self.max_width,
        self.max_height,
        &options,
        &self.text_style,
    );
}

pub inline fn clear(_: *const Self, color: rl.Color) void {
    rl.clearBackground(color);
}
