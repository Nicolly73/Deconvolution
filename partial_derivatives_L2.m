function [dr, dn] = partial_derivatives_L2(W, trace, trace_estimated)
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
    err = trace - trace_estimated;
    % Derivada parcial direta em relação a 'n' e 'r'
    dn = err;
    dr = (trace_estimated - trace) .* W;
end