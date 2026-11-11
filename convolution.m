function signal_convolution = convolution(f, g)
    % CONVOLUTION Calcula a convolução discreta 1D entre dois vetores.
    %
    % A função implementa passo a passo a operação matemática de convolução 
    % linear entre dois sinais 'f' e 'g'. Ela replica o comportamento da 
    % função nativa conv() do MATLAB através do método de "reverter e deslizar".
    %
    % Parâmetros de Entrada:
    %   f - Primeiro sinal/vetor de entrada (tamanho N).
    %   g - Segundo sinal/vetor de entrada (tamanho M). Frequentemente
    %       representa o filtro (kernel) ou a resposta ao impulso.
    %
    % Parâmetros de Saída:
    %   signal_convolution - Vetor resultante da convolução, cujo tamanho 
    %                        será sempre (N + M - 1).
    %
    % Exemplo:
    %   f = [1, 2, 3];
    %   g = [0.5, 1];
    %   resultado = convolution(f, g);
    %   % Retorno esperado: [0.5, 2, 3.5, 3]

    % --- 1. Definição do Tamanho e Pré-alocação ---
    % Na convolução linear, o tamanho do sinal resultante é a soma 
    % do tamanho das duas entradas menos 1 (N + M - 1).
    signal_length = length(f) + length(g) - 1;
    
    % Pré-aloca o vetor de saída com zeros para otimizar velocidade e memória
    signal_convolution = zeros(1, signal_length);
    
    % --- 2. Algoritmo de Convolução ---
    % Loop externo: itera sobre cada amostra temporal do sinal de saída.
    for i = 1:signal_length
        s = 0; % Acumulador (soma) para a posição atual 'i'
        
        % Loop interno: itera sobre todos os elementos do primeiro sinal 'f'
        for j = 1:length(f)
            % Calcula o índice correspondente no segundo sinal 'g'.
            % O termo "- j" aplica a reversão no tempo do sinal 'g', e 
            % o termo "+ i" cuida do deslocamento (deslizamento).
            index = i - j + 1;
            
            % Verifica se o índice calculado está dentro dos limites do vetor 'g'.
            % Isso simula implicitamente o "zero-padding" nas extremidades.
            if (index >= 1) && (index <= length(g))
                % Multiplica os elementos sobrepostos e adiciona ao acumulador
                s = s + f(j) * g(index);
            end
        end
        
        % Atribui o valor total acumulado à respectiva posição temporal de saída
        signal_convolution(i) = s;
    end
end