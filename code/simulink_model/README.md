# Simulink Models for $\Theta$-H Control

This folder contains the Simulink models used to generate all results presented in the article **"$\Theta$-H Control: From Explosive Divergence to Quasi-Periodic Order in Quartic Nonlinear Systems"**.

## 📁 Files

| File | Description |
|------|-------------|
| `theta_control_hardware.slx` | Main simulation model ($\Theta$-H controller + Quartic plant) |
| `duffing_x4_safe.slx` | Quartic oscillator plant model (S-Function wrapper) |
| `theta_control.c` | $\Theta$-H controller S-Function (C code) |
| `duffing_x4_safe.c` | Quartic oscillator plant S-Function (C code) |

## 🏗️ Model Architecture

### Main Model: `theta_control_hardware.slx`


## 🔧 Block Configurations

### 1. Step (Reference)
| Parameter | Value |
|-----------|-------|
| Step time | 0 |
| Initial value | 0 |
| Final value | 1.0 |

### 2. Sum (Error)
| Parameter | Value |
|-----------|-------|
| List of signs | `+-` |
| Icon shape | round |

### 3. Mux (4 inputs)
| Input | Source |
|-------|--------|
| Input 1 | Step (setpoint) |
| Input 2 | Plant output (x1) |
| Input 3 | Plant output (x2) |
| Input 4 | Clock (time) |

### 4. $\Theta$-H Controller (S-Function)
| Parameter | Value |
|-----------|-------|
| S-function name | `theta_control` |
| S-function parameters | `[0.5, 0.4, 0.1]` |

**Outputs:**
| Port | Signal | Description |
|------|--------|-------------|
| 1 | `u_total` | Control signal to plant |
| 2 | `u_theta` | Theta action (for analysis) |
| 3 | `compensacao` | Nonlinearity compensation |
| 4 | `potencia` | Estimated nonlinearity order |

### 5. Duffing Quartic Plant (S-Function)
| Parameter | Value |
|-----------|-------|
| S-function name | `duffing_x4_safe` |
| S-function parameters | `[-0.2, -0.6, 0.25, 0.3, 1.0]` |

**Inputs:**
| Port | Signal | Description |
|------|--------|-------------|
| 1 | `u_theta` | Control signal from $\Theta$-H |
| 2 | `hit_crossing` | Phase reset signal (from Hit Crossing) |

**Outputs:**
| Port | Signal | Description |
|------|--------|-------------|
| 1 | `x1` | Position |
| 2 | `x2` | Velocity |
| 3 | `phase` | Phase (ωt mod 2π) |

### 6. Hit Crossing (for Poincaré Section)
| Parameter | Value |
|-----------|-------|
| Hit crossing offset | 0 |
| Hit crossing direction | rising |
| Output data type | double |

**Purpose:** Detects when `phase = 2π` and triggers Poincaré section sampling.

### 7. Data Type Conversion
| Parameter | Value |
|-----------|-------|
| Output data type | double |
| Input data type | inherit |

**Purpose:** Ensures compatibility between Hit Crossing output and S-Function input.

## 🚀 How to Run

### Step 1: Compile S-Functions

Before running the simulation, compile the C S-Functions:

```matlab
% Navigate to the sfunctions folder
cd ../sfunctions

% Compile the Theta-H controller
mex theta_control.c

% Compile the quartic plant
mex duffing_x4_safe.c
```

### Step 2: Open the Model

    open('theta_control_hardware.slx')

### Step 3: Configure Simulation Parameters

| Parameter | Value |
|-----------|-------|
| Solver | `ode4` |
| Type | `Fixed-step` |
| Fixed-step size | `0.001` |
| Stop time | `20000` |

### Step 4: Run Simulation

    sim('theta_control_hardware')

### Step 5: Collect Data

After simulation, the following variables are saved:

| Variable | Description |
|----------|-------------|
| `y_out` | Plant position (x1) |
| `u_out` | Control signal |
| `t_out` | Time vector |

To generate analysis data files:

    cd ../scripts
    generate_all_data.m



## 📊 Results Generated

| Result | File | Figure in Article |
|--------|------|-------------------|
| Poincaré Map | `poincare_data.txt` | Figure 1 |
| Lyapunov Exponent | `lyapunov_data.mat` | Figure 2 |
| Spontaneous Transition | `transition_data.mat` | Figure 3 |
| Power Spectrum | `spectrum_data.mat` | Figure 4 |

After simulation, run the following scripts to generate the data files:

    cd ../scripts
    generate_all_data.m

## ⚠️ Important Notes

### Hit Crossing Configuration
The Hit Crossing block is **critical** for correct Poincaré section sampling:
- **Hit crossing offset:** `0`
- **Hit crossing direction:** `rising`
- **Output data type:** `double` (use Data Type Conversion block)

**Why this matters:** The Poincaré section is defined by `phase = 0 (mod 2π)`. The Hit Crossing detects when the phase reaches `2π` and resets it to `0`, ensuring that data is sampled exactly at the same phase each cycle.

**Do NOT change:**
- The offset value (must remain 0)
- The direction (must remain rising)
- The phase initialization in the plant S-Function

### Data Type Conversion
The Hit Crossing block outputs a `boolean` by default. The Data Type Conversion block converts it to `double` for compatibility with the S-Function input.

### S-Function Compilation
Always recompile S-Functions after modifying them:

    cd ../sfunctions
    mex theta_control.c
    mex duffing_x4_safe.c

### Simulation Time
- **Total time:** 20,000 seconds (ensures statistical convergence)
- **Do not reduce** below 10,000 seconds for reliable results

## 🔄 Variants (How to Modify for Other Experiments)

### Variant 1: Different Reference Signal
Replace the **Step** block with:
- **Sine Wave** for periodic reference
- **Ramp** for constant velocity tracking
- **Chirp Signal** for frequency sweep
- **Custom MATLAB Function** for arbitrary trajectories

### Variant 2: Different Nonlinearity
Modify `duffing_x4_safe.c` to change the nonlinear term:

    // For x³ (Duffing), change:
    x4_term = pow(x1_sat, 4);  // current (quartic)
    // to:
    x3_term = pow(x1_sat, 3);  // cubic (Duffing)

Then recompile and re-run.

### Variant 3: Different Control Gains
Modify the Theta-H S-Function parameters:

    % Original parameters: [0.5, 0.4, 0.1]
    % For faster response: [0.3, 0.25, 0.08]
    % For slower response: [0.8, 0.6, 0.15]

Or modify the fixed gains in the C code:

    // In theta_control.c, change:
    static real_T K1 = 8.0;  // position gain
    static real_T K2 = 6.0;  // velocity gain

### Variant 4: Different BK Memory Factor
Modify `alpha` in `theta_control.c`:

    // Current value (high memory):
    static real_T alpha = 0.98;
    // For less memory (more instantaneous):
    static real_T alpha = 0.5;
    // For no memory (pure feedback):
    static real_T alpha = 0.0;

### Variant 5: Without Poincaré Sampling (Faster Simulation)
Remove the Hit Crossing block and sample manually:

    % After simulation, downsample the time series
    dt = 0.001;
    t_down = 0:0.83:20000;
    x_poincare = interp1(t, x, t_down);

## 🛠️ Troubleshooting

| Issue | Possible Cause | Solution |
|-------|----------------|----------|
| S-Function not found | Not compiled or not in path | Recompile with `mex` and ensure `.mexw64` is in current directory |
| Hit Crossing not triggering | Phase never reaches 2π | Check plant S-Function: `dx[2] = omega` must be integrated correctly |
| Model too slow | Fixed step size too small | Increase to `0.01` (decreases accuracy but faster) |
| Diverging simulation (NaN/Inf) | System became unstable | Reduce step size to `0.0005` or increase saturation limits |
| Poincaré points not forming ellipses | Insufficient simulation time | Run for longer (at least 20,000 seconds) |
| Data files not generated | To Workspace not configured | Set `Save format` to `Array` and `Limit data points` to `off` |
| Compilation error in C | Missing compiler or syntax error | Run `mex -setup C` first, check for typos |
| Memory error during simulation | Too many data points saved | Reduce `Stop time` or increase sampling rate |
| Different results from paper | Different initial conditions | Use `x0 = -0.2`, `v0 = -0.6` |

### Quick Diagnostic Commands

    % Check if S-Functions are compiled
    which theta_control
    which duffing_x4_safe

    % Check data files
    dir('*.mat')
    dir('*.txt')

    % Quick plot of Poincaré data
    data = load('poincare_data.txt');
    plot(data(1:end-1), data(2:end), '.');
    axis equal;

## 📁 Final Folder Structure (for reference)

    code/simulink_models/
    ├── theta_control_hardware.slx    # Main model
    ├── duffing_x4_safe.slx           # Plant model (optional, referenced)
    ├── README.md                     # This file
    └── diagrams/                     # (Optional) Screenshots
        └── simulink_diagram.pdf

## 📝 Note on MATLAB Version

All models were tested with **MATLAB R2015b** and **MATLAB R2025b**. They should work with later versions, but:
- Hit Crossing block behavior may differ slightly
- S-Function compilation may require adjusting compiler settings