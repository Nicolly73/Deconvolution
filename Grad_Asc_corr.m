function [r, historical_cost] = Grad_Asc_corr(W, r, trace, interactions, step, k_size, N, lambda)
    % Grad_Asc_corr 
    %
    % A função implementa o algoritmo de Subida de Gradiente para
    % otimizar interativamente o parâmetro 'r'. O objetivo é 
    % maximizar essa função, ajustando o  sinal estimado até que
    % fique o mais semelhante possível a um sinal real observado (trace).
    %
    % Parâmetros de Entrada:
    %   W - Wavelet conhecida.
    %   r_init - Vetor com o chute inicial do parâmetro 'r'.
    %   trace - Sinal/traço real de referência que se deseja alcançar.
    %   interactions - Número de iterações do algoritmo (Padrão: 1000).
    %   step - Taxa de aprendizado/tamanho do passo (Padrão: 0.5).
    %   k_size - Tamanho do kernel (Padrão: 0.5).
    %
    % Parâmetros de Saída:
    %   r - Vetor do parâmetro 'r' otimizado.
    %   historical_cost - Vetor contendo o valor da função de custo em cada iteração.
    %
    % Exemplo:
    %   W = randn(1, 50); r0 = zeros(1, 100); trace = sin(linspace(0, 10, 100));
    %   [r_opt, custo] = Grad_Asc_corr(W, r0, trace, 500, 0.1, 0.5);
    %   plot(custo);
    %
    % Notas:
    %   - Por ser uma *Subida* de Gradiente, os parâmetros são atualizados 
    %     somando-se o gradiente (buscando o máximo global/local da correlação).

    % --- Verificação e atribuição de valores padrão  ---
    if nargin < 4 || isempty(interactions), interactions = 1000; end
    if nargin < 5 || isempty(step), step = 0.5; end
    if nargin < 6 || isempty(k_size), k_size = 0.5; end
    
    % --- Inicializa as variáveis---
    rng(42);
    
    r = r(:)';
    trace = trace(:)';
    W = W(:)';
    
    H = deconvlapps.conv_matrix(W, N, length(trace));
    
    % Pré-alocação do vetor de histórico
    historical_cost = zeros(1, interactions);
    
    % --- Loop de Otimização ---
    for i = 1:interactions
        % Calcula a estimativa atual
        trace_estimated = convolution(W, r);
        
        % Calcula as derivadas parciais
        dr = partial_derivatives_corr(H, trace, trace_estimated, k_size, lambda, r);
        
        % Registra o custo da iteração atual
        historical_cost(i) = cost_corr(trace, trace_estimated, k_size, lambda, r);
        
        % Atualiza os parâmetros
        r = r + step * dr;
    end
end