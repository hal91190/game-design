module Eval where

import Relude
import qualified Data.Map as Map
import Ast

type ThrowsError = Either String
type Env = Map String Expr

consImpl :: [Expr] -> ThrowsError Expr
consImpl [expr1, List l] = Right $ List (expr1 : l)
consImpl [_, _] = Left "Second argument of cons is not a list"
consImpl _ = Left "Invalid number of arguments"

headImpl :: [Expr] -> ThrowsError Expr
headImpl [List (x : _)] = Right x
headImpl [List _] = Left "Empty list has no head"
headImpl [_] = Left "Wrong argument"
headImpl _ = Left "Invalid number of arguments"

tailImpl :: [Expr] -> ThrowsError Expr
tailImpl [List (_ : xs)] = Right (List xs)
tailImpl [List _] = Left "Empty list has no head"
tailImpl [_] = Left "Wrong argument"
tailImpl _ = Left "Invalid number of arguments"

emptyImpl :: [Expr] -> ThrowsError Expr
emptyImpl [List []] = Right MTrue
emptyImpl [_] = Right MFalse
emptyImpl _ = Left "Invalid number of arguments"

intBinaryOp :: (Int -> Int -> Int) -> [Expr] -> ThrowsError Expr
intBinaryOp op [Integer x, Integer y] = Right $ Integer (op x y)
intBinaryOp _ [_, _] = Left "One argument is not an intger"
intBinaryOp _ _ = Left "Invalid number of arguments"

equalsImpl :: [Expr] -> ThrowsError Expr
equalsImpl [Integer x, Integer y] = Right $ if x == y then MTrue else MFalse
equalsImpl [_, _] = Left "One argument is not an intger"
equalsImpl _ = Left "Invalid number of arguments"

primitives :: Map String Expr
primitives = Map.fromList
             [ ("+", Primitive $ intBinaryOp (+))
             , ("-", Primitive $ intBinaryOp (-))
             , ("*", Primitive $ intBinaryOp (*))
             , ("/", Primitive $ intBinaryOp div)
             , ("==", Primitive equalsImpl)
             , ("cons", Primitive consImpl)
             , ("head", Primitive headImpl)
             , ("tail", Primitive tailImpl)
             , ("empty", Primitive emptyImpl)
            ]

isTrue :: Expr -> Bool
isTrue MFalse = False
isTrue (Integer 0) = False
isTrue _ = True

eval :: Env -> Expr -> ThrowsError Expr
eval env (List l) = List <$> mapM (eval env) l
eval env (Var a) =
    case Map.lookup a env <|> Map.lookup a primitives of
        Just e -> Right e
        Nothing -> Left $ a ++ " is not defined"
eval env (Apply fn args) = do
    fn' <- eval env fn
    args' <- mapM (eval env) args
    case fn' of
        Primitive f -> f args'
        Lambda names expr ->
            let env' = Map.union (Map.fromList (zip names args')) env in
            eval env' expr
        _ -> Left $ show fn' <> " is not a function"
eval env (If expr1 expr2 expr3) = do
    expr1' <- eval env expr1
    if isTrue expr1' then
        eval env expr2
    else
        eval env expr3
eval env (Let vars expr) = do
    let env' = Map.union (Map.fromList vars) env 
    vars' <- mapM (\(var, val) -> (var,) <$> eval env' val) vars
    let env'' = Map.union (Map.fromList vars') env 
    eval env'' expr
eval _ x = Right x
