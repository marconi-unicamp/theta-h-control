%% Generate all .mat files from poincare_data.txt
% Run this script after simulation is complete

clear; clc;

fprintf('\n========================================\n');
fprintf('GENERATING ALL DATA FILES\n');
fprintf('========================================\n\n');

% Check if poincare_data.txt exists
if ~exist('poincare_data.txt', 'file')
    error('poincare_data.txt not found. Run simulation first.');
end

% Generate all data files
generate_lyapunov_data;
generate_transition_data;
generate_spectrum_data;

fprintf('\n========================================\n');
fprintf('ALL DATA FILES GENERATED SUCCESSFULLY!\n');
fprintf('========================================\n');
fprintf('Files created:\n');
fprintf('  - lyapunov_data.mat\n');
fprintf('  - transition_data.mat\n');
fprintf('  - spectrum_data.mat\n');
fprintf('========================================\n');