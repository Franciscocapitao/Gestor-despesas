module Main (main) where

import Control.Monad (unless)
import System.Exit (exitFailure)

import Domain
import Examples (despesasExemplo, orcamentosExemplo)
import Model

-- | Um teste é um nome e o resultado (verdadeiro = passou).
type Teste = (String, Bool)

testes :: [Teste]
testes =
  [ -- totais
    ("total de lista vazia e 0",            totalDespesas [] == 0)
  , ("total das despesas de exemplo",       totalDespesas despesasExemplo == 13065)
  , ("total Alimentacao",                   totalPorCategoria Alimentacao despesasExemplo == 3380)
  , ("total Transporte",                    totalPorCategoria Transporte despesasExemplo == 4220)
  , ("total de categoria sem despesas",     totalPorCategoria Outros despesasExemplo == 0)
  , ("total de outubro",                    totalDoMes 2026 10 despesasExemplo == 8400)
  , ("total de novembro",                   totalDoMes 2026 11 despesasExemplo == 4665)
  , ("total de mes sem despesas",           totalDoMes 2025 1 despesasExemplo == 0)
    -- selecao e pesquisa
  , ("despesas de Lazer",                   map idDespesa (despesasDaCategoria Lazer despesasExemplo) == [3, 8])
  , ("despesas de categoria vazia",         null (despesasDaCategoria Outros despesasExemplo))
  , ("despesas de outubro",                 contarDespesas (despesasDoMes 2026 10 despesasExemplo) == 4)
  , ("procurar id existente",               fmap descricao (procurarPorId 3 despesasExemplo) == Just "Cinema")
  , ("procurar id inexistente",             procurarPorId 99 despesasExemplo == Nothing)
  , ("maior despesa",                       fmap idDespesa (maiorDespesa despesasExemplo) == Just 2)
  , ("maior despesa de lista vazia",        maiorDespesa [] == Nothing)
  , ("categorias usadas",                   contarCategorias (categoriasUsadas despesasExemplo) == 4)
  , ("categorias usadas (lista vazia)",     null (categoriasUsadas []))
    -- contagem e alteracao
  , ("contar despesas",                     contarDespesas despesasExemplo == 8)
  , ("contar lista vazia",                  contarDespesas [] == 0)
  , ("remover despesa existente",           contarDespesas (removerDespesa 1 despesasExemplo) == 7)
  , ("remover despesa inexistente",         removerDespesa 99 despesasExemplo == despesasExemplo)
    -- ordenacao
  , ("ordenar: primeira e a mais cara",     fmap idDespesa (headMaybe (ordenarPorValor despesasExemplo)) == Just 2)
  , ("ordenar: ultima e a mais barata",     fmap idDespesa (headMaybe (reverse (ordenarPorValor despesasExemplo))) == Just 5)
  , ("ordenar mantem o numero de despesas", contarDespesas (ordenarPorValor despesasExemplo) == 8)
  , ("ordenar lista vazia",                 null (ordenarPorValor []))
    -- orcamentos
  , ("orcamento de Lazer excedido",         excedeOrcamento (orcamentosExemplo !! 1) despesasExemplo)
  , ("orcamento de Alimentacao respeitado", not (excedeOrcamento (head orcamentosExemplo) despesasExemplo))
    -- apresentacao
  , ("formatar 850",                        formatarMontante 850 == "8,50 EUR")
  , ("formatar 5",                          formatarMontante 5 == "0,05 EUR")
  , ("formatar 0",                          formatarMontante 0 == "0,00 EUR")
  , ("formatar negativo",                   formatarMontante (-1250) == "-12,50 EUR")
  , ("formatar data",                       formatarData (Data 2026 11 4) == "2026-11-04")
  ]

-- | Conta o número de categorias numa lista.
contarCategorias :: [Categoria] -> Int
contarCategorias [] = 0
contarCategorias (_:cs) = 1 + contarCategorias cs

headMaybe :: [a] -> Maybe a
headMaybe []    = Nothing
headMaybe (x:_) = Just x

executar :: Teste -> IO Bool
executar (nome, passou) = do
  putStrLn ((if passou then "[OK]    " else "[FALHA] ") ++ nome)
  return passou

main :: IO ()
main = do
  resultados <- mapM executar testes
  let falhas = length (filter not resultados)
  putStrLn ""
  putStrLn (show (length resultados - falhas) ++ "/" ++ show (length resultados) ++ " testes passaram.")
  unless (falhas == 0) exitFailure
