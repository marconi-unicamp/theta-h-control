# Figure Generation Scripts

This folder contains MATLAB scripts to generate all figures used in the article **"$\Theta$-H Control: From Explosive Divergence to Quasi-Periodic Order in Quartic Nonlinear Systems"**.

## 📁 Files

| Script | Description | Output Figure |
|--------|-------------|---------------|
| `generate_all_figures.m` | Master script to generate all figures | Figures 1-4 |
| `generate_fig1_poincare.m` | Generate Poincaré map (two concentric ellipses) | Figure 1 |
| `generate_fig2_lyapunov.m` | Generate Lyapunov exponent calculation | Figure 2 |
| `generate_fig3_transition.m` | Generate spontaneous transition between regimes | Figure 3 |
| `generate_fig4_spectrum.m` | Generate power spectrum | Figure 4 |


## 📁 Supplementary Files

| Script | Output Figure | Destination |
|--------|---------------|-------------|
| `fig_torus_3d.m` | 3D torus visualization | `supplementary/` |
| `fig_recurrence_plot.m` | Recurrence plot (mosaic) | `supplementary/` |
| `fig_poincare_phase.m` | Poincaré section colored by phase | `supplementary/` |


## 🚀 How to Use

### Option 1: Generate all main figures at once

```matlab
generate_all_figures
```

### Option 2: Generate individual figures
```matlab
generate_fig1_poincare   % Figure 1
generate_fig2_lyapunov   % Figure 2
generate_fig3_transition % Figure 3
generate_fig4_spectrum   % Figure 4
```

## 📊 Output Files

| Output | Format | Destination | Figure |
|--------|--------|-------------|--------|
| `fig_poincare` | .eps, .pdf, .png | `paper/figures/` | Figure 1 |
| `fig_lyapunov` | .eps, .pdf, .png | `paper/figures/` | Figure 2 |
| `fig_transition` | .eps, .pdf, .png | `paper/figures/` | Figure 3 |
| `fig_spectrum` | .eps, .pdf, .png | `paper/figures/` | Figure 4 |

## 📋 Figure Descriptions

### Figure 1: Poincaré Map
- Shows two concentric nearly-circular ellipses
- Inner ellipse: radius ≈ 0.274 (59.6% of points)
- Outer ellipse: radius ≈ 0.577 (40.4% of points)
- Excentricities: e_in = 0.0392, e_out = 0.0057
- Ratio r_out/r_in ≈ 2.11

### Figure 2: Lyapunov Exponent
- Calculated using Wolf method
- Estimated value: λ ≈ 0.0014 ≈ 0
- Confirms quasi-periodic (non-chaotic) behavior

### Figure 3: Spontaneous Transition
- Transition at approximately 4300 Poincaré crossings
- Regime 1: low amplitude (±0.1)
- Regime 2: high amplitude (±0.6)
- Same fundamental frequency in both regimes

### Figure 4: Power Spectrum
- Hanning window, Welch method
- Dominant peak at approximately 0.5 Hz
- Re-excitation at 2.6-5.0 Hz (≈22 dB increase)
- Ratio f2/f1 ≈ 4 (harmonic with radius ratio)

## ⚠️ Requirements

- MATLAB R2015b or later
- Data files in `../../data/` folder:
  - `poincare_data.txt` (required for all figures)
  - `lyapunov_data.mat` (optional, generated if not present)
  - `transition_data.mat` (optional, generated if not present)
  - `spectrum_data.mat` (optional, generated if not present)

## 🔧 Troubleshooting

| Issue | Solution |
|-------|----------|
| `poincare_data.txt not found` | Run simulation first (`../scripts/run_simulation.m`) |
| Data files not generated | Run `generate_all_data.m` in `../scripts/` first |
| Figure not saving | Check write permissions in `paper/figures/` |
| Wrong axis limits | Adjust limits in individual scripts |
| Memory error during FFT | Reduce `N_steady` in `generate_fig4_spectrum.m` |

## 📝 Notes

- All figures are saved in three formats: EPS (vector), PDF (vector), and PNG (raster)
- EPS and PDF are recommended for publication
- PNG is included for quick preview
- Figures are saved to `paper/figures/` (relative path from this folder)

## 🔄 Workflow

Typical workflow to generate figures after simulation:

```matlab
% 1. Ensure data exists (run once)
cd ../scripts
generate_all_data

% 2. Generate figures
cd ../generate_figures
generate_all_figures