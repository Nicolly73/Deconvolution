function [dr, dn] = partial_derivatives_corr(W, trace, trace_estimated, k_size, r_len)
    % PARTIAL_DERIVATIVES_CORR Calcula os gradientes para a função de Correntropia.
    %
    % Esta função calcula as derivadas parciais da função de custo baseada no 
    % kernel Gaussiano (Correntropia) em relação aos parâmetros 'r' e 'n'. 
    % O cálculo utiliza a Regra da Cadeia e a propriedade de que a derivada de 
    % uma convolução em relação a um dos sinais equivale à correlação cruzada 
    % do erro com o outro sinal.
    %
    % Parâmetros de Entrada:
    %   W               - Vetor de pesos/wavelet usado na predição original.
    %   trace           - Sinal real de referência (ground truth).
    %   trace_estimated - Sinal estimado pelo modelo na iteração atual.
    %   k_size          - Tamanho do kernel Gaussiano (controla a rejeição a outliers).
    %   r_len           - Comprimento original do vetor 'r' (para alinhar o gradiente).
    %
    % Parâmetros de Saída:
    %   dr - Vetor gradiente (derivada parcial) em relação ao parâmetro 'r'.
    %   dn - Vetor gradiente (derivada parcial) em relação ao parâmetro 'n'.
    %
    % Notas Matemáticas:
    %   A derivada da Gaussiana exp(-e^2 / (2*k^2)) gera um termo proporcional 
    %   a (-e) * exp(...). Ao definirmos 'err = trace - trace_estimated' 
    %   (o inverso de estimado - real), o sinal negativo da derivada já é 
    %   incorporado matematicamente. O fator de escala (1/k^2) geralmente 
    %   é absorvido pela taxa de aprendizado (step) no loop principal.

    % --- 1. Cálculo do Erro e Termo Ponderado ---
    % Calcula o erro. A ordem (real - estimado) absorve o sinal negativo da
    % regra da cadeia advindo da derivada da função exponencial.
    err = trace - trace_estimated;
    
    % Calcula a derivada local do erro ponderada pelo kernel Gaussiano.
    % Outliers (erros grandes) farão a exponencial tender a zero, reduzindo 
    % drasticamente o gradiente ("weighted_err") para esses pontos. 
    % Isso evita que ruídos fortes desviem o ajuste dos parâmetros.
    weighted_err = exp(-(err.^2) ./ (2 * k_size^2)) .* err;
    
    % --- 2. Derivada em relação a 'r' ---
    % Se 'trace_estimated' é gerado pela convolução de 'r' com 'W', a derivada 
    % do custo em relação a 'r' é a correlação cruzada do termo de erro com 'W'.
    % A correlação cruzada matemática é idêntica à convolução usando 'W' invertido no tempo (flip).
    dr_full = convolution(weighted_err, flip(W));
    
    % Alinhamento (Trimming):
    % A convolução linear expande o tamanho do sinal para (len(weighted_err) + len(W) - 1).
    % Precisamos extrair apenas a porção válida correspondente aos atrasos de 'r'.
    % O índice de início ignora o "transiente" criado pelo comprimento da wavelet 'W'.
    idx_start = length(W);
    
    % Recorta exatamente a janela de tamanho 'r_len' correspondente ao gradiente de 'r'
    dr = dr_full(idx_start : idx_start + r_len - 1);
    
    % --- 3. Derivada em relação a 'n' ---
    % Assume-se que 'n' tem relação aditiva direta com o traço (ex: ruído ou background).
    % Logo, a derivada de 'trace_estimated' em relação a 'n' é 1, e o gradiente 
    % em relação a 'n' reflete exatamente o termo de erro ponderado.
    dn = weighted_err;
end