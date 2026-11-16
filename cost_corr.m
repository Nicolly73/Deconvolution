function cost_value = cost_corr(trace, trace_estimated, k_size)
    % COST_CORR Calcula o valor de custo usando Correntropia.
    %
    % A função avalia a similaridade entre um sinal real (trace) e um sinal 
    % estimado (trace_estimated).
    %
    % Parâmetros de Entrada:
    %   trace - Vetor com o traço real capitado.
    %   trace_estimated - Vetor do sinal estimado pelo modelo.
    %   k_size - Tamanho do kernel (largura de banda da Gaussiana). 
    %
    % Parâmetros de Saída:
    %   cost_value - Escalar que representa o custo total. 
    %
    % Exemplo:
    %   trace = [1.2, 2.5, 3.1];
    %   trace_est = [1.0, 2.5, 3.8];
    %   k = 0.5;
    %   custo = cost_corr(trace, trace_est, k);
    
    % Calcula o erro (a diferença entre o sinal estimado e o real
    err = trace_estimated - trace;
    
    % realiza o calculo do custo
    cost_value = sum(exp(-(err.^2) ./ (2 * k_size^2)));
end