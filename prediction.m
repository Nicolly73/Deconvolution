function predicted = prediction(w, r, n)
    % PREDICTION Gera o sinal estimado através de um modelo convolucional aditivo.
    %
    % A função implementa o "forward pass" (passo de predição), construindo
    % o sinal modelado com base nos parâmetros atuais. Matematicamente,
    % avalia a equação: y = w * r + n, onde '*' representa a convolução.
    %
    % Parâmetros de Entrada:
    %   w - Vetor de pesos, filtro, wavelet ou resposta ao impulso do sistema.
    %   r - Vetor da série de refletividade, impulsos ou sinal de entrada principal.
    %   n - Vetor representando o ruído aditivo, bias ou fundo do sinal.
    %
    % Parâmetros de Saída:
    %   predicted - Vetor contendo o sinal (traço) estimado.
    %
    % Exemplo:
    %   w = [0.5, 1, 0.5];
    %   r = [0, 0, 1, 0, -1, 0, 0];
    %   n = 0.05 * randn(1, 7);
    %   y_est = prediction(w, r, n);
    %
    % Notas:
    %   - Para evitar inconsistências e erros do MATLAB durante operações, a 
    %     função força a transformação das variáveis em vetores-linha.
    %   - A operação de convolução expande o tamanho original do sinal. 
    %     Para alinhar os vetores e permitir a soma matemática, a função 
    %     trunca o resultado baseando-se no menor comprimento disponível.

    % --- 1. Aplicação do Modelo (Convolução) ---
    % Convolve o filtro/wavelet (w) com a série de parâmetros/refletividade (r).
    % O tamanho do resultado 'conv_res' será: length(w) + length(r) - 1.
    conv_res = convolution(w, r);
    
    % --- 2. Padronização de Dimensões ---
    % O operador (:)' (vetorização + transposta) garante que o resultado 
    % da convolução e o vetor de ruído sejam estritamente vetores-linha (1 x M).
    % Isso previne o famoso erro do MATLAB: "Matrix dimensions must agree".
    conv_res = conv_res(:)';
    n = n(:)';
    
    % --- 3. Alinhamento de Tamanho (Trimming) e Adição ---
    % Define uma janela de corte baseada no menor comprimento disponível.
    % Isso garante que a soma ocorra apenas onde ambos os sinais existem.
    len = min(length(conv_res), length(n));
    
    % Trunca a convolução e o vetor de ruído para o tamanho seguro 'len',
    % realizando a soma (adição de ruído/bias) para finalizar a predição.
    predicted = conv_res(1:len) + n(1:len);
end