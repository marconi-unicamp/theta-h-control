%% Generate Recurrence Plot (Mosaic) - Versão Corrigida
% Reduz o número de pontos para caber na memória

clear; clc; close all;

% Load data
load('data/simulation_results.mat');

% Reduzir drasticamente o número de pontos
step = 2000;  % Aumentado de 200 para 2000 (menos pontos)
y_sample = y_out(1:step:end);
N = length(y_sample);

fprintf('Pontos para o Recurrence Plot: %d\n', N);

% Verificar se a matriz é muito grande
max_points = 2000;  % Limite para manter a matriz pequena
if N > max_points
    % Amostrar novamente
    step2 = round(N / max_points);
    y_sample = y_sample(1:step2:end);
    N = length(y_sample);
    fprintf('Reduzido para %d pontos\n', N);
end

% Parâmetros
epsilon = 0.15 * std(y_sample);

% Calcular matriz de recorrência (apenas triangular superior)
fprintf('Calculando matriz de recorrência (%d x %d)...\n', N, N);
R = zeros(N, N);

% Usar loop único para economizar memória
for i = 1:N
    for j = i:N
        if abs(y_sample(i) - y_sample(j)) < epsilon
            R(i,j) = 1;
            R(j,i) = 1;
        end
    end
end

% Criar figura
figure('Position', [100, 100, 600, 600], 'Color', 'white');
imagesc(R);
colormap([1,1,1; 0,0,0]);
xlabel('Time index');
ylabel('Time index');
title('Recurrence Plot - Quasi-Periodic Structure');
axis square;

% Salvar
if ~exist('supplementary', 'dir')
    mkdir('supplementary');
end
print('-dpng', '-r300', 'supplementary/fig_recurrence_plot.png');
fprintf('Saved: supplementary/fig_recurrence_plot.png\n');