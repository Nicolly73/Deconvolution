function predicted = prediction(w, r, n)
    conv_res = convolution(w, r);
    
    % Garante que ambos sejam vetores-linha
    conv_res = conv_res(:)';
    n = n(:)';
    
    len = min(length(conv_res), length(n));
    predicted = conv_res(1:len) + n(1:len);
end