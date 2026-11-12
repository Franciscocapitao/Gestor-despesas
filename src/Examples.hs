module Examples
  ( despesasExemplo
  , orcamentosExemplo
  ) where

import Model

-- | Pequeno conjunto de dados para demonstrar e testar as funções do domínio.
despesasExemplo :: [Despesa]
despesasExemplo =
  [ Despesa 1 "Almoco"               850 Alimentacao (Data 2026 10  2)
  , Despesa 2 "Passe mensal"        4000 Transporte  (Data 2026 10  3)
  , Despesa 3 "Cinema"              1200 Lazer       (Data 2026 10 10)
  , Despesa 4 "Compras"             2350 Alimentacao (Data 2026 10 15)
  , Despesa 5 "Cafe"                 180 Alimentacao (Data 2026 11  1)
  , Despesa 6 "Bilhete de autocarro" 220 Transporte  (Data 2026 11  2)
  , Despesa 7 "Farmacia"             765 Saude       (Data 2026 11  3)
  , Despesa 8 "Concerto"            3500 Lazer       (Data 2026 11  4)
  ]

-- | Orçamentos de exemplo (valores em cêntimos).
orcamentosExemplo :: [Orcamento]
orcamentosExemplo =
  [ Orcamento Alimentacao 5000
  , Orcamento Lazer       4000
  ]
