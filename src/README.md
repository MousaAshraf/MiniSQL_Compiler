# MiniSQL Compiler - Phase 1: Lexer

## Overview
The lexer is the first phase of the MiniSQL compiler, responsible for breaking down SQL source code into meaningful tokens (lexical analysis).

## Components

### `lexer.py`
Main lexer module containing:

#### `LexerError` Exception
Custom exception class for lexer-specific errors.

#### `Token` Class
Represents a single token with:
- `type`: Token type (KEYWORD, IDENTIFIER, OPERATOR, etc.)
- `value`: The actual text/value of the token
- `line`: Line number where token appears
- `column`: Column number where token appears

#### `Lexer` Class
Main lexer class responsible for tokenization:

##### Methods:
- `advance()`: Move to next character with proper line/column tracking
- `skip_whitespace()`: Skip whitespace characters
- `skip_comment()`: Skip single-line (--)  and multi-line (##) comments
- `get_number()`: Parse numeric literals including scientific notation
- `get_identifier()`: Parse identifiers and keywords
- `get_string()`: Parse string literals with escaped quote support
- `get_next_token()`: Get the next token from input
- `similar_to_keyword()`: Fuzzy match for potential keyword typos
- `error()`: Raise LexerError with message

### `app.py`
Streamlit web interface for the lexer:
- File upload for SQL files
- Real-time token visualization
- Error reporting
- Symbol table generation

## Supported SQL Features

### Keywords (70+)
Core SQL keywords: SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, etc.
Control keywords: IF, CASE, WHEN, WHERE, GROUP, ORDER, etc.
Functions: COUNT, SUM, AVG, MIN, MAX, CAST, COALESCE, etc.

### Token Types
- `KEYWORD`: SQL reserved words
- `IDENTIFIER`: Variable names, table names, column names
- `STRING`: Text literals ('...')
- `INTEGER`: Whole numbers
- `FLOAT`: Decimal numbers or scientific notation (1.5e-10)
- `OPERATOR`: Arithmetic operators (+, -, *, /, %)
- `COMPARISON`: Comparison operators (<, >, =, !=, <>)
- `DELIMITER`: Punctuation (,, (, ), ;)
- `DOT`: Dot for qualified names (table.column)
- `EOF`: End of file marker

### Operators Supported
- Arithmetic: `+`, `-`, `*`, `/`, `%`
- Comparison: `=`, `<`, `>`, `!=`, `<>`, `<=`, `>=`
- Multi-char: `==`, `<>`, `!=`, `<=`, `>=`, `||`, `<<`, `>>`
- Bitwise: `&`, `|`, `^`

### String Features
- Single-quoted strings: `'text'`
- Escaped quotes: `'O''Brien'` (SQL standard)
- Error detection for unclosed strings

### Number Features
- Integer literals: `123`, `0`
- Float literals: `123.45`
- Scientific notation: `1.5e-10`, `3E+5`, `2.3e10`

### Comments
- Single-line: `-- comment`
- Multi-line: `## comment ##`

## Usage

### Command Line
```bash
python src/lexer.py tests/valid_queries.sql
```

### As a Module
```python
from src.lexer import Lexer, LexerError

sql_code = "SELECT * FROM users WHERE id = 1;"
lexer = Lexer(sql_code)

tokens = []
while True:
    token = lexer.get_next_token()
    if token.type == 'EOF':
        break
    tokens.append(token)
    print(token)
```

### Web Interface
```bash
streamlit run app.py
```

Then navigate to http://localhost:8501 and upload a SQL file.

## Error Handling

The lexer detects and reports:
- Invalid characters
- Unclosed strings
- Unclosed comments
- Invalid number formats
- Invalid escape sequences

Errors are reported with:
- Error message
- Line number
- Column number

## Performance

The lexer uses:
- Single-pass scanning (O(n) complexity)
- Efficient character-by-character processing
- Early error detection and recovery

## Future Enhancements

- Backtick-quoted identifiers (`` `column_name` ``)
- Square bracket identifiers (`[column name]`)
- Double-quoted strings (ANSI SQL)
- HEX literals (`0x1A2B`)
- Boolean literals (`TRUE`, `FALSE`)
- Array syntax (`[1, 2, 3]`)
- JSON operators (`->`, `->>`)
