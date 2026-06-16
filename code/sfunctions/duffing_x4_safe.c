/*
 * duffing_x4_safe.c - Duffing com x⁴ e Mapa de Poincaré
 */

#define S_FUNCTION_NAME duffing_x4_safe
#define S_FUNCTION_LEVEL 2

#include "simstruc.h"
#include <string.h>
#include <math.h>

#define PI 3.141592653589793
#define MAX_POSICAO 8.0
#define MAX_VELOCIDADE 15.0

/* Índices dos parâmetros */
#define PARAM_X0   0
#define PARAM_V0   1
#define PARAM_B    2
#define PARAM_A    3
#define PARAM_OMEGA 4
#define NUM_PARAMS 5

static real_T b, A_param, omega;
static real_T tt;  /* tempo para iniciar aquisição (ignorar transiente) */
static int amostra_idx = 0;
static int janela_aberta = 0;

/* Buffer para armazenar pontos do Poincaré (para análise posterior) */
#define MAX_POINCARE 10000
static real_T poincare_x[MAX_POINCARE];
static real_T poincare_v[MAX_POINCARE];
static int poincare_count = 0;

static void mdlInitializeSizes(SimStruct *S)
{
    ssSetNumSFcnParams(S, NUM_PARAMS);
    
#if defined(MATLAB_MEX_FILE)
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
        ssSetErrorStatus(S, "ERRO: Informe [x0, v0, b, A, omega]");
        return;
    }
#endif

    ssSetNumContStates(S, 3);
    ssSetNumDiscStates(S, 0);
    
    ssSetNumInputPorts(S, 2);
    ssSetInputPortWidth(S, 0, 1);
    ssSetInputPortWidth(S, 1, 1);
    ssSetInputPortDirectFeedThrough(S, 0, 0);
    ssSetInputPortDirectFeedThrough(S, 1, 0);
    
    ssSetNumOutputPorts(S, 3);
    ssSetOutputPortWidth(S, 0, 1);
    ssSetOutputPortWidth(S, 1, 1);
    ssSetOutputPortWidth(S, 2, 1);
    
    ssSetNumSampleTimes(S, 1);
    ssSetOptions(S, SS_OPTION_EXCEPTION_FREE_CODE);
}

static void mdlInitializeSampleTimes(SimStruct *S)
{
    ssSetSampleTime(S, 0, CONTINUOUS_SAMPLE_TIME);
    ssSetOffsetTime(S, 0, 0.0);
}

#define MDL_INITIALIZE_CONDITIONS
static void mdlInitializeConditions(SimStruct *S)
{
    real_T *x = ssGetContStates(S);
    
    real_T x0 = mxGetScalar(ssGetSFcnParam(S, PARAM_X0));
    real_T v0 = mxGetScalar(ssGetSFcnParam(S, PARAM_V0));
    
    x[0] = x0;
    x[1] = v0;
    x[2] = 0.0;
    
    b = mxGetScalar(ssGetSFcnParam(S, PARAM_B));
    A_param = mxGetScalar(ssGetSFcnParam(S, PARAM_A));
    omega = mxGetScalar(ssGetSFcnParam(S, PARAM_OMEGA));
    
    /* Tempo para iniciar aquisição (ignorar transiente) */
    tt = 10.0;
    amostra_idx = 0;
    poincare_count = 0;
    janela_aberta = 0;
    
    mexPrintf("\n========================================\n");
    mexPrintf("DUFFING X⁴ COM MAPA DE POINCARÉ\n");
    mexPrintf("  b = %.3f\n", b);
    mexPrintf("  A = %.3f\n", A_param);
    mexPrintf("  ω = %.3f\n", omega);
    mexPrintf("  Início da aquisição: t = %.1f s\n", tt);
    mexPrintf("========================================\n\n");
    
    /* Abre uma figura para o Poincaré */
    mexEvalString("figure('Name', 'Mapa de Poincaré');");
    mexEvalString("hold on; grid on;");
    mexEvalString("xlabel('Posição x₁');");
    mexEvalString("ylabel('Velocidade x₂');");
    mexEvalString("title('Mapa de Poincaré (x₂ = 0, rising)');");
    mexEvalString("plot(0,0,'ro','MarkerSize',8,'LineWidth',2);");
    janela_aberta = 1;
}

#define MDL_UPDATE
static void mdlUpdate(SimStruct *S, int_T tid)
{
    InputRealPtrsType u = ssGetInputPortRealSignalPtrs(S, 0);
    real_T *x = ssGetContStates(S);

    InputRealPtrsType u_hit = ssGetInputPortRealSignalPtrs(S, 1);
    if (*u_hit[0] == 1.0) {
        x[2] = 0.0;
		
		/* Sinaliza que o solver precisa resetar */
        ssSetSolverNeedsReset(S);
    }
}

#define MDL_DERIVATIVES
static void mdlDerivatives(SimStruct *S)
{
    real_T *dx = ssGetdX(S);
    real_T *x = ssGetContStates(S);
    InputRealPtrsType u = ssGetInputPortRealSignalPtrs(S, 0);
    InputRealPtrsType u_hit = ssGetInputPortRealSignalPtrs(S, 1);
    
    real_T u_theta = *u[0];
    real_T t = ssGetT(S);
    
    /* Aplica limites para evitar overflow */
    real_T x1_sat = x[0];
    if (x1_sat > MAX_POSICAO) x1_sat = MAX_POSICAO;
    if (x1_sat < -MAX_POSICAO) x1_sat = -MAX_POSICAO;
    
    real_T x2_sat = x[1];
    if (x2_sat > MAX_VELOCIDADE) x2_sat = MAX_VELOCIDADE;
    if (x2_sat < -MAX_VELOCIDADE) x2_sat = -MAX_VELOCIDADE;
    
    /* Termo x⁴ com proteção */
    real_T x4_term = 0.0;
    real_T abs_x1 = fabs(x1_sat);
    
    if (abs_x1 <= 4.0) {
        x4_term = pow(x1_sat, 4);
    } else {
        x4_term = pow(4.0, 4) * (1.0 + 4.0 * (abs_x1 - 4.0) / 4.0);
        if (x1_sat < 0) x4_term = -x4_term;
    }
    
    dx[0] = x2_sat;
    dx[1] = x1_sat - x4_term - b * x2_sat + A_param * cos(omega * t) + u_theta;
    dx[2] = omega;
    
    /* ========================================================= */
    /* MAPA DE POINCARÉ - Aquisição em fase fixa (x₂ = 0, rising) */
    /* ========================================================= */
    if (*u_hit[0] == 1.0 && t >= tt) {
        /* Armazena em buffer interno */
        if (poincare_count < MAX_POINCARE) {
            poincare_x[poincare_count] = x[0];
            poincare_v[poincare_count] = x[1];
            poincare_count++;
        }
        
        /* Plota ponto na figura (a cada 20 pontos para não sobrecarregar) */
        static int plot_counter = 0;
        plot_counter++;
        if (plot_counter >= 20) {
            char buf[200];
            snprintf(buf, sizeof(buf), 
                     "plot(%.6f, %.6f, 'b.', 'MarkerSize', 4); drawnow;", 
                     x[0], x[1]);
            mexEvalString(buf);
            plot_counter = 0;
        }
        
        /* Debug a cada 100 pontos */
        if (poincare_count % 100 == 0 && poincare_count > 0) {
            mexPrintf("Poincaré: %d pontos adquiridos (x=%.4f, v=%.4f)\n", 
                      poincare_count, x[0], x[1]);
        }
    }
}

static void mdlOutputs(SimStruct *S, int_T tid)
{
    real_T *y = ssGetOutputPortRealSignal(S, 0);
    real_T *x = ssGetContStates(S);
    
    y[0] = x[0];
    y[1] = x[1];
    y[2] = x[2];
}

static void mdlTerminate(SimStruct *S)
{
    mexPrintf("\n========================================\n");
    mexPrintf("RESULTADOS DO MAPA DE POINCARÉ\n");
    mexPrintf("========================================\n");
    mexPrintf("Pontos adquiridos: %d\n", poincare_count);
    
    if (poincare_count > 0) {
        /* Calcula estatísticas básicas */
        real_T x_mean = 0.0, v_mean = 0.0;
        real_T x_std = 0.0, v_std = 0.0;
        
        for (int i = 0; i < poincare_count; i++) {
            x_mean += poincare_x[i];
            v_mean += poincare_v[i];
        }
        x_mean /= poincare_count;
        v_mean /= poincare_count;
        
        for (int i = 0; i < poincare_count; i++) {
            x_std += pow(poincare_x[i] - x_mean, 2);
            v_std += pow(poincare_v[i] - v_mean, 2);
        }
        x_std = sqrt(x_std / poincare_count);
        v_std = sqrt(v_std / poincare_count);
        
        mexPrintf("Centro do atrator: (%.4f, %.4f)\n", x_mean, v_mean);
        mexPrintf("Desvio padrão: (%.4f, %.4f)\n", x_std, v_std);
        
        /* Salva dados em arquivo para análise posterior */
        FILE *fp = fopen("poincare_data.txt", "w");
        if (fp) {
            for (int i = 0; i < poincare_count; i++) {
                fprintf(fp, "%.6f %.6f\n", poincare_x[i], poincare_v[i]);
            }
            fclose(fp);
            mexPrintf("Dados salvos em poincare_data.txt\n");
        }
    }
    
    mexPrintf("========================================\n\n");
    
    /* Fecha a figura com um título final */
//    mexEvalString("title('Mapa de Poincaré - Regime Permanente');");
}

#ifdef MATLAB_MEX_FILE
#include "simulink.c"
#else
#include "cg_sfun.h"
#endif