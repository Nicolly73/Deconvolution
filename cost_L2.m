function cost_value = cost_L2(trace, trace_estimated, lambda, r)
    % COST_L2 Calcula o custo usando a norma_L2
    %
    % A função avalia a diferença entre um sinal real (trace) e um sinal 
    % estimado (trace_estimated) utilizando a métrica de distância L2 
    % (mínimos quadrados).
    %
    % Parâmetros de Entrada:
    %   trace - Vetor com o sinal ou traço real de referência.
    %   trace_estimated - Vetor com o sinal estimado pelo modelo.
    %
    % Parâmetros de Saída:
    %   cost_value - Escalar que representa o custo (erro) total. 
    %                Neste caso, quanto menor o valor, mais semelhantes 
    %                são os sinais, pois  "Descida 
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
    
    % Calcula o erro (a diferença entre o sinal estimado e o real
    err = trace_estimated - trace;
    
    % realiza o calculo do custo
    cost_value = (1/2) * sum(err.^2) + lambda * sum(abs(r(:)));
end