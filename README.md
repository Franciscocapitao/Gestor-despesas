# Gestor de Despesas Pessoais

Projeto de Programação Funcional em Haskell — **Fase 1: Modelação e núcleo funcional**.

## Descrição

Aplicação para organizar despesas pessoais: registar despesas, classificá-las
por categoria e data, calcular totais (globais, por categoria e por mês),
pesquisar, ordenar e verificar se um orçamento foi ultrapassado.

Nesta fase o programa corre uma **demonstração no terminal** com dados de exemplo.
Leitura/escrita de ficheiros, validação de dados e interface interativa ficam para as fases seguintes.

## Requisitos

- GHC (>= 8.10) e Cabal (>= 3.0). Instalação recomendada: [GHCup](https://www.haskell.org/ghcup/).
- Apenas é usada a biblioteca `base` (não há dependências externas).

## Compilar e executar

```bash
cabal build
cabal run gestor-despesas-fase1
```

## Testes

```bash
cabal test --test-show-details=direct
```

Alternativa sem Cabal (a partir da pasta do projeto):

```bash
runghc -isrc app/Main.hs
runghc -isrc test/Spec.hs
```

## Estrutura

```
gestor-despesas/
├── README.md
├── cabal.project
├── gestor-despesas.cabal
├── src/
│   ├── Model.hs      -- tipos: Categoria, Data, Despesa, Orcamento
│   ├── Domain.hs     -- funções puras (cálculos, pesquisa, ordenação)
│   └── Examples.hs   -- dados de exemplo
├── app/
│   └── Main.hs       -- demonstração no terminal (único módulo com IO)
├── test/
│   └── Spec.hs       -- testes das funções puras e casos limite
├── data/             -- reservado para ficheiros (Fase 3)
└── docs/
    └── EXPLICACAO.md -- explicação de cada ficheiro e função
```

## Modelo de dados

| Tipo        | Descrição                                                         |
|-------------|-------------------------------------------------------------------|
| `Centimos`  | sinónimo de tipo (`type Centimos = Integer`) para valores monetários |
| `Categoria` | Alimentacao, Transporte, Lazer, Saude, Outros                     |
| `Data`      | ano, mês, dia                                                     |
| `Despesa`   | id, descrição, valor em cêntimos (`Integer`), categoria, data     |
| `Orcamento` | categoria e limite em cêntimos                                    |

Os valores monetários são inteiros (cêntimos) para evitar erros de vírgula flutuante.

## Funcionalidades (Fase 1)

`totalDespesas`, `totalPorCategoria`, `totalDoMes`, `despesasDaCategoria`,
`despesasDoMes`, `procurarPorId` (`Maybe`), `maiorDespesa` (`Maybe`),
`categoriasUsadas`, `contarDespesas`, `removerDespesa`, `ordenarPorValor`,
`excedeOrcamento`, `formatarMontante`, `formatarData`.

## Git

```bash
git init
git add .
git commit -m "Fase 1: modelo e nucleo funcional"
```

Cada elemento do grupo deve fazer os seus próprios commits.

## Grupo

- (nome e número de cada elemento)
