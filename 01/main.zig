const std = @import("std");

const print = std.debug.print;

// NOTE: This is stupid, but I don't know enough about zig to make it better
// nor do I care to find out right now...
const realDigits = [9]u8{ 1, 2, 3, 4, 5, 6, 7, 8, 9 };

const digits = [9][]const u8{ "1", "2", "3", "4", "5", "6", "7", "8", "9" };
const words = [9][]const u8{ "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" };

fn wordToDigit(index: usize) u8 {
    return realDigits[index];
}

pub fn solve01() !u32 {
    const file = try std.fs.cwd().openFile("01/input", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    var buf: [1024]u8 = undefined;

    var result: u32 = 0;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const first: u8 = blk: {
            var foundIndex: usize = line.len - 1;
            var foundDigit: u8 = 0;

            for (digits, 0..) |digit, digitIndex| {
                if (std.mem.indexOf(u8, line, digit)) |position| {
                    if (position <= foundIndex) {
                        foundIndex = position;
                        foundDigit = wordToDigit(digitIndex);
                    }
                }
            }

            break :blk foundDigit;
        };

        const second: u8 = blk: {
            var foundIndex: usize = 0;
            var foundDigit: u8 = 0;

            for (digits, 0..) |digit, digitIndex| {
                if (std.mem.lastIndexOf(u8, line, digit)) |position| {
                    if (position >= foundIndex) {
                        foundIndex = position;
                        foundDigit = wordToDigit(digitIndex);
                    }
                }
            }

            break :blk foundDigit;
        };

        const number = (first * 10) + second;

        result += number;
    }

    return result;
}

pub fn solve02() !u32 {
    const file = try std.fs.cwd().openFile("01/input", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    var buf: [1024]u8 = undefined;

    var result: u32 = 0;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const first: u8 = blk: {
            var foundIndex: usize = line.len - 1;
            var foundDigit: u8 = 0;

            for (digits, 0..) |digit, digitIndex| {
                if (std.mem.indexOf(u8, line, digit)) |position| {
                    if (position <= foundIndex) {
                        foundIndex = position;
                        foundDigit = wordToDigit(digitIndex);
                    }
                }
            }

            for (words, 0..) |word, wordIndex| {
                if (std.mem.indexOf(u8, line, word)) |position| {
                    if (position < foundIndex) {
                        foundIndex = position;
                        foundDigit = wordToDigit(wordIndex);
                    }
                }
            }

            break :blk foundDigit;
        };

        const second: u8 = blk: {
            var foundIndex: usize = 0;
            var foundDigit: u8 = 0;

            for (digits, 0..) |digit, digitIndex| {
                if (std.mem.lastIndexOf(u8, line, digit)) |position| {
                    if (position >= foundIndex) {
                        foundIndex = position;
                        foundDigit = wordToDigit(digitIndex);
                    }
                }
            }

            for (words, 0..) |word, wordIndex| {
                if (std.mem.lastIndexOf(u8, line, word)) |position| {
                    if (position > foundIndex) {
                        foundIndex = position;
                        foundDigit = wordToDigit(wordIndex);
                    }
                }
            }

            break :blk foundDigit;
        };

        const number = (first * 10) + second;

        result += number;
    }

    return result;
}

pub fn main() !void {
    const part1 = try solve01();
    const part2 = try solve02();

    print("Part 1: {}\nPart 2: {}\n", .{ part1, part2 });
}
