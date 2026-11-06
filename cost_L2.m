function cost_value = cost_L2(trace, trace_estimated)
    N = length(trace);
    cost_value = (1 / N) * sum((trace_estimated - trace).^2);
end