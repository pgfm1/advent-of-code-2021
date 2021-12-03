const std = @import("std");

const day01 = @import("day01.zig");

pub fn main() anyerror!void {
    // TODO: Allow for selecting the day with CLI args.
    const day01_part1_solution = try day01.solvePart1ForFile("input/day01");
    std.debug.print("Solution for Day 01, Part 1: {d}\n", .{day01_part1_solution});
    const day01_part2_solution = try day01.solvePart2ForFile("input/day01");
    std.debug.print("Solution for Day 01, Part 2: {d}\n", .{day01_part2_solution});
}

test "day01, part 1" {
    const part1 = try day01.solvePart1ForFile("input/day01");
    try std.testing.expectEqual(part1, 1374);
}

test "day02, part 2" {
    const part2 = try day01.solvePart2ForFile("input/day01");
    try std.testing.expectEqual(part2, 1418);
}
