function [dr, dn] = partial_derivatives_L2(W, trace, trace_estimated, r_len)
    % PARTIAL_DERIVATIVES_L2 Calcula os gradientes para a função de custo L2.
    %
    % Esta função calcula as derivadas parciais da função de custo baseada no 
    % Erro Quadrático (L2) em relação aos parâmetros 'r' (refletividade/sinal) 
    % e 'n' (ruído/bias). Utiliza-se a regra da cadeia clássica para 
    % problemas de deconvolução ou otimização de sinais.
    %
    % Parâmetros de Entrada:
    %   W               - Vetor de pesos/wavelet usado na predição original.
    %   trace           - Sinal real de referência (ground truth).
    %   trace_estimated - Sinal estimado pelo modelo na iteração atual.
    %   r_len           - Comprimento original do vetor 'r' (para alinhar o gradiente).
    %
    % Parâmetros de Saída:
    %   dr - Vetor gradiente (derivada parcial) em relação ao parâmetro 'r'.
    %   dn - Vetor gradiente (derivada parcial) em relação ao parâmetro 'n'.
    %
    % Notas Matemáticas:
    %   A derivada da função de custo L2, C = sum((est - real).^2), em relação 
    %   a um parâmetro 'x' é: dC/dx = 2 * (est - real) * dest/dx. 
    %   O fator constante '2' geralmente é omitido (absorvido pela taxa de 
    %   aprendizado 'step' no loop de otimização). 

    % --- 1. Cálculo do Erro (Resíduo) ---
    % Diferente da Correntropia, onde o sinal negativo era absorvido pela 
    % derivada da exponencial, aqui usamos (estimado - real). Isso aponta 
    % o gradiente na direção de crescimento do erro. (Para minimizar, o loop 
    % principal fará a subtração: r = r - step * dr).
    err = trace_estimated - trace;
    
    % --- 2. Derivada em relação a 'r' ---
    % Sabendo que 'trace_estimated' surge da convolução entre 'r' e 'W', a 
    % regra da cadeia nos diz que a derivada do erro em relação a 'r' é a 
    % correlação cruzada do vetor de erro com o vetor 'W'.
    % Matematicamente, a correlação cruzada é feita invertendo-se 'W' (flip).
    dr_full = convolution(err, flip(W));
    
    % Alinhamento (Trimming):
    % A convolução gera um vetor de tamanho (len(err) + len(W) - 1). Para 
    % podermos atualizar 'r', o gradiente 'dr' precisa ter o exato mesmo 
    % tamanho de 'r'.
    % O índice de início remove o atraso (transiente) gerado pelo filtro 'W'.
    idx_start = length(W);
    
    % Extrai apenas a porção válida e alinhada correspondente aos atrasos de 'r'.
    dr = dr_full(idx_start : idx_start + r_len - 1);
    
    % --- 3. Derivada em relação a 'n' ---
    % Como 'n' é considerado um termo aditivo simples (trace_estimated = W*r + n),
    % a derivada de 'trace_estimated' em relação a 'n' é simplesmente 1.
    % Portanto, pela regra da cadeia, o gradiente recai inteiramente sobre o erro.
    dn = err;
end