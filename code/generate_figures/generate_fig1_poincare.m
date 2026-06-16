%% generate_fig1_poincare.m
% Generate Figure 1: Poincaré Map - Two Concentric Ellipses
% This script generates the main Poincaré map figure for the article

clear; clc; close all;

fprintf('Generating Figure 1: Poincaré Map...\n');

%% Load Data
if exist('../../data/poincare_data.txt', 'file')
    data = load('../../data/poincare_data.txt');
    fprintf('Data loaded: ../../data/poincare_data.txt (%d points)\n', length(data));
elseif exist('poincare_data.txt', 'file')
    data = load('poincare_data.txt');
    fprintf('Data loaded: poincare_data.txt (%d points)\n', length(data));
else
    error('poincare_data.txt not found. Please run simulation first.');
end

%% Construct Poincaré Map
x = data;
y = data(2:end);
x = x(1:end-1);
min_len = min(length(x), length(y));
x = x(1:min_len);
y = y(1:min_len);

%% Calculate Ellipse Parameters
cx = mean(x);
cy = mean(y);

% Split into two ellipses based on radius
r = sqrt((x - cx).^2 + (y - cy).^2);
r_limiar = 0.4;

idx_interna = r <= r_limiar;
idx_externa = r > r_limiar;

x_int = x(idx_interna);
y_int = y(idx_interna);
x_ext = x(idx_externa);
y_ext = y(idx_externa);

% Semi-axes
a_int = max(abs(x_int - cx));
b_int = max(abs(y_int - cy));
a_ext = max(abs(x_ext - cx));
b_ext = max(abs(y_ext - cy));

% Excentricities
e_int = sqrt(1 - (min(a_int, b_int)/max(a_int, b_int))^2);
e_ext = sqrt(1 - (min(a_ext, b_ext)/max(a_ext, b_ext))^2);

fprintf('Ellipse parameters:\n');
fprintf('  Inner: a=%.4f, b=%.4f, e=%.4f, points=%d (%.1f%%)\n', ...
        a_int, b_int, e_int, length(x_int), 100*length(x_int)/length(x));
fprintf('  Outer: a=%.4f, b=%.4f, e=%.4f, points=%d (%.1f%%)\n', ...
        a_ext, b_ext, e_ext, length(x_ext), 100*length(x_ext)/length(x));

%% Create Figure
figure('Position', [100, 100, 800, 600], 'Color', 'white');

% Plot points
plot(x, y, 'b.', 'MarkerSize', 2);
hold on;

% Fit ellipses
theta_plot = linspace(0, 2*pi, 200);
x_int_fit = cx + a_int * cos(theta_plot);
y_int_fit = cy + b_int * sin(theta_plot);
plot(x_int_fit, y_int_fit, 'r-', 'LineWidth', 1.5);

x_ext_fit = cx + a_ext * cos(theta_plot);
y_ext_fit = cy + b_ext * sin(theta_plot);
plot(x_ext_fit, y_ext_fit, 'r-', 'LineWidth', 1.5);

% Center
plot(cx, cy, 'ko', 'MarkerSize', 8, 'LineWidth', 2);

% Reference diagonal
plot([-0.7, 0.7], [-0.7, 0.7], 'k--', 'LineWidth', 0.5);

% Formatting
axis equal;
grid on;
xlim([-0.7, 0.7]);
ylim([-0.7, 0.7]);
xlabel('x(n)');
ylabel('x(n+1)');
title('Poincaré Map - Two Concentric Ellipses');
legend('Data points', 'Inner ellipse', 'Outer ellipse', 'Center', ...
       'Location', 'best');

% Annotations
text(-0.65, 0.55, sprintf('Inner: a = %.3f, b = %.3f', a_int, b_int), ...
     'FontSize', 9, 'BackgroundColor', 'white');
text(-0.65, 0.45, sprintf('Outer: a = %.3f, b = %.3f', a_ext, b_ext), ...
     'FontSize', 9, 'BackgroundColor', 'white');
text(-0.65, 0.35, sprintf('e_{in} = %.4f, e_{out} = %.4f', e_int, e_ext), ...
     'FontSize', 9, 'BackgroundColor', 'white');
text(-0.65, 0.25, sprintf('r_{out}/r_{in} = %.2f', a_ext/a_int), ...
     'FontSize', 9, 'BackgroundColor', 'white');

%% Save Figure
% Create figures directory if it doesn't exist
if ~exist('../../paper/figures', 'dir')
    mkdir('../../paper/figures');
end

print('-depsc', '../../paper/figures/fig_poincare.eps');
print('-dpdf', '../../paper/figures/fig_poincare.pdf');
saveas(gcf, '../../paper/figures/fig_poincare.png');

fprintf('Figure saved: ../../paper/figures/fig_poincare.eps/.pdf/.png\n');