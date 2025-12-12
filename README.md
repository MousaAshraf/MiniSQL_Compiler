# MiniSQL Compiler

A comprehensive SQL compiler implementation with lexical analysis (Phase 01) and syntax analysis (Phase 02).

## Overview

This project implements a complete compiler frontend for a SQL-like language, capable of:
1. **Tokenizing** SQL statements into a stream of tokens (Lexical Analysis)
2. **Parsing** tokens into an Abstract Syntax Tree (Syntax Analysis)
3. **Detecting and reporting** syntax errors with precise location information
4. **Recovering** from errors to find multiple issues in one pass

## Features

### Phase 01: Lexical Analysis ✅
- ✅ Tokenizes SQL statements into KEYWORD, IDENTIFIER, OPERATOR, DELIMITER, and more
- ✅ Supports 60+ SQL keywords
- ✅ Handles scientific notation (1.5e-10)
- ✅ Supports escaped string quotes ('O''Brien')
- ✅ Multi-character operators (<>, !=, <=, >=, ||, <<, >>)
- ✅ Proper error handling with line/column reporting
- ✅ Comment support (both -- and ## styles)

### Phase 02: Syntax Analysis ✅
- ✅ **Recursive Descent Parser** - Hand-written, no parser generators
- ✅ **Parse Tree Generation** - Explicit derivation of statements
- ✅ **50+ SQL Constructs** supported
- ✅ **DDL Support**: CREATE/ALTER/DROP TABLE, DATABASE, VIEW, INDEX
- ✅ **DML Support**: SELECT, INSERT, UPDATE, DELETE
- ✅ **Complex Conditions**: AND/OR/NOT with proper precedence
- ✅ **Special Operators**: BETWEEN, IN, LIKE, IS NULL
- ✅ **JOINs**: INNER, LEFT, RIGHT, FULL, CROSS
- ✅ **Aggregate Functions**: COUNT, SUM, AVG, MIN, MAX
- ✅ **Error Detection & Recovery**: Panic mode error recovery
- ✅ **Comprehensive Error Reporting**: Line, column, expected vs. found
- ✅ **Boolean Conditions**: Support for bare expressions (e.g., `NOT Active`)

## Project Structure

```
MiniSQL_Compiler/
├── src/
│   ├── __init__.py              # Package initialization (exports main classes)
│   ├── lexer.py                 # Phase 01: Lexer (343 lines)
│   ├── parser.py                # Phase 02: Parser (1341 lines)
│   ├── app.py                   # Streamlit web interface (240 lines)
│   └── __pycache__/             # Python cache
├── tests/
│   ├── README.md                # Test documentation
│   ├── valid_queries.sql        # Valid SQL test cases
│   ├── invalid_queries.sql      # Error handling test cases
│   ├── advanced_queries.sql     # Advanced feature test cases
│   ├── test_input.sql           # General input test file
│   └── input.sql                # Input test file
├── LICENSE                      # MIT License
├── README.md                    # This file
└── .gitignore                   # Git ignore file
```

## Quick Start

### 1. Web Interface (Recommended)
```bash
cd src
streamlit run app.py
```

Open your browser to `http://localhost:8501`

### 2. Command Line Testing
```bash
# Run lexer on SQL file
python src/lexer.py tests/valid_queries.sql

# Test parser directly
python -c "from src.lexer import Lexer; from src.parser import parse_sql; tree, lex_errors, parse_errors = parse_sql(open('tests/test_input.sql').read()); print(f'Parse errors: {len(parse_errors)}')"
```

### 3. As a Python Module
```python
from src import parse_sql

# Parse SQL and get results
tree, lex_errors, parse_errors = parse_sql("SELECT * FROM users WHERE age > 18;")

if parse_errors:
    for error in parse_errors:
        print(error)
else:
    print("✓ Parsing successful!")
    print(f"Parse tree nodes: {count_nodes(tree)}")
```

## Language Support

### Supported SQL Statements

#### DDL (Data Definition Language)
```sql
CREATE TABLE users (id INTEGER PRIMARY KEY, name VARCHAR(50) NOT NULL);
CREATE DATABASE mydb;
CREATE VIEW active_users AS SELECT * FROM users WHERE status = 'active';
CREATE INDEX idx_user_id ON users(id);

ALTER TABLE users ADD COLUMN email VARCHAR(100);
ALTER TABLE users DROP COLUMN age;

DROP TABLE users;
DROP DATABASE mydb;
DROP VIEW active_users;
DROP INDEX idx_user_id;
```

#### DML (Data Manipulation Language)
```sql
-- SELECT with all clauses
SELECT DISTINCT u.id, u.name, COUNT(o.id) AS order_count
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
WHERE u.age > 18 AND u.status = 'active'
GROUP BY u.id, u.name
HAVING COUNT(o.id) > 5
ORDER BY order_count DESC
LIMIT 10;

-- INSERT
INSERT INTO users (id, name, age) VALUES (1, 'John', 25);

-- UPDATE
UPDATE users SET age = 26 WHERE name = 'John';

-- DELETE
DELETE FROM users WHERE id = 1;
```

### Operators and Conditions

#### Logical Operators
```sql
WHERE age > 18 AND status = 'active'
WHERE country = 'USA' OR country = 'Canada'
WHERE NOT deleted
WHERE (age > 18 AND status = 'active') OR premium = 1
WHERE Active  -- Boolean columns without comparison
```

#### Comparison Operators
```sql
=, <>, !=, <, >, <=, >=
BETWEEN ... AND ...
IN (list, of, values)
LIKE '%pattern%'
IS NULL, IS NOT NULL
```

#### Aggregate Functions
```sql
COUNT(*), COUNT(DISTINCT user_id), SUM(amount), AVG(price), MIN(date), MAX(total)
```

#### Built-in Functions
```sql
SUBSTR(string, start, length)
LENGTH(string)
UPPER(string), LOWER(string)
ROUND(number, decimals)
FLOOR(number), CEIL(number)
CAST(expr AS type)
COALESCE(expr1, expr2, ...)
```

## Web Interface Features

### Tab 1: Input & Tokens
- Upload SQL files
- View source code
- Display token table (Type, Lexeme, Line, Column)
- Show lexical errors with details

### Tab 2: Parse Tree
- Display syntax errors with context
- Interactive tree visualization with proper ASCII formatting
- JSON representation of parse tree
- Tree statistics (nodes, depth, terminals)

### Tab 3: Analysis Summary
- Compilation status dashboard
- Token type distribution chart
- Syntax error summary table
- Detailed error information

## Error Handling

### Detection
The parser detects:
- ❌ Unexpected tokens
- ❌ Missing required tokens
- ❌ Type mismatches
- ❌ Incomplete clauses
- ❌ Syntax violations

### Reporting
Each error includes:
```
Syntax Error at line 5, column 12: Expected 'FROM' but found 'WHERE'.
```

### Recovery
- Uses **Panic Mode** recovery
- Skips tokens until finding sync point (`;` or major keyword)
- Continues parsing to find more errors
- Reports all errors in one pass

## Examples

### Example 1: Simple SELECT
**Input:**
```sql
SELECT id, name FROM users WHERE age > 18;
```

**Parse Tree:**
```
Select
├── SelectList
│   ├── Column: 'id'
│   └── Column: 'name'
├── FromClause
│   └── TableName: 'users'
└── WhereClause
    └── Comparison
        ├── Column: 'age'
        ├── Terminal: '>'
        └── Literal: '18'
```

### Example 2: Complex WHERE with Boolean Condition
**Input:**
```sql
SELECT * FROM Users WHERE (Salary_2025 >= 10000 AND NOT Active) OR (Balance <= 5000 / 2);
```

**Result:** ✅ Parses successfully with 0 errors

### Example 3: Error Detection
**Input:**
```sql
SELECT id, name WHERE age > 18;
```

**Errors:**
```
⚠ Syntax Error at line 1, column 18: Missing FROM clause before WHERE
```

## Testing

### Test Files
- **valid_queries.sql**: Valid SQL statements that should parse successfully
- **invalid_queries.sql**: Invalid SQL for error handling validation
- **advanced_queries.sql**: Complex queries with advanced features
- **test_input.sql**: Comprehensive test input with mixed statements

### Test Coverage
- ✅ All DDL statements (CREATE, ALTER, DROP)
- ✅ All DML statements (SELECT, INSERT, UPDATE, DELETE)
- ✅ Operator types (logical, comparison, arithmetic)
- ✅ Special operators (BETWEEN, IN, LIKE, IS NULL)
- ✅ JOINs (INNER, LEFT, RIGHT, FULL, CROSS)
- ✅ Aggregate functions
- ✅ Error detection and recovery
- ✅ Complex nested conditions
- ✅ Boolean column references

## Performance

| Metric | Value |
|--------|-------|
| Time Complexity | O(n) |
| Space Complexity | O(d) |
| Typical Parse Time | < 100ms |
| Max Tested Statements | 100+ |

## Implementation Details

### Architecture
```
SQL Source Code
    ↓
Lexer (Phase 01) - 343 lines
    ↓
Token Stream
    ↓
Parser (Phase 02) - 1341 lines
    ↓
Parse Tree (AST)
    ↓
Web UI (app.py) - 240 lines
```

### Key Classes

- **Token**: Represents a single token (type, value, line, column)
- **Lexer**: Tokenizes SQL source code (src/lexer.py)
- **ParseTreeNode**: Node in the abstract syntax tree
- **Parser**: Implements recursive descent parsing (src/parser.py)
- **SyntaxErrorInfo**: Error with full context

### Parsing Technique
- **Recursive Descent**: Direct implementation of grammar rules
- **Operator Precedence**: Iterative handling in expression parsing
- **Error Recovery**: Panic mode synchronization
- **Lookahead**: Minimal (0-1 tokens typically)

## Supported Token Types

- **KEYWORD**: SQL reserved words (SELECT, INSERT, WHERE, etc.)
- **IDENTIFIER**: Variable, table, and column names
- **STRING**: Text literals ('...')
- **INTEGER**: Whole numbers (123)
- **FLOAT**: Decimal numbers and scientific notation (1.5e-10)
- **OPERATOR**: Arithmetic operators (+, -, *, /, %)
- **COMPARISON**: Comparison operators (<, >, =, !=, <>, <=, >=)
- **DELIMITER**: Punctuation (,, (, ), ;)
- **DOT**: Qualified names (table.column)
- **EOF**: End of file

## Supported SQL Keywords

**Core Operations:** SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER

**Clauses:** WHERE, FROM, JOIN, GROUP BY, ORDER BY, HAVING, LIMIT

**Functions:** COUNT, SUM, AVG, MIN, MAX, CAST, COALESCE, SUBSTR, LENGTH, UPPER, LOWER, ROUND, FLOOR, CEIL

**Additional:** AND, OR, NOT, BETWEEN, IN, LIKE, IS, NULL, PRIMARY, KEY, FOREIGN, UNIQUE, DEFAULT, CHECK, ON, AS, DISTINCT, ASC, DESC, INNER, LEFT, RIGHT, FULL, CROSS, VIEW, INDEX, DATABASE, TABLE, CONSTRAINT, REFERENCES, CASCADE

## Requirements

- Python 3.8+
- Streamlit (for web interface)
- pandas (for web interface data display)
- No external parser generators (hand-written parser)

## Installation

```bash
# Clone the repository
git clone https://github.com/MousaAshraf/MiniSQL_Compiler.git
cd MiniSQL_Compiler

# Install dependencies
pip install streamlit pandas

# Run web interface
cd src
streamlit run app.py
```

## Recent Fixes (December 2025)

### Bug Fixes
- ✅ **Fixed CREATE TABLE parsing**: Corrected DELIMITER type checking in `parse_data_type()` and `parse_column_definitions()`
- ✅ **Fixed comparison operators**: Resolved parsing issues with `>=` and `<=` operators in conditions
- ✅ **Fixed boolean conditions**: Added support for bare expressions (e.g., `NOT Active`) as valid conditions
- ✅ **Improved token type checking**: Replaced 7 incorrect `match()` calls with proper `match_type('DELIMITER')` checks throughout parser

### UI Improvements
- ✅ **Removed Text Tree view**: Simplified output display to show only Visual Tree and JSON Structure options
- ✅ **Enhanced parse tree visualization**: Interactive tree view with proper formatting

### Testing
- ✅ All test queries now parse without errors
- ✅ Verified complex WHERE conditions with multiple operators
- ✅ Tested arithmetic expressions in conditions (e.g., `Balance <= 5000 / 2`)

**Branch**: `fix/syntax-errors` with 4 focused commits documenting each fix

## Known Limitations

- Subqueries: Partial support only
- Window functions: Not implemented
- CTEs (WITH clause): Not supported
- Array/JSON types: Not supported
- Set operations (UNION, INTERSECT, EXCEPT): Not fully supported

## Future Enhancements

1. **Semantic Analysis** (Phase 03)
   - Type checking
   - Column existence validation
   - Constraint validation

2. **Optimization**
   - Query plan generation
   - Statistics-based optimization

3. **Extended SQL Support**
   - Subqueries in all positions
   - Window functions
   - Common Table Expressions
   - Full set operations support

## Contributing

This is an educational project. Contributions welcome for:
- Bug fixes
- Documentation improvements
- Additional test cases
- Grammar enhancements

## License

MIT License - See [LICENSE](LICENSE) file

## Author

Omar (2025)

## Acknowledgments

Based on compiler design principles from:
- "Compilers: Principles, Techniques, and Tools" (Aho, Lam, Sethi, Ullman)
- Standard SQL-92 specification
- Recursive Descent Parsing techniques

---

## Status

✅ **Phase 01 (Lexer)**: Complete - 343 lines
✅ **Phase 02 (Parser)**: Complete - 1341 lines
✅ **Web Interface**: Complete - 240 lines

**Last Updated**: December 12, 2025
