function [r, n, historical_cost] = Grad_Desc_L2(W, r_init, n_init, trace, interactions, step)
    if nargin < 5 || isempty(interactions), interactions = 1000; end
    if nargin < 6 || isempty(step), step = 0.5; end
    
    rng(42);
    r = r_init(:)';
    n = n_init(:)';
    trace = trace(:)';
    W = W(:)';
    
    historical_cost = zeros(1, interactions);
    
    for i = 1:interactions
        trace_estimated = prediction(W, r, n);
        [dr, dn] = partial_derivatives_L2(W, trace, trace_estimated, length(r));
        historical_cost(i) = cost_L2(trace, trace_estimated);
        
        r = r - step * dr;
        n = n - step * dn;
    end
end
