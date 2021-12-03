const std = @import("std");
const ArrayList = std.ArrayList;

/// Calculate the Part 1 solution based on some list of integers.
pub fn solvePart1(integers: ArrayList(u32)) !u32 {
    var counter: u32 = 0;
    var prev: u32 = 0;
    var current: u32 = 0;
    for (integers.items) |value| {
        // Step 1: Retain our old 'current' value.
        const old = current;

        // Step 2: Update our current/prev values.
        current = value;
        prev = old;

        // Step 3: Check for an increase from prev -> current.
        if (current > prev) {
            counter = counter + 1;
        }
    }

    // Account for the first measurement being non-applicable.
    // This is a key requirement of the problem.
    if (counter > 0) {
        counter = counter - 1;
    }

    return counter;
}

/// Calculate the Part 2 solution based on some list of integers.
pub fn solvePart2(integers: ArrayList(u32)) !u32 {
    // We need to maintain two sliding windows. This is the total size that
    // accounts for both windows.
    const sz: u32 = 4;

    // This is a fixed-size rotating array.
    var windows: [sz]u32 = [sz]u32{ 0, 0, 0, 0 };

    // Used to track our initial population of windows.
    var counter: u32 = 0;

    // Used to track the first index of the first window.
    var w1: u32 = 0;

    // Counts the number of increases across windows that we see.
    var window_increases: u32 = 0;

    for (integers.items) |value| {
        if (counter < sz) {
            // We haven't populated 2 full windows yet.
            windows[counter] = value;
            counter = counter + 1;

            // Special case: the first populated windows must be calculated
            // here:
            if (counter == sz) {
                const first_sum = windows[0] + windows[1] + windows[2];
                std.debug.print("\n{d} (initial)\n", .{first_sum});
                if (evaluateWindows(windows, w1)) {
                    window_increases = window_increases + 1;
                }
            }
        } else {
            // Set the last value to be our current value, then increment our
            // "first window" index to rotate our array.
            windows[w1] = value;
            w1 = w1 + 1;

            // Ensure that w1 (index to the first window) is properly-rotated,
            // wrapping around the end.
            if (w1 > (sz - 1)) {
                w1 = w1 - sz;
            }

            // Calculate the updated windows:
            if (evaluateWindows(windows, w1)) {
                window_increases = window_increases + 1;
            }
        }
    }

    return window_increases;
}

/// Returns 'true' if the second window is greater than the first. Returns 
/// 'false' otherwise.
fn evaluateWindows(w: [4]u32, w1: u32) bool {
    const w1_sum: u32 =
        w[calculateIndex(w1, 4)] +
        w[calculateIndex(w1 + 1, 4)] +
        w[calculateIndex(w1 + 2, 4)];
    const w2_sum: u32 =
        w[calculateIndex(w1 + 3, 4)] +
        w[calculateIndex(w1 + 2, 4)] +
        w[calculateIndex(w1 + 1, 4)];

    //if (w2_sum > w1_sum) {
    //    std.debug.print("{d} (increased)\n", .{w2_sum});
    //} else if (w2_sum == w1_sum) {
    //    std.debug.print("{d} (no change)\n", .{w2_sum});
    //} else {
    //    std.debug.print("{d} (decreased)\n", .{w2_sum});
    //}

    return w2_sum > w1_sum;
}

/// Given some index and some maximum size, calculate the adjusted index.
fn calculateIndex(raw: u32, max_sz: u32) u32 {
    return raw % max_sz;
}

/// Calculate the solution for Day 01, Part 1, given some input file.
pub fn solvePart1ForFile(comptime file_name: []const u8) !u32 {
    const integers: ArrayList(u32) = try fileToInts(file_name);
    defer integers.deinit();
    return solvePart1(integers);
}

/// Calculate the solution for Day 01, Part 2, given some input file.
pub fn solvePart2ForFile(comptime file_name: []const u8) !u32 {
    const integers: ArrayList(u32) = try fileToInts(file_name);
    defer integers.deinit();
    return solvePart2(integers);
}

/// Given a relative path to an input file (e.g. "input/day01"),
/// read the file line-by-line into an ArrayList(u32).
/// Empty lines are ignored, and errors are reported but non-breaking.
fn fileToInts(comptime input: []const u8) !std.ArrayList(u32) {
    var list = std.ArrayList(u32).init(std.heap.page_allocator);
    const file: std.fs.File = try std.fs.cwd().openFile(
        input,
        .{ .read = true },
    );
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    var buf: [1024]u8 = undefined;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        // Discard empty lines
        if (line.len > 0) {
            if (std.fmt.parseInt(u32, line, 10)) |parsed| {
                try list.append(parsed);
            } else |err| switch (err) {
                // Don't adjust any variables.
                else => std.debug.print("Failed to parse a line as an integer (32-bit): '{s}'", .{line}),
            }
        }
    }
    return list;
}

test "part 1, provided example" {
    var integers = ArrayList(u32).init(std.testing.allocator);
    defer integers.deinit();
    try integers.append(199);
    try integers.append(200);
    try integers.append(208);
    try integers.append(210);
    try integers.append(200);
    try integers.append(207);
    try integers.append(240);
    try integers.append(269);
    try integers.append(260);
    try integers.append(263);
    const part1 = try solvePart1(integers);
    try std.testing.expectEqual(part1, 7);
}

test "part 2, provided example" {
    var integers = ArrayList(u32).init(std.testing.allocator);
    defer integers.deinit();
    try integers.append(199);
    try integers.append(200);
    try integers.append(208);
    try integers.append(210);
    try integers.append(200);
    try integers.append(207);
    try integers.append(240);
    try integers.append(269);
    try integers.append(260);
    try integers.append(263);
    const part2 = try solvePart2(integers);
    try std.testing.expectEqual(part2, 5);
}
