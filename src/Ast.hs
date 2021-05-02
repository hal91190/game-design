module Ast where

data Expr
    = Var String
    | Integer Int
    | MTrue | MFalse
    | List [Expr]
    | Primitive ([Expr] -> Either String Expr)
    | Lambda [String] Expr
    | Apply Expr [Expr]
    | Let [(String, Expr)] Expr
    | If Expr Expr Expr

instance Show Expr where
    show (Integer x) = show x
    show (List l) = show l
    show MTrue = "true"
    show MFalse = "false"