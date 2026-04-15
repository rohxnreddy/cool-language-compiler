# --- Top-Level Structure ---
Program      → Class
Class        → class TYPE_ID { Function } ;
Function     → OBJECT_ID ( ) { ExprList } ;

# --- Statement Types ---
Expr         → TYPE_ID OBJECT_ID <- LogicExpr   # Variable Declaration
             | OBJECT_ID <- LogicExpr           # Assignment
             | LogicExpr                        # General Expression

# --- Logic Hierarchy (OR < AND < NOT) ---
LogicExpr    → LogicExpr or LogicTerm | LogicTerm
LogicTerm    → LogicTerm and LogicFactor | LogicFactor
LogicFactor  → not LogicFactor|CompareExpr

# --- Relational (Non-Associative) ---
CompareExpr  → ArithExpr < ArithExpr | ArithExpr = ArithExpr | ArithExpr != ArithExpr | ArithExpr

# --- Arithmetic Hierarchy (+ / - < * / /) ---
ArithExpr    → ArithExpr + Term | ArithExpr - Term | Term
Term         → Term * Factor | Term / Factor | Factor

# --- Atoms & Multiple Precedence ---
# Unary Minus (- Factor) is defined here for highest precedence
Factor       → - Factor
             | ( Expr )
             | OBJECT_ID | FLOAT | STRING | BOOL
             | while LogicExpr loop { ExprList } pool
             | if LogicExpr then { ExprList } else { ExprList } fi

# --- Block Structure ---
ExprList     → Expr ; | ExprList Expr ;