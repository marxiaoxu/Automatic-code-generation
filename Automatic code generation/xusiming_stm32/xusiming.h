/*
 * File: xusiming.h
 *
 * Code generated for Simulink model :xusiming.
 *
 * Model version      : 1.48
 * Simulink Coder version    : 9.7 (R2022a) 13-Nov-2021
 * TLC version       : 9.7 (Feb 17 2022)
 * C/C++ source code generated on  : Thu Apr 25 14:58:01 2024
 *
 * Target selection: stm32.tlc
 * Embedded hardware selection: Intel->x86-64 (Windows64)
 * Code generation objectives: Unspecified
 * Validation result: Not run
 *
 *
 *
 * ******************************************************************************
 * * attention
 * *
 * * THE PRESENT FIRMWARE WHICH IS FOR GUIDANCE ONLY AIMS AT PROVIDING CUSTOMERS
 * * WITH CODING INFORMATION REGARDING THEIR PRODUCTS IN ORDER FOR THEM TO SAVE
 * * TIME. AS A RESULT, STMICROELECTRONICS SHALL NOT BE HELD LIABLE FOR ANY
 * * DIRECT, INDIRECT OR CONSEQUENTIAL DAMAGES WITH RESPECT TO ANY CLAIMS ARISING
 * * FROM THE CONTENT OF SUCH FIRMWARE AND/OR THE USE MADE BY CUSTOMERS OF THE
 * * CODING INFORMATION CONTAINED HEREIN IN CONNECTION WITH THEIR PRODUCTS.
 * *
 * ******************************************************************************
 */

#ifndef RTW_HEADER_xusiming_h_
#define RTW_HEADER_xusiming_h_
#ifndef xusiming_COMMON_INCLUDES_
#define xusiming_COMMON_INCLUDES_
#include "rtwtypes.h"
#include "getBuffPtr.h"
#endif                                 /* xusiming_COMMON_INCLUDES_ */

#include "xusiming_CAN.h"
#include "xusiming_TIM.h"
#include "xusiming_USART.h"
#include "STM32_Config.h"
#include "xusiming_External_Functions.h"
#include "xusiming_types.h"
#include "rt_zcfcn.h"
#include "rtGetInf.h"
#include "rt_nonfinite.h"
#include "zero_crossing_types.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetErrorStatus
#define rtmGetErrorStatus(rtm)         ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
#define rtmSetErrorStatus(rtm, val)    ((rtm)->errorStatus = (val))
#endif

/* user code (top of header file) */
#include "string.h"
#include "xusiming_private.h"
#include "math.h"

/* Block signals (default storage) */
typedef struct {
  real_T GPIO_Read1;                   /* '<Root>/GPIO_Read1' */
  real_T DiscreteTimeIntegrator1;      /* '<S1>/Discrete-Time Integrator1' */
  uint32_T Timers1_o2;                 /* '<S2>/Timers1' */
  uint32_T Timers2_o1;                 /* '<S2>/Timers2' */
  uint32_T Timers2_o2;                 /* '<S2>/Timers2' */
  uint32_T BuffPtr;                    /* '<S2>/RcvUsartBuf4' */
  uint32_T CAN_Read_Data_o3;           /* '<S4>/CAN_Read_Data' */
  uint16_T CAN_NbPendingMsg;           /* '<Root>/CAN_NbPendingMsg' */
  uint16_T USART_Send2;                /* '<S2>/USART_Send2' */
  uint16_T CAN_Read_Data_o5;           /* '<S4>/CAN_Read_Data' */
  uint8_T TmpRTBAtSubsystem2Outport1;  /* '<Root>/Subsystem2' */
  uint8_T Timers1_o1;                  /* '<S2>/Timers1' */
  uint8_T DataTypeConversion;          /* '<S1>/Data Type Conversion' */
  uint8_T DataTypeConversion1;         /* '<S1>/Data Type Conversion1' */
  uint8_T DataTypeConversion3;         /* '<S1>/Data Type Conversion3' */
  uint8_T CAN_Read_Data_o1;            /* '<S4>/CAN_Read_Data' */
  uint8_T CAN_Read_Data_o2;            /* '<S4>/CAN_Read_Data' */
  uint8_T CAN_Read_Data_o4;            /* '<S4>/CAN_Read_Data' */
  uint8_T CAN_Read_Data_o6[8];         /* '<S4>/CAN_Read_Data' */
  boolean_T GPIO_Read;                 /* '<Root>/GPIO_Read' */
} B_xusiming;

/* Block states (default storage) for system '<Root>' */
typedef struct {
  real_T DiscreteTimeIntegrator1_DSTATE;/* '<S1>/Discrete-Time Integrator1' */
  real_T Delay1_DSTATE;                /* '<S1>/Delay1' */
  real_T DiscreteTimeIntegrator_DSTATE;/* '<S1>/Discrete-Time Integrator' */
  real_T execpt;                       /* '<Root>/Data Store Memory' */
  real_T kp;                           /* '<Root>/Data Store Memory1' */
  real_T ki;                           /* '<Root>/Data Store Memory2' */
  real_T DiscreteTimeIntegrator1_PREV_U;/* '<S1>/Discrete-Time Integrator1' */
  real_T DiscreteTimeIntegrator_PREV_U;/* '<S1>/Discrete-Time Integrator' */
  uint32_T Subsystem1_PREV_T;          /* '<Root>/Subsystem1' */
  uint8_T DiscreteTimeIntegrator1_SYSTEM_ENABLE;/* '<S1>/Discrete-Time Integrator1' */
  uint8_T DiscreteTimeIntegrator_SYSTEM_ENABLE;/* '<S1>/Discrete-Time Integrator' */
  boolean_T Subsystem1_RESET_ELAPS_T;  /* '<Root>/Subsystem1' */
} DW_xusiming;

/* Zero-crossing (trigger) state */
typedef struct {
  ZCSigState Subsystem4_Trig_ZCE;      /* '<Root>/Subsystem4' */
} PrevZCX_xusiming;

/* Real-time Model Data Structure */
struct tag_RTM_xusiming {
  const char_T * volatile errorStatus;

  /*
   * Timing:
   * The following substructure contains information regarding
   * the timing information for the model.
   */
  struct {
    uint32_T clockTick0;
    uint32_T clockTick3;
    uint8_T rtmDbBufReadBuf3;
    uint8_T rtmDbBufWriteBuf3;
    boolean_T rtmDbBufLastBufWr3;
    uint32_T rtmDbBufClockTick3[2];
  } Timing;
};

/* Block signals (default storage) */
extern B_xusiming xusiming_B;

/* Block states (default storage) */
extern DW_xusiming xusiming_DW;

/* Zero-crossing (trigger) state */
extern PrevZCX_xusiming xusiming_PrevZCX;

/* Model entry point functions */
extern void xusiming_initialize(void);
extern void xusiming_step(void);

/* Real-time Model object */
extern RT_MODEL_xusiming *const xusiming_M;

/*-
 * These blocks were eliminated from the model due to optimizations:
 *
 * Block '<S2>/Data Type Conversion2' : Unused code path elimination
 * Block '<S1>/Data Type Conversion2' : Eliminate redundant data type conversion
 */

/*-
 * The generated code includes comments that allow you to trace directly
 * back to the appropriate location in the model.  The basic format
 * is <system>/block_name, where system is the system number (uniquely
 * assigned by Simulink) and block_name is the name of the block.
 *
 * Use the MATLAB hilite_system command to trace the generated code back
 * to the model.  For example,
 *
 * hilite_system('<S3>')    - opens system 3
 * hilite_system('<S3>/Kp') - opens and selects block Kp which resides in S3
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'xusiming'
 * '<S1>'   : 'xusiming/Subsystem1'
 * '<S2>'   : 'xusiming/Subsystem2'
 * '<S3>'   : 'xusiming/Subsystem4'
 * '<S4>'   : 'xusiming/Subsystem5'
 * '<S5>'   : 'xusiming/Subsystem1/MATLAB Function'
 * '<S6>'   : 'xusiming/Subsystem2/MATLAB Function'
 * '<S7>'   : 'xusiming/Subsystem2/RcvUsartBuf4'
 * '<S8>'   : 'xusiming/Subsystem5/If Action Subsystem'
 * '<S9>'   : 'xusiming/Subsystem5/If Action Subsystem1'
 * '<S10>'  : 'xusiming/Subsystem5/If Action Subsystem/If Action Subsystem'
 * '<S11>'  : 'xusiming/Subsystem5/If Action Subsystem/If Action Subsystem1'
 * '<S12>'  : 'xusiming/Subsystem5/If Action Subsystem/If Action Subsystem2'
 * '<S13>'  : 'xusiming/Subsystem5/If Action Subsystem/If Action Subsystem3'
 * '<S14>'  : 'xusiming/Subsystem5/If Action Subsystem/If Action Subsystem4'
 * '<S15>'  : 'xusiming/Subsystem5/If Action Subsystem/If Action Subsystem5'
 */
#endif                                 /* RTW_HEADER_xusiming_h_ */

/* File trailer for Real-Time Workshop generated code.
 *
 * [EOF] xusiming.h
 */
