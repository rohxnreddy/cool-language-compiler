# --- Top-Level Structure ---
Program      → Class
Class        → class TYPE_ID { FeatureList } ;

FeatureList  → Feature
             | FeatureList Feature

Feature      → OBJECT_ID ( ) : TYPE_ID { Expr } ;
             | OBJECT_ID ( ) : TYPE_ID { ExprList } ;

# --- Expression Hierarchy ---
Expr         → AssignExpr
             | LogicExpr

# Assignment (Right-Associative)
AssignExpr   → OBJECT_ID <- Expr

# Logic Stratification (Precedence: OR < AND < NOT)
LogicExpr    → LogicExpr or LogicTerm
             | LogicTerm

LogicTerm    → LogicTerm and LogicFactor
             | LogicFactor

LogicFactor  → not LogicFactor
             | CompareExpr

# Relational (Non-Associative)
CompareExpr  → ArithExpr < ArithExpr
             | ArithExpr = ArithExpr
             | ArithExpr != ArithExpr
             | ArithExpr

# Arithmetic (Binary Precedence: + / - < * / /)
ArithExpr    → ArithExpr + Term
             | ArithExpr - Term
             | Term

Term         → Term * Factor
             | Term / Factor
             | Factor

# Atoms & High Precedence Unary Operators
# MULTIPLE PRECEDENCE: MINUS appears here (Unary) and in ArithExpr (Binary)
Factor       → - Factor                  # Unary Negation (Highest Arithmetic Precedence)
             | OBJECT_ID
             | FLOAT
             | STRING
             | BOOL
             | ( Expr )
             | { }                       # Empty stub
             | { ExprList }              # Scoped block
             | while LogicExpr loop Expr pool
             | if LogicExpr then Expr else Expr fi

# Block Structure (Left-Recursive & Stack-Safe)
ExprList     → Expr ;
             | ExprList Expr ;