# Lexical Specification for COOL 


## 1. Keywords
| Token | Regular Expression | Description |
| :--- | :--- | :--- |
| **CLASS** | `(?i)class` | Start of class definition |
| **ELSE** | `(?i)else` | Alternative branch of `if` |
| **FI** | `(?i)fi` | End of `if` statement |
| **IF** | `(?i)if` | Conditional start |
| **IN** | `(?i)in` | Let expression body delimiter |
| **LET** | `(?i)let` | Variable declaration start |
| **LOOP** | `(?i)loop` | Start of while loop body |
| **POOL** | `(?i)pool` | End of while loop body |
| **THEN** | `(?i)then` | Consequent branch of `if` |
| **WHILE** | `(?i)while` | While loop start |
| **NOT** | `(?i)not` | Logical negation |
| **AND** | `(?i)and` | Logical conjunction |

---

## 2. Identifiers and Types

| Token | Regular Expression | Description |
| :--- | :--- | :--- |
| **TYPE** | `[A-Z][a-zA-Z0-9_]*` | Must start with Uppercase (e.g., `Int`, `Main`) |
| **ID** | `[a-z][a-zA-Z0-9_]*` | Must start with Lowercase (e.g., `x`, `main`) |

---

## 3. Literals

| Token | Regular Expression | Description |
| :--- | :--- | :--- |
| **INT** | `[0-9]+` | Sequence of digits |
| **BOOL** | `t[rR][uU][eE]|f[aA][lL][sS][eE]` | Boolean constants |
| **STRING** | `\"([^\"\\\n]|\\.)*\"` | Characters enclosed in double quotes |

---

## 4. Operators and Delimiters

| Token | Regular Expression | Description |
| :--- | :--- | :--- |
| **ASSIGN** | `<-` | Assignment operator |
| **LPAREN** | `\(` | Left parenthesis |
| **RPAREN** | `\)` | Right parenthesis |
| **LBRACE** | `\{` | Left curly brace |
| **RBRACE** | `\}` | Right curly brace |
| **COLON** | `:` | Type declaration separator |
| **SEMICOLON** | `;` | Statement terminator |
| **COMMA** | `,` | List separator |
| **PLUS** | `\+` | Addition |
| **MINUS** | `-` | Subtraction |
| **MULT** | `\*` | Multiplication |
| **DIV** | `/` | Division |
| **LT** | `<` | Less than comparison |

---

## 5. Whitespace and Comments

| Category | Regular Expression | Action |
| :--- | :--- | :--- |
| **WS** | `[ \t\r\n]+` | Skip whitespace |
| **COMMENT** | `--.*` | Skip single-line comments |
| **B-COMMENT** | `\(\*([^*]|\*[^)])*\*\)` | Skip block comments |

---