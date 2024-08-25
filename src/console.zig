const std = @import("std");

pub const Color = enum(u8) {
    Black,
    Red,
    Green,
    Yellow,
    Blue,
    Magenta,
    Cyan,
    White,
    // Use terminal defaults
    Default,
};

pub const Style = enum(u8) {
    Bold,
    Italic,
    Underline,
    Blink,
    FastBlink,
    Reverse, // Invert the foreground and background colors
    Hide,
    Strike,
};

pub const TextStyle = struct {
    fg_color: ?Color = null,
    bg_color: ?Color = null,
    bold: bool = false,
    italic: bool = false,
    underline: bool = false,
    blink: bool = false,
    fastblink: bool = false,
    reverse: bool = false,
    hide: bool = false,
    strike: bool = false,
};

// ANSI terminal escape character
pub const ansi = [1]u8{0x1b};

// ANSI Reset command (clear formatting)
pub const ansi_end = ansi ++ "[m";

// ANSI cursor movements
pub const move_up = ansi ++ "[{d}A";
pub const move_down = ansi ++ "[{d}B";
pub const move_right = ansi ++ "[{d}C";
pub const move_left = ansi ++ "[{d}D";
pub const move_setcol = ansi ++ "[{d}G";
pub const move_home = ansi ++ "[0G";

pub const set_col = ansi ++ "[{d}G";
pub const set_row_col = ansi ++ "[{d};{d}H"; // Row, Column

pub const save_position = ansi ++ "[s";
pub const restore_position = ansi ++ "[u";

// ANSI Clear Screen Command
pub const clear_screen_end = ansi ++ "[0J"; // Clear from cursor to end of screen
pub const clear_screen_beg = ansi ++ "[1J"; // Clear from cursor to beginning of screen
pub const clear_screen = ansi ++ "[2J"; // Clear entire screen

// ANSI Clear Line Command
pub const clear_line_end = ansi ++ "[0K"; // Clear from cursor to end of line
pub const clear_line_beg = ansi ++ "[1K"; // Clear from cursor to beginning of line
pub const clear_line = ansi ++ "[2K"; // Clear entire line

// ====================================================
// ANSI display codes (colors, styles, etc.)
// ----------------------------------------------------

// Basic Background Colors
pub const bg_black = ansi ++ "[40m";
pub const bg_red = ansi ++ "[41m";
pub const bg_green = ansi ++ "[42m";
pub const bg_yellow = ansi ++ "[43m";
pub const bg_blue = ansi ++ "[44m";
pub const bg_magenta = ansi ++ "[45m";
pub const bg_cyan = ansi ++ "[46m";
pub const bg_white = ansi ++ "[47m";
pub const bg_default = ansi ++ "[49m";

// Basic Foreground Colors
pub const fg_black = ansi ++ "[30m";
pub const fg_red = ansi ++ "[31m";
pub const fg_green = ansi ++ "[32m";
pub const fg_yellow = ansi ++ "[33m";
pub const fg_blue = ansi ++ "[34m";
pub const fg_magenta = ansi ++ "[35m";
pub const fg_cyan = ansi ++ "[36m";
pub const fg_white = ansi ++ "[37m";
pub const fg_default = ansi ++ "[39m";

// Full 24-Bit RGB Coloring
// Format strings which take 3 u8's for (r, g, b)
pub const fg_rgb = ansi ++ "[38;2;{d};{d};{d}m";
pub const bg_rgb = ansi ++ "[48;2;{d};{d};{d}m";

// Typeface Formatting
pub const text_bold = ansi ++ "[1m";
pub const text_italic = ansi ++ "[3m";
pub const text_underline = ansi ++ "[4m";
pub const text_blink = ansi ++ "[5m";
pub const text_fastblink = ansi ++ "[6m";
pub const text_reverse = ansi ++ "[7m";
pub const text_hide = ansi ++ "[8m";
pub const text_strike = ansi ++ "[9m";

pub const end_bold = ansi ++ "[22m";
pub const end_italic = ansi ++ "[23m";
pub const end_underline = ansi ++ "[24m";
pub const end_blink = ansi ++ "[25m";
pub const end_reverse = ansi ++ "[27m";
pub const end_hide = ansi ++ "[28m";
pub const end_strike = ansi ++ "[29m";

pub fn getFgColor(color: Color) []const u8 {
    return switch (color) {
        .Black => fg_black,
        .Red => fg_red,
        .Green => fg_green,
        .Yellow => fg_yellow,
        .Blue => fg_blue,
        .Cyan => fg_cyan,
        .White => fg_white,
        .Magenta => fg_magenta,
        .Default => fg_default,
    };
}

pub fn getBgColor(color: Color) []const u8 {
    return switch (color) {
        .Black => bg_black,
        .Red => bg_red,
        .Green => bg_green,
        .Yellow => bg_yellow,
        .Blue => bg_blue,
        .Cyan => bg_cyan,
        .White => bg_white,
        .Magenta => bg_magenta,
        .Default => bg_default,
    };
}

/// Configure the terminal to start printing with the given foreground color
pub fn startFgColor(stream: anytype, color: Color) void {
    stream.print("{s}", .{getFgColor(color)}) catch unreachable;
}

/// Configure the terminal to start printing with the given background color
pub fn startBgColor(stream: anytype, color: Color) void {
    stream.print("{s}", .{getBgColor(color)}) catch unreachable;
}

/// Configure the terminal to start printing with the given (single) style
pub fn startStyle(stream: anytype, style: Style) void {
    switch (style) {
        .Bold => stream.print(text_bold, .{}) catch unreachable,
        .Italic => stream.print(text_italic, .{}) catch unreachable,
        .Underline => stream.print(text_underline, .{}) catch unreachable,
        .Blink => stream.print(text_blink, .{}) catch unreachable,
        .FastBlink => stream.print(text_fastblink, .{}) catch unreachable,
        .Reverse => stream.print(text_reverse, .{}) catch unreachable,
        .Hide => stream.print(text_hide, .{}) catch unreachable,
        .Strike => stream.print(text_strike, .{}) catch unreachable,
    }
}

/// Configure the terminal to start printing one or more styles with color
pub fn startStyles(stream: anytype, style: TextStyle) void {
    if (style.bold) stream.print(text_bold, .{}) catch unreachable;
    if (style.italic) stream.print(text_italic, .{}) catch unreachable;
    if (style.underline) stream.print(text_underline, .{}) catch unreachable;
    if (style.blink) stream.print(text_blink, .{}) catch unreachable;
    if (style.fastblink) stream.print(text_fastblink, .{}) catch unreachable;
    if (style.reverse) stream.print(text_reverse, .{}) catch unreachable;
    if (style.hide) stream.print(text_hide, .{}) catch unreachable;
    if (style.strike) stream.print(text_strike, .{}) catch unreachable;

    if (style.fg_color) |fg_color| {
        startFgColor(stream, fg_color);
    }

    if (style.bg_color) |bg_color| {
        startBgColor(stream, bg_color);
    }
}

/// Reset all style in the terminal
pub fn resetStyle(stream: anytype) void {
    stream.print(ansi_end, .{}) catch unreachable;
}

/// Print the text using the given color
pub fn printColor(stream: anytype, color: Color, comptime fmt: []const u8, args: anytype) void {
    startFgColor(stream, color);
    stream.print(fmt, args) catch unreachable;
    resetStyle(stream);
}

/// Print the text using the given style description
pub fn printStyled(stream: anytype, style: TextStyle, comptime fmt: []const u8, args: anytype) void {
    startStyles(stream, style);
    stream.print(fmt, args) catch unreachable;
    resetStyle(stream);
}
