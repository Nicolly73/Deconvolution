classdef Deconvolution

    properties
        L2
        correntropy
        convolution
    end
    
    methods

        function predicted = prediction(w, r, n)
            predicted = convolution(w, r) + n;
        end

        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        % Convolution
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function signal_convolution = convolution(f, g)

            signal_length = length(f) + length(g) -1;

            signal_convolution = zeros(1, signal_length);

            for i = 1:signal_length
                sum = 0;
                for j = 1:length(f)
                index = i -j +1;
                if (index >= 1) && (length(f) >= index)
                    sum = sum + f(j)*g(index);
                end
                end
        signal_convolution(i) = sum;
            end
        end
        
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        % Norm-L2
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


        function cost_value = cost(trace, trace_estimated)
            N = length(trace);
            cost_value.L2 = (1/N)*(sum((trace_estimated - trace)^2));
        end

        %------------------------------------------------
        
        function dr, dn = partial_derivatives(trace, trace_estimated)
            dr.L2 = r*(1/N)*(trace_estimated - trace);
            dn.L2 = (1/N)*(trace_estimated - trace);
        end

        %------------------------------------------------

        function r, n, historical_cost = Grad_Desc_L2(W, r_init, n_init, trace, interactions = 1000, step=0.5)
            seed(42)
            r = r_init;
            n = n_init;
            historical_cost = zeros(1, interactions);
            for i=1:interactions
                trace_estimated = predicted(W, r, n);
                dr, dn = partial_derovatives(trace, trace_estimated);
                historical_cost(i).L2 = cost_value(trace, trace_estimated).L2; 

                r.L2 = r - step*dr;
                n.L2 = n - sep*dn;

            end
        end

        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        % Correntropy
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
        function cost_value = cost(trace, trace_estimated, k_size)
            N = length(trace);
            cost_value.correntropy = (1/(k_size*np.sqrt(2*np.pi)))*(1/N)*np.sum(np.exp(-((trace_estimated - trace)^2 / (2 * k_size^2))));
        end

        %------------------------------------------------

        function dr, dn = partial_derivatives(W, trace, trace_estimated, k_size)
            N = length(trace);
            err = traced_estimated - traced;
            before_the_summation = -(1/((k_size^3)*np.sqrt(2*np.pi)))*(1/N);
            
            dr = before_the_summation*np.sum(np.exp(-(((err)^2)/(2*k_size^2)))*W*err);
            dn = before_the_summation*np.sum(np.exp(-(((err)^2)/(2*k_size^2)))*err);
        end
    
        %------------------------------------------------
        
        function r, n, historical_cost = Grad_Asc_corr(W, trace, r_init, n_int, k_size, step, interactions)
            seed(42);
            r = r_init;
            n = n_init;
            historical_cost = zeros(1, interactions);

            for i = 1:interactions
            trace_estimated = predict(W, r, n);
            dr, dn = partial_derivatives(W, trace, trace_estimated, k_size);
            historical_cost(i) = cost(trace, trace_estimated).correntropy;
            
            r.correntropy = r + step*dr;
            n.correntropy = n + step*dr;
            end
        end
    end
end

