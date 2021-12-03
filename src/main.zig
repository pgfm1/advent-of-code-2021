const std = @import("std");

const day01 = @import("day01.zig");

pub fn main() anyerror!void {
    // TODO: Allow for selecting the day with CLI args.
    const day01_solution = try day01.solution();
    std.debug.print("Solution for Day 01, Part 1: {d}", .{day01_solution});
}

test "day01, part01" {
    const day01_solution = try day01.solution();
    try std.testing.expectEqual(day01_solution, 1374);
}
