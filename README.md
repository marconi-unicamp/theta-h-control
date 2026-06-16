# $\Theta$-H Control: From Explosive Divergence to Quasi-Periodic Order in Quartic Nonlinear Systems

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![MATLAB](https://img.shields.io/badge/MATLAB-R2025b%2B-blue)](https://www.mathworks.com/products/matlab.html)
[![Simulink](https://img.shields.io/badge/Simulink-✓-orange)](https://www.mathworks.com/products/simulink.html)

## 🚀 Overview

This repository contains the complete source code, simulation models, data, and figures for the paper:

> **"$\Theta$-H Control: From Explosive Divergence to Quasi-Periodic Order in Quartic Nonlinear Systems"**

The $\Theta$-H controller is a **hybrid adaptive controller** that:
- ✅ Stabilizes **explosive nonlinear systems** (e.g., quartic oscillator $x^4$)
- ✅ Requires **no mathematical model** of the plant
- ✅ Learns the dynamics through **safe autonomous exploration**
- ✅ Transforms explosive divergence into **stable quasi-periodic orbits**
- ✅ Spontaneously switches between **low and high amplitude regimes**

## 🔬 Key Results

| Finding | Value / Observation |
|---------|---------------------|
| **Poincaré map** | Two concentric nearly‑circular ellipses (radii ≈ 0.274 and 0.577) |
| **Lyapunov exponent** | $\lambda = 0.0014 \approx 0$ (quasi‑periodic, not chaotic) |
| **Spontaneous transition** | Jump from low amplitude ($\pm 0.1$) to high amplitude ($\pm 0.6$) after ≈4300 crossings |
| **Power spectrum** | Dominant frequencies at 0.16 Hz and 0.80 Hz (ratio 5:1) |
| **Control method** | Model‑free, adaptive, with BK memory ($\alpha = 0.98$) |

## 📁 Repository Structure
theta-h-control/
├── paper/ # LaTeX source of the article
│ ├── article.tex
│ ├── references.bib
│ └── figures/ # All main figures (PDF)
├── code/
│ ├── sfunctions/ # C S‑Functions ($\Theta$‑H controller & plant)
│ │ ├── theta_control.c
│ │ ├── duffing_x4_safe.c
│ │ ├── compile_sfunctions.m
│ │ └── README.md
│ ├── scripts/ # MATLAB scripts for simulation & analysis
│ │ ├── init_simulation.m
│ │ ├── run_simulation.m
│ │ ├── analyze_results.m
│ │ ├── generate_all_data.m
│ │ ├── generate_lyapunov_data.m
│ │ ├── generate_transition_data.m
│ │ ├── generate_spectrum_data.m
│ │ └── README.md
│ └── generate_figures/ # Scripts to generate all figures
│ ├── generate_all_figures.m
│ ├── generate_fig1_poincare.m
│ ├── generate_fig2_lyapunov.m
│ ├── generate_fig3_transition.m
│ ├── generate_fig4_spectrum.m
│ ├── fig_torus_3d.m
│ ├── fig_recurrence_plot.m
│ ├── fig_poincare_phase.m
│ └── README.md
├── data/ # Raw and processed simulation data
│ ├── poincare_data.txt
│ ├── simulation_results.mat
│ ├── lyapunov_data.mat
│ ├── transition_data.mat
│ ├── spectrum_data.mat
│ ├── analysis_results.mat
│ ├── simulation_params.mat
│ ├── generate_all_data.m
│ └── README.md
├── supplementary/ # Extra material (not in main paper)
│ ├── supplementary.pdf
│ ├── fig_spectrum_comparison.pdf
│ ├── fig_architecture.pdf
│ ├── fig_simulink_diagram.pdf
│ ├── fig_torus_3d.pdf
│ ├── fig_recurrence_plot.pdf
│ └── fig_poincare_phase.pdf
├── LICENSE # MIT License
└── README.md # This file


## 🛠️ Requirements

- **MATLAB R2015b or later** (tested with R2015b, R2020b, R2024a, R2025b)
- **Simulink**
- **C compiler** configured for MEX (e.g., MinGW‑w64 on Windows, `gcc` on Linux/macOS)
- No additional toolboxes required

## 🚀 How to Reproduce All Results

### 1. Clone the repository
```bash
git clone https://github.com/marconi-unicamp/theta-h-control.git
cd theta-h-control
```
### 2. Compile the C S‑Functions
Open MATLAB in the repository root, then:
```matlab
cd code/sfunctions
compile_sfunctions
cd ../..
```
### 3. Run the simulation
```matlab
init_simulation       % load parameters
run_simulation        % this takes ~10‑15 minutes
```
### 4. Generate all data files
```matlab
cd code/scripts
generate_all_data
cd ../..
```
### 5. Generate all figures (main + supplementary)
```matlab
cd code/generate_figures
generate_all_figures   % creates main figures (1‑4)
fig_torus_3d           % supplementary 3D torus
fig_recurrence_plot    % supplementary recurrence plot
fig_poincare_phase     % supplementary colored Poincaré section
cd ../..
```
All figures will appear in paper/figures/ and supplementary/.

## 📊 Results at a Glance
| Figure | Description | Location |
|---------|---------------------|
|**Figure 1** |	Poincaré map – two concentric ellipses|	paper/figures/fig_poincare.pdf|
|**Figure 2**|	Lyapunov exponent calculation|	paper/figures/fig_lyapunov.pdf|
|**Figure 3**|	Spontaneous transition between regimes|	paper/figures/fig_transicao.pdf|
|**Figure 4**|	Power spectrum (Hann window)|	paper/figures/fig_spectrum.pdf|
|**Supplementary**|	3D torus, recurrence plot, phase‑colored Poincaré section, etc.|	supplementary/|

## 📝 License
This project is licensed under the MIT License – see the LICENSE file for details.

<!--
## 📖 Citation
If you use this code or data in your own research, please cite:

bibtex
@article{thetaH2026,
  title={$\Theta$-H Control: From Explosive Divergence to Quasi-Periodic Order in Quartic Nonlinear Systems},
  author={[Marconi Kolm Madrid]},
  journal={[arXiv]},
  year={2026},
  note={Available at: \url{https://github.com/marconi-unicamp/theta-h-control}}
}
-->
## 🙏 Acknowledgments
This study was financed in part by the Coordenação de Aperfeiçoamento de Pessoal de Nível Superior - Brasil (CAPES) - Finance Code 001.


Enjoy exploring the $\Theta$-H controller! 😊 🔬 