function [dr, dn] = partial_derivatives_corr(W, trace, trace_estimated, k_size, r_len)
    N = length(trace);
    err = trace_estimated - trace;
    before_the_summation = -(1 / ((k_size^3) * sqrt(2 * pi))) * (1 / N);
    
    weighted_err = exp(-(err.^2) ./ (2 * k_size^2)) .* err;
    
    % Gradiente em relação a 'r' e 'n'
    dr_full = conv(weighted_err, flip(W), 'full');
    dr = before_the_summation * dr_full(1:r_len);
    dn = before_the_summation * weighted_err;
end