# Explicação dos ficheiros

## Ideia geral

O projeto separa **dados** (Model), **lógica** (Domain) e **interação com o exterior** (Main):

```
Model.hs  ->  Domain.hs  ->  Main.hs
(tipos)       (funções puras)  (IO / terminal)
                 ^
            Examples.hs (dados de teste)
```

Quem importa quem: `Domain` importa `Model`; `Examples` importa `Model`;
`Main` importa `Domain`, `Examples` e `Model`. O `Model` não importa ninguém.

---

## src/Model.hs — os tipos

- **`Centimos`**: sinónimo de tipo (`type Centimos = Integer`). Não cria um tipo novo, só dá um nome mais claro aos valores em cêntimos.
- **`Categoria`**: tipo algébrico com 5 construtores (`Alimentacao`, `Transporte`, `Lazer`, `Saude`, `Outros`).
  `deriving (Eq, Show, Enum, Bounded)` permite comparar (`==`), mostrar, e listar todos com `[minBound .. maxBound]`.
- **`Data`**: record com `ano`, `mes`, `dia`. O `Ord` derivado compara datas por ordem de campos.
- **`Despesa`**: record com `idDespesa`, `descricao`, `valorCentimos`, `categoria`, `dataDespesa`.
  O nome de cada campo é também uma função: `valorCentimos d` devolve o valor da despesa `d`.
- **`Orcamento`**: categoria + limite em cêntimos.

## src/Domain.hs — o núcleo funcional (tudo funções puras)

| Função | O que faz | Técnica |
|---|---|---|
| `totalDespesas` | soma todos os valores | recursão sobre lista |
| `totalPorCategoria` | soma só os de uma categoria | recursão + guards |
| `totalDoMes` | soma de um mês | composição de `despesasDoMes` e `totalDespesas` |
| `despesasDaCategoria` | filtra por categoria | recursão + guards |
| `despesasDoMes` | filtra por ano/mês | recursão + `where` |
| `procurarPorId` | encontra uma despesa | recursão, devolve `Maybe` |
| `maiorDespesa` | despesa mais cara | recursão + `case`, devolve `Maybe` |
| `categoriasUsadas` | categorias sem repetição | recursão + `elem` |
| `contarDespesas` | número de despesas | recursão |
| `removerDespesa` | remove por id | recursão |
| `ordenarPorValor` | do maior para o menor | ordenação por inserção (`inserirPorValor`) |
| `excedeOrcamento` | total > limite? | reutiliza `totalPorCategoria` |
| `formatarMontante` | `850` -> `"8,50 EUR"` | guards, `divMod`, trata negativos |
| `formatarData` | `Data 2026 11 4` -> `"2026-11-04"` | pattern matching |

Na Fase 1 as funções são escritas **à mão com recursão** de propósito (é o objetivo da fase).
Na Fase 2 podem ser reescritas com `filter`, `map`, `foldr`, etc.

`Maybe` é usado onde pode não haver resultado (lista vazia, id inexistente), em vez de erros ou valores especiais.

## src/Examples.hs — dados de exemplo

`despesasExemplo` (8 despesas em outubro e novembro de 2026) e `orcamentosExemplo` (Alimentação 50,00 €, Lazer 40,00 €).
Servem para a demonstração e para os testes.

## app/Main.hs — demonstração

É o **único** ficheiro com `IO`. Chama as funções do `Domain` com os dados de exemplo e imprime os resultados.
Funções auxiliares (`apresentarDespesas`, `apresentarTotais`, `apresentarOrcamentos`) também são recursivas.

## test/Spec.hs — testes

Cada teste é um par `(nome, Bool)`. O programa corre todos, imprime `[OK]` ou `[FALHA]`
e termina com erro se algum falhar (por isso `cabal test` falha). Cobre casos normais e casos limite
(lista vazia, id inexistente, categoria sem despesas, valor 0, valor negativo).

## gestor-despesas.cabal / cabal.project

Descrevem o projeto para o Cabal: uma biblioteca (`src`), um executável `gestor-despesas-fase1` (`app`)
e uma suite de testes (`test`). Só depende de `base`.

## README.md, .gitignore, data/, docs/

README com instruções de compilação e estrutura; `.gitignore` evita guardar ficheiros compilados no Git;
`data/` fica vazio até à Fase 3 (ficheiros); `docs/` contém esta explicação (e, mais tarde, o relatório).

---

## Resultados esperados da demonstração

- Total: 130,65 EUR · Alimentação: 33,80 · Transporte: 42,20 · Lazer: 47,00 · Saúde: 7,65 · Outros: 0,00
- Outubro: 84,00 EUR · Novembro: 46,65 EUR
- Maior despesa: Passe mensal (40,00 EUR)
- Orçamento de Lazer excedido; Alimentação dentro do limite

## Perguntas prováveis na defesa

1. Porque usar cêntimos em `Integer` e não `Double`? (precisão)
2. Porque `Maybe` em `maiorDespesa` e `procurarPorId`? (lista vazia / id inexistente)
3. Qual é o caso base e o caso recursivo de `totalPorCategoria`?
4. Porque está o IO só no `Main`? (funções puras são fáceis de testar)
5. Como reescreverias `despesasDaCategoria` com `filter`? (`filter ((== cat) . categoria)`)
