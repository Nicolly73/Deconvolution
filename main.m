clear
clc
close all

%% Geração dos Dados Sintéticos

% Semente
rng(42)

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

% Colocando refletores (camadas de rocha em posições determinadas)
r(200) = 1;
r(500) = -0.6;
r(800) = 0.4;

%% Geração do Traço Sísmico pelo modelo convolucional
x_withoutN = convolution(r, w);

Nx = length(x_withoutN);

% n = 0.05 * randn(1, Nx);
 n = 0 * randn(1, Nx);
% n = 1.5 * (rand(1, Nx) > 0.995);

x = x_withoutN + n;

% Tamanho do traço convoluído e vetores iniciais
Nx = length(x);
tx = (0:Nx-1)*dt;

r_init = zeros(N, 1);

%% Plot dos Resultados

fontesize = 15;
figure('Name', 'Dado Sísmico Sintético');
plot(tx - 0.06, x, 'linewidth', 4, 'color', 'magenta'); hold on;
plot(t, r, 'linewidth', 2, 'color', 'blue');
xlim([0, max(t)]);
grid on;
legend('Seismic Trace', 'Reflectivity');
xlabel('Time (s)');
ylabel('Amplitude');
set(gca, 'fontsize', fontesize);

%% Deconvolução

% Parâmetros do método
step = 0.009; % Taxa de aprendizagem (alpha)
n_iter = 1000;      % Número de iterações
lambda = 0.5;
k_size = 0.8;      % Largura do kernel da sua função cost_corr
iter_axis = 1:n_iter;

% Chamada da função de deconvolução pela Norma-L2
[r_est_L2, cost_history_L2] = Grad_Desc_L2(w, r_init, x, n_iter, step, N, lambda);

figure('Name', 'Refletividade Estimada - Norma L2');
plot(t, r, 'linewidth', 5, 'color', 'magenta'); hold on;
plot(t, r_est_L2, 'linewidth', 2, 'color', 'blue');
grid on;
legend('Reflectivity', 'Estimated Reflectivity with norm - L2');
xlabel('Time (s)');
ylabel('Amplitude');
set(gca, 'fontsize', fontesize);

figure('Name', 'Histórico de Custo - Norma L2');
plot(iter_axis, cost_history_L2, 'linewidth', 1.5, 'color', 'black');
grid on;
legend('Cost History - Norm-L2');
xlabel('Iteration (n)');
ylabel('Cost Value');
set(gca, 'fontsize', fontesize);

% Chamada da sua função de deconvolução pela Correntropia
[r_est_corr, cost_history_corr] = Grad_Asc_corr(w, r_init, x, n_iter, step, k_size, N, lambda);

figure('Name', 'Refletividade Estimada - Correntropia');
plot(t, r, 'linewidth', 5, 'color', 'magenta'); hold on;
plot(t, r_est_corr, 'linewidth', 2, 'color', 'blue');
grid on;
legend('Reflectivity', 'Estimated Reflectivity with Correntropy');
xlabel('Time (s)');
ylabel('Amplitude');
set(gca, 'fontsize', fontesize);

figure('Name', 'Histórico de Custo - Correntropia');
plot(iter_axis, cost_history_corr, 'linewidth', 1.5, 'color', 'black');
grid on;
legend('Cost History - Correntropy');
xlabel('Iteration (n)');
ylabel('Cost Value');
set(gca, 'fontsize', fontesize);