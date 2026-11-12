module Domain
  ( -- * Totais
    totalDespesas
  , totalPorCategoria
  , totalDoMes
    -- * Seleção e pesquisa
  , despesasDaCategoria
  , despesasDoMes
  , procurarPorId
  , maiorDespesa
  , categoriasUsadas
    -- * Contagem e alteração
  , contarDespesas
  , removerDespesa
    -- * Ordenação
  , ordenarPorValor
    -- * Orçamentos
  , excedeOrcamento
    -- * Apresentação
  , formatarMontante
  , formatarData
  ) where

import Model

-- ---------------------------------------------------------------
-- Totais
-- ---------------------------------------------------------------

-- | Soma recursivamente o valor de todas as despesas.
totalDespesas :: [Despesa] -> Centimos
totalDespesas [] = 0
totalDespesas (d:ds) = valorCentimos d + totalDespesas ds

-- | Soma recursivamente apenas as despesas da categoria indicada.
totalPorCategoria :: Categoria -> [Despesa] -> Centimos
totalPorCategoria _ [] = 0
totalPorCategoria cat (d:ds)
  | categoria d == cat = valorCentimos d + totalPorCategoria cat ds
  | otherwise          = totalPorCategoria cat ds

-- | Total gasto num determinado ano e mês.
totalDoMes :: Int -> Int -> [Despesa] -> Centimos
totalDoMes a m ds = totalDespesas (despesasDoMes a m ds)

-- ---------------------------------------------------------------
-- Seleção e pesquisa
-- ---------------------------------------------------------------

-- | Devolve as despesas que pertencem à categoria indicada.
despesasDaCategoria :: Categoria -> [Despesa] -> [Despesa]
despesasDaCategoria _ [] = []
despesasDaCategoria cat (d:ds)
  | categoria d == cat = d : despesasDaCategoria cat ds
  | otherwise          = despesasDaCategoria cat ds

-- | Devolve as despesas feitas num determinado ano e mês.
despesasDoMes :: Int -> Int -> [Despesa] -> [Despesa]
despesasDoMes _ _ [] = []
despesasDoMes a m (d:ds)
  | ano dt == a && mes dt == m = d : resto
  | otherwise                  = resto
  where
    dt    = dataDespesa d
    resto = despesasDoMes a m ds

-- | Procura uma despesa pelo seu identificador.
-- Devolve 'Nothing' se não existir.
procurarPorId :: Int -> [Despesa] -> Maybe Despesa
procurarPorId _ [] = Nothing
procurarPorId i (d:ds)
  | idDespesa d == i = Just d
  | otherwise        = procurarPorId i ds

-- | Devolve a despesa de maior valor, ou 'Nothing' se a lista for vazia.
maiorDespesa :: [Despesa] -> Maybe Despesa
maiorDespesa [] = Nothing
maiorDespesa (d:ds) =
  case maiorDespesa ds of
    Nothing -> Just d
    Just m
      | valorCentimos d >= valorCentimos m -> Just d
      | otherwise                          -> Just m

-- | Lista (sem repetições) as categorias que têm pelo menos uma despesa.
categoriasUsadas :: [Despesa] -> [Categoria]
categoriasUsadas [] = []
categoriasUsadas (d:ds)
  | categoria d `elem` restantes = restantes
  | otherwise                    = categoria d : restantes
  where
    restantes = categoriasUsadas ds

-- ---------------------------------------------------------------
-- Contagem e alteração
-- ---------------------------------------------------------------

-- | Conta recursivamente o número de despesas.
contarDespesas :: [Despesa] -> Int
contarDespesas [] = 0
contarDespesas (_:ds) = 1 + contarDespesas ds

-- | Remove a despesa com o identificador indicado (se existir).
removerDespesa :: Int -> [Despesa] -> [Despesa]
removerDespesa _ [] = []
removerDespesa i (d:ds)
  | idDespesa d == i = ds
  | otherwise        = d : removerDespesa i ds

-- ---------------------------------------------------------------
-- Ordenação
-- ---------------------------------------------------------------

-- | Ordena as despesas da mais cara para a mais barata (ordenação por inserção).
ordenarPorValor :: [Despesa] -> [Despesa]
ordenarPorValor [] = []
ordenarPorValor (d:ds) = inserirPorValor d (ordenarPorValor ds)

-- | Insere uma despesa numa lista já ordenada (do maior para o menor valor).
inserirPorValor :: Despesa -> [Despesa] -> [Despesa]
inserirPorValor d [] = [d]
inserirPorValor d (x:xs)
  | valorCentimos d >= valorCentimos x = d : x : xs
  | otherwise                          = x : inserirPorValor d xs

-- ---------------------------------------------------------------
-- Orçamentos
-- ---------------------------------------------------------------

-- | Indica se o total gasto na categoria do orçamento ultrapassa o limite.
excedeOrcamento :: Orcamento -> [Despesa] -> Bool
excedeOrcamento o ds =
  totalPorCategoria (orcCategoria o) ds > orcLimiteCentimos o

-- ---------------------------------------------------------------
-- Apresentação
-- ---------------------------------------------------------------

-- | Converte um montante em cêntimos para texto em euros (ex.: 850 -> "8,50 EUR").
formatarMontante :: Centimos -> String
formatarMontante montante
  | montante < 0 = "-" ++ formatarMontante (negate montante)
  | otherwise    = show euros ++ "," ++ doisDigitos centimos ++ " EUR"
  where
    (euros, centimos) = montante `divMod` 100

-- | Formata uma data como AAAA-MM-DD.
formatarData :: Data -> String
formatarData (Data a m d) =
  show a ++ "-" ++ doisDigitos (toInteger m) ++ "-" ++ doisDigitos (toInteger d)

-- | Escreve um número com pelo menos dois dígitos (5 -> "05").
doisDigitos :: Integer -> String
doisDigitos n
  | n < 10    = "0" ++ show n
  | otherwise = show n
