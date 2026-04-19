const std = @import("std");
const definitions = @import("definitions");

// Prism js.zig
// (c) Connor J. Link. All Rights Reserved.

pub const UnaryOperator = enum {
    Negative,
    Positive,
    LogicalNot,
    Subscript,
    PrefixIncrement,
    PrefixDecrement,
    PostfixIncrement,
    PostfixDecrement,
};

pub const BinaryOperator = enum {
    Add,
    Subtract,
    Multiply,
    Divide,
    Remainder,
    Exponentiation,
    LeftShift,
    RightShift,
    ZeroFillRightShift,
    BitwiseAnd,
    BitwiseOr,
    BitwiseXor,
    LogicalAnd,
    LogicalOr,
    NullishCoalescing,

    Assignment,
    AdditionAssignment,
    SubtractionAssignment,
    MultiplicationAssignment,
    DivisionAssignment,
    RemainderAssignment,
    ExponentiationAssignment,
    LeftShiftAssignment,
    RightShiftAssignment,
    ZeroFillRightShiftAssignment,
    BitwiseAndAssignment,
    BitwiseOrAssignment,
    BitwiseXorAssignment,
    LogicalAndAssignment,
    LogicalOrAssignment,
    NullishCoalescingAssignment,

    Equality,
    Inequality,
    StrictEquality,
    StrictInequality,
    GreaterThan,
    GreaterThanOrEqual,
    LessThan,
    LessThanOrEqual,
};

pub fn parseBinaryOperator(s: []const u8) ?BinaryOperator {
    return parseBinaryOperatorManual(s);
}

fn parseBinaryOperatorManual(s: []const u8) ?BinaryOperator {
    // TODO: optimize this with a manual trie using first-character switch and rest comparisons
    if (std.mem.eql(u8, s, "+")) return .Add;
    if (std.mem.eql(u8, s, "-")) return .Subtract;
    if (std.mem.eql(u8, s, "*")) return .Multiply;
    if (std.mem.eql(u8, s, "/")) return .Divide;
    if (std.mem.eql(u8, s, "%")) return .Remainder;
    if (std.mem.eql(u8, s, "**")) return .Exponentiation;
    if (std.mem.eql(u8, s, "<<")) return .LeftShift;
    if (std.mem.eql(u8, s, ">>")) return .RightShift;
    if (std.mem.eql(u8, s, ">>>")) return .ZeroFillRightShift;
    if (std.mem.eql(u8, s, "&")) return .BitwiseAnd;
    if (std.mem.eql(u8, s, "|")) return .BitwiseOr;
    if (std.mem.eql(u8, s, "^")) return .BitwiseXor;
    if (std.mem.eql(u8, s, "&&")) return .LogicalAnd;
    if (std.mem.eql(u8, s, "||")) return .LogicalOr;
    if (std.mem.eql(u8, s, "??")) return .NullishCoalescing;
    if (std.mem.eql(u8, s, "=")) return .Assignment;
    if (std.mem.eql(u8, s, "+=")) return .AdditionAssignment;
    if (std.mem.eql(u8, s, "-=")) return .SubtractionAssignment;
    if (std.mem.eql(u8, s, "*=")) return .MultiplicationAssignment;
    if (std.mem.eql(u8, s, "/=")) return .DivisionAssignment;
    if (std.mem.eql(u8, s, "%=")) return .RemainderAssignment;
    if (std.mem.eql(u8, s, "**=")) return .ExponentiationAssignment;
    if (std.mem.eql(u8, s, "<<=")) return .LeftShiftAssignment;
    if (std.mem.eql(u8, s, ">>=")) return .RightShiftAssignment;
    if (std.mem.eql(u8, s, ">>>=")) return .ZeroFillRightShiftAssignment;
    if (std.mem.eql(u8, s, "&=")) return .BitwiseAndAssignment;
    if (std.mem.eql(u8, s, "|=")) return .BitwiseOrAssignment;
    if (std.mem.eql(u8, s, "^=")) return .BitwiseXorAssignment;
    if (std.mem.eql(u8, s, "&&=")) return .LogicalAndAssignment;
    if (std.mem.eql(u8, s, "||=")) return .LogicalOrAssignment;
    if (std.mem.eql(u8, s, "??=")) return .NullishCoalescingAssignment;
    if (std.mem.eql(u8, s, "==")) return .Equality;
    if (std.mem.eql(u8, s, "!=")) return .Inequality;
    if (std.mem.eql(u8, s, "===")) return .StrictEquality;
    if (std.mem.eql(u8, s, "!==")) return .StrictInequality;
    if (std.mem.eql(u8, s, ">")) return .GreaterThan;
    if (std.mem.eql(u8, s, ">=")) return .GreaterThanOrEqual;
    if (std.mem.eql(u8, s, "<")) return .LessThan;
    if (std.mem.eql(u8, s, "<=")) return .LessThanOrEqual;
    return null;
}

pub const Operator = union(enum) {
    Unary: UnaryOperator,
    Binary: BinaryOperator,
};

pub const TokenKind = enum {
    Identifier,
    Number,
    String,
    Boolean,
    Null,
    Keyword,
    Operator,
    Punctuation,
};

pub const Token = struct {
    kind: TokenKind,
    lexeme: []const u8,
    number: f64 = 0,
    boolean: bool = false,
    operator: ?Operator = null,
    punct: u8 = 0,
};

pub const ProgramNode = struct {
    statements: []const *ASTNode,
};

pub const VariableDeclarationNode = struct {
    name: []const u8,
    initializer: ?*ASTNode,
    is_const: bool,
};

pub const FunctionDeclarationNode = struct {
    name: []const u8,
    parameters: []const []const u8,
    body: *ASTNode,
};

pub const ExpressionStatementNode = struct {
    expression: *ASTNode,
};

pub const UnaryExpressionNode = struct {
    operator: UnaryOperator,
    operand: *ASTNode,
};

pub const BinaryExpressionNode = struct {
    operator: BinaryOperator,
    left: *ASTNode,
    right: *ASTNode,
};

pub const IdentifierNode = struct {
    name: []const u8,
};

pub const LiteralNode = struct {
    value: *JSValue,
};

pub const ASTNode = union(enum) {
    Program: ProgramNode,
    VariableDeclaration: VariableDeclarationNode,
    FunctionDeclaration: FunctionDeclarationNode,
    ExpressionStatement: ExpressionStatementNode,
    UnaryExpression: UnaryExpressionNode,
    BinaryExpression: BinaryExpressionNode,
    Identifier: IdentifierNode,
    Literal: LiteralNode,
    NullStatement,
};

pub const JSFunction = struct {
    parameters: []const []const u8,
    body: *ASTNode,
};

pub const JSValue = union(enum) {
    Number: f64,
    String: []const u8,
    Boolean: bool,
    Object: std.StringHashMap(*JSValue),
    Array: std.ArrayList(*JSValue),
    Function: JSFunction,
    Void,
};

pub const JSInterpreterContext = struct {
    variables: std.StringHashMap(*JSValue),
    functions: std.StringHashMap(FunctionDeclarationNode),
};

pub const JSInterpreter = struct {
    allocator: std.mem.Allocator,
    context: JSInterpreterContext,

    pub fn init(allocator: std.mem.Allocator) JSInterpreter {
        return .{
            .allocator = allocator,
            .context = .{
                .variables = std.StringHashMap(*JSValue).init(allocator),
                .functions = std.StringHashMap(FunctionDeclarationNode).init(allocator),
            },
        };
    }

    pub fn deinit(self: *JSInterpreter) void {
        self.context.variables.deinit();
        self.context.functions.deinit();
    }

    pub fn lex(self: *JSInterpreter, source: []const u8) ![]Token {
        var tokens = std.ArrayList(Token).init(self.allocator);
        var i: usize = 0;

        while (i < source.len) {
            const c = source[i];

            if (std.ascii.isWhitespace(c)) {
                i += 1;
                continue;
            }

            if (std.ascii.isDigit(c)) {
                const start = i;
                var has_dot = false;
                while (i < source.len) : (i += 1) {
                    const ch = source[i];
                    if (std.ascii.isDigit(ch)) continue;
                    if (!has_dot and ch == '.') {
                        has_dot = true;
                        continue;
                    }
                    break;
                }
                const number_str = source[start..i];
                const number = std.fmt.parseFloat(f64, number_str) catch {
                    _ = try definitions.writeError("Error: invalid number '{s}'\n", .{number_str});
                    continue;
                };
                try tokens.append(.{
                    .kind = .Number,
                    .lexeme = number_str,
                    .number = number,
                });
                continue;
            }

            if (std.ascii.isAlphabetic(c) or c == '_') {
                const start = i;
                while (i < source.len and (std.ascii.isAlphanumeric(source[i]) or source[i] == '_')) : (i += 1) {}
                const ident = source[start..i];

                if (std.mem.eql(u8, ident, "true")) {
                    try tokens.append(.{ .kind = .Boolean, .lexeme = ident, .boolean = true });
                } else if (std.mem.eql(u8, ident, "false")) {
                    try tokens.append(.{ .kind = .Boolean, .lexeme = ident, .boolean = false });
                } else if (std.mem.eql(u8, ident, "null")) {
                    try tokens.append(.{ .kind = .Null, .lexeme = ident });
                } else if (std.mem.eql(u8, ident, "var") or std.mem.eql(u8, ident, "let") or std.mem.eql(u8, ident, "const") or
                    std.mem.eql(u8, ident, "function") or std.mem.eql(u8, ident, "if") or std.mem.eql(u8, ident, "else") or
                    std.mem.eql(u8, ident, "while") or std.mem.eql(u8, ident, "for") or std.mem.eql(u8, ident, "return"))
                {
                    try tokens.append(.{ .kind = .Keyword, .lexeme = ident });
                } else {
                    try tokens.append(.{ .kind = .Identifier, .lexeme = ident });
                }
                continue;
            }

            if (c == '"' or c == '\'') {
                const quote = c;
                i += 1;

                var sb = std.ArrayList(u8).init(self.allocator);
                defer sb.deinit();

                while (i < source.len and source[i] != quote) : (i += 1) {
                    if (source[i] == '\\' and i + 1 < source.len) {
                        i += 1;
                        switch (source[i]) {
                            'n' => try sb.append('\n'),
                            't' => try sb.append('\t'),
                            '\\' => try sb.append('\\'),
                            '"' => try sb.append('"'),
                            '\'' => try sb.append('\''),
                            else => try sb.append(source[i]),
                        }
                    } else {
                        try sb.append(source[i]);
                    }
                }
                if (i < source.len and source[i] == quote) i += 1;

                const owned = try self.allocator.dupe(u8, sb.items);
                try tokens.append(.{ .kind = .String, .lexeme = owned });
                continue;
            }

            if (i + 3 <= source.len) {
                const s3 = source[i .. i + 3];
                if (parseBinaryOperatorManual(s3)) |op| {
                    try tokens.append(.{
                        .kind = .Operator,
                        .lexeme = s3,
                        .operator = .{ .Binary = op },
                    });
                    i += 3;
                    continue;
                }
            }

            if (i + 2 <= source.len) {
                const s2 = source[i .. i + 2];
                if (parseBinaryOperatorManual(s2)) |op| {
                    try tokens.append(.{
                        .kind = .Operator,
                        .lexeme = s2,
                        .operator = .{ .Binary = op },
                    });
                    i += 2;
                    continue;
                }
            }

            {
                const s1 = source[i .. i + 1];
                if (parseBinaryOperatorManual(s1)) |op| {
                    try tokens.append(.{
                        .kind = .Operator,
                        .lexeme = s1,
                        .operator = .{ .Binary = op },
                    });
                    i += 1;
                    continue;
                }
            }

            switch (c) {
                '!' => {
                    try tokens.append(.{
                        .kind = .Operator,
                        .lexeme = "!",
                        .operator = .{ .Unary = .LogicalNot },
                    });
                    i += 1;
                },
                ';', ',', '(', ')', '{', '}', '[', ']' => {
                    try tokens.append(.{
                        .kind = .Punctuation,
                        .lexeme = source[i .. i + 1],
                        .punct = c,
                    });
                    i += 1;
                },
                else => {
                    _ = try definitions.writeError("Error: Unrecognized character '{c}'\n", .{c});
                    i += 1;
                },
            }
        }

        return tokens.toOwnedSlice();
    }

    pub fn parse(self: *JSInterpreter, tokens: []const Token) ASTNode {
        _ = self;
        _ = tokens;
        // TODO: implement the parser
        return .NullStatement;
    }

    pub fn interpret(self: *JSInterpreter, ast: ASTNode) JSValue {
        _ = self;
        _ = ast;
        // TODO: implement the interpreter
        return .Void;
    }
};