/*
 * File: xusiming_CAN.h
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

#ifndef RTW_HEADER_xusiming_CAN_h_
#define RTW_HEADER_xusiming_CAN_h_
#include "STM32_Config.h"

/* CAN1 handler declaration. */
extern CAN_HandleTypeDef hcan1;

/* Interrupt pointer callback function declaration. */
extern void (* Rx_ItFcn1)(void);
extern void (* Tx_ItFcn1)(void);
extern void (* Error_ItFcn1)(void);

/* CAN1 RX IT function */
void CAN1_Rx_ItFcn(void);

/* CAN1 TX IT function */
void CAN1_Tx_ItFcn(void);

#endif                                 /* RTW_HEADER_xusiming_CAN_h_ */

/* File trailer for Real-Time Workshop generated code.
 *
 * [EOF] xusiming_CAN.h
 */
