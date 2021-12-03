const std = @import("std");

/// Run the solution for Day 01.
pub fn solution() !u32 {
    const file: std.fs.File = try std.fs.cwd().openFile(
        "input/day01",
        .{ .read = true },
    );
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var counter: u32 = 0;
    var prev: u32 = 0;
    var current: u32 = 0;
    var buf: [1024]u8 = undefined;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        // Discard empty lines
        if (line.len > 0) {
            if (std.fmt.parseInt(u32, line, 10)) |parsed| {
                // Step 1: Retain our old 'current' value.
                const old = current;

                // Step 2: Update our current/prev values.
                current = parsed;
                prev = old;

                // Step 3: Check for an increase from prev -> current.
                if (current > prev) {
                    counter = counter + 1;
                }
            } else |err| switch (err) {
                // Don't adjust any variables.
                else => std.debug.print("Failed to parse the line", .{}),
            }
        }
    }

    // Account for the first measurement being non-applicable.
    // This is a key requirement of the problem.
    if (counter > 0) {
        counter = counter - 1;
    }

    return counter;
}
