const std = @import("std");
const log = std.log.scoped(.main);

const Sl = @import("saral");
const Window = Sl.Window;
const Context = Sl.Context;
const Color = Sl.Color;
const Rect = Sl.Rect;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    Window.init("Raylib-zig");
    defer Window.deinit();

    Window.run(allocator, struct {
        pub fn render(ctx: *const Context) void {
            ctx.clear(Color.init(200, 200, 255, 255));

            ctx.rect(.{
                .position = Rect.Position.centerd(),
                .width = ctx.max_width / 2,
                .height = ctx.max_height / 4,
                .color = Color.red,
                .child = struct {
                    const positions = [_]Rect.Position{
                        Rect.Position.topLeft(),
                        Rect.Position.topCenter(),
                        Rect.Position.topRight(),
                        Rect.Position.centerLeft(),
                        Rect.Position.centerd(),
                        Rect.Position.centerRight(),
                        Rect.Position.bottomLeft(),
                        Rect.Position.bottomCenter(),
                        Rect.Position.bottomRight(),
                    };
                    const colors = [_]Color{
                        Color.yellow,
                        Color.magenta,
                        Color.lime,
                        Color.blue,
                        Color.purple,
                        Color.orange,
                        Color.brown,
                        Color.white,
                        Color.init(0, 0, 0, 100),
                    };
                    pub fn render(ctx1: *const Context) void {
                        for (positions, colors) |position, color| {
                            ctx1.rect(.{
                                .width = ctx1.max_width / 3,
                                .height = ctx1.max_height / 3,
                                .position = position,
                                .color = color,
                            });
                        }

                        ctx1.rect(.{
                            .width = ctx1.max_width / 2,
                            .height = ctx1.max_height / 2,
                            .position = Rect.Position.centerd(),
                            .color = Color.init(0, 0, 0, 100),
                        });

                        ctx1.text(.{
                            .text = "Hello World! Hello, World!! even more stuff so that I can test the wrap feature",
                            .size = 80,
                            .color = Color.black,
                            .alignment = .left,
                            .wrap = .character,
                        });
                    }
                }.render,
            });
        }
    }.render);
}
