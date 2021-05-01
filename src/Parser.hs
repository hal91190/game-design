{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}

module Parser where

import Control.Monad (void)
import Data.Text (Text)
import Data.Void (Void)
import Text.Megaparsec
    ( (<?>), between, choice, some, many, try, Parsec )
import Text.Megaparsec.Char ( alphaNumChar, letterChar, space1 )
import qualified Control.Monad.Combinators.Expr as CE
import qualified Data.Text as T
import qualified Text.Megaparsec.Char.Lexer as L

import Ast (Expr(..), Operator(..))

type Parser = Parsec Void Text

sc :: Parser ()
sc = L.space
  space1                         
  (L.skipLineComment "//")       
  (L.skipBlockComment "/*" "*/")

lexeme :: Parser a -> Parser a
lexeme = L.lexeme sc

symbol :: Text -> Parser Text
symbol = L.symbol sc

rws :: [String] -- list of reserved words
rws = ["if", "then", "else", "let", "in"]

identifier :: Parser String
identifier = (lexeme . try) (p >>= check)
  where
    p       = (:) <$> letterChar <*> many alphaNumChar
    check x = if x `elem` rws
              then fail $ "keyword " ++ show x ++ " cannot be a variable name"
              else pure x

pVariable :: Parser Expr
pVariable = Var <$> identifier

pInteger :: Parser Expr
pInteger = Integer <$> lexeme L.decimal

parens :: Parser a -> Parser a
parens = between (symbol "(") (symbol ")")

pTerm :: Parser Expr
pTerm = choice [pIf, pLet, pLambda, parens pExpr, pVariable, pInteger]

pIf :: Parser Expr
pIf = do
  void $ symbol "if"
  expr1 <- pExpr
  void $ symbol "then"
  expr2 <- pExpr
  void $ symbol "else"
  If expr1 expr2 <$> pExpr

pLet :: Parser Expr
pLet = do
  void $ symbol "let"
  var <- identifier
  void $ symbol "="
  expr1 <- pExpr
  void $ symbol "in"
  Let [(var, expr1)] <$> pExpr

pLambda :: Parser Expr
pLambda = do
  void $ symbol "\\"
  vars <- many identifier
  void $ symbol "->"
  Lambda vars <$> pExpr

pTerm2 :: Parser Expr 
pTerm2 = do
  x <- some pTerm
  case x of
    [l] -> pure l
    y : ys -> pure $ Apply y ys 

pExpr :: Parser Expr
pExpr = CE.makeExprParser pTerm2 operatorTable

operatorTable :: [[CE.Operator Parser Expr]]
operatorTable =
  [ [ prefix "-" Negation
    ]
  , [ binary "*" (Operation Times)
    , binary "/" (Operation Divides)
    ]
  , [ binary "+" (Operation Plus)
    , binary "-" (Operation Minus)
    ]
  , [ binary "==" (Operation Equals)
    , binary "/=" (Operation NotEqual)
    ]
  ]

binary :: Text -> (Expr -> Expr -> Expr) -> CE.Operator Parser Expr
binary  name f = CE.InfixL  (f <$ symbol name)

prefix :: Text -> (Expr -> Expr) -> CE.Operator Parser Expr
prefix  name f = CE.Prefix  (f <$ symbol name)
