%% Generate lyapunov_data.mat from poincare_data.txt
% This script calculates the Lyapunov exponent from the Poincaré data

clear; clc;

fprintf('Generating lyapunov_data.mat...\n');

% Load Poincaré data
if exist('poincare_data.txt', 'file')
    data = load('poincare_data.txt');
    x = data;
    fprintf('Data loaded: %d points\n', length(x));
else
    error('poincare_data.txt not found. Run simulation first.');
end

% Parameters
N = length(x);
dt_poincare = 0.83; % Approximate time between crossings (from simulation)

% Estimate Lyapunov exponent using Wolf method
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

% Save data
t_fit_save = t_fit;
log_dist_save = log_dist;
p_save = p;
lambda_save = lambda;

save('lyapunov_data.mat', 't_fit_save', 'log_dist_save', 'p_save', 'lambda_save');

fprintf('Lyapunov exponent: lambda = %.6f\n', lambda);
fprintf('Data saved to lyapunov_data.mat\n');