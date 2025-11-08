% Domínios, parâmetros e faixas básicas
% Percentuais de referência (podem ser ajustados):
ideal_faixa(habitacao, 0.20, 0.35).
ideal_faixa(alimentacao, 0.10, 0.20).
ideal_faixa(transporte, 0.05, 0.15).
ideal_faixa(educacao, 0.05, 0.15).
ideal_faixa(lazer, 0.00, 0.15).
ideal_faixa(outros, 0.00, 0.10).

% Regras de bolso
min_poupanca_seg(0.10).          % 10% da renda, quando possível
alvo_fundo_emergencia_meses(6).  % alvo geral
alvo_fundo_emergencia_min(3).    % mínimo desejável

% Sinais de alerta por comprometimento de dívida (juros + parcelas)
faixa_dividas(baixo,   0.00, 0.15).
faixa_dividas(medio,   0.15, 0.30).
faixa_dividas(alto,    0.30, 1.00). % 30%+ da renda líquida em dívidas

% Limiares de decisão
juros_altos_anual(20).   % >=20% a.a. considerado alto
superavit_bom(0.10).     % 10% de sobra é confortável

% Utilitários
entre(X, Min, Max) :- X >= Min, X =< Max.

% Mapeamento para explicações amigáveis
rotulo_comp(baixo, 'baixo').
rotulo_comp(medio, 'médio').
rotulo_comp(alto,  'alto').
