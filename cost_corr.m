function cost_value = cost_corr(trace, trace_estimated, k_size)
    N = length(trace);
    err = trace_estimated - trace;
    cost_value = (1 / (k_size * sqrt(2 * pi))) * (1 / N) * sum(exp(-(err.^2) ./ (2 * k_size^2)));
end