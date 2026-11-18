function dr = partial_derivatives_L2(H, trace, trace_estimated, lambda, r)
    % PARTIAL_DERIVATIVES_L2 Calcula os gradientes para a função de custo L2.
    %
    % Parâmetros de Entrada:
    %   W - Vetor da wavelet conhecida.
    %   trace - Sinal real de referência.
    %   trace_estimated - Sinal estimado pelo modelo.
    %
    % Parâmetros de Saída:
    %   dr - Vetor gradiente (derivada parcial) em relação ao parâmetro 'r'.

    % Calcula o erro
    err = trace - trace_estimated;
    % Derivada parcial direta em relação a 'r'

    dr = (-H'*err')' +  + lambda*sign(r);
end