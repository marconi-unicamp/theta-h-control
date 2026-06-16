%% Generate 3D Torus Visualization
% Salvar em: supplementary/fig_torus_3d.png

clear; clc; close all;

% Load data
load('data/simulation_results.mat');
load('data/poincare_data.txt');

% Parameters
dt = t_out(2) - t_out(1);
v = gradient(y_out, dt);

% Sample for visualization (avoid overload)
step = 5000;
y_sample = y_out(1:step:end);
v_sample = v(1:step:end);
t_sample = t_out(1:step:end);

% Normalize time for color
t_norm = (t_sample - min(t_sample)) / (max(t_sample) - min(t_sample));

% Create figure
figure('Position', [100, 100, 800, 600], 'Color', 'white');
scatter3(y_sample, v_sample, t_sample, 15, t_norm, 'filled');
colormap('jet');
colorbar;
xlabel('Position x');
ylabel('Velocity v');
zlabel('Time (s)');
title('3D Torus Visualization of the Controlled System');
view(45, 30);
grid on;

% Save
print('-dpng', '-r300', 'supplementary/fig_torus_3d.png');
fprintf('Saved: supplementary/fig_torus_3d.png\n');