const std = @import("std");

const Company = struct {
    csv: []const u8,
    name: []const u8,
    se: []const u8,
    income_year: []const u8,
    company_type: []const u8,
    taxable_income: []const u8,
    deficit: []const u8,
    corporate_tax: []const u8,
};

fn csvLineToCompany(line: []const u8) Company {
    var row_columns = std.mem.split(u8, line, ";");
    const csv = row_columns.next() orelse "";
    const name = row_columns.next() orelse "";
    const se = row_columns.next() orelse "";
    const income_year = row_columns.next() orelse "";
    _ = row_columns.next(); // Skip 5
    const company_type = row_columns.next() orelse "";
    _ = row_columns.next(); // Skip 7
    _ = row_columns.next(); // Skip 8
    const taxable_income = row_columns.next() orelse "";
    const deficit = row_columns.next() orelse "";
    const corporate_tax = row_columns.next() orelse "";

    const company = Company{
        .csv = csv,
        .name = name,
        .se = se,
        .income_year = income_year,
        .company_type = company_type,
        .taxable_income = taxable_income,
        .deficit = deficit,
        .corporate_tax = corporate_tax,
    };

    return company;
}

pub fn main() anyerror!void {
    const input_file_name = "";
    const output_file_name = "";

    const input_file = try std.fs.cwd().openFile(input_file_name, std.fs.File.OpenFlags{});
    defer input_file.close();
    var buf_reader = std.io.bufferedReader(input_file.reader());
    var in_stream = buf_reader.reader();

    const output_file = try std.fs.cwd().createFile(output_file_name, std.fs.File.CreateFlags{});
    defer output_file.close();
    var buf_writer = std.io.bufferedWriter(output_file.writer());
    const out_stream = buf_writer.writer();

    var buf_string: [512]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buf_string);
    var string = std.ArrayList(u8).init(fba.allocator());

    _ = try in_stream.readUntilDelimiterOrEof(&buf_string, '\n'); // Skip first line
    var buf_line_reader: [512]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf_line_reader, '\n')) |line| {
        // do something with line...
        try std.json.stringify(csvLineToCompany(line), .{}, string.writer());
        try string.append('\n');
        _ = try out_stream.write(string.items);
        string.clearRetainingCapacity();
    }
}
