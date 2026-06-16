%% run_simulation.m (versão atualizada)
% Run the Theta-H control simulation and save results

function run_simulation()
    
fprintf('\n========================================\n');
fprintf('RUNNING THETA-H SIMULATION\n');
fprintf('========================================\n\n');

% Check if parameters exist
if ~exist('simulation_params.mat', 'file')
    error('Please run init_simulation.m first.');
end

% Load parameters
load('simulation_params.mat');

% Check if Simulink model exists
if ~exist('theta_control_hardware.slx', 'file')
    error('Simulink model theta_control_hardware.slx not found.');
end

% Open the model
open_system('theta_control_hardware');

% Configure simulation parameters
set_param('theta_control_hardware', 'StopTime', num2str(params.T_sim));
set_param('theta_control_hardware', 'Solver', 'ode4');
set_param('theta_control_hardware', 'FixedStep', num2str(params.dt));
set_param('theta_control_hardware', 'SolverType', 'Fixed-step');

% Run simulation
fprintf('Simulating %.0f seconds with dt = %.4f s...\n', params.T_sim, params.dt);
fprintf('This may take several minutes.\n');

tic;
sim('theta_control_hardware');
elapsed = toc;

fprintf('\nSimulation completed in %.2f seconds.\n', elapsed);

% Save simulation results
if exist('y_out', 'var')
    % Ensure variables are column vectors
    if size(y_out,1) == 1, y_out = y_out'; end
    if size(u_out,1) == 1, u_out = u_out'; end
    if size(t_out,1) == 1, t_out = t_out'; end
    
    % Save to current directory
    save('simulation_results.mat', 'y_out', 'u_out', 't_out');
    fprintf('Results saved to simulation_results.mat\n');
    
    % Also save to data folder if it exists
    if exist('../../data', 'dir')
        save('../../data/simulation_results.mat', 'y_out', 'u_out', 't_out');
        fprintf('Results also saved to ../../data/simulation_results.mat\n');
    end
    
    % Save Poincaré data if it exists
    if exist('poincare_data.txt', 'file')
        if exist('../../data', 'dir')
            copyfile('poincare_data.txt', '../../data/poincare_data.txt');
            fprintf('Poincaré data copied to ../../data/poincare_data.txt\n');
        end
    end
else
    fprintf('Warning: No output data found.\n');
    fprintf('Check that To Workspace blocks are named "saida" and "controle".\n');
end

fprintf('\n========================================\n');
fprintf('SIMULATION COMPLETE\n');
fprintf('========================================\n');

end