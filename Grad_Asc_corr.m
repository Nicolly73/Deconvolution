function [r, n, historical_cost] = Grad_Asc_corr(W, r_init, n_init, trace, interactions, step, k_size)
    % Grad_Asc_corr 
    %
    % A função implementa o algoritmo de Subida de Gradiente (Gradient Ascent) 
    % para otimizar interativamente os parâmetros 'r' e 'n'. O objetivo é 
    % maximizar uma função de custo baseada em correlação, ajustando um 
    % sinal estimado para que fique o mais semelhante possível a um sinal 
    % real observado (trace).
    %
    % Parâmetros de Entrada:
    %   W            - Vetor de pesos, modelo ou wavelet usado na predição.
    %   r_init       - Vetor com o chute inicial para o parâmetro 'r'.
    %   n_init       - Vetor com o chute inicial para o parâmetro 'n'.
    %   trace        - Sinal/traço real de referência que se deseja alcançar.
    %   interactions - Número de iterações do algoritmo (Padrão: 1000).
    %   step         - Taxa de aprendizado (learning rate) ou tamanho do passo (Padrão: 0.5).
    %   k_size       - Parâmetro de escala ou tamanho do kernel para a correlação (Padrão: 0.5).
    %
    % Parâmetros de Saída:
    %   r               - Vetor do parâmetro 'r' otimizado.
    %   n               - Vetor do parâmetro 'n' otimizado.
    %   historical_cost - Vetor contendo o valor da função de custo em cada iteração.
    %
    % Exemplo:
    %   W = randn(1, 50); r0 = zeros(1, 100); n0 = zeros(1, 100); trace = sin(linspace(0, 10, 100));
    %   [r_opt, n_opt, custo] = Grad_Asc_corr(W, r0, n0, trace, 500, 0.1, 0.5);
    %   plot(custo); % Para visualizar a curva de convergência
    %
    % Notas:
    %   - A função fixa a semente aleatória (rng(42)) para garantir reprodutibilidade.
    %   - A variável 'interactions' geralmente é chamada de 'iterations' em inglês,
    %     mas a nomenclatura original foi mantida.
    %   - Por ser uma *Subida* de Gradiente, os parâmetros são atualizados 
    %     somando-se o gradiente (buscando o máximo global/local da correlação).

    % --- 1. Verificação e atribuição de valores padrão (Defaults) ---
    if nargin < 5 || isempty(interactions), interactions = 1000; end
    if nargin < 6 || isempty(step), step = 0.5; end
    if nargin < 7 || isempty(k_size), k_size = 0.5; end
    
    % --- 2. Inicialização e padronização de dimensões ---
    rng(42); % Fixa a semente para garantir resultados consistentes
    
    % O operador (:)' garante que todas as variáveis sejam vetores-linha (1 x M)
    r = r_init(:)';
    n = n_init(:)';
    trace = trace(:)';
    W = W(:)';
    
    % Pré-alocação do vetor de histórico para otimizar velocidade e memória
    historical_cost = zeros(1, interactions);
    
    % --- 3. Loop de Otimização (Gradient Ascent) ---
    for i = 1:interactions
        % Passo Forward: Calcula a estimativa atual baseada em W, r e n
        trace_estimated = prediction(W, r, n);
        
        % Passo Backward: Calcula as derivadas parciais da correlação em relação a r e n
        [dr, dn] = partial_derivatives_corr(W, trace, trace_estimated, k_size, length(r));
        
        % Avaliação: Registra o custo/métrica de sucesso da iteração atual
        historical_cost(i) = cost_corr(trace, trace_estimated, k_size);
        
        % Atualização: Ajusta os parâmetros na direção do gradiente (Subida)
        r = r + step * dr;
        n = n + step * dn;
    end
end