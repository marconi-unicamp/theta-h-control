/*
 * theta_control_safe.c - Theta-H Adaptativo Simplificado
 * 
 * Parâmetros: [tau1, tau2, tau3] apenas (simplificado)
 * Entradas: [setpoint, x1, x2, t]
 * Saídas: [u_total, u_theta, compensacao]
 */

#define S_FUNCTION_NAME theta_control
#define S_FUNCTION_LEVEL 2

#include "simstruc.h"
#include <math.h>

#define PI 3.141592653589793
#define MAX_COMPENSACAO 20.0
#define MAX_INTEGRAL 20.0

#define STATE_INTEGRAL 0
#define STATE_ERRO_ANTERIOR 1
#define NUM_STATES 2

static real_T dt = 0.001;
static real_T K1 = 8.0;
static real_T K2 = 6.0;
static int init_done = 0;

/* Coeficiente aprendido (fixo para teste) */
static real_T alpha_fixo = 1.5;  /* Valor médio entre x³ e x⁴ */

static void mdlInitializeSizes(SimStruct *S)
{
    /* APENAS 3 PARÂMETROS: tau1, tau2, tau3 */
    ssSetNumSFcnParams(S, 3);
    
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
        ssSetErrorStatus(S, "ERRO: Informe [tau1, tau2, tau3]");
        return;
    }
    
    ssSetNumContStates(S, 0);
    ssSetNumDiscStates(S, NUM_STATES);
    
    ssSetNumInputPorts(S, 4);
    ssSetInputPortWidth(S, 0, 1);
    ssSetInputPortWidth(S, 1, 1);
    ssSetInputPortWidth(S, 2, 1);
    ssSetInputPortWidth(S, 3, 1);
    ssSetInputPortDirectFeedThrough(S, 0, 1);
    ssSetInputPortDirectFeedThrough(S, 1, 1);
    ssSetInputPortDirectFeedThrough(S, 2, 1);
    ssSetInputPortDirectFeedThrough(S, 3, 1);
    
    ssSetNumOutputPorts(S, 3);
    ssSetOutputPortWidth(S, 0, 1);
    ssSetOutputPortWidth(S, 1, 1);
    ssSetOutputPortWidth(S, 2, 1);
    
    ssSetNumSampleTimes(S, 1);
    ssSetOptions(S, SS_OPTION_EXCEPTION_FREE_CODE);
}

static void mdlInitializeSampleTimes(SimStruct *S)
{
    ssSetSampleTime(S, 0, INHERITED_SAMPLE_TIME);
    ssSetOffsetTime(S, 0, 0.0);
}

static void mdlInitializeConditions(SimStruct *S)
{
    real_T *x = ssGetDiscStates(S);
    x[STATE_INTEGRAL] = 0.0;
    x[STATE_ERRO_ANTERIOR] = 0.0;
    
    dt = ssGetFixedStepSize(S);
    if (dt <= 0) dt = 0.001;
    
    mexPrintf("\n========================================\n");
    mexPrintf("THETA-H SEGURO (VERSÃO SIMPLIFICADA)\n");
    mexPrintf("K1=%.1f, K2=%.1f\n", K1, K2);
    mexPrintf("Compensação fixa: α = %.2f\n", alpha_fixo);
    mexPrintf("========================================\n\n");
}

static void mdlOutputs(SimStruct *S, int_T tid)
{
    real_T *y_total = ssGetOutputPortRealSignal(S, 0);
    real_T *y_theta = ssGetOutputPortRealSignal(S, 1);
    real_T *y_comp = ssGetOutputPortRealSignal(S, 2);
    
    InputRealPtrsType u_sp = ssGetInputPortRealSignalPtrs(S, 0);
    InputRealPtrsType u_x1 = ssGetInputPortRealSignalPtrs(S, 1);
    InputRealPtrsType u_x2 = ssGetInputPortRealSignalPtrs(S, 2);
    InputRealPtrsType u_t = ssGetInputPortRealSignalPtrs(S, 3);
    real_T *x = ssGetDiscStates(S);
    
    /* Parâmetros com valores padrão conservadores */
    real_T tau1 = mxGetScalar(ssGetSFcnParam(S, 0));
    real_T tau2 = mxGetScalar(ssGetSFcnParam(S, 1));
    real_T tau3 = mxGetScalar(ssGetSFcnParam(S, 2));
    
    if (tau1 < 0.1) tau1 = 0.5;
    if (tau2 < 0.05) tau2 = 0.15;
    if (tau3 < 0.05) tau3 = 0.1;
    
    real_T Kp = 1.2 / tau1;
    real_T Ki = 0.6 / (tau1 * tau2);
    real_T Kd = 0.5 * tau1 * tau3;
    
    real_T t = *u_t[0];
    real_T x1 = *u_x1[0];
    real_T x2 = *u_x2[0];
    
    /* Referência oscilatória suave */
    real_T freq_desejada = 0.8;
    real_T amplitude_desejada = 0.5;
    real_T setpoint = amplitude_desejada * sin(2 * PI * freq_desejada * t);
    
    real_T erro = setpoint - x1;
    
    /* Integral com limite */
    static real_T integral = 0.0;
    integral = integral + erro * dt;
    if (integral > MAX_INTEGRAL) integral = MAX_INTEGRAL;
    if (integral < -MAX_INTEGRAL) integral = -MAX_INTEGRAL;
    x[STATE_INTEGRAL] = integral;
    
    real_T derro = (erro - x[STATE_ERRO_ANTERIOR]) / dt;
    x[STATE_ERRO_ANTERIOR] = erro;
    
    /* Realimentação */
    real_T u_fb = -K1 * x1 - K2 * x2;
    
    /* Theta básico */
    real_T u_theta_base = Kp * erro + Ki * integral + Kd * derro;
    
    /* Compensação da não-linearidade (usa x³ como aproximação para x⁴) */
    real_T compensacao = 0.0;
    real_T abs_x1 = fabs(x1);
    
    if (abs_x1 < 4.0) {
        real_T sinal = (x1 >= 0) ? 1.0 : -1.0;
        compensacao = -alpha_fixo * pow(abs_x1, 3) * sinal;
    }
    
    /* Limita compensação */
    if (compensacao > MAX_COMPENSACAO) compensacao = MAX_COMPENSACAO;
    if (compensacao < -MAX_COMPENSACAO) compensacao = -MAX_COMPENSACAO;
    
    /* Controle total */
    y_total[0] = u_fb + u_theta_base + compensacao;
    
    if (y_total[0] > 30.0) y_total[0] = 30.0;
    if (y_total[0] < -30.0) y_total[0] = -30.0;
    
    y_theta[0] = u_theta_base;
    y_comp[0] = compensacao;
    
    static int cont = 0;
    cont++;
    if (!init_done && cont > 500) {
        mexPrintf("🤖 THETA-H ATIVO\n");
        mexPrintf("  Kp=%.2f, Ki=%.2f, Kd=%.2f\n", Kp, Ki, Kd);
        mexPrintf("  α = %.2f (fixo)\n", alpha_fixo);
        mexPrintf("  Frequência imposta: %.2f Hz\n", freq_desejada);
        mexPrintf("  Amplitude imposta: %.2f\n", amplitude_desejada);
        init_done = 1;
    }
}

static void mdlUpdate(SimStruct *S, int_T tid)
{
    /* Estados já atualizados no mdlOutputs */
}

static void mdlTerminate(SimStruct *S)
{
    mexPrintf("\n========================================\n");
    mexPrintf("THETA-H SEGURO FINALIZADO\n");
    mexPrintf("========================================\n\n");
}

static void mdlSetInputPortWidth(SimStruct *S, int_T port, int_T width)
{
    ssSetInputPortWidth(S, port, width);
}

static void mdlSetOutputPortWidth(SimStruct *S, int_T port, int_T width)
{
    ssSetOutputPortWidth(S, port, width);
}

#ifdef MATLAB_MEX_FILE
#include "simulink.c"
#else
#include "cg_sfun.h"
#endif