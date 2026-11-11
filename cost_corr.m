function cost_value = cost_corr(trace, trace_estimated, k_size)
    % COST_CORR Calcula o valor de custo usando um kernel Gaussiano (Correntropia).
    %
    % A função avalia a similaridade entre um sinal real (trace) e um sinal 
    % estimado (trace_estimated). Ao invés de usar o clássico Erro Quadrático 
    % Médio (MSE), ela utiliza uma função exponencial baseada em um kernel 
    % Gaussiano. Esta abordagem (ligada ao Critério de Máxima Correntropia - MCC) 
    % é altamente robusta contra "outliers" (ruídos atípicos de grande amplitude), 
    % pois erros muito grandes tendem a zero na exponencial, não distorcendo o custo.
    %
    % Parâmetros de Entrada:
    %   trace           - Vetor com o sinal ou traço real de referência.
    %   trace_estimated - Vetor com o sinal estimado pelo modelo.
    %   k_size          - Tamanho do kernel (largura de banda da Gaussiana). 
    %                     Controla a sensibilidade da função aos erros. Valores 
    %                     maiores aproximam o comportamento do MSE, enquanto 
    %                     valores menores rejeitam melhor os outliers.
    %
    % Parâmetros de Saída:
    %   cost_value - Valor escalar representando o custo total. Como usamos a 
    %                Gaussiana, quanto maior o valor, mais semelhantes são os 
    %                sinais. (Por isso usa-se "Subida de Gradiente" para maximizá-lo).
    %
    % Exemplo:
    %   trace = [1.2, 2.5, 3.1];
    %   trace_est = [1.0, 2.5, 3.8];
    %   k = 0.5;
    %   custo = cost_corr(trace, trace_est, k);
    
    % --- 1. Cálculo do Resíduo (Erro) ---
    % Calcula a diferença ponto a ponto entre o sinal estimado e o real.
    err = trace_estimated - trace;
    
    % --- 2. Aplicação do Kernel Gaussiano e Integração (Soma) ---
    % Eleva o erro ao quadrado (err.^2) e divide por (2 * k_size^2).
    % A função exp() inverte a lógica do erro:
    %   - Se o erro for 0, exp(0) = 1 (similaridade máxima).
    %   - Se o erro for muito grande, exp(-grande) = 0 (penalidade limitada, 
    %     ignorando o outlier em vez de explodir o valor do erro).
    % A função sum() acumula o valor de similaridade para todo o sinal.
    cost_value = sum(exp(-(err.^2) ./ (2 * k_size^2)));
end