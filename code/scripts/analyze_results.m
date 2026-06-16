%% analyze_results.m
% Analyze simulation results and compute metrics
% Requires simulation_results.mat to exist

clear; clc;

fprintf('\n========================================\n');
fprintf('ANALYZING THETA-H RESULTS\n');
fprintf('========================================\n\n');

% Load simulation results
if exist('../../data/simulation_results.mat', 'file')
    load('../../data/simulation_results.mat');
    fprintf('Loaded: ../../data/simulation_results.mat\n');
elseif exist('simulation_results.mat', 'file')
    load('simulation_results.mat');
    fprintf('Loaded: simulation_results.mat\n');
elseif exist('y_out', 'var')
    fprintf('Using variables from workspace\n');
else
    error('No simulation results found. Please run run_simulation.m first.');
end

% Ensure variables are column vectors
if size(y_out,1) == 1, y_out = y_out'; end
if size(u_out,1) == 1, u_out = u_out'; end
if size(t_out,1) == 1, t_out = t_out'; end

% Parameters
N = length(y_out);
dt = t_out(2) - t_out(1);
t = t_out;

% Basic statistics
fprintf('\n--- BASIC STATISTICS ---\n');
fprintf('Points: %d\n', N);
fprintf('Time: %.1f s\n', t(end));
fprintf('Output mean: %.6f\n', mean(y_out));
fprintf('Output std: %.6f\n', std(y_out));
fprintf('Output max: %.6f\n', max(abs(y_out)));

% Control effort
control_energy = sum(u_out.^2) * dt;
fprintf('\n--- CONTROL METRICS ---\n');
fprintf('Control energy: %.4f\n', control_energy);
fprintf('Control mean: %.4f\n', mean(u_out));
fprintf('Control std: %.4f\n', std(u_out));
fprintf('Control max: %.4f\n', max(abs(u_out)));

% Settling time (5% band)
setpoint = 0;
band = 0.05;
idx_settled = find(abs(y_out - setpoint) < band, 1, 'last');
if ~isempty(idx_settled) && idx_settled < N
    settling_time = t(idx_settled);
    fprintf('\n--- TRANSIENT METRICS ---\n');
    fprintf('Settling time (5%%): %.1f s\n', settling_time);
else
    fprintf('\n--- TRANSIENT METRICS ---\n');
    fprintf('Settling time: Not reached within simulation time\n');
end

% Poincaré section analysis
if exist('../../data/poincare_data.txt', 'file')
    poincare_data = load('../../data/poincare_data.txt');
    fprintf('\n--- POINCARE METRICS ---\n');
    
    % Check if data has one or two columns
    [n_points, n_cols] = size(poincare_data);
    fprintf('Poincaré points: %d, columns: %d\n', n_points, n_cols);
    
    if n_cols == 1
        % One column: just position
        x_poin = poincare_data;
        y_poin = poincare_data(2:end);
        x_poin = x_poin(1:end-1);
        cx = mean(x_poin);
        cy = mean(y_poin);
        
        r = sqrt((x_poin - cx).^2 + (y_poin - cy).^2);
        fprintf('Center: (%.4f, %.4f)\n', cx, cy);
        fprintf('Mean radius: %.4f\n', mean(r));
        fprintf('Radius std: %.4f (%.1f%%)\n', std(r), 100*std(r)/mean(r));
        
    elseif n_cols >= 2
        % Two columns: position and velocity
        x_poin = poincare_data(:,1);
        v_poin = poincare_data(:,2);
        cx = mean(x_poin);
        cy = mean(v_poin);
        
        r = sqrt((x_poin - cx).^2 + (v_poin - cy).^2);
        fprintf('Center: (%.4f, %.4f)\n', cx, cy);
        fprintf('Mean radius: %.4f\n', mean(r));
        fprintf('Radius std: %.4f (%.1f%%)\n', std(r), 100*std(r)/mean(r));
    end
else
    fprintf('\n--- POINCARE METRICS ---\n');
    fprintf('Poincare data not found.\n');
end

% Save analysis results
analysis.N = N;
analysis.t_end = t(end);
analysis.dt = dt;
analysis.mean_y = mean(y_out);
analysis.std_y = std(y_out);
analysis.max_y = max(abs(y_out));
analysis.control_energy = control_energy;
analysis.control_max = max(abs(u_out));
if exist('settling_time', 'var')
    analysis.settling_time = settling_time;
end

% Save to data folder
if exist('../../data', 'dir')
    save('../../data/analysis_results.mat', 'analysis');
    fprintf('\nAnalysis saved to ../../data/analysis_results.mat\n');
else
    save('analysis_results.mat', 'analysis');
    fprintf('\nAnalysis saved to analysis_results.mat\n');
end

fprintf('\n========================================\n');
fprintf('ANALYSIS COMPLETE\n');
fprintf('========================================\n');