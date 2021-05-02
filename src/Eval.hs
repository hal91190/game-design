{-# LANGUAGE TupleSections #-}
module Eval where
import Control.Applicative ((<|>))
import Control.Monad.Except
import Data.Map (Map)
import qualified Data.Map as Map
import Ast

type ThrowsError = Either String
type Env = Map String Expr

consImpl :: [Expr] -> ThrowsError Expr
consImpl [expr1, List l] = Right $ List (expr1 : l)
consImpl [_, _] = Left "Second argument of cons is not a list"
consImpl _ = Left "Invalid number of arguments"

headImpl :: [Expr] -> ThrowsError Expr
headImpl [List (x : xs)] = Right x
headImpl [List _] = Left "Empty list has no head"
headImpl [_] = Left "Wrong argument"
headImpl _ = Left "Invalid number of arguments"

tailImpl :: [Expr] -> ThrowsError Expr
tailImpl [List (x : xs)] = Right (List xs)
tailImpl [List _] = Left "Empty list has no head"
tailImpl [_] = Left "Wrong argument"
tailImpl _ = Left "Invalid number of arguments"

intBinaryOp :: (Int -> Int -> Int) -> [Expr] -> ThrowsError Expr
intBinaryOp op [Integer x, Integer y] = Right $ Integer (op x y)
intBinaryOp op [_, _] = Left "One argument is not an intger"
intBinaryOp op _ = Left "Invalid number of arguments"

equalsImpl :: [Expr] -> ThrowsError Expr
equalsImpl [Integer x, Integer y] = Right $ if x == y then MTrue else MFalse
equalsImpl [_, _] = Left "One argument is not an intger"

primitives :: [(String, Expr)]
primitives = [ ("+", Primitive $ intBinaryOp (+))
             , ("-", Primitive $ intBinaryOp (-))
             , ("*", Primitive $ intBinaryOp (*))
             , ("/", Primitive $ intBinaryOp div)
             , ("==", Primitive $ equalsImpl)
             , ("cons", Primitive $ consImpl)
             , ("head", Primitive $ headImpl)
             , ("tail", Primitive $ tailImpl)
            ]

isTrue :: Expr -> Bool
isTrue MFalse = False
isTrue (Integer 0) = False
isTrue _ = True

eval :: Env -> Expr -> ThrowsError Expr
eval env (List l) = List <$> mapM (eval env) l
eval env (Var a) =
    case Map.lookup a env <|> lookup a primitives of
        Just e -> Right e
        Nothing -> Left "meuh"
eval env (Apply fn args) = do
    fn' <- eval env fn
    args' <- mapM (eval env) args
    case fn' of
        Primitive f -> f args'
        Lambda names expr ->
            let env' = Map.union (Map.fromList (zip names args')) env in
            eval env' expr
eval env (If expr1 expr2 expr3) = do
    expr1' <- eval env expr1
    if isTrue expr1' then
        eval env expr2
    else
        eval env expr3
eval env (Let vars expr) = do
    let env' = Map.union (Map.fromList vars) env 
    vars' <- mapM (\(var, val) -> (var,) <$> eval env val) vars
    let env'' = Map.union (Map.fromList vars') env 
    eval env'' expr
eval env x = Right x