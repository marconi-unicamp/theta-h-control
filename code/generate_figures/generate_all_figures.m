%% generate_all_figures.m
% Master script to generate all figures for the article
% Run this script to generate Figures 1-4

clear; clc;

fprintf('\n========================================\n');
fprintf('GENERATING ALL FIGURES\n');
fprintf('========================================\n\n');

% Check if data exists
if ~exist('../../data/poincare_data.txt', 'file') && ~exist('poincare_data.txt', 'file')
    error('poincare_data.txt not found. Please run simulation first.');
end

% Generate each figure
fprintf('Generating Figure 1: Poincaré Map...\n');
generate_fig1_poincare;

fprintf('\nGenerating Figure 2: Lyapunov Exponent...\n');
generate_fig2_lyapunov;

fprintf('\nGenerating Figure 3: Spontaneous Transition...\n');
generate_fig3_transition;

fprintf('\nGenerating Figure 4: Power Spectrum...\n');
generate_fig4_spectrum;

fprintf('\n========================================\n');
fprintf('ALL FIGURES GENERATED SUCCESSFULLY!\n');
fprintf('========================================\n');
fprintf('Files created in ../../paper/figures/:\n');
fprintf('  - fig_poincare.eps/.pdf/.png\n');
fprintf('  - fig_lyapunov.eps/.pdf/.png\n');
fprintf('  - fig_transition.eps/.pdf/.png\n');
fprintf('  - fig_spectrum.eps/.pdf/.png\n');
fprintf('========================================\n');