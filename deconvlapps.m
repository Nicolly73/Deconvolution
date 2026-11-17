classdef deconvlapps
    methods (Static)

        % % ----------------------------------------- tools --------------------------------------------
        function wavelet = ricker_wavelet(f0, t, theta)
            % ricker_wavelet: Generates a Ricker wavelet (Mexican Hat Wavelet) based on f0 and t.
            %
            % The Ricker wavelet is widely used in applications such as seismics, signal processing,
            % and wave analysis due to its good localization in both time and frequency.
            %
            % Parameters:
            % ----------
            % f0 : float
            %     Central frequency of the wavelet, controlling its width. The higher the
            %     value of f0, the narrower the Ricker wavelet will be.
            %
            % t : array-like
            %     The time vector at which the wavelet will be computed. It can be a
            %     one-dimensional vector defining the time points where the wavelet will be evaluated.
            %
            % theta : rotation phase in degrees
            %     The Ricker wavelet computed for the provided time values, possibly normalized if
            %     normalise is true.
            %
            % Returns:
            % --------
            % wavelet : array

            if nargin == 2
                wavelet = (1 - 2 * (pi^2) * (f0^2) * (t.^2)) .* exp(-(pi^2) * (f0^2) * (t.^2));
            else
                % zero phase wavelet
                w_p0 = (1 - 2 * (pi^2) * (f0^2) * (t.^2)) .* exp(-(pi^2) * (f0^2) * (t.^2));

                % phase in rad
                th = theta*pi/180;

                % hilbert transform applied to zero phase wavelet
                hbt_w = hilbert(w_p0);

                % wavelet with phase rotation
                wavelet = cos(th)*real(hbt_w)+sin(th)*imag(hbt_w);

                % normalization by max absolut value of wavelet
                wavelet = wavelet/norm(wavelet,'inf');

                % --------------------------- wavelet centralization -------------------------------
                
                L = length(wavelet);

                central_pos = round(L/2);

                [~, idx_max] = max(wavelet); 

                shift_value = central_pos - idx_max;

                wavelet = circshift(wavelet,shift_value);

            end          

        end

        function HH = conv_matrix(ww, NN, DD)
            % conv_matrix Gera uma matriz de convolução a partir de um vetor de pesos.
            %
            % A função cria uma matriz onde cada coluna é uma versão deslocada do vetor
            % de pesos 'ww'. A matriz resultante pode ser usada para realizar operações
            % de convolução em um sinal.
            %
            % Parâmetros:
            %   ww : vetor unidimensional (array-like)
            %       Um vetor de pesos ou coeficientes que serão usados na operação de
            %       convolução. Este vetor é "deslocado" para formar a matriz de
            %       convolução.
            %
            %   NN : inteiro
            %       O número de colunas desejadas na matriz de convolução. Geralmente,
            %       corresponde à largura da janela de convolução.
            %
            %   DD : inteiro (opcional)
            %       A profundidade da matriz de convolução (número de linhas). Se não
            %       for fornecido, assume-se que DD é igual a NN.
            %
            %   Se DD for maior que o comprimento de 'ww' e 'NN', o vetor 'ww' será
            %   preenchido com zeros para manter o tamanho correto da matriz.
            %
            % Saída:
            %   HH : matriz 2D (DD, NN)
            %       Uma matriz de tamanho DD x NN onde cada coluna é uma versão deslocada
            %       do vetor de pesos 'ww'. A matriz resultante pode ser usada para realizar
            %       operações de convolução.
            %
            % Exemplo:
            %   ww = [1, 2, 3];
            %   rr = [1, 0, 0, 1, -1, 0, 1];
            %   NN = length(rr);
            %   LL = length(ww);
            %   
            %   result_1 = deconvlapps.conv_matrix(ww, NN);
            %   result_2 = deconvlapps.conv_matrix(rr, LL, NN);
            %
            %   disp(result_1);
            %   disp(result_2);
            %
            % Notas:
            %   - A função utiliza 'circshift' para realizar o deslocamento cíclico do vetor
            %     de pesos, criando as colunas da matriz de convolução.
            %   - O vetor 'ww' é preenchido com zeros na parte inferior, caso seja necessário,
            %     para ajustar o tamanho da matriz.
            
            if nargin < 3
                DD = NN;  % Se DD não for fornecido, assume-se que DD = NN
            end
        
            MM = length(ww);  % Comprimento do vetor de pesos
            aux_shift = floor(MM / 2);  % Deslocamento inicial com base no tamanho de 'ww'
            
            % Ajuste do deslocamento se DD for maior que o comprimento de 'ww' e NN
            if DD == MM + NN - 1
                aux_shift = 1;
            elseif MM > NN
                aux_shift = floor(NN / 2);
            end
            
            % Preenchendo o vetor 'ww' com zeros para ajustar a profundidade
            ww_pad = [ww(:)', zeros(1, DD + MM)];
            
            % Inicializando a matriz de saída (DD x NN)
            HH = zeros(DD, NN);
            
            % Preenchendo a matriz de convolução com versões deslocadas de 'ww'
            for nn = 1:NN
                aux_vect = circshift(ww_pad, [0, nn - aux_shift]);  % Deslocamento cíclico
                HH(:, nn) = aux_vect(1:DD);  % Armazenando a parte relevante do vetor deslocado
            end
        end         
    end
end