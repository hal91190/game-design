{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE LambdaCase   #-}
{-# LANGUAGE TupleSections #-}

{- |
>>> 2+2
-}
module Main where
import Relude
import Data.Text.IO as IO
import Text.Megaparsec (parse) 
import qualified Data.Map as Map
import Parser (pExpr, pFile)
import Eval (eval)

main :: IO ()
main = do
    code <- IO.readFile "./test.mc"
    let Right env = parse pFile "./test.mc" code
    let exprText = "map (\\x -> x * x) [1, 2, 3]"
    let Right expr = parse pExpr "expr" exprText
    print $ eval (Map.fromList env) expr
    --let p2 = eval Map.empty p
    --print expr
    --print p2