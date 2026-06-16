# Data Files for $\Theta$-H Control

This folder contains all raw and processed data used to generate the figures in the article.

## 📁 Files

| File | Description | Format |
|------|-------------|--------|
| `poincare_data.txt` | Raw Poincaré section data (x position at each crossing) | ASCII text, one column |
| `simulation_results.mat` | Complete simulation output (position, control, time) | MATLAB binary |
| `simulation_params.mat` | Saved simulation parameters (struct) | MATLAB binary |
| `analysis_results.mat` | Computed metrics (settling time, control energy, etc.) | MATLAB binary |
| `lyapunov_data.mat` | Lyapunov exponent calculation data | MATLAB binary |
| `transition_data.mat` | Spontaneous transition data (low/high amplitude regimes) | MATLAB binary |
| `spectrum_data.mat` | Power spectrum data | MATLAB binary |
| `generate_all_data.m` | Script to regenerate all .mat files from `poincare_data.txt` | MATLAB script |

## 📊 Data Details

### `poincare_data.txt`
- **Source:** Simulation output from `theta_control_hardware.slx`
- **Points:** ~20,000 crossings (20000 s simulation)
- **Format:** One value per line (position x at each Poincaré crossing)

### `simulation_results.mat`
- **Variables:**
  - `y_out` – Position x(t) (continuous time series)
  - `u_out` – Control signal u(t)
  - `t_out` – Time vector (s)
- **Size:** 20,000,001 points (dt = 0.001 s)

### `simulation_params.mat`
- **Variables:**
  - `params` – Struct containing all simulation and control parameters (tau1, tau2, tau3, K1, K2, alpha_mem, plant parameters, etc.)

### `analysis_results.mat`
- **Variables:**
  - `analysis` – Struct with metrics: N, t_end, dt, mean_y, std_y, max_y, control_energy, control_max, settling_time (if reached)

### `lyapunov_data.mat`
- **Variables:**
  - `t_fit_save` – Time vector (crossings)
  - `log_dist_save` – Log distance for Lyapunov calculation
  - `p_save` – Polynomial fit coefficients
  - `lambda_save` – Estimated Lyapunov exponent (≈ 0.0014)

### `transition_data.mat`
- **Variables:**
  - `x_before` – Data before transition (first 4300 points)
  - `x_after` – Data after transition
  - `x_before_zoom` – First 2000 points of low regime
  - `x_after_zoom` – First 2000 points of high regime
  - `transition_point` – Index where transition occurs (4300)
  - `mean_before`, `std_before`, `max_before` – Statistics of low regime
  - `mean_after`, `std_after`, `max_after` – Statistics of high regime

### `spectrum_data.mat`
- **Variables:**
  - `freq` – Frequency vector (Hz)
  - `P1_dB` – Power spectrum magnitude (dB)
  - `P1` – Linear power spectrum
  - `freq_picos` – Dominant frequencies (≈ 0.16 Hz and 0.80 Hz)
  - `mag_picos` – Magnitudes at dominant frequencies
  - `Fs` – Sampling frequency (1000 Hz)
  - `dt` – Time step (0.001 s)

## 🔄 How to Regenerate

All data files (except `simulation_results.mat` and `poincare_data.txt`) can be regenerated from the raw simulation output using the scripts in `../code/scripts/`:

```matlab
% After a successful simulation, run:
cd ../code/scripts
generate_lyapunov_data
generate_transition_data
generate_spectrum_data
generate_all_data   % runs the three scripts above
```

The raw files simulation_results.mat and poincare_data.txt are produced directly by the Simulink model (theta_control_hardware.slx) during the simulation run.

## ⚠️ Notes
All .mat files are MATLAB binary files; load them with load('filename.mat').

The data stored here is exactly that used to generate the figures in the article and supplementary material.

Do not delete poincare_data.txt – it is required to regenerate the other .mat files.