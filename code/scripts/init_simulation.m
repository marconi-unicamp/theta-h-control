%% init_simulation.m
% Initialize simulation parameters for Theta-H control
% Run this script before run_simulation.m

clear; clc; close all;

fprintf('\n========================================\n');
fprintf('INITIALIZING THETA-H SIMULATION\n');
fprintf('========================================\n\n');

%% Model Parameters
model_name = 'theta_control_hardware';

%% Controller Parameters (Theta-H)
% Gains derived from tau parameters
% tau1 = 0.5, tau2 = 0.4, tau3 = 0.1
params.tau1 = 0.5;
params.tau2 = 0.4;
params.tau3 = 0.1;
params.tau4 = 0.08;
params.tau5 = 0.04;
params.gain_fantasma = 1.0;
params.alpha_mem = 0.98;

% State feedback gains (fixed)
params.K1 = 8.0;
params.K2 = 6.0;

%% Plant Parameters (Quartic Oscillator)
% Equation: x'' + b*x' - x + alpha*x^4 = A*cos(omega*t) + u
params.x0 = -0.2;      % Initial position
params.v0 = -0.6;      % Initial velocity
params.b = 0.25;       % Damping coefficient
params.A = 0.3;        % External force amplitude
params.omega = 1.0;    % External force frequency
params.alpha = 1.0;    % Quartic nonlinearity coefficient

%% Simulation Parameters
params.dt = 0.001;     % Fixed step size (s)
params.T_sim = 20000;  % Total simulation time (s)
params.N = round(params.T_sim / params.dt);  % Number of steps

%% Reference Signal (Setpoint)
% For stabilization, setpoint = 0
% For forced oscillation, uncomment the line below
params.setpoint = 0;
% params.setpoint = @(t) 0.5 * sin(2*pi*0.8*t);  % Oscillatory reference

%% Output Configuration
fprintf('Controller Parameters:\n');
fprintf('  tau1 = %.2f, tau2 = %.2f, tau3 = %.2f\n', ...
        params.tau1, params.tau2, params.tau3);
fprintf('  K1 = %.1f, K2 = %.1f\n', params.K1, params.K2);
fprintf('  alpha_mem = %.2f\n', params.alpha_mem);

fprintf('\nPlant Parameters:\n');
fprintf('  x0 = %.1f, v0 = %.1f\n', params.x0, params.v0);
fprintf('  b = %.2f, A = %.2f, omega = %.2f\n', ...
        params.b, params.A, params.omega);
fprintf('  alpha = %.1f\n', params.alpha);

fprintf('\nSimulation Parameters:\n');
fprintf('  dt = %.4f s\n', params.dt);
fprintf('  T_sim = %.0f s\n', params.T_sim);
fprintf('  Setpoint = %.1f\n', params.setpoint);

fprintf('\n========================================\n');
fprintf('INITIALIZATION COMPLETE\n');
fprintf('========================================\n');

% Save parameters for later use
save('simulation_params.mat', 'params');