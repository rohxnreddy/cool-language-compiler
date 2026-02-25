# CFG for COOL

## Start Symbol
```
Program → ClassList
```
---

## Classes
```
ClassList → Class ClassList
          | Class

Class → class TYPE { FeatureList } ;

FeatureList → Feature FeatureList
            | ε

Feature → ID ( ) : TYPE { Expr } ;
```
---
## Expressions
```
Expr → LetExpr
     | AssignExpr
     | WhileExpr
     | IfExpr
     | Block
     | ArithExpr
     | BoolExpr
     | ID
     | INT
     | BOOL
     | STRING
     | FunctionCall
```
---

## Let Expression
```
LetExpr → let LetDeclList in Expr

LetDeclList → LetDecl , LetDeclList
            | LetDecl

LetDecl → ID : TYPE
        | ID : TYPE ← Expr
```

---

## Assignment
```
AssignExpr → ID ← Expr
```

---

## While Loop
```
WhileExpr → while Expr loop Expr pool
```

---

## If Statement
```
IfExpr → if Expr then Expr else Expr fi
```

---

## Block
```
Block → { ExprList }

ExprList → Expr ;
         | Expr ; ExprList
```
---

## Arithmetic Expressions (With Precedence)
```
ArithExpr → ArithExpr + Term
          | Term

Term → Term * Factor
     | Factor

Factor → ID
       | INT
       | ( Expr )
```

---

## Boolean Expressions
```
BoolExpr → Expr < Expr
         | Expr and Expr
         | not Expr
         | BOOL
```

---

## Function Call
```
FunctionCall → ID ( ArgList )

ArgList → Expr , ArgList
        | Expr
        | ε
```

---

# Parse Tree
```
Program
└── ClassList
    └── Class
        ├── class
        ├── TYPE (Main)
        ├── {
        ├── FeatureList
        │   └── Feature
        │       ├── ID (main)
        │       ├── ( )
        │       ├── :
        │       ├── TYPE (Object)
        │       └── Expr
        │           └── Block
        │               └── {
        │                   └── Expr
        │                       └── LetExpr
        │                           ├── let
        │                           ├── LetDeclList
        │                           │   ├── x : Int
        │                           │   ├── y : Int ← 2
        │                           │   ├── z : Int ← 3
        │                           │   └── flag : Bool ← false
        │                           ├── in
        │                           └── Block
        │                               └── {
        │                                   ├── AssignExpr
        │                                   │   ├── x
        │                                   │   ├── ←
        │                                   │   └── 1
        │                                   │
        │                                   ├── AssignExpr
        │                                   │   ├── z
        │                                   │   ├── ←
        │                                   │   └── ArithExpr
        │                                   │       ├── x
        │                                   │       ├── +
        │                                   │       └── Term
        │                                   │           ├── y
        │                                   │           ├── *
        │                                   │           └── 2
        │                                   │
        │                                   ├── WhileExpr
        │                                   │   ├── while
        │                                   │   ├── BoolExpr (z > 0)
        │                                   │   ├── loop
        │                                   │   └── Block
        │                                   │       └── z ← z - 1
        │                                   │   └── pool
        │                                   │
        │                                   └── IfExpr
        │                                       ├── if
        │                                       ├── BoolExpr
        │                                       │   ├── (x < y)
        │                                       │   ├── and
        │                                       │   └── not flag
        │                                       ├── then
        │                                       │   └── out_string("Condition True\n")
        │                                       ├── else
        │                                       │   └── out_string("Condition False\n")
        │                                       └── fi
        │
        ├── }
        └── ;
```        