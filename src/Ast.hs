module Ast where

data Operator = Plus | Minus | Times | Divides | Modulo | Equals | NotEqual
    deriving (Eq, Show)

data Expr
    = Var String
    | Integer Int
    | True
    | False
    | Negation Expr
    | Operation Operator Expr Expr
    | Lambda [String] Expr
    | Apply Expr [Expr]
    | Let [(String, Expr)] Expr
    | If Expr Expr Expr
    deriving (Eq, Show)