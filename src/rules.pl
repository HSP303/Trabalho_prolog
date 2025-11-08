:- dynamic obs/1.

% meta/1 devolve a estrutura principal com diagnóstico e recomendações
% Ex.: resultado(status(critico), poupanca_mensal(300), estrategia_dividas(avalanche), prioridades([fundo_emergencia, reduzir_lazer]))
meta(resultado(status(Status), poupanca_mensal(Poup), estrategia_dividas(Estrat), prioridades(Prioridades))) :-
  renda(R), total_gastos_fixos(GFix), total_dividas(Div), juros_anuais(J),
  fundo_meses(FMeses), irregular(Irreg), dependentes(Dep),

  superavit(R, GFix, Div, Sup),
  classificar_status(Sup, Div, R, Status),                % (R1)
  poupanca_sugerida(R, Sup, Poup),                        % (R2)
  estrategia_dividas(J, Estrat),                          % (R3)
  prioridade_fundo(FMeses, Irreg, Dep, PriFundo),         % (R4)
  excesso_categoria(PriCortes),                           % (R5)
  prioridade_investir(Status, FMeses, PriInvest),         % (R6)
  saude_dividas(Div, R, _NivelDiv),                       % (R7)
  equilibrio_gastos(R, GFix, _Equi),                      % (R8)

  montar_prioridades([PriFundo|PriCortes], PriInvest, Prioridades).

/* ===== Observações lidas ===== */

renda(R) :- obs(renda(R)).

% gastos fixos por categoria
cat(habitacao). cat(alimentacao). cat(transporte). cat(educacao). cat(lazer). cat(outros).

cat_val(C, V) :- obs(gasto(C,V)).

% totais
soma_categorias(S) :- findall(V, obs(gasto(_,V)), L), sum_list(L, S).

% dívidas
parcelas_dividas(V) :- obs(dividas_total(V)).

juros_anuais(J) :- obs(juros_anuais(J)).

% fundo de emergência já acumulado (em meses de despesas básicas)
fundo_meses(M) :- obs(fundo_emergencia_meses(M)).

% perfil e contexto
irregular(sim) :- obs(irregular(sim)).
irregular(nao) :- \+ obs(irregular(sim)).

dependentes(D) :- obs(dependentes(D)).

/* ===== Derivações ===== */

% total de gastos (exclui dívidas)
total_gastos_fixos(T) :- soma_categorias(T).

% total de dívidas (parcelas mensais)
total_dividas(D) :- parcelas_dividas(D).

% superávit (renda - (gastos + dívidas))
superavit(R, G, D, S) :- S is R - G - D.

% (R1) Classificação de status financeiro
classificar_status(Sup, Div, R, saudavel) :- Sup > 0, Div/R =< 0.15, !.
classificar_status(Sup, Div, R, alerta)   :- Sup >= 0, Div/R =< 0.30, !.
classificar_status(_,   _,   _, critico).

% (R2) Poupança sugerida: mínimo entre 10% da renda e o superávit positivo
poupanca_sugerida(R, Sup, P) :- min_poupanca_seg(Min), Alvo is R*Min, (Sup =< 0 -> P = 0 ; P is min(Alvo, Sup)).

% (R3) Estratégia de quitação de dívidas por juros
estrategia_dividas(J, avalanche) :- juros_altos_anual(L), J >= L, !.
estrategia_dividas(_, snowball).

% (R4) Prioridade de fundo de emergência
prioridade_fundo(M, sim, Dep, fundo_emergencia) :- alvo_fundo_emergencia_min(Min), (M < Min ; Dep >= 1), !.
prioridade_fundo(M, nao, _, fundo_emergencia)   :- alvo_fundo_emergencia_min(Min), M < Min, !.
prioridade_fundo(_, _, _, quitar_dividas).

% (R5) Identificar categorias com excesso vs faixa ideal
excesso_categoria(ListaCortes) :-
  findall(C, (cat(C), excesso(C)), L),
  (L = [] -> ListaCortes = ["sem_cortes_obrigatorios"]; ListaCortes = L).

excesso(C) :- renda(R), cat_val(C,V), P is V/R, ideal_faixa(C, _Min, Max), P > Max.

% (R6) Investir só quando status saudável e fundo >= 3 meses
prioridade_investir(saudavel, M, investir) :- alvo_fundo_emergencia_min(Min), M >= Min, !.
prioridade_investir(_, _, adiar_investimentos).

% (R7) Nível de comprometimento com dívidas
saude_dividas(Div, R, Nivel) :-
  Perc is Div/R,
  faixa_dividas(Nivel, Min, Max), entre(Perc, Min, Max), !.

% (R8) Equilíbrio global de gastos (gastos fixos <= 80% renda)
equilibrio_gastos(R, G, equilibrado) :- G/R =< 0.80, !.
equilibrio_gastos(_, _, desequilibrado).

% Montagem de prioridades (remove placeholders)
montar_prioridades(PIn, PriInvest, POut) :-
  include(\=("sem_cortes_obrigatorios"), PIn, Tmp),
  append(Tmp, [PriInvest], POut).
