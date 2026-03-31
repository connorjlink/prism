package main

import (
	"fmt"
	"io"
	"os"
	"strconv"
	"strings"
	"unicode"
)

// thread-synchronized error stream for logging
func errorStream() io.Writer {
	return os.Stderr
}

type Application struct {
	Name    string
	Version string
	Logo    string
}

func NewApplication() Application {
	return Application{
		Name:    "Prism",
		Version: "0.0.1",
		Logo:    "(c) Connor J. Link. All Rights Reserved.",
	}
}

type Window struct {
	Width       uint32
	Height      uint32
	Application Application
}

const (
	AspectRatio  float32 = 16.0 / 9.0
	WindowHeight uint32  = 720
)

func NewWindow() Window {
	return Window{
		Width:       uint32(AspectRatio * float32(WindowHeight)),
		Height:      WindowHeight,
		Application: NewApplication(),
	}
}

// Quadratic bezier curves only
type Point struct {
	X float32
	Y float32
}

type Spline struct {
	StartPoint   Point
	ControlPoint Point
	EndPoint     Point
}

type Glyph struct {
	Character rune
	Width     uint32
	Height    uint32
	Splines   []Spline
}

type FontParser struct {
	FontPath string
	Glyphs   []Glyph
}

func NewFontParser(fontPath string) *FontParser {
	return &FontParser{
		FontPath: fontPath,
		Glyphs:   []Glyph{},
	}
}

func (fp *FontParser) Parse() {
	fontFile, err := os.Open(fp.FontPath)
	if err != nil {
		fmt.Fprintf(errorStream(), "Error: Could not open font file at path '%s'\n", fp.FontPath)
		return
	}
	defer fontFile.Close()

	
}

type Cursor struct {
	X uint32
	Y uint32
}

type FontRenderer struct {
	FontParser *FontParser
	Cursor     Cursor
}

func NewFontRenderer(fontParser *FontParser) *FontRenderer {
	return &FontRenderer{
		FontParser: fontParser,
		Cursor:     Cursor{X: 0, Y: 0},
	}
}

func (fr *FontRenderer) WithCursor(cursor Cursor) *FontRenderer {
	fr.Cursor = cursor
	return fr
}

func (fr *FontRenderer) RenderCharacter(character rune) {
	_ = character
	// TODO
}

func (fr *FontRenderer) RenderString(s string, maximumWidth uint32) {
	_ = maximumWidth
	for _, character := range s {
		fr.RenderCharacter(character)
	}
}

//region DOMNode "union"

type DOMNode interface {
	isDOMNode()
}

type ElementNode struct {
	TagName    string
	Attributes [][2]string
	Children   []DOMNode
}

func (ElementNode) isDOMNode() {}

type TextNode struct {
	Text string
}

func (TextNode) isDOMNode() {}

//endregion

//region CSSValue "union"

type CSSValue interface {
	isCSSValue()
}

type LengthValue struct {
	Value float32
	Unit  string
}

func (LengthValue) isCSSValue() {}

type ColorValue struct {
	Value string
}

func (ColorValue) isCSSValue() {}

type KeywordValue struct {
	Value string
}

func (KeywordValue) isCSSValue() {}

//endregion

func parseHTML(html string) DOMNode {
	_ = html
	// TODO: implement HTML parser that returns the root of a new DOM tree
	return TextNode{Text: "TODO"}
}

func querySelector(root DOMNode, selector string) []DOMNode {
	_ = root
	_ = selector
	// TODO: implement CSS selector engine
	return []DOMNode{}
}

type UnaryOperator int

const (
	UnaryNegative UnaryOperator = iota
	UnaryPositive
	UnaryLogicalNot
	UnarySubscript
	UnaryPrefixIncrement
	UnaryPrefixDecrement
	UnaryPostfixIncrement
	UnaryPostfixDecrement
)

type BinaryOperator int

const (
	BinaryAdd BinaryOperator = iota
	BinarySubtract
	BinaryMultiply
	BinaryDivide
	BinaryRemainder
	BinaryExponentiation
	BinaryLeftShift
	BinaryRightShift
	BinaryZeroFillRightShift
	BinaryBitwiseAnd
	BinaryBitwiseOr
	BinaryBitwiseXor
	BinaryLogicalAnd
	BinaryLogicalOr
	BinaryNullishCoalescing

	BinaryAssignment
	BinaryAdditionAssignment
	BinarySubtractionAssignment
	BinaryMultiplicationAssignment
	BinaryDivisionAssignment
	BinaryRemainderAssignment
	BinaryExponentiationAssignment
	BinaryLeftShiftAssignment
	BinaryRightShiftAssignment
	BinaryZeroFillRightShiftAssignment
	BinaryBitwiseAndAssignment
	BinaryBitwiseOrAssignment
	BinaryBitwiseXorAssignment
	BinaryLogicalAndAssignment
	BinaryLogicalOrAssignment
	BinaryNullishCoalescingAssignment

	BinaryEquality
	BinaryInequality
	BinaryStrictEquality
	BinaryStrictInequality
	BinaryGreaterThan
	BinaryGreaterThanOrEqual
	BinaryLessThan
	BinaryLessThanOrEqual
)

func ParseBinaryOperator(s string) (BinaryOperator, bool) {
	switch s {
	case "+":
		return BinaryAdd, true
	case "-":
		return BinarySubtract, true
	case "*":
		return BinaryMultiply, true
	case "/":
		return BinaryDivide, true
	case "%":
		return BinaryRemainder, true
	case "**":
		return BinaryExponentiation, true
	case "<<":
		return BinaryLeftShift, true
	case ">>":
		return BinaryRightShift, true
	case ">>>":
		return BinaryZeroFillRightShift, true
	case "&":
		return BinaryBitwiseAnd, true
	case "|":
		return BinaryBitwiseOr, true
	case "^":
		return BinaryBitwiseXor, true
	case "&&":
		return BinaryLogicalAnd, true
	case "||":
		return BinaryLogicalOr, true
	case "??":
		return BinaryNullishCoalescing, true
	case "=":
		return BinaryAssignment, true
	case "+=":
		return BinaryAdditionAssignment, true
	case "-=":
		return BinarySubtractionAssignment, true
	case "*=":
		return BinaryMultiplicationAssignment, true
	case "/=":
		return BinaryDivisionAssignment, true
	case "%=":
		return BinaryRemainderAssignment, true
	case "**=":
		return BinaryExponentiationAssignment, true
	case "<<=":
		return BinaryLeftShiftAssignment, true
	case ">>=":
		return BinaryRightShiftAssignment, true
	case ">>>=":
		return BinaryZeroFillRightShiftAssignment, true
	case "&=":
		return BinaryBitwiseAndAssignment, true
	case "|=":
		return BinaryBitwiseOrAssignment, true
	case "^=":
		return BinaryBitwiseXorAssignment, true
	case "&&=":
		return BinaryLogicalAndAssignment, true
	case "||=":
		return BinaryLogicalOrAssignment, true
	case "??=":
		return BinaryNullishCoalescingAssignment, true
	case "==":
		return BinaryEquality, true
	case "!=":
		return BinaryInequality, true
	case "===":
		return BinaryStrictEquality, true
	case "!==":
		return BinaryStrictInequality, true
	case ">":
		return BinaryGreaterThan, true
	case ">=":
		return BinaryGreaterThanOrEqual, true
	case "<":
		return BinaryLessThan, true
	case "<=":
		return BinaryLessThanOrEqual, true
	default:
		return 0, false
	}
}

type Operator struct {
	Unary  *UnaryOperator
	Binary *BinaryOperator
}

func NewUnaryOperator(op UnaryOperator) Operator {
	return Operator{Unary: &op}
}

func NewBinaryOperator(op BinaryOperator) Operator {
	return Operator{Binary: &op}
}

type TokenKind int

const (
	TokenIdentifier TokenKind = iota
	TokenNumber
	TokenString
	TokenBoolean
	TokenNull
	TokenKeyword
	TokenOperator
	TokenPunctuation
)

type Token struct {
	Kind     TokenKind
	Lexeme   string
	Number   float64
	Boolean  bool
	Operator *Operator
	Punct    rune
}

//region ASTNode "union"

type ASTNode interface {
	isASTNode()
}

type ProgramNode struct {
	Statements []ASTNode
}

func (ProgramNode) isASTNode() {}

type VariableDeclarationNode struct {
	Name        string
	Initializer ASTNode
	IsConst     bool
}

func (VariableDeclarationNode) isASTNode() {}

type FunctionDeclarationNode struct {
	Name       string
	Parameters []string
	Body       ASTNode
}

func (FunctionDeclarationNode) isASTNode() {}

type ExpressionStatementNode struct {
	Expression ASTNode
}

func (ExpressionStatementNode) isASTNode() {}

type UnaryExpressionNode struct {
	Operator UnaryOperator
	Operand  ASTNode
}

func (UnaryExpressionNode) isASTNode() {}

type BinaryExpressionNode struct {
	Operator BinaryOperator
	Left     ASTNode
	Right    ASTNode
}

func (BinaryExpressionNode) isASTNode() {}

type IdentifierNode struct {
	Name string
}

func (IdentifierNode) isASTNode() {}

type LiteralNode struct {
	Value JSValue
}

func (LiteralNode) isASTNode() {}

type NullStatementNode struct{}

func (NullStatementNode) isASTNode() {}

//endregion

//region JSValue "union"

type JSValue interface {
	isJSValue()
}

type JSNumber float64

func (JSNumber) isJSValue() {}

type JSString string

func (JSString) isJSValue() {}

type JSBoolean bool

func (JSBoolean) isJSValue() {}

type JSObject map[string]JSValue

func (JSObject) isJSValue() {}

type JSArray []JSValue

func (JSArray) isJSValue() {}

type JSFunction struct {
	Parameters []string
	Body       ASTNode
}

func (JSFunction) isJSValue() {}

type JSVoid struct{}

func (JSVoid) isJSValue() {}

//endregion

type JSInterpreterContext struct {
	Variables map[string]JSValue
	Functions map[string]FunctionDeclarationNode
}

type JSInterpreter struct {
	Context JSInterpreterContext
}

func NewJavaScriptInterpreter() *JSInterpreter {
	return &JSInterpreter{
		Context: JSInterpreterContext{
			Variables: map[string]JSValue{},
			Functions: map[string]FunctionDeclarationNode{},
		},
	}
}

func (js *JSInterpreter) Lex(source string) []Token {
	_ = js

	var tokens []Token
	chars := []rune(source)

	for i := 0; i < len(chars); {
		c := chars[i]

		if unicode.IsSpace(c) {
			i++
			continue
		}

		if unicode.IsDigit(c) {
			start := i
			hasDot := false
			for i < len(chars) && (unicode.IsDigit(chars[i]) || (!hasDot && chars[i] == '.')) {
				if chars[i] == '.' {
					hasDot = true
				}
				i++
			}
			numberString := string(chars[start:i])
			number, err := strconv.ParseFloat(numberString, 64)
			if err != nil {
				fmt.Fprintf(errorStream(), "Error: Invalid number '%s'\n", numberString)
				continue
			}
			tokens = append(tokens, Token{
				Kind:   TokenNumber,
				Lexeme: numberString,
				Number: number,
			})
			continue
		}

		if unicode.IsLetter(c) || c == '_' {
			start := i
			for i < len(chars) && (unicode.IsLetter(chars[i]) || unicode.IsDigit(chars[i]) || chars[i] == '_') {
				i++
			}
			ident := string(chars[start:i])

			switch ident {
			case "true":
				tokens = append(tokens, Token{Kind: TokenBoolean, Lexeme: ident, Boolean: true})
			case "false":
				tokens = append(tokens, Token{Kind: TokenBoolean, Lexeme: ident, Boolean: false})
			case "null":
				tokens = append(tokens, Token{Kind: TokenNull, Lexeme: ident})
			case "var", "let", "const", "function", "if", "else", "while", "for", "return":
				tokens = append(tokens, Token{Kind: TokenKeyword, Lexeme: ident})
			default:
				tokens = append(tokens, Token{Kind: TokenIdentifier, Lexeme: ident})
			}
			continue
		}

		if c == '"' || c == '\'' {
			quote := c
			i++ // skip opening quote

			var b strings.Builder
			for i < len(chars) && chars[i] != quote {
				if chars[i] == '\\' && i+1 < len(chars) {
					i++
					switch chars[i] {
					case 'n':
						b.WriteRune('\n')
					case 't':
						b.WriteRune('\t')
					case '\\':
						b.WriteRune('\\')
					case '"':
						b.WriteRune('"')
					case '\'':
						b.WriteRune('\'')
					default:
						b.WriteRune(chars[i])
					}
				} else {
					b.WriteRune(chars[i])
				}
				i++
			}
			if i < len(chars) && chars[i] == quote {
				i++ // closing quote
			}

			tokens = append(tokens, Token{
				Kind:   TokenString,
				Lexeme: b.String(),
			})
			continue
		}

		// operators (try longest-first)
		if i+3 <= len(chars) {
			if op, ok := ParseBinaryOperator(string(chars[i : i+3])); ok {
				operator := NewBinaryOperator(op)
				tokens = append(tokens, Token{Kind: TokenOperator, Lexeme: string(chars[i : i+3]), Operator: &operator})
				i += 3
				continue
			}
		}
		if i+2 <= len(chars) {
			if op, ok := ParseBinaryOperator(string(chars[i : i+2])); ok {
				operator := NewBinaryOperator(op)
				tokens = append(tokens, Token{Kind: TokenOperator, Lexeme: string(chars[i : i+2]), Operator: &operator})
				i += 2
				continue
			}
		}
		if op, ok := ParseBinaryOperator(string(c)); ok {
			operator := NewBinaryOperator(op)
			tokens = append(tokens, Token{Kind: TokenOperator, Lexeme: string(c), Operator: &operator})
			i++
			continue
		}

		switch c {
		case '!':
			u := NewUnaryOperator(UnaryLogicalNot)
			tokens = append(tokens, Token{Kind: TokenOperator, Lexeme: "!", Operator: &u})
			i++
		case ';', ',', '(', ')', '{', '}', '[', ']':
			tokens = append(tokens, Token{Kind: TokenPunctuation, Lexeme: string(c), Punct: c})
			i++
		default:
			fmt.Fprintf(errorStream(), "Error: Unrecognized character '%c'\n", c)
			i++
		}
	}

	return tokens
}

func (js *JSInterpreter) Parse(tokens []Token) ASTNode {
	_ = js
	_ = tokens
	// TODO: implement JavaScript parser that returns the root of a new AST
	return NullStatementNode{}
}

func (js *JSInterpreter) Interpret(ast ASTNode) JSValue {
	_ = js
	_ = ast
	// TODO: implement JavaScript interpreter that evaluates the AST
	return JSVoid{}
}

func main() {
	fmt.Println("Hello, world!")
}
