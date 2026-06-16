%% generate_fig4_spectrum.m
% Generate Figure 4: Power Spectrum
% This script calculates and plots the power spectrum

clear; clc; close all;

fprintf('Generating Figure 4: Power Spectrum...\n');

%% Load Data
if exist('../../data/poincare_data.txt', 'file')
    data = load('../../data/poincare_data.txt');
    fprintf('Data loaded: ../../data/poincare_data.txt (%d points)\n', length(data));
elseif exist('poincare_data.txt', 'file')
    data = load('poincare_data.txt');
    fprintf('Data loaded: poincare_data.txt (%d points)\n', length(data));
else
    error('poincare_data.txt not found. Please run simulation first.');
end

x = data;

%% Parameters
dt = 0.001;  % Integration step (seconds)
Fs = 1 / dt; % Sampling frequency (Hz)

% Remove transient (20% of data)
x_steady = x(round(0.8*end):end);
N_steady = length(x_steady);

fprintf('Signal for FFT: %d points (%.1f seconds)\n', N_steady, N_steady*dt);

%% FFT with Hanning window
x_detrend = detrend(x_steady);
window = hanning(N_steady);
x_windowed = x_detrend .* window;

Y = fft(x_windowed);
P2 = abs(Y / N_steady);
P1 = P2(1:floor(N_steady/2)+1);
P1(2:end-1) = 2 * P1(2:end-1);
freq = Fs * (0:floor(N_steady/2)) / N_steady;
P1_dB = 20 * log10(P1 + eps);

%% Find dominant frequencies
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

fprintf('Dominant frequencies: ');
fprintf('%.2f Hz ', freq_picos);
fprintf('\n');

%% Create Figure
figure('Position', [100, 100, 800, 600], 'Color', 'white');

plot(freq, P1_dB, 'b-', 'LineWidth', 1.2);
hold on;

if ~isempty(freq_picos)
    mag_picos_dB = 20 * log10(mag_picos + eps);
    plot(freq_picos, mag_picos_dB, 'ro', 'MarkerSize', 8, 'LineWidth', 1.5);
end

grid on;
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('Power Spectrum of the Controlled System');
xlim([0, 5]);
ylim([-120, 20]);

if ~isempty(freq_picos)
    legend('Power Spectrum', 'Dominant frequencies', 'Location', 'best');
else
    legend('Power Spectrum', 'Location', 'best');
end

% Annotate dominant frequencies
for i = 1:length(freq_picos)
    text(freq_picos(i) + 0.05, 20*log10(mag_picos(i)) - 5, ...
         sprintf('%.2f Hz', freq_picos(i)), 'FontSize', 9, ...
         'BackgroundColor', 'white', 'EdgeColor', [0.7 0.7 0.7]);
end

% Add ratio annotation
if length(freq_picos) >= 2
    razao = freq_picos(2) / freq_picos(1);
    text(3.5, -90, sprintf('f_2/f_1 = %.2f', razao), ...
         'FontSize', 10, 'BackgroundColor', 'white', ...
         'EdgeColor', [0.7 0.7 0.7]);
    
    if abs(razao - 4) < 0.2
        text(3.5, -105, 'Harmonic ratio ~ 4', 'FontSize', 10, ...
             'Color', 'red', 'BackgroundColor', 'white');
    end
end

%% Save Figure
if ~exist('../../paper/figures', 'dir')
    mkdir('../../paper/figures');
end

print('-depsc', '../../paper/figures/fig_spectrum.eps');
print('-dpdf', '../../paper/figures/fig_spectrum.pdf');
saveas(gcf, '../../paper/figures/fig_spectrum.png');

fprintf('Figure saved: ../../paper/figures/fig_spectrum.eps/.pdf/.png\n');