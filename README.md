# Orçamento Familiar — Sistema Especialista (Prolog)

Sistema de console em SWI‑Prolog que analisa seu orçamento doméstico e recomenda: status financeiro, valor de poupança mensal sugerido, estratégia de quitação de dívidas e prioridades (fundo de emergência, cortes por categoria, investir agora ou adiar).

##Autores: Pedro Henrique Scheidt (@HSP303) e Vinícius Minas (@viniciusminas)

## Pré‑requisitos
- SWI‑Prolog instalado (`swipl`)

## Como executar
```bash
cd orcamento_familiar/src
swipl
?- ['main.pl'].
?- start.
```

## Entradas solicitadas
- Renda líquida mensal (R$)
- Gastos por categoria: habitação, alimentação, transporte, educação, lazer e outros
- Total de parcelas de dívidas no mês (R$)
- Juros médios anuais das dívidas (%)
- Meses já acumulados em fundo de emergência
- Quantidade de dependentes
- Se a renda é irregular (s/n)

## Saídas
- **Status**: `saudavel | alerta | critico`
- **Poupança sugerida**: valor em R$
- **Estratégia de dívidas**: `avalanche | snowball`
- **Prioridades**: lista com itens como `fundo_emergencia`, categorias com excesso e `investir/adiar_investimentos`

## Regras principais (exemplos)
1. Classificar status por superávit e razão dívidas/renda.
2. Poupança sugerida = min(10% renda, superávit positivo).
3. Estratégia de dívidas: `avalanche` se juros a.a. ≥ 20%, senão `snowball`.
4. Priorizar fundo de emergência (<3 meses) e/ou se renda irregular ou há dependentes.
5. Apontar categorias acima da faixa ideal (ex.: lazer > 15%).
6. Só recomendar investir quando status saudável **e** fundo ≥ 3 meses.
7. Classificar nível de comprometimento com dívidas (baixo/médio/alto).
8. Checar equilíbrio global de gastos (gastos fixos ≤ 80% da renda).

## Exemplo de Execução (resumo)
**Entrada (exemplo):** renda 5000; hab 1500; alim 900; transp 400; educ 300; lazer 600; outros 200; dívidas 700; juros 28; fundo 1.5; dep 1; irregular s

**Saída (resumo):** status `alerta`; poupança sugerida `R$ 300`; estratégia `avalanche`; prioridades `[fundo_emergencia, habitacao, lazer, adiar_investimentos]`
