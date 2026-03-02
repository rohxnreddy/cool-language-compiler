```
Program
└── ClassList
    └── Class
        ├── class
        ├── TYPE (Main)
        ├── {
        ├── FeatureList
        │   ├── Feature
        │   │   ├── ID (main)
        │   │   ├── (
        │   │   ├── )
        │   │   ├── :
        │   │   ├── TYPE (Object)
        │   │   ├── {
        │   │   ├── Expr (Block)
        │   │   │   ├── {
        │   │   │   ├── ExprList
        │   │   │   │   ├── Expr (LetExpr)
        │   │   │   │   │   ├── let
        │   │   │   │   │   ├── LetDeclList
        │   │   │   │   │   │   ├── LetDecl
        │   │   │   │   │   │   │   ├── ID (x)
        │   │   │   │   │   │   │   ├── :
        │   │   │   │   │   │   │   └── TYPE (Int)
        │   │   │   │   │   │   ├── ,
        │   │   │   │   │   │   └── LetDeclList
        │   │   │   │   │   │       ├── LetDecl
        │   │   │   │   │   │       │   ├── ID (y)
        │   │   │   │   │   │       │   ├── :
        │   │   │   │   │   │       │   ├── TYPE (Int)
        │   │   │   │   │   │       │   ├── <-
        │   │   │   │   │   │       │   └── Expr (INT: 2)
        │   │   │   │   │   │       ├── ,
        │   │   │   │   │   │       └── LetDeclList
        │   │   │   │   │   │           ├── LetDecl
        │   │   │   │   │   │           │   ├── ID (z)
        │   │   │   │   │   │           │   ├── :
        │   │   │   │   │   │           │   ├── TYPE (Int)
        │   │   │   │   │   │           │   ├── <-
        │   │   │   │   │   │           │   └── Expr (INT: 3)
        │   │   │   │   │   │           ├── ,
        │   │   │   │   │   │           └── LetDeclList
        │   │   │   │   │   │               └── LetDecl
        │   │   │   │   │   │                   ├── ID (flag)
        │   │   │   │   │   │                   ├── :
        │   │   │   │   │   │                   ├── TYPE (Bool)
        │   │   │   │   │   │                   ├── <-
        │   │   │   │   │   │                   └── Expr (BOOL: false)
        │   │   │   │   │   ├── in
        │   │   │   │   │   └── Expr (Block)
        │   │   │   │   │       ├── {
        │   │   │   │   │       ├── ExprList
        │   │   │   │   │       │   ├── Expr (AssignExpr)
        │   │   │   │   │       │   │   ├── ID (x)
        │   │   │   │   │       │   │   ├── <-
        │   │   │   │   │       │   │   └── Expr (INT: 1)
        │   │   │   │   │       │   ├── ;
        │   │   │   │   │       │   └── ExprList
        │   │   │   │   │       │       ├── Expr (AssignExpr)
        │   │   │   │   │       │       │   ├── ID (z)
        │   │   │   │   │       │       │   ├── <-
        │   │   │   │   │       │       │   └── Expr (ArithExpr)
        │   │   │   │   │       │       │       ├── ArithExpr
        │   │   │   │   │       │       │       │   └── Term
        │   │   │   │   │       │       │       │       └── Factor
        │   │   │   │   │       │       │       │           └── ID (x)
        │   │   │   │   │       │       │       ├── +
        │   │   │   │   │       │       │       └── Term
        │   │   │   │   │       │       │           ├── Term
        │   │   │   │   │       │       │           │   └── Factor
        │   │   │   │   │       │       │           │       └── ID (y)
        │   │   │   │   │       │       │           ├── *
        │   │   │   │   │       │       │           └── Factor
        │   │   │   │   │       │       │               └── INT (2)
        │   │   │   │   │       │       ├── ;
        │   │   │   │   │       │       └── ExprList
        │   │   │   │   │       │           ├── Expr (WhileExpr)
        │   │   │   │   │       │           │   ├── while
        │   │   │   │   │       │           │   ├── Expr (BoolExpr)
        │   │   │   │   │       │           │   │   ├── Expr (INT: 0)
        │   │   │   │   │       │           │   │   ├── <
        │   │   │   │   │       │           │   │   └── Expr (ID: z)
        │   │   │   │   │       │           │   ├── loop
        │   │   │   │   │       │           │   ├── Expr (Block)
        │   │   │   │   │       │           │   │   ├── {
        │   │   │   │   │       │           │   │   ├── ExprList
        │   │   │   │   │       │           │   │   │   ├── Expr (AssignExpr)
        │   │   │   │   │       │           │   │   │   │   ├── ID (z)
        │   │   │   │   │       │           │   │   │   │   ├── <-
        │   │   │   │   │       │           │   │   │   │   └── Expr (ArithExpr)
        │   │   │   │   │       │           │   │   │   │       ├── ArithExpr
        │   │   │   │   │       │           │   │   │   │       │   └── Term
        │   │   │   │   │       │           │   │   │   │       │       └── Factor
        │   │   │   │   │       │           │   │   │   │       │           └── ID (z)
        │   │   │   │   │       │           │   │   │   │       ├── -
        │   │   │   │   │       │           │   │   │   │       └── Term
        │   │   │   │   │       │           │   │   │   │           └── Factor
        │   │   │   │   │       │           │   │   │   │               └── INT (1)
        │   │   │   │   │       │           │   │   │   └── ;
        │   │   │   │   │       │           │   │   └── }
        │   │   │   │   │       │           │   └── pool
        │   │   │   │   │       │           ├── ;
        │   │   │   │   │       │           └── ExprList
        │   │   │   │   │       │               ├── Expr (IfExpr)
        │   │   │   │   │       │               │   ├── if
        │   │   │   │   │       │               │   ├── Expr (BoolExpr)
        │   │   │   │   │       │               │   │   ├── Expr (ArithExpr)
        │   │   │   │   │       │               │   │   │   └── Term
        │   │   │   │   │       │               │   │   │       └── Factor
        │   │   │   │   │       │               │   │   │           ├── (
        │   │   │   │   │       │               │   │   │           ├── Expr (BoolExpr)
        │   │   │   │   │       │               │   │   │           │   ├── Expr (ID: x)
        │   │   │   │   │       │               │   │   │           │   ├── <
        │   │   │   │   │       │               │   │   │           │   └── Expr (ID: y)
        │   │   │   │   │       │               │   │   │           └── )
        │   │   │   │   │       │               │   │   ├── and
        │   │   │   │   │       │               │   │   └── Expr (BoolExpr)
        │   │   │   │   │       │               │   │       ├── not
        │   │   │   │   │       │               │   │       └── Expr (ID: flag)
        │   │   │   │   │       │               │   ├── then
        │   │   │   │   │       │               │   ├── Expr (FunctionCall)
        │   │   │   │   │       │               │   │   ├── ID (out_string)
        │   │   │   │   │       │               │   │   ├── (
        │   │   │   │   │       │               │   │   ├── ArgList
        │   │   │   │   │       │               │   │   │   └── Expr (STRING: "Condition True\n")
        │   │   │   │   │       │               │   │   └── )
        │   │   │   │   │       │               │   ├── else
        │   │   │   │   │       │               │   ├── Expr (FunctionCall)
        │   │   │   │   │       │               │   │   ├── ID (out_string)
        │   │   │   │   │       │               │   │   ├── (
        │   │   │   │   │       │               │   │   ├── ArgList
        │   │   │   │   │       │               │   │   │   └── Expr (STRING: "Condition False\n")
        │   │   │   │   │       │               │   │   └── )
        │   │   │   │   │       │               │   └── fi
        │   │   │   │   │       │               └── ;
        │   │   │   │   │       └── }
        │   │   │   │   └── ;
        │   │   │   └── }
        │   │   ├── }
        │   │   └── ;
        │   └── ε
        ├── }
        └── ;

    ```