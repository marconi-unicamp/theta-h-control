%% Generate spectrum_data.mat from poincare_data.txt
% This script calculates the power spectrum

clear; clc;

fprintf('Generating spectrum_data.mat...\n');

% Load Poincaré data
if exist('poincare_data.txt', 'file')
    data = load('poincare_data.txt');
    x = data;
    fprintf('Data loaded: %d points\n', length(x));
else
    error('poincare_data.txt not found. Run simulation first.');
end

% Parameters
dt = 0.001; % Integration step (seconds)
Fs = 1 / dt; % Sampling frequency

% Remove transient (20% of data)
x_steady = x(round(0.8*end):end);
N_steady = length(x_steady);

% Detrend and apply Hanning window
x_detrend = detrend(x_steady);
window = hanning(N_steady);
x_windowed = x_detrend .* window;

% FFT
Y = fft(x_windowed);
P2 = abs(Y / N_steady);
P1 = P2(1:floor(N_steady/2)+1);
P1(2:end-1) = 2 * P1(2:end-1);
freq = Fs * (0:floor(N_steady/2)) / N_steady;

% Convert to dB
P1_dB = 20 * log10(P1 + eps);

% Find dominant frequencies
[picos, locs] = findpeaks(P1, 'MinPeakHeight', 0.05*max(P1), ...
                          'MinPeakDistance', round(N_steady/500));

if ~isempty(locs)
    freq_picos = freq(locs);
    mag_picos = picos;
    freq_picos = freq_picos(freq_picos <= 5);
    mag_picos = mag_picos(1:length(freq_picos));
else
    freq_picos = [];
    mag_picos = [];
end

% Save data
save('spectrum_data.mat', 'freq', 'P1_dB', 'P1', ...
     'freq_picos', 'mag_picos', 'Fs', 'dt');

fprintf('Spectrum data saved to spectrum_data.mat\n');
fprintf('Dominant frequencies: ');
fprintf('%.2f Hz ', freq_picos);
fprintf('\n');