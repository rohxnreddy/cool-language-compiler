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
            ArithExpr - Term
          | Term

Term → Term * Factor
       Term / Factor
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


