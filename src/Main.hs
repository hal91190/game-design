{-# LANGUAGE OverloadedStrings #-}

module Main where
import Text.Megaparsec (parseMaybe) 
import qualified Data.Map as Map
import Parser (pExpr)
import Eval (eval)

main :: IO ()
main = do
  let expr = "let fact = \\n -> if n == 0 then 1 else n * fact (n-1) in fact 6"
  let Just p = parseMaybe pExpr expr
  let p2 = eval Map.empty p
  print expr
  print p2