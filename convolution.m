function signal_convolution = convolution(f, g)
    % CONVOLUTION Calcula a convolução discreta entre dois vetores unidimensionais.
    %
    % A função implementa passo a passo a operação matemática de convolução 
    % linear entre dois sinais 'f' e 'g'.
    %
    % Parâmetros de Entrada:
    %   f - Primeiro sinal/vetor de entrada (tamanho N).
    %   g - Segundo sinal/vetor de entrada (tamanho M).
    %
    % Parâmetros de Saída:
    %   signal_convolution - Vetor resultante da convolução.
    %
    % Exemplo:
    %   f = [1, 2, 3];
    %   g = [0.5, 1];
    %   resultado = convolution(f, g);
    %   ° Retorno esperado: [0.5, 2, 3.5, 3]

    % Define o tamanho do sinal resultante
    signal_length = length(f) + length(g) - 1;
    
    % Aloca o sinal
    signal_convolution = zeros(1, signal_length);
    
    % itera sobre cada amostra temporal do sinal de saída.
    for i = 1:signal_length
        s = 0; % Acumulador
        
        % itera sobre os elementos do sinal f
        for j = 1:length(f)
            % Calcula o índice correspondente ao sinal g
            index = i - j + 1;
            
            % Verifica se o índice está dentro dos limites do vetor g
            if (index >= 1) && (index <= length(g))
                % "Desliza" o sinal g pelo sinal f fazendo a multiplicacao
                % entre os termos e posterior somatorio                s = s + f(j) * g(index);
            end
        end
        
        % Atribui o valor total acumulado ao resultado da convolucao
        signal_convolution(i) = s;
    end
end