# Scripts for $\Theta$-H Control

## 📁 Files

| Script | Description |
|--------|-------------|
| `init_simulation.m` | Initialize parameters and environment |
| `run_simulation.m` | Run the main simulation |
| `analyze_results.m` | Compute metrics from simulation results |
| `generate_all_data.m` | Generate all .mat data files from raw data |
| `generate_all_figures.m` | Generate all figures for the article |

## 🚀 How to Use

### Step 1: Initialize

```matlab
init_simulation
```
### Step 2: Run Simulation
```matlab
run_simulation
```
### Step 3: Generate Data Files
```matlab
generate_all_data
```
### Step 4: Generate Figures
```matlab
generate_all_figures
```
### Step 5: Analyze Results
```matlab
analyze_results
```
## 📊 Output Files

| Output | Description |
|--------|-------------|
| `simulation_params.mat` | Saved parameters |
| `simulation_results.mat` | Raw simulation outputs |
| `analysis_results.mat` | Computed metrics |
| `lyapunov_data.mat` | Lyapunov exponent data |
| `transition_data.mat` | Transition data |
| `spectrum_data.mat` | Power spectrum data |
| `fig_*.eps/.pdf/.png` | Figure files |

## ⚠️ Requirements

- MATLAB R2015b or later
- Simulink
- $\Theta$-H S-Functions compiled
- `theta_control_hardware.slx` model in path

## 🔧 Troubleshooting

| Issue | Solution |
|-------|----------|
| Model not found | Ensure `theta_control_hardware.slx` is in the current directory or MATLAB path |
| S-Function not found | Compile S-Functions first using `compile_sfunctions.m` |
| No data files | Run simulation first (`run_simulation`) |