const std = @import("std");
const log = std.log.scoped(.main);

const Sl = @import("saral");
const Window = Sl.Window;
const Context = Sl.Context;
const Color = Sl.Color;
const Rect = Sl.Rect;

pub fn main() !void {
    Window.init("Raylib-zig");
    defer Window.deinit();

    Window.run(struct {
        pub fn render(ctx: *const Context) void {
            ctx.clear(Color.black);

            ctx.rect(.{
                .position = Rect.Position.centerd(),
                .width = ctx.max_width / 2,
                .height = ctx.max_height / 4,
                .color = Color.red,
                .child = struct {
                    pub fn render(ctx1: *const Context) void {
                        ctx1.rect(.{
                            .width = ctx1.max_width / 3,
                            .height = ctx1.max_height / 3,
                            .position = Rect.Position.topCenter(),
                            .color = Color.yellow,
                        });
                        ctx1.rect(.{
                            .width = ctx1.max_width / 3,
                            .height = ctx1.max_height / 3,
                            .position = Rect.Position.topRight(),
                            .color = Color.magenta,
                        });
                        ctx1.rect(.{
                            .width = ctx1.max_width / 3,
                            .height = ctx1.max_height / 3,
                            .position = Rect.Position.centerLeft(),
                            .color = Color.lime,
                        });
                        ctx1.rect(.{
                            .width = ctx1.max_width / 3,
                            .height = ctx1.max_height / 3,
                            .position = Rect.Position.centerd(),
                            .color = Color.blue,
                        });
                        ctx1.rect(.{
                            .width = ctx1.max_width / 3,
                            .height = ctx1.max_height / 3,
                            .position = Rect.Position.centerRight(),
                            .color = Color.purple,
                        });
                        ctx1.rect(.{
                            .width = ctx1.max_width / 3,
                            .height = ctx1.max_height / 3,
                            .position = Rect.Position.bottomLeft(),
                            .color = Color.orange,
                        });
                        ctx1.rect(.{
                            .width = ctx1.max_width / 3,
                            .height = ctx1.max_height / 3,
                            .position = Rect.Position.bottomCenter(),
                            .color = Color.brown,
                        });
                        ctx1.rect(.{
                            .width = ctx1.max_width / 3,
                            .height = ctx1.max_height / 3,
                            .position = Rect.Position.bottomRight(),
                            .color = Color.white,
                        });

                        ctx1.rect(.{
                            .width = ctx1.max_width / 2,
                            .height = ctx1.max_height / 2,
                            .position = Rect.Position.centerd(),
                            .color = Color.init(0, 0, 0, 100),
                        });

                        ctx1.text(.{
                            .text = "Hello World!",
                            .size = 80,
                            .color = Color.black,
                        });
                    }
                }.render,
            });
        }
    }.render);
}
