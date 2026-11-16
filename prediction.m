function predicted = prediction(w, r, n)
    % PREDICTION Gera o sinal estimado a partir do modelo convolucional.

    % Parâmetros de Entrada:
    %   w - Vetor da Wavelet conhecida.
    %   r - Vetor da refletividade.
    %   n - Vetor do ruído aditivo.
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
    % --- Realiza o calculo da convolução ---
    conv_res = convolution(w, r);
    
    % --- transpoem os vetores ---
    conv_res = conv_res(:)';
    n = n(:)';
    
    % --- Define a janela de corte ---
    % A soma ocorre apenas onde ambos os sinais existem
    len = min(length(conv_res), length(n));
    
    % Realiza o truncamento e a soma dos vetores
    predicted = conv_res(1:len) + n(1:len);
end