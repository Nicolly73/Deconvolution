function dr = partial_derivatives_corr(H, trace, trace_estimated, k_size, lambda, r)
    % PARTIAL_DERIVATIVES_CORR Calcula os gradientes para a função de Correntropia.
    %
    % Parâmetros de Entrada:
    %   W - Vetor da wavelet conhecida
    %   trace - Sinal real de referência.
    %   trace_estimated - Sinal estimado pelo modelo.
    %   k_size - Tamanho do kernel.
    %
    % Parâmetros de Saída:
    %   dr - Vetor gradiente (derivada parcial) em relação ao parâmetro 'r'.

    % Calcula o erro
    err = trace - trace_estimated;
    % Derivada parcial direta em relação a 'n' e 'r'
    expression = exp(-((err).^2) ./ (2 * k_size^2))*err;

    dr = (H' * expression) -  + lambda*sign(r);
end