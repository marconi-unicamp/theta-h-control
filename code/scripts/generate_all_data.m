%% generate_all_data.m
% Generate all .mat data files from raw data

clear; clc;

fprintf('\n========================================\n');
fprintf('GENERATING ALL DATA FILES\n');
fprintf('========================================\n\n');

% Check if data directory exists
if ~exist('data', 'dir')
    error('data/ directory not found. Please run simulation first.');
end

% Check if required files exist
if ~exist('data/poincare_data.txt', 'file')
    error('data/poincare_data.txt not found. Run simulation first.');
end

if ~exist('data/simulation_results.mat', 'file')
    error('data/simulation_results.mat not found. Run simulation first.');
end

% Generate data files
fprintf('\nGenerating lyapunov_data.mat...\n');
generate_lyapunov_data;

fprintf('\nGenerating transition_data.mat...\n');
generate_transition_data;

fprintf('\nGenerating spectrum_data.mat...\n');
generate_spectrum_data;

fprintf('\n========================================\n');
fprintf('ALL DATA FILES GENERATED SUCCESSFULLY!\n');
fprintf('========================================\n');
fprintf('Files in data/:\n');
dir('data/*.mat')