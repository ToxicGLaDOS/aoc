const std = @import("std");
const allocator = std.heap.page_allocator;

const Point = struct {
    x: u32,
    y: u32,

    pub fn equals(self: Point, other: Point) bool {
        return self.x == other.x and self.y == other.y;
    }
};

const Orientation = enum {
    horz,
    vert,
};

const Fold = struct {
    foldPosition: u32,
    orientation: Orientation,
};

// I'm a big fan of this std.ArrayList(Point) syntax for defining a type
// It looks like a function call because it literally is a function call
// see here: https://github.com/ziglang/zig/blob/master/lib/std/array_list.zig#L13
// It's a function that returns a type, sweet!
pub fn contains(list: std.ArrayList(Point), target: Point) bool {
    for (list.items) |item| {
        if (item.equals(target)) {
            return true;
        }
    }
    return false;
}

// Could return an error from `try newList.append(item)` so return type is
// anyerror!std.ArrayList(Point). Which means we have to use try when calling it
pub fn dedupe(list: std.ArrayList(Point)) anyerror!std.ArrayList(Point) {
    var newList = std.ArrayList(Point).init(allocator);

    for (list.items) |item| {
        if (!contains(newList, item)) {
            try newList.append(item);
        }
    }

    return newList;
}

pub fn main() !void {

    var buf = try allocator.alloc(u8, 1024);
    defer allocator.free(buf);

    var file = try std.fs.cwd().openFile("../input/day13.txt", .{});
    defer file.close();
    const reader = std.io.bufferedReader(file.reader()).reader();
    const stdout = std.io.getStdOut().writer();

    var points = std.ArrayList(Point).init(allocator);
    var folds = std.ArrayList(Fold).init(allocator);

    while (try reader.readUntilDelimiterOrEof(buf, '\n')) |line| {
        // Stop when we get to the blank line that seperates points from folds
        if (line.len == 0) {
            break;
        }

        var pointBuf = try allocator.alloc(u8, 10);
        // Initalize pointBuf to 0's
        {
            var index: usize = 0;
            while (index < 10) : (index += 1) {
                pointBuf[index] = 0;
            }
        }

        var x : u32 = undefined; 
        var y : u32 = undefined;
        var xLen: usize = 0;
        var yLen: usize = 0;


        // Reinitalize pointBuf to 0's
        for (line) |character, index| {
            if (character == ',') {
                xLen = index;
                x = try std.fmt.parseInt(u32, pointBuf[0..index], 10);
            }
            else {
                pointBuf[index] = character;
            }
        }

        {
            var index: usize = 0;
            while (index < 10) : (index += 1) {
                pointBuf[index] = 0;
            }
        }

        for (line[xLen+1..]) |character, index| {
            yLen = index + 1;
            pointBuf[index] = character;
        }
        
        y = try std.fmt.parseInt(u32, pointBuf[0..yLen], 10);
        try stdout.print("{d}, {d}\n", .{x, y});
        var point = Point{
            // parseInt doesn't seem to respect null-terminated strings
            // so we have to pass it _exactly_ the buffer that makes the int
            .x = x,
            .y = y,
        };
        try points.append(point);
    }



    while (try reader.readUntilDelimiterOrEof(buf, '\n')) |line| {
        var orientation : Orientation = undefined;
        if (line[11] == 'x') {
            orientation = Orientation.vert;
        }
        else {
            orientation = Orientation.horz;
        }
        var value = try std.fmt.parseInt(u32, line[13..], 10);
        var fold = Fold{
            .foldPosition = value,
            .orientation = orientation,
        };
        try stdout.print("{d}={d}\n", .{fold.orientation, fold.foldPosition});
        try folds.append(fold);
    }


    var fold = folds.items[0];

    if (fold.orientation == Orientation.horz) {
        // It's not :)
    }
    else {
        // See "for reference" test here: https://ziglang.org/documentation/0.9.0/#for
        // for this *point syntax. Without it point is const and can't be assigned to.
        for (points.items) |*point| {
            // This worked for my input, but I realized later that this doesn't actually work :)
            if (point.x < fold.foldPosition){
                point.x = fold.foldPosition + (fold.foldPosition - point.x);
            }
        }
    }

    points = try dedupe(points);

    try stdout.print("Num points: {d}\n", .{points.items.len});

}
