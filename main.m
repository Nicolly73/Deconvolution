
%% Geração dos Dados Sintéticos

% Wavelet


% Período de Amostragem de 4 ms
dt = 4e-3;

% Eixo temporal da wavelet
tw = -0.06:dt:0.06;

%% Geração de uma wavelet de ricker
% Frequência central da wavelet
f0 = 20;

w = deconvlapps.ricker_wavelet(f0, tw);



%% Geração da refletividade sintética

% Tamanho da série de refletividade
N = 1000;

% Eixo temporal do dado sísmico
t = (0:N-1)*dt;

% Vetor esparso inicial
r = zeros(N, 1);


% Colocando refletores (camadas de rocha em posições determinadas

r(200) = 1;

r(500) = -0.6;

r(800) = 0.4;





%% Geração do Traço Sísmico pelo modelo convolucional

x = conv(r, w, 'same');





%% Plot dos Resultados

fontesize = 15;
figure()
% plot(tw, w, 'linewidth', 5, 'color', 'red'); hold on;
plot(t, x, 'linewidth', 7, 'color', 'magenta'); hold on;
plot(t, r, 'linewidth', 2, 'color', 'blue');
grid on
legend('Seismic Trace', 'Reflectivity');
xlabel('Time (s)');
ylabel('Amplitude')
set(gca, 'fontsize', fontesize)






%% Deconvolução

% Utilizando a biblioteca deconvlapps.m, complete a função supervised_deconvolution_l2 e
% realize a deconvolução supervisionada do traço sísmico gerado acima


% Defina os parâmetros do método(taxa de aprendizagem, regularização,
% número de iterações)

% Parâmetros que você pode usar como chutes iniciais
lambda_r = 0.05; %Peso da regularizacao. Controla o quanto se deseja forcar a solucao a ter zeros (ser espassada)
rn_rate_r = 0.009; % Taxa de aprendizagem (alpha). E o tamanho do passo que o algoritmo da a cada tentativa para diminuir o erro.É
n_iter = 500; % Numero de interacoes


% Chame a função de deconvolução da biblioteca deconvlapps
[r_est, cost_history] = deconvlapps.supervised_deconvolution_l2(x, w, lambda_r, ...
                lrn_rate_r, n_iter);


figure()
plot(t, r, 'linewidth', 7, 'color', 'magenta'); hold on;
plot(t, r_est, 'linewidth', 2, 'color', 'blue');
grid on
legend('Reflectivity', 'Estimated Reflectivity');
xlabel('Time (s)');
ylabel('Amplitude')
set(gca, 'fontsize', fontesize)

