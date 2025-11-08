explicar(resultado(status(Status), poupanca_mensal(Poup), estrategia_dividas(Estrat), prioridades(Prior))) :-
  obs(renda(R)), soma_categorias(GFix), obs(dividas_total(Div)), obs(juros_anuais(J)),
  (obs(fundo_emergencia_meses(M)); M=0), (obs(dependentes(Dep)); Dep=0),
  (obs(irregular(sim)) -> Irreg = sim ; Irreg = nao),

  Sup is R - GFix - Div,
  PercDiv is (Div/R)*100,

  % monta lista de cortes com percentuais
  findall(pair(C, Perc), (
      (member(C,[habitacao,alimentacao,transporte,educacao,lazer,outros]),
       obs(gasto(C,V)), Perc is (V/R)*100)
  ), LP),

  format("\n[Explicação]\n"),
  format("- Renda: R$ ~2f | Gastos: R$ ~2f | Dívidas: R$ ~2f | Superávit: R$ ~2f\n", [R,GFix,Div,Sup]),
  format("- Comprometimento com dívidas: ~1f%% do orçamento\n", [PercDiv]),
  format("- Juros médios a.a.: ~1f%% \u2192 Estratégia: ~w\n", [J, Estrat]),
  format("- Fundo de emergência atual: ~1f meses | Irregular: ~w | Dependentes: ~w\n", [M, Irreg, Dep]),
  format("- Status financeiro: ~w\n", [Status]),
  format("- Poupança sugerida este mês: R$ ~2f\n", [Poup]),
  format("- Prioridades: ~w\n", [Prior]),
  format("- Percentuais por categoria:\n"),
  maplist(print_pair, LP).

print_pair(pair(C, P)) :- format("  · ~w: ~1f%% da renda\n", [C, P]).
