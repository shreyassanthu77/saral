const std = @import("std");
const log = std.log.scoped(.@"saral/rect");
const Context = @import("context.zig");
const rl = @import("raylib");
const Color = rl.Color;

pub const Options = struct {
    width: f32,
    height: f32,
    position: Position = .{ .absolute = .{ .x = 0, .y = 0 } },
    border_radius: f32 = 0,
    overflow: Overflow = .visible,
    color: Color = Color.init(0, 0, 0, 0),
    child: ?*const fn (ctx: *const Context) void = null,
};

pub inline fn render(
    x: f32,
    y: f32,
    options: *const Options,
) void {
    const rec = rl.Rectangle{
        .x = x,
        .y = y,
        .width = options.width,
        .height = options.height,
    };
    rl.drawRectangleRounded(rec, options.border_radius / (options.width / 3), 12, options.color);
}

pub const Alignment = enum {
    start,
    end,
    center,
};

pub const Position = union(enum) {
    absolute: struct {
        x: f32 = 0,
        y: f32 = 0,
    },
    aligned: struct {
        horizontal: Alignment = .start,
        vertical: Alignment = .start,
    },

    pub fn topLeft() Position {
        return .{
            .aligned = .{
                .horizontal = .start,
                .vertical = .start,
            },
        };
    }

    pub fn topCenter() Position {
        return .{
            .aligned = .{
                .horizontal = .center,
                .vertical = .start,
            },
        };
    }

    pub fn topRight() Position {
        return .{
            .aligned = .{
                .horizontal = .end,
                .vertical = .start,
            },
        };
    }

    pub fn centerLeft() Position {
        return .{
            .aligned = .{
                .horizontal = .start,
                .vertical = .center,
            },
        };
    }

    pub fn centerd() Position {
        return .{
            .aligned = .{
                .horizontal = .center,
                .vertical = .center,
            },
        };
    }

    pub fn centerRight() Position {
        return .{
            .aligned = .{
                .horizontal = .end,
                .vertical = .center,
            },
        };
    }

    pub fn bottomLeft() Position {
        return .{
            .aligned = .{
                .horizontal = .start,
                .vertical = .end,
            },
        };
    }

    pub fn bottomCenter() Position {
        return .{
            .aligned = .{
                .horizontal = .center,
                .vertical = .end,
            },
        };
    }

    pub fn bottomRight() Position {
        return .{
            .aligned = .{
                .horizontal = .end,
                .vertical = .end,
            },
        };
    }
};

pub const Overflow = enum {
    visible,
    hidden,
};
