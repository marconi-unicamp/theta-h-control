%% generate_transition_data.m
% Generate transition_data.mat from poincare_data.txt

clear; clc;

fprintf('Generating transition_data.mat...\n');

% Load Poincaré data
if exist('data/poincare_data.txt', 'file')
    data = load('data/poincare_data.txt');
    fprintf('Data loaded: data/poincare_data.txt (%d points)\n', length(data));
elseif exist('poincare_data.txt', 'file')
    data = load('poincare_data.txt');
    fprintf('Data loaded: poincare_data.txt (%d points)\n', length(data));
else
    error('poincare_data.txt not found. Run simulation first.');
end

x = data;
N = length(x);

% Parameters
transition_point = 4300;

if N > transition_point
    x_before = x(1:transition_point);
    x_after = x(transition_point+1:end);
else
    transition_point = round(N/2);
    x_before = x(1:transition_point);
    x_after = x(transition_point+1:end);
end

% Zoom windows
n_zoom_before = min(2000, length(x_before));
n_zoom_after = min(2000, length(x_after));

x_before_zoom = x_before(1:n_zoom_before);
x_after_zoom = x_after(1:n_zoom_after);

% Statistics
mean_before = mean(x_before);
std_before = std(x_before);
max_before = max(abs(x_before));

mean_after = mean(x_after);
std_after = std(x_after);
max_after = max(abs(x_after));

% Save data
save('data/transition_data.mat', 'x_before', 'x_after', ...
     'x_before_zoom', 'x_after_zoom', ...
     'transition_point', 'n_zoom_before', 'n_zoom_after', ...
     'mean_before', 'std_before', 'max_before', ...
     'mean_after', 'std_after', 'max_after');

fprintf('Transition data saved to data/transition_data.mat\n');
fprintf('  Before transition: mean=%.4f, std=%.4f, max=%.4f\n', ...
        mean_before, std_before, max_before);
fprintf('  After transition: mean=%.4f, std=%.4f, max=%.4f\n', ...
        mean_after, std_after, max_after);