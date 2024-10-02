const std = @import("std");
const log = std.log.scoped(.@"saral/text");
const rl = @import("raylib");
const Color = rl.Color;

pub const Options = struct {
    text: [*:0]const u8,
    size: f32 = 20,
    wrap: Wrap = .clip,
    alignment: Align = .left,
    color: Color = Color.white,
};

pub inline fn render(
    x: f32,
    y: f32,
    max_width: f32,
    max_height: f32,
    options: *const Options,
    text_style: *const Style,
) void {
    const font = text_style.font.inner;
    const txt = options.text;
    switch (options.wrap) {
        .clip => {
            const text_size = rl.measureTextEx(font, txt, options.size, text_style.spacing);
            const x1 = switch (options.alignment) {
                .left => x,
                .center => x + (max_width / 2) - (text_size.x / 2),
                .right => x + max_width - text_size.x,
            };
            const pos = rl.Vector2.init(x1, y);
            rl.beginScissorMode(
                @intFromFloat(x),
                @intFromFloat(y),
                @intFromFloat(max_width),
                @intFromFloat(max_height),
            );
            rl.drawRectangleLinesEx(.{
                .x = x,
                .y = y,
                .width = max_width,
                .height = max_height,
            }, 0, Color.red);
            rl.drawTextEx(font, txt, pos, options.size, text_style.spacing, options.color);
            rl.endScissorMode();
        },
        else => {
            log.info("UnImplemented text wrap mode {}", .{options.wrap});
        },
    }
}

pub const Wrap = enum {
    clip,
    character,
    word,
};

pub const Align = enum {
    left,
    center,
    right,
};

pub const Style = struct {
    font: Font = undefined,
    spacing: f32 = 0,

    pub fn default() Style {
        return .{
            .font = Font.init(geist.regular, 144),
            .spacing = 0,
        };
    }
};

pub const Font = struct {
    inner: rl.Font,

    pub fn init(font_data: []const u8, size: i32) Font {
        var font = rl.Font.fromMemory(".ttf", font_data, size, null);
        rl.genTextureMipmaps(&font.texture);
        rl.setTextureFilter(font.texture, rl.TextureFilter.texture_filter_bilinear);
        return .{
            .inner = font,
        };
    }
};

const geist = struct {
    const regular = @embedFile("./assets/fonts/geist/regular.ttf");
};
