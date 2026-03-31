use std::io::{self, Write};
use std::str::FromStr;

// thread-synchronized error stream for logging
fn error_stream() -> impl Write {
    return io::stderr();
}


struct Application {
    name: String,
    version: String,
    logo: String,
}

impl Application {
    fn new() -> Self {
        return Application {
            name: String::from("Prism"),
            version: String::from("0.0.1"),
            logo: String::from("(c) Connor J. Link. All Rights Reserved."),
        };
    }
}

struct Window {
    width: u32,
    height: u32,
    application: Application,
}

const ASPECT_RATIO: f32 = 16.0 / 9.0;
const WINDOW_HEIGHT: u32 = 600;

impl Window {
    fn new() -> Self {
        return Window {
            width: (ASPECT_RATIO * WINDOW_HEIGHT as f32) as u32,
            height: WINDOW_HEIGHT,
            application: Application::new(),
        };
    }
}


// Quadratic bezier curves only
struct Spline {
    start_point: (f32, f32),
    control_point: (f32, f32),
    end_point: (f32, f32),
}

struct Glyph {
    character: char,
    width: u32,
    height: u32,
    splines: Vec<Spline>,
}

struct FontParser {
    font_path: String,
    glyphs: Vec<Glyph>,
}

impl FontParser {
    pub fn new(font_path: String) -> Self {
        return FontParser { 
            font_path,
            glyphs: Vec::new(),
        };
    }

    pub fn parse(&mut self) {
        let font_file = std::fs::File::open(&self.font_path);
        if font_file.is_err() {
            writeln!(error_stream(), "Error: Could not open font file at path '{}'", self.font_path).unwrap();
            return;
        }

        /* TODO
            1. File parsing
                - Offset table
                - Table directory
                - Required tables:
                - head
                - maxp
                - loca
                - glyf
                - cmap

            2. Glyph loading
                - Map character → glyph index (cmap)
                - Read glyph outline from glyf
         */
    }
}

struct Cursor {
    x: u32,
    y: u32,
}

struct FontRenderer<'a> {
    font_parser: &'a mut FontParser,
    cursor: Cursor,
}

impl<'a> FontRenderer<'a> {
    pub fn new(font_parser: &'a mut FontParser) -> Self {
        return FontRenderer {
            font_parser,
            cursor: Cursor { x: 0, y: 0 },
        };
    }

    pub fn with_cursor(mut self, cursor: Cursor) -> Self {
        self.cursor = cursor;
        return self;
    }

    pub fn render_character(&mut self, character: char) {

    }

    pub fn render_string(&mut self, string: &str, maximum_width: u32, ) {
        for character in string.chars() {
            self.render_character(character);
        }
    }
}


enum DOMNode {
    Element(ElementNode),
    Text(String),
}

enum CSSValue {
    // value and unit (e.g., "px", "em")
    Length(f32, String),
    // e.g., "#ff0000" or "rgb(255, 0, 0)"
    Color(String),
    // e.g., "block", "inline", "none"
    Keyword(String),
}

struct ElementNode {
    tag_name: String,
    attributes: Vec<(String, String)>,
    children: Vec<DOMNode>,
}

fn parse_html(html: &str) -> DOMNode {
    // TODO: implement HTML parser that returns the root of a new DOM tree
    return DOMNode::Text(String::from("TODO"));
}

fn query_selector<'a>(root: &'a DOMNode, selector: &str) -> Vec<&'a DOMNode> {
    // TODO: implement CSS selector engine
    return Vec::new();
}

enum UnaryOperator {
    Negative, // -
    Positive, // +
    LogicalNot, // !
    Subscript, // []
    PrefixIncrement, // ++x
    PrefixDecrement, // --x
    PostfixIncrement, // x++
    PostfixDecrement, // x--
}

enum BinaryOperator {
    Add, // +
    Subtract, // -
    Multiply, // *
    Divide, // /
    Remainder, // %
    Exponentiation, // **
    LeftShift, // <<
    RightShift, // >>
    ZeroFillRightShift, // >>>
    BitwiseAnd, // &
    BitwiseOr, // |
    BitwiseXor, // ^
    LogicalAnd, // &&
    LogicalOr, // ||
    NullishCoalescing, // ??
    
    Assignment, // =
    AdditionAssignment, // +=
    SubtractionAssignment, // -=
    MultiplicationAssignment, // *=
    DivisionAssignment, // /=
    RemainderAssignment, // %=
    ExponentiationAssignment, // **=
    LeftShiftAssignment, // <<=
    RightShiftAssignment, // >>=
    ZeroFillRightShiftAssignment, // >>>=
    BitwiseAndAssignment, // &=
    BitwiseOrAssignment, // |=
    BitwiseXorAssignment, // ^=
    LogicalAndAssignment, // &&=
    LogicalOrAssignment, // ||=
    NullishCoalescingAssignment, // ??=
    
    Equality, // ==
    Inequality, // !=
    StrictEquality, // ===
    StrictInequality, // !==
    GreaterThan, // >
    GreaterThanOrEqual, // >=
    LessThan, // <
    LessThanOrEqual, // <=
}

impl FromStr for BinaryOperator {
    type Err = ();

    fn from_str(string: &str) -> Result<Self, Self::Err> {
        return match string {
            "+" => Ok(BinaryOperator::Add),
            "-" => Ok(BinaryOperator::Subtract),
            "*" => Ok(BinaryOperator::Multiply),
            "/" => Ok(BinaryOperator::Divide),
            "%" => Ok(BinaryOperator::Modulo),
            "&&" => Ok(BinaryOperator::LogicalAnd),
            "||" => Ok(BinaryOperator::LogicalOr),
            "==" => Ok(BinaryOperator::Equality),
            "===" => Ok(BinaryOperator::StrictEquality),
            "!=" => Ok(BinaryOperator::Inequality),
            "!==" => Ok(BinaryOperator::StrictInequality),
            "<" => Ok(BinaryOperator::LessThan),
            "<=" => Ok(BinaryOperator::LessThanOrEqual),
            ">" => Ok(BinaryOperator::GreaterThan),
            ">=" => Ok(BinaryOperator::GreaterThanOrEqual),
            _ => Err(()),
        };
    }
}

enum Operator {
    UnaryOperator(UnaryOperator),
    BinaryOperator(BinaryOperator),
}


enum Token {
    Identifier(String),
    Number(f64),
    String(String),
    Boolean(bool),
    Null,
    Keyword(String),
    Operator(Operator),
    Punctuation(char),
}

enum ASTNode {
    Program(Vec<Box<ASTNode>>),
    VariableDeclaration(String, Box<ASTNode>, bool), // name, initializer, is_const
    FunctionDeclaration(String, Vec<String>, Box<ASTNode>), // name, parameters, body
    ExpressionStatement(Box<ASTNode>),
    UnaryExpression(UnaryOperator, Box<ASTNode>),
    BinaryExpression(BinaryOperator, Box<ASTNode>, Box<ASTNode>),
    Identifier(String),
    Literal(JavaScriptValue),
    NullStatement,
}

enum JavaScriptValue {
    Number(f64),
    String(String),
    Boolean(bool),
    Object(Vec<(String, JavaScriptValue)>), // property name -> value
    Array(Vec<JavaScriptValue>),
    Function(Vec<String>, Box<ASTNode>), // parameters, body
    Void,
}

struct InterpreterContext {
    variables: Vec<(String, JavaScriptValue)>,
    functions: Vec<(String, (Vec<String>, ASTNode))>,
}

struct JavaScriptInterpreter {
    context: InterpreterContext,
}

impl JavaScriptInterpreter {
    pub fn new() -> Self {
        return JavaScriptInterpreter {
            context: InterpreterContext {
                variables: Vec::new(),
                functions: Vec::new(),
            },
        };
    }

    pub fn lex(&self, source: &str) -> Vec<Token> {
        let mut tokens = Vec::new();

        let chars: Vec<char> = source.chars().collect();
        for mut i in 0..chars.len() {
            let c = chars[i];
            if c.is_whitespace() {
                continue;

            } else if c.is_ascii_digit() {
                let mut number_string = String::new();
                number_string.push(c);
                while i + 1 < chars.len() && (chars[i + 1].is_ascii_digit() || chars[i + 1] == '.') {
                    number_string.push(chars[i + 1]);
                    i += 1;
                }
                let number = number_string.parse::<f64>().unwrap();
                tokens.push(Token::Number(number));

            } else if c.is_ascii_alphabetic() || c == '_' {
                // collect valid identifier strings
                let mut identifier_string = String::new();
                identifier_string.push(c);
                while i + 1 < chars.len() && (chars[i + 1].is_ascii_alphanumeric() || chars[i + 1] == '_') {
                    identifier_string.push(chars[i + 1]);
                    i += 1;
                }

                match identifier_string.as_str() {
                    "true" => tokens.push(Token::Boolean(true)),
                    "false" => tokens.push(Token::Boolean(false)),
                    "null" => tokens.push(Token::Null),
                    "var" | "let" | "const" | "function" | "if" | "else" | "while" | "for" | "return" => {
                        tokens.push(Token::Keyword(identifier_string));
                    }
                    _ => tokens.push(Token::Identifier(identifier_string)),
                }
            } else if c == '"' || c == '\'' {
                let quote_char = c;
                let mut string_literal = String::new();
                i += 1; // skip opening quote
                while i < chars.len() && chars[i] != quote_char {
                    if chars[i] == '\\' && i + 1 < chars.len() {
                        // handle escape sequences
                        i += 1;
                        match chars[i] {
                            'n' => string_literal.push('\n'),
                            't' => string_literal.push('\t'),
                            '\\' => string_literal.push('\\'),
                            '"' => string_literal.push('"'),
                            '\'' => string_literal.push('\''),
                            _ => string_literal.push(chars[i]),
                        }
                    } else {
                        string_literal.push(chars[i]);
                    }
                    i += 1;
                }
                tokens.push(Token::String(string_literal));
            } else {
                // handle operators and punctuation
                let mut operator_string = String::new();
                operator_string.push(c);
                if i + 1 < chars.len() {
                    operator_string.push(chars[i + 1]);
                    if let Ok(binary_op) = BinaryOperator::from_str(&operator_string) {
                        tokens.push(Token::BinaryOperator(binary_op));
                        i += 1; // consume second character of operator
                        continue;
                    }
                    operator_string.pop(); // remove second character if not a valid operator
                }

                match c {
                    '+' | '-' | '*' | '/' | '%' | '&' | '|' | '!' | '=' | '<' | '>' => {
                        if let Ok(binary_op) = BinaryOperator::from_str(&operator_string) {
                            tokens.push(Token::BinaryOperator(binary_op));
                        } else if c == '-' || c == '!' {
                            let unary_op = if c == '-' { UnaryOperator::Negate } else { UnaryOperator::LogicalNot };
                            tokens.push(Token::UnaryOperator(unary_op));
                        } else {
                            writeln!(error_stream(), "Error: Unrecognized operator '{}'", c).unwrap();
                        }
                    }
                    ';' | ',' | '(' | ')' | '{' | '}' | '[''|''] => tokens.push(Token::Punctuation(c)),
                    _ => writeln!(error_stream(), "Error: Unrecognized character '{}'", c).unwrap(),
                }
            }
        }

        // TODO: implement JavaScript lexer and return stream of tokens
        
        return tokens;
    }

    pub fn parse(&self, tokens: Vec<Token>) -> ASTNode {
        // TODO: implement JavaScript parser that returns the root of a new AST
        return ASTNode::NullStatement;
    }

    pub fn interpret(&mut self, ast: ASTNode) -> JavaScriptValue {
        // TODO: implement JavaScript interpreter that evaluates the AST and returns its result if an expression, else Void()
        return JavaScriptValue::Void;
    }
}


fn main() {
    println!("Hello, world!");
}
