function [dr, dn] = partial_derivatives_L2(W, trace, trace_estimated, r_len)
    % PARTIAL_DERIVATIVES_L2 Calcula os gradientes para a função de custo L2.
    %
    % Parâmetros de Entrada:
    %   W - Vetor da wavelet conhecida.
    %   trace - Sinal real de referência.
    %   trace_estimated - Sinal estimado pelo modelo.
    %
    % Parâmetros de Saída:
    %   dr - Vetor gradiente (derivada parcial) em relação ao parâmetro 'r'.
    %   dn - Vetor gradiente (derivada parcial) em relação ao parâmetro 'n'.

    % Calcula o erro
    err = trace_estimated - trace;
    % Derivada parcial direta em relação a 'n' e 'r'
    expression = err;
    
    
    H = deconvlapps.conv_matrix(W, r_len, length(trace));
    
    dn = sum(expression(:), 1);
    dr = sum(expression(:) .* H, 1);
end