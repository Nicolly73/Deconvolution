function signal_convolution = convolution(f, g)
    signal_length = length(f) + length(g) - 1;
    signal_convolution = zeros(1, signal_length);
    
    for i = 1:signal_length
        s = 0;
        for j = 1:length(f)
            index = i - j + 1;
            if (index >= 1) && (index <= length(g))
                s = s + f(j) * g(index);
            end
        end
        signal_convolution(i) = s;
    end
end