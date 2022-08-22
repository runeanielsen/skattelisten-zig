const std = @import("std");
const io = std.io;
const fs = std.fs;
const mem = std.mem;
const json = std.json;
const fmt = std.fmt;

const Company = struct {
    csv: []const u8,
    name: []const u8,
    se: []const u8,
    income_year: []const u8,
    company_type: []const u8,
    taxable_income: u64,
    deficit: u64,
    corporate_tax: u64,
};

fn csvLineToCompany(line: []const u8) Company {
    var row_columns = mem.split(u8, line, ",");

    const csv = row_columns.next() orelse "";
    const name = row_columns.next() orelse "";
    const se = row_columns.next() orelse "";
    const income_year = row_columns.next() orelse "";
    _ = row_columns.next(); // Skip 5
    const company_type = row_columns.next() orelse "";
    _ = row_columns.next(); // Skip 7
    _ = row_columns.next(); // Skip 8
    const taxable_income = fmt.parseUnsigned(u64, row_columns.next() orelse "0", 10) catch 0;
    const deficit = fmt.parseUnsigned(u64, row_columns.next() orelse "0", 10) catch 0;
    const corporate_tax = fmt.parseUnsigned(u64, row_columns.next() orelse "0", 10) catch 0;

    return Company{
        .csv = csv,
        .name = name,
        .se = se,
        .income_year = income_year,
        .company_type = company_type,
        .taxable_income = taxable_income,
        .deficit = deficit,
        .corporate_tax = corporate_tax,
    };
}

pub fn main() anyerror!void {
    const input_f_name = "";
    const output_f_name = "";

    const input_file = try fs.openFileAbsolute(input_f_name, fs.File.OpenFlags{});
    defer input_file.close();
    const in_stream = io.bufferedReader(input_file.reader()).reader();

    const output_file = try fs.createFileAbsolute(output_f_name, fs.File.CreateFlags{});
    defer output_file.close();
    var buf_writer = io.bufferedWriter(output_file.writer());
    const out_stream = buf_writer.writer();

    var buf_line_reader: [512]u8 = undefined;
    _ = try in_stream.readUntilDelimiterOrEof(&buf_line_reader, '\n'); // Skip CSV header.
    while (try in_stream.readUntilDelimiterOrEof(&buf_line_reader, '\n')) |line| {
        try json.stringify(csvLineToCompany(line), .{}, out_stream);
        _ = try out_stream.write("\n");
    }
    try buf_writer.flush();
}
