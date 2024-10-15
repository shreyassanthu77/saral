const std = @import("std");
const builtin = @import("builtin");
const Allocator = std.mem.Allocator;
const log = std.log.scoped(.@"saral/window");
const rl = @import("raylib");

const Context = @import("context.zig");
const Text = @import("text.zig");

const aspect_ratio = 9.0 / 16.0;
const height = 1000;
const width: i32 = @intFromFloat(aspect_ratio * height);

pub fn init(title: [*:0]const u8) void {
    rl.setTraceLogLevel(.log_warning);
    rl.initWindow(width, height, title);
    if (builtin.mode == .Debug) {
        // move the window to the center right of the screen
        const padding_right = 50;
        rl.setWindowPosition(1920 - width - padding_right, @divTrunc(1080, 2) - @divTrunc(height, 2));
    }

    if (builtin.mode != .Debug) {
        rl.setExitKey(rl.KeyboardKey.key_null);
        rl.setTargetFPS(120);
    }
}

pub fn deinit() void {
    rl.closeWindow();
}

pub fn run(alloc: Allocator, render_fn: fn (ctx: *const Context) void) void {
    var ctx: Context = .{
        .alloc = alloc,
        .x = 0,
        .y = 0,
        .max_width = width,
        .max_height = height,
        .text_style = Text.Style.default(),
    };
    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();
        // if (builtin.mode == .Debug) {
        rl.drawFPS(10, 10);
        // }
        @call(std.builtin.CallModifier.always_inline, render_fn, .{&ctx});
    }
}
