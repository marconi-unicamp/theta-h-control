%% compile_sfunctions.m
% Compile all C S-Functions for Theta-H control
% Run this script once before using the Simulink models

clear; clc;

fprintf('\n========================================\n');
fprintf('COMPILING THETA-H S-FUNCTIONS\n');
fprintf('========================================\n\n');

% Check if C compiler is configured
try
    mex -setup C
catch
    fprintf('ERROR: No C compiler found.\n');
    fprintf('Please run "mex -setup C" first.\n');
    return;
end

% List of S-Functions to compile
sfunctions = {'theta_control.c', 'duffing_x4_safe.c'};

for i = 1:length(sfunctions)
    fprintf('Compiling %s...\n', sfunctions{i});
    
    if ~exist(sfunctions{i}, 'file')
        fprintf('  ERROR: File %s not found!\n', sfunctions{i});
        continue;
    end
    
    try
        mex(sfunctions{i}, '-output', sfunctions{i}(1:end-2));
        fprintf('  SUCCESS: %s compiled.\n', sfunctions{i});
    catch ME
        fprintf('  ERROR: %s\n', ME.message);
    end
end

fprintf('\n========================================\n');
fprintf('COMPILATION COMPLETE\n');
fprintf('========================================\n');