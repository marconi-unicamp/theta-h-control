%% generate_fig3_transition.m
% Generate Figure 3: Spontaneous Transition Between Regimes

clear; clc; close all;

fprintf('Generating Figure 3: Spontaneous Transition...\n');

%% Load Data
if exist('data/transition_data.mat', 'file')
    load('data/transition_data.mat');
    fprintf('Loaded: data/transition_data.mat\n');
elseif exist('transition_data.mat', 'file')
    load('transition_data.mat');
    fprintf('Loaded: transition_data.mat\n');
else
    error('transition_data.mat not found. Run generate_all_data first.');
end

%% Create Figure
figure('Position', [100, 100, 1000, 600], 'Color', 'white');

% Subplot 1: Low amplitude regime
subplot(2,1,1);
plot(1:n_zoom_before, x_before_zoom, 'b-', 'LineWidth', 0.7);
grid on;
xlabel('Crossing number');
ylabel('Position x');
title('Regime 1: Low Amplitude (\pm0.1)');
ylim([-0.2, 0.2]);

% Subplot 2: High amplitude regime
subplot(2,1,2);
plot(1:n_zoom_after, x_after_zoom, 'r-', 'LineWidth', 0.7);
grid on;
xlabel('Crossing number');
ylabel('Position x');
title('Regime 2: High Amplitude (\pm0.6)');
ylim([-0.8, 0.8]);

% General title
sgtitle('Spontaneous Transition Between Quasi-Periodic Orbits');

%% Save Figure
if ~exist('paper/figures', 'dir')
    mkdir('paper/figures');
end

print('-depsc', 'paper/figures/fig_transicao.eps');
print('-dpdf', 'paper/figures/fig_transicao.pdf');
saveas(gcf, 'paper/figures/fig_transicao.png');

fprintf('Figure saved: paper/figures/fig_transicao.eps/.pdf/.png\n');