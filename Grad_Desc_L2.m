function [r, historical_cost] = Grad_Desc_L2(W, r, trace, interactions, step, N, lambda)
    % GRAD_DESC_L2 
    %
    % A função implementa o algoritmo de Descida de Gradiente para otimizar
    % o parâmetro 'r'. O objetivo é minimizar a 
    % função de custo, ajustando o sinal estimado para que a diferença 
    % em relação ao sinal real diminua o máximo possíel
    %
    % Parâmetros de Entrada:
    %   W - Vetor de pesos, modelo ou filtro/wavelet usado na predição.
    %   r_init - Vetor com o chute inicial para o parâmetro 'r'.
    %   trace - Sinal/traço real de referência (ground truth).
    %   interactions - Número de iterações do algoritmo (Padrão: 1000).
    %   step - Taxa de aprendizado (learning rate) ou tamanho do passo (Padrão: 0.5).
    %
    % Parâmetros de Saída:
    %   r - Vetor do parâmetro 'r' otimizado.
    %   historical_cost - Vetor contendo o valor do erro (custo L2) em cada iteração.
    %
    % Exemplo:
    %   W = randn(1, 50); r0 = zeros(1, 100); trace = sin(linspace(0, 10, 100));
    %   [r_opt, n_opt, custo] = Grad_Desc_L2(W, r0, trace, 500, 0.01);
    %   plot(custo); % O gráfico deve mostrar uma curva decrescente
    %
    % Notas:
    %   - Por ser uma *Descida* de Gradiente, os parâmetros são atualizados 
    %     subtraindo-se o gradiente (buscando o mínimo da função de custo).

    % --- 1. Verificação e atribuição de valores padrão (Defaults) ---
    if nargin < 4 || isempty(interactions), interactions = 1000; end
    if nargin < 5 || isempty(step), step = 0.5; end
    
    % --- 2. Inicialização e padronização de dimensões ---
    rng(42); % Fixa a semente para garantir resultados consistentes e reprodutíveis
    
    % O operador (:)' garante que todas as variáveis sejam tratadas como vetores-linha (1 x M)
    
    r = r(:)';
    trace = trace(:)';
    W = W(:)';
    
    H = deconvlapps.conv_matrix(W, N, length(trace));
    
    % Pré-alocação do vetor de histórico para otimizar velocidade e uso de memória
    historical_cost = zeros(1, interactions);
    
    % --- 3. Loop de Otimização (Gradient Descent) ---
    for i = 1:interactions
        % Passo Forward: Calcula a estimativa atual baseada nos parâmetros W, r e n
        trace_estimated = convolution(W, r);
        
        % Passo Backward: Calcula as derivadas parciais do Erro Quadrático 
        % em relação a 'r' e 'n'. Indica a direção de maior crescimento do erro.
        dr = partial_derivatives_L2(H, trace, trace_estimated, lambda, r);
        
        % Avaliação: Registra o erro atual na iteração correspondente
        historical_cost(i) = cost_L2(trace, trace_estimated, lambda, r);
        
        % Atualização: Ajusta os parâmetros na direção OPOSTA do gradiente (Descida).
        % É aqui que entra o sinal negativo (-), minimizando assim a função L2.
        r = r - step * dr;
    end
end