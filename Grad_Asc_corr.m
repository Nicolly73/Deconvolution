function [r, n, historical_cost] = Grad_Asc_corr(W, trace, r_init, n_init, k_size, step, interactions)
    if nargin < 7 || isempty(interactions), interactions = 1000; end
    if nargin < 6 || isempty(step), step = 0.5; end
    
    rng(42);
    r = r_init(:)';
    n = n_init(:)';
    trace = trace(:)';
    W = W(:)';
    
    historical_cost = zeros(1, interactions);
    
    for i = 1:interactions
        trace_estimated = prediction(W, r, n);
        [dr, dn] = partial_derivatives_corr(W, trace, trace_estimated, k_size, length(r));
        historical_cost(i) = cost_corr(trace, trace_estimated, k_size);
        
        r = r + step * dr;
        n = n + step * dn;
    end
end