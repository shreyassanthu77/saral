const std = @import("std");
const Allocator = std.mem.Allocator;
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
    alloc: Allocator,
    x: f32,
    y: f32,
    max_width: f32,
    max_height: f32,
    options: *const Options,
    text_style: *const Style,
) void {
    const font = text_style.font.inner;
    const txt = options.text;
    const len = std.mem.len(txt);
    const text_size = rl.measureTextEx(font, txt, options.size, text_style.spacing);
    switch (options.wrap) {
        .none => {
            const x1 = switch (options.alignment) {
                .left => x,
                .center => x + (max_width / 2) - (text_size.x / 2),
                .right => x + max_width - text_size.x,
            };
            const pos = rl.Vector2.init(x1, y);
            rl.drawTextEx(font, txt, pos, options.size, text_style.spacing, options.color);
        },
        .clip => {
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
            rl.drawTextEx(font, txt, pos, options.size, text_style.spacing, options.color);
            rl.endScissorMode();
        },
        .character => {
            const width_per_char = text_size.x / @as(f32, @floatFromInt(len));
            const chars_per_line: usize = @intFromFloat(@floor(max_width / width_per_char) - 1);
            const total_lines: usize = @intFromFloat(@ceil(@as(f32, @floatFromInt(len)) / @as(f32, @floatFromInt(chars_per_line))));

            var line_index: usize = 0;
            while (line_index < total_lines) : (line_index += 1) {
                const start = line_index * chars_per_line;
                const end = @min(start + chars_per_line, len);
                const line = alloc.dupeZ(u8, txt[start..end]) catch unreachable;
                defer alloc.free(line);

                const line_width = @as(f32, @floatFromInt(line.len)) * width_per_char;
                const x1 = switch (options.alignment) {
                    .left => x,
                    .center => x + (max_width / 2) - (line_width / 2),
                    .right => x + max_width - line_width,
                };
                const y1 = y + @as(f32, @floatFromInt(line_index)) * text_size.y;
                if (y1 + text_size.y > y + max_height) {
                    break;
                }
                const pos = rl.Vector2.init(x1, y1);

                rl.drawTextEx(font, line.ptr, pos, options.size, text_style.spacing, options.color);
            }
        },
        else => {
            log.info("UnImplemented text wrap mode {}", .{options.wrap});
        },
    }
}

pub const Wrap = enum {
    none,
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
