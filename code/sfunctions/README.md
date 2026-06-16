# S-Functions for Theta-H Control

## 📁 Files

| File | Description |
|------|-------------|
| `theta_control.c` | Theta-H controller S-Function (C code) |
| `duffing_x4_safe.c` | Quartic oscillator plant S-Function (C code) |
| `compile_sfunctions.m` | Script to compile both S-Functions |

## 🚀 How to Compile

### Option 1: Automatic (Recommended)

Run the compilation script:

```matlab
compile_sfunctions
```
### Option 2: Manual
Compile each S-Function individually:
```matlab
mex theta_control.c
mex duffing_x4_safe.c
```

### ⚠️ Requirements
MATLAB R2015b or later

C compiler configured (mex -setup C)

MinGW-w64 (Windows) or gcc (Linux/Mac) recommended

## 🔧 Troubleshooting

| Issue | Solution |
|-------|----------|
| No compiler found | Run `mex -setup C` and select a compiler |
| Undefined function or variable | Check that all source files are in the current directory |
| Compilation errors | Verify MATLAB version compatibility |

## 📝 Notes

- Compiled S-Functions will have extension `.mexw64` (Windows), `.mexa64` (Linux), or `.mexmaci64` (Mac)
- Recompile after any modification to the C source code
- Ensure the compiled files are in MATLAB's path before running simulations