:- dynamic obs/1.

ask_number(Label, Functor) :-
  format("~w ", [Label]),
  read(V),
  Term =.. [Functor, V],
  assertz(obs(Term)).

ask_yesno(Texto, CampoYesTerm) :-
  format("~w (s/n) ", [Texto]),
  read(Ans0), downcase_atom(Ans0, Ans),
  ( Ans == s -> assertz(obs(CampoYesTerm))
  ; Ans == n -> true
  ; format("Entrada inválida.~n"), ask_yesno(Texto, CampoYesTerm) ).

ask_cat(Label, Categoria) :-
  format("~w ", [Label]),
  read(V),
  assertz(obs(gasto(Categoria, V))).

coletar_observacoes :-
  format("Informe os valores mensais em reais (apenas números).~n"),
  ask_number("Renda líquida mensal:", renda),

  % categorias
  ask_cat("Gasto com habitação:", habitacao),
  ask_cat("Gasto com alimentação:", alimentacao),
  ask_cat("Gasto com transporte:", transporte),
  ask_cat("Gasto com educação:", educacao),
  ask_cat("Gasto com lazer:", lazer),
  ask_cat("Gasto com outros:", outros),

  % dívidas e contexto
  ask_number("Total de parcelas de dívidas no mês:", dividas_total),
  ask_number("Juros médios ANUAIS das dívidas (em %):", juros_anuais),
  ask_number("Fundo de emergência já acumulado (em meses do seu custo mensal):", fundo_emergencia_meses),
  ask_number("Quantidade de dependentes:", dependentes),
  ask_yesno("Renda é irregular?", irregular(sim)).

cleanup :- retractall(obs(_)).
