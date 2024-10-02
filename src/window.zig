const std = @import("std");
const builtin = @import("builtin");
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
    rl.setExitKey(rl.KeyboardKey.key_null);
    rl.setTargetFPS(120);
}

pub fn deinit() void {
    rl.closeWindow();
}

pub fn run(render_fn: fn (ctx: *const Context) void) void {
    var ctx: Context = .{
        .x = 0,
        .y = 0,
        .max_width = width,
        .max_height = height,
        .text_style = Text.Style.default(),
    };
    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();
        if (builtin.mode == .Debug) {
            rl.drawFPS(10, 10);
        }
        @call(std.builtin.CallModifier.always_inline, render_fn, .{&ctx});
    }
}
