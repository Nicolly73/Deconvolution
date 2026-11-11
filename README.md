# Deconvolution
This repository contains my solution to the supervised deconvolution problem (with a known wavelet) using L2-norm and correntropy.
# Otimização e Deconvolução de Sinais (MATLAB)

Este repositório contém uma suíte de funções em MATLAB/Octave para estimativa de parâmetros e deconvolução de sinais baseada em modelos convolucionais. O projeto implementa dois métodos de otimização iterativa: **Descida de Gradiente (Norma L2)** e **Subida de Gradiente (Correntropia/Kernel Gaussiano)**.

## 📌 Visão Geral

O objetivo principal destes algoritmos é resolver o problema inverso de um modelo convolucional aditivo. Dado um sinal observado (`trace`) e um filtro/wavelet conhecido (`W`), o algoritmo estima os vetores iterativamente:
* **`r`**: Refletividade, série de impulsos ou sinal original.
* **`n`**: Ruído aditivo, bias ou sinal de fundo.

O modelo direto (*forward model*) é matematicamente definido como:
> **y = W * r + n**

Onde `*` denota a operação de convolução 1D linear.

## 🧰 Estrutura dos Arquivos

O projeto está dividido nas seguintes funções independentes:

### Algoritmos de Otimização
* `Grad_Desc_L2.m`: Otimiza `r` e `n` utilizando a métrica do Erro Quadrático (L2). É sensível a *outliers*, mas tem convergência clássica e rápida para ruídos Gaussianos.
* `Grad_Asc_corr.m`: Otimiza `r` e `n` utilizando Correntropia (Kernel Gaussiano). É altamente robusto contra *outliers* e ruídos não-Gaussianos de alta amplitude.

### Funções de Custo e Gradientes
* `cost_L2.m`: Calcula a soma dos erros quadráticos.
* `cost_corr.m`: Calcula o custo baseado na similaridade Gaussiana (Máxima Correntropia).
* `partial_derivatives_L2.m`: Calcula os gradientes usando correlação cruzada para o custo L2.
* `partial_derivatives_corr.m`: Calcula os gradientes ponderados para a Correntropia.

### Funções Base
* `prediction.m`: Implementa o modelo direto (Gera o sinal estimado).
* `convolution.m`: Implementação nativa da convolução linear 1D baseada no método de reverter e deslizar.

## 🚀 Como Usar (Exemplo Rápido)

Abaixo há um script de exemplo simples mostrando como criar dados sintéticos, contaminá-los com ruído e usar o otimizador para recuperar os parâmetros originais.

Crie um arquivo `main.m` e execute:

```matlab
% 1. Criação de Dados Sintéticos
W = [0.5, 1.0, 0.5]; % Wavelet/Filtro conhecido
r_true = zeros(1, 50); r_true([10, 25, 40]) = [1, -0.8, 0.5]; % Refletividade real
n_true = 0.05 * randn(1, 52); % Ruído gaussiano

% Gera o sinal real observado (trace)
trace = prediction(W, r_true, n_true);

% 2. Chutes Iniciais (Vazios/Zeros)
r_init = zeros(1, length(r_true));
n_init = zeros(1, length(n_true));

% 3. Otimização L2
interactions = 500;
step = 0.05;
[r_opt_L2, n_opt_L2, cost_L2_hist] = Grad_Desc_L2(W, r_init, n_init, trace, interactions, step);

% 4. Otimização Correntropia
k_size = 0.5; % Tamanho do kernel
[r_opt_Corr, n_opt_Corr, cost_corr_hist] = Grad_Asc_corr(W, r_init, n_init, trace, interactions, step, k_size);

% 5. Visualização
figure;
subplot(2,1,1);
plot(cost_L2_hist, 'LineWidth', 2); title('Convergência L2 (Minimização)'); xlabel('Iterações'); ylabel('Erro L2');

subplot(2,1,2);
plot(cost_corr_hist, 'r', 'LineWidth', 2); title('Convergência Correntropia (Maximização)'); xlabel('Iterações'); ylabel('Custo Correntropia');