%% generate_fig2_lyapunov.m
% Generate Figure 2: Lyapunov Exponent Calculation
% This script calculates and plots the Lyapunov exponent

clear; clc; close all;

fprintf('Generating Figure 2: Lyapunov Exponent...\n');

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

x = data;
N = length(x);

%% Calculate Lyapunov Exponent (Wolf method)
max_time = 500;
step = 50;
distances = zeros(max_time, 1);
count = zeros(max_time, 1);

for i = 1:step:N-max_time
    x_ref = x(i);
    dist_min = inf;
    j_min = 0;
    
    for j = 1:step:N-max_time
        if abs(j - i) > 10
            dist = abs(x(j) - x_ref);
            if dist < dist_min && dist > 0.001
                dist_min = dist;
                j_min = j;
            end
        end
    end
    
    if j_min > 0
        for k = 1:max_time
            if i+k <= N && j_min+k <= N
                dist_curr = abs(x(i+k) - x(j_min+k));
                if dist_curr > 0
                    distances(k) = distances(k) + log(dist_curr);
                    count(k) = count(k) + 1;
                end
            end
        end
    end
end

for k = 1:max_time
    if count(k) > 0
        distances(k) = distances(k) / count(k);
    end
end

% Linear fit
t_vec = (1:max_time)';
idx_valid = isfinite(distances) & distances ~= 0 & t_vec < 200;
t_fit = t_vec(idx_valid);
log_dist = distances(idx_valid);
p = polyfit(t_fit, log_dist, 1);
lambda = p(1);

fprintf('Lyapunov exponent: λ = %.6f\n', lambda);

%% Create Figure
figure('Position', [100, 100, 800, 600], 'Color', 'white');

plot(t_fit, log_dist, 'b.', 'MarkerSize', 3);
hold on;
t_line = [min(t_fit), max(t_fit)];
log_line = polyval(p, t_line);
plot(t_line, log_line, 'r-', 'LineWidth', 2);

grid on;
xlabel('Time (crossings)');
ylabel('log(mean distance)');
title(sprintf('Lyapunov Exponent: λ = %.6f ≈ 0', lambda));
legend('Experimental data', sprintf('Linear fit: λ = %.5f', lambda), ...
       'Location', 'best');

%% Save Figure
if ~exist('../../paper/figures', 'dir')
    mkdir('../../paper/figures');
end

print('-depsc', '../../paper/figures/fig_lyapunov.eps');
print('-dpdf', '../../paper/figures/fig_lyapunov.pdf');
saveas(gcf, '../../paper/figures/fig_lyapunov.png');

fprintf('Figure saved: ../../paper/figures/fig_lyapunov.eps/.pdf/.png\n');