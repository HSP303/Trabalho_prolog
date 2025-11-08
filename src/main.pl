:- ["kb.pl","rules.pl","ui.pl","explain.pl"].

start :-
  banner, menu.

banner :-
  format("~n=== Sistema Especialista - Orçamento Familiar ===~n"),
  format("Desenvolvido por: Pedro Henrique Scheidt e Vinícius Antônio Minas~n~n").

menu :-
  format("1) Executar diagnóstico~n2) Sair~n> "),
  read(Opt),
  ( Opt = 1 -> run_case, cleanup, menu
  ; Opt = 2 -> format("Saindo...~n")
  ; format("Opção inválida.~n"), menu ).

run_case :-
  coletar_observacoes,
  ( meta(Result) ->
      explicar(Result),
      format("~nRESULTADO: ~w~n", [Result])
  ; format("~nNão foi possível concluir o diagnóstico. Revise as respostas.~n")
  ),
  true.
