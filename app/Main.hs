module Main (main) where

import Domain
import Examples (despesasExemplo, orcamentosExemplo)
import Model

main :: IO ()
main = do
  putStrLn "Gestor de Despesas Pessoais - demonstracao da Fase 1"
  putStrLn ""
  putStrLn "Despesas de exemplo:"
  apresentarDespesas despesasExemplo
  putStrLn ""
  putStrLn ("Numero de despesas: " ++ show (contarDespesas despesasExemplo))
  putStrLn ("Total de despesas:  " ++ formatarMontante (totalDespesas despesasExemplo))
  putStrLn ""
  putStrLn "Total por categoria:"
  apresentarTotais [minBound .. maxBound] despesasExemplo
  putStrLn ""
  putStrLn ("Total em 2026-10: " ++ formatarMontante (totalDoMes 2026 10 despesasExemplo))
  putStrLn ("Total em 2026-11: " ++ formatarMontante (totalDoMes 2026 11 despesasExemplo))
  putStrLn ""
  putStrLn "Despesas de Lazer:"
  apresentarDespesas (despesasDaCategoria Lazer despesasExemplo)
  putStrLn ""
  putStrLn "Maior despesa:"
  case maiorDespesa despesasExemplo of
    Nothing -> putStrLn "  (nenhuma)"
    Just d  -> apresentarDespesas [d]
  putStrLn ""
  putStrLn "Despesas ordenadas por valor (da maior para a menor):"
  apresentarDespesas (ordenarPorValor despesasExemplo)
  putStrLn ""
  putStrLn "Pesquisa por id 3:"
  case procurarPorId 3 despesasExemplo of
    Nothing -> putStrLn "  (nao encontrada)"
    Just d  -> apresentarDespesas [d]
  putStrLn "Pesquisa por id 99:"
  case procurarPorId 99 despesasExemplo of
    Nothing -> putStrLn "  (nao encontrada)"
    Just d  -> apresentarDespesas [d]
  putStrLn ""
  putStrLn ("Apos remover a despesa 1 ficam " ++ show (contarDespesas (removerDespesa 1 despesasExemplo)) ++ " despesas.")
  putStrLn ""
  putStrLn "Orcamentos:"
  apresentarOrcamentos orcamentosExemplo despesasExemplo

-- | Mostra uma lista de despesas, uma por linha (recursivo).
apresentarDespesas :: [Despesa] -> IO ()
apresentarDespesas [] = putStrLn "  (nenhuma)"
apresentarDespesas [d] = putStrLn (linhaDespesa d)
apresentarDespesas (d:ds) = do
  putStrLn (linhaDespesa d)
  apresentarDespesas ds

linhaDespesa :: Despesa -> String
linhaDespesa d =
  "  #" ++ show (idDespesa d) ++ " | " ++ formatarData (dataDespesa d)
    ++ " | " ++ descricao d
    ++ " | " ++ formatarMontante (valorCentimos d)
    ++ " | " ++ show (categoria d)

-- | Mostra o total gasto em cada categoria da lista (recursivo).
apresentarTotais :: [Categoria] -> [Despesa] -> IO ()
apresentarTotais [] _ = return ()
apresentarTotais (c:cs) ds = do
  putStrLn ("  " ++ show c ++ ": " ++ formatarMontante (totalPorCategoria c ds))
  apresentarTotais cs ds

-- | Indica, para cada orçamento, se o limite foi ou não ultrapassado.
apresentarOrcamentos :: [Orcamento] -> [Despesa] -> IO ()
apresentarOrcamentos [] _ = return ()
apresentarOrcamentos (o:os) ds = do
  putStrLn
    ("  " ++ show (orcCategoria o)
      ++ " (limite " ++ formatarMontante (orcLimiteCentimos o) ++ "): "
      ++ (if excedeOrcamento o ds then "EXCEDIDO" else "dentro do limite"))
  apresentarOrcamentos os ds
