function [dr, dn] = partial_derivatives_L2(W, trace, trace_estimated, r_len)
    N = length(trace);
    err = trace_estimated - trace;
    
    % Gradiente em relação a 'r' (correlação cruzada do erro com W)
    dr_full = conv(err, flip(W), 'full');
    dr = (2 / N) * dr_full(1:r_len);
    
    % Gradiente em relação ao ruído 'n'
    dn = (2 / N) * err;
end