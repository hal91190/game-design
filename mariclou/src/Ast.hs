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
    show (Var s) = s
    show (Apply f args) = "(" ++ show f ++ " " ++ show args ++ ")"
    show (Lambda args e) = "\\" ++ show args ++ "->" ++ show e
    show (If e1 e2 e3) = "if " ++ show e1 ++ " then " ++ show e2 ++ " else " ++ show e3
    show (Let vars expr) = "let " ++ show vars ++ " in " ++ show expr
    show (Primitive _) = "#primitive" 