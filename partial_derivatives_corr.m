function [dr, dn] = partial_derivatives_corr(W, trace, trace_estimated, k_size, r_len)
    % PARTIAL_DERIVATIVES_CORR Calcula os gradientes para a função de Correntropia.
    %
    % Parâmetros de Entrada:
    %   W - Vetor da wavelet conhecida
    %   trace - Sinal real de referência.
    %   trace_estimated - Sinal estimado pelo modelo.
    %   k_size - Tamanho do kernel.
    %   r_len - Comprimento original do vetor 'r'.
    %
    % Parâmetros de Saída:
    %   dr - Vetor gradiente (derivada parcial) em relação ao parâmetro 'r'.
    %   dn - Vetor gradiente (derivada parcial) em relação ao parâmetro 'n'.

    % Calcula o erro
    err = trace - trace_estimated;
    % Derivada parcial direta em relação a 'n' e 'r'
    expression = exp(-((err).^2) ./ (2 * k_size^2)) .* (err);
    
    H = deconvlapps.conv_matrix(W, r_len, length(trace));
    
    dn = expression;
    dr = sum(expression(:) .* H, 1);
end