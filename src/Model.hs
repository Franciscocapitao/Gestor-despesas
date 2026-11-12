module Model
  ( Centimos
  , Categoria(..)
  , Data(..)
  , Despesa(..)
  , Orcamento(..)
  ) where

-- | Valores monetários guardados em cêntimos (inteiros), para evitar
-- imprecisões de vírgula flutuante.
type Centimos = Integer

-- | Categorias disponíveis para classificar uma despesa.
data Categoria
  = Alimentacao
  | Transporte
  | Lazer
  | Saude
  | Outros
  deriving (Eq, Show, Enum, Bounded)

-- | Data de calendário simples (ano, mês, dia).
-- O 'Ord' derivado compara por ano, depois mês, depois dia.
data Data = Data
  { ano :: Int
  , mes :: Int
  , dia :: Int
  } deriving (Eq, Ord, Show)

-- | Uma despesa. O valor é guardado em cêntimos (inteiro) para evitar
-- imprecisões de vírgula flutuante nos cálculos monetários.
data Despesa = Despesa
  { idDespesa     :: Int
  , descricao     :: String
  , valorCentimos :: Centimos
  , categoria     :: Categoria
  , dataDespesa   :: Data
  } deriving (Eq, Show)

-- | Limite de gasto (em cêntimos) definido para uma categoria.
data Orcamento = Orcamento
  { orcCategoria      :: Categoria
  , orcLimiteCentimos :: Centimos
  } deriving (Eq, Show)
