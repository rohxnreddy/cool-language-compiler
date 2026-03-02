(Expr)
 ├── TYPE_ID (Int)
 ├── OBJECT_ID (result)
 ├── <-
 └── (LogicExpr)
      └── (LogicTerm)
           └── (LogicFactor)
                └── (CompareExpr)
                     └── (ArithExpr)
                          ├── (ArithExpr)
                          │    └── (Term)
                          │         └── (Factor)
                          │              ├── -
                          │              └── (Factor) -> FLOAT (5)
                          ├── +
                          └── (Term)
                               ├── (Term)
                               │    └── (Factor) -> FLOAT (10)
                               ├── *
                               └── (Factor) -> FLOAT (2)