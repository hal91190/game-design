{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE LambdaCase   #-}
{-# LANGUAGE TupleSections #-}

module Parser where

import Relude hiding (many, some)
import Data.Text (unpack)
import Text.Megaparsec( (<?>), between, choice, many, some, sepBy, try, Parsec )
import Text.Megaparsec.Char ( alphaNumChar, letterChar, space1 )
import qualified Control.Monad.Combinators.Expr as CE
import qualified Text.Megaparsec.Char.Lexer as L

import Ast (Expr(..))

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
    p = (:) <$> letterChar <*> many alphaNumChar
    check x = if x `elem` rws
              then fail $ "keyword " ++ show x ++ " cannot be a variable name"
              else pure x

pTerm :: Parser Expr
pTerm = choice [pIf, pLet, pLambda, parens pExpr, pList, pVariable, pInteger]

pVariable :: Parser Expr
pVariable = Var <$> identifier

pInteger :: Parser Expr
pInteger = Integer <$> lexeme L.decimal

parens :: Parser a -> Parser a
parens = between (symbol "(") (symbol ")")

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

pList :: Parser Expr
pList = List <$> between (symbol "[") (symbol "]") (pExpr `sepBy` symbol ",")

pTermList :: Parser Expr 
pTermList =
    some pTerm >>= \case
        [l] -> pure l
        y : ys -> pure $ Apply y ys
        _ -> fail "impossible has happened"

pExpr :: Parser Expr
pExpr = CE.makeExprParser pTermList operatorTable

operatorTable :: [[CE.Operator Parser Expr]]
operatorTable =
    [ --[ prefix "-" Negation
     -- ]
      [ binary "*"
      , binary "/"
      ]
    , [ binary "+"
      , binary "-"
      ]
    , [ binary "=="
      , binary "/="
      ]
    ]

binary :: Text -> CE.Operator Parser Expr
binary  name = CE.InfixL (f <$ symbol name)
  where
    f x y = Apply (Var $ unpack name) [x, y]

prefix :: Text -> (Expr -> Expr) -> CE.Operator Parser Expr
prefix  name f = CE.Prefix  (f <$ symbol name)

pStatement :: Parser (String, Expr)
pStatement = do
    var <- identifier
    args <- many identifier
    void $ symbol "="
    if null args then
        (var,) <$> pExpr
    else
        (var,) . Lambda args <$> pExpr

pFile :: Parser [(String, Expr)]
pFile = pStatement `sepBy` symbol ";"
