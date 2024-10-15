const std = @import("std");
const Allocator = std.mem.Allocator;
const log = std.log.scoped(.@"saral/context");
const rl = @import("raylib");

const Color = rl.Color;
const Text = @import("text.zig");
const Rect = @import("rect.zig");

alloc: Allocator,
x: f32,
y: f32,
max_width: f32,
max_height: f32,
text_style: Text.Style = .{},

const Self = @This();

const rounded_shader = struct {
    const rounded_shader_src = @embedFile("assets/shaders/rounded_mask.frag");
    var loaded: bool = false;
    var shader: rl.Shader = undefined;

    pub fn load() void {
        if (loaded) return;
        defer loaded = true;
        shader = rl.loadShaderFromMemory(null, rounded_shader_src);
    }

    pub fn unload() void {
        if (!loaded) return;
        defer loaded = false;
        rl.unloadShader(shader);
    }

    pub fn begin(radius: f32, width: f32, height: f32) void {
        if (!loaded) load();
        const radius_loc = rl.getShaderLocation(shader, "radius");
        const resolution_loc = rl.getShaderLocation(shader, "resolution");
        const radius_val: [1]f32 = .{radius};
        const resolution_val: [2]f32 = .{ width, height };
        rl.setShaderValue(shader, radius_loc, &radius_val, .shader_uniform_float);
        rl.setShaderValue(shader, resolution_loc, &resolution_val, .shader_uniform_vec2);
        rl.beginShaderMode(shader);
    }

    pub fn end() void {
        rl.endShaderMode();
    }
};
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
        .alloc = self.alloc,
        .x = self.x + x,
        .y = self.y + y,
        .max_width = options.width,
        .max_height = options.height,
        .text_style = self.text_style,
    };
    if (options.child) |f| {
        if (options.border_radius > 0 and options.overflow == .hidden) {
            const texture = rl.RenderTexture2D.init(
                @intFromFloat(new_ctx.max_width),
                @intFromFloat(new_ctx.max_height),
            );
            rl.beginTextureMode(texture);
            rl.clearBackground(rl.Color.init(0, 0, 0, 0));
            new_ctx.x = 0;
            new_ctx.y = 0;
            f(&new_ctx);
            rl.endTextureMode();

            rounded_shader.begin(options.border_radius * 1.3, new_ctx.max_width, new_ctx.max_height);
            rl.drawTexturePro(
                texture.texture,
                .{
                    .x = 0,
                    .y = 0,
                    .width = new_ctx.max_width,
                    .height = -new_ctx.max_height,
                },
                .{
                    .x = self.x + x,
                    .y = self.y + y,
                    .width = new_ctx.max_width,
                    .height = new_ctx.max_height,
                },
                rl.Vector2.zero(),
                0,
                rl.Color.white,
            );
            rounded_shader.end();
            // texture.unload();
        } else {
            f(&new_ctx);
        }
    }
}

pub inline fn text(
    self: *const Self,
    options: Text.Options,
) void {
    return Text.render(
        self.alloc,
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
