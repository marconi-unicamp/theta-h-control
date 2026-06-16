%% Generate Poincaré Section Colored by Phase - Versão Corrigida

clear; clc; close all;

% Load data
if exist('data/poincare_data.txt', 'file')
    x = load('data/poincare_data.txt');
    fprintf('Loaded: data/poincare_data.txt (%d points)\n', length(x));
else
    error('poincare_data.txt not found');
end

% Calcular velocidade aproximada (derivada)
v = gradient(x);

% Garantir que x e v tenham o mesmo tamanho
if length(v) > length(x)
    v = v(1:length(x));
elseif length(x) > length(v)
    x = x(1:length(v));
end

% Calcular fase
theta = atan2(v, x);

% Verificar tamanhos
fprintf('Tamanhos: x=%d, v=%d, theta=%d\n', length(x), length(v), length(theta));

% Reduzir número de pontos para visualização (opcional)
step = 10;
x_sample = x(1:step:end);
v_sample = v(1:step:end);
theta_sample = theta(1:step:end);

% Criar figura
figure('Position', [100, 100, 700, 600], 'Color', 'white');
scatter(x_sample, v_sample, 8, theta_sample, 'filled');
colormap('hsv');
colorbar;
xlabel('Position x');
ylabel('Velocity v');
title('Poincaré Section - Colored by Phase');
axis equal;
grid on;
xlim([-0.7, 0.7]);
ylim([-0.7, 0.7]);

% Salvar
if ~exist('supplementary', 'dir')
    mkdir('supplementary');
end
print('-dpng', '-r300', 'supplementary/fig_poincare_phase.png');
fprintf('Saved: supplementary/fig_poincare_phase.png\n');