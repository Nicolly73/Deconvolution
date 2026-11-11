function cost_value = cost_L2(trace, trace_estimated)
    % COST_L2 Calcula o custo baseado na Soma dos Erros Quadráticos.
    %
    % A função avalia a diferença entre um sinal real (trace) e um sinal 
    % estimado (trace_estimated) utilizando a métrica de distância L2 
    % (mínimos quadrados). Diferente da função Gaussiana (Correntropia), 
    % o custo L2 penaliza erros grandes de forma quadrática, o que o torna 
    % extremamente sensível a "outliers" (valores atípicos ou ruídos fortes).
    %
    % Parâmetros de Entrada:
    %   trace           - Vetor com o sinal ou traço real de referência.
    %   trace_estimated - Vetor com o sinal estimado pelo modelo.
    %
    % Parâmetros de Saída:
    %   cost_value - Valor escalar representando o custo (erro) total. 
    %                Neste caso, quanto menor o valor, mais semelhantes 
    %                são os sinais (idealmente 0 se forem idênticos). Por 
    %                isso, em otimizações com L2, utiliza-se a "Descida 
    %                de Gradiente" para minimizar o custo.
    %
    % Exemplo:
    %   trace = [1.0, 2.0, 3.0];
    %   trace_est = [1.1, 1.9, 3.2];
    %   custo = cost_L2(trace, trace_est);
    %   % Resultado esperado: (0.1)^2 + (-0.1)^2 + (0.2)^2 = 0.06
    
    % --- Cálculo do Erro Quadrático ---
    % 1. (trace_estimated - trace): Calcula o resíduo (erro) ponto a ponto.
    % 2. .^2 : Eleva cada erro individual ao quadrado, garantindo que erros 
    %          negativos e positivos não se anulem, e penalizando erros maiores.
    % 3. sum() : Acumula o erro de todos os pontos em um único valor escalar.
    cost_value = sum((trace_estimated - trace).^2);
end