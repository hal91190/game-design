{-# LANGUAGE OverloadedStrings #-}

module Main where
import Text.Megaparsec (parseTest) 
import Parser (pExpr)

main :: IO ()
main = do
  let expr = "\\n -> if n == 0 then 1 else n * fact (n - 1)"
  putStrLn $ "parse: " <> expr
  parseTest pExpr "\\n -> if n == 0 then [1, 2, 3] else n * fact (n - 1)"
