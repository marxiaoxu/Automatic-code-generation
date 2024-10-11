/*
 * File: xusiming_TIM.c
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

#include "xusiming.h"
#include "xusiming_TIM.h"

/* Number of configured TIMER. */
uint16_t G_TIM_Count = 0;

/* Array of TIMER information. */
TIM_ConfTypeDef* G_TIM_Conf[5];
TIM_HandleTypeDef* G_TIM_Handler[5];

/* TIM1 informations. */
TIM_ConfTypeDef TIM1_Conf;

/* TIM2 informations. */
TIM_ConfTypeDef TIM2_Conf;

/* TIM6 informations. */
TIM_ConfTypeDef TIM6_Conf;

/* TIM6 polling timeout value. Number of Solver loop. (can be changed). */
uint32_t G_TIM6_PollTimeOut = 10;

/* TIM3 informations. */
TIM_ConfTypeDef TIM3_Conf;

/*******************************************************************************
 * Function Name  : TIM_PeriodElapsedCustomCallback
 * Description    : Timer callback for update event
 * Input          : TIM_HandleTypeDef*   TIM IC handle
 *******************************************************************************/
void TIM_PeriodElapsedCustomCallback(TIM_HandleTypeDef *htim)
{
  TIM_ConfTypeDef * pConf = G_TIM_Conf[0];
  TIM_HandleTypeDef* pHandler = G_TIM_Handler[0];

  {
    uint16_t idx = 0;
    for (idx = 0;idx < 5;idx++) {
      pHandler = G_TIM_Handler[idx];
      if (pHandler == htim) {
        pConf = G_TIM_Conf[idx];
        break;
      }
    }
  }

  if (pHandler == htim) {
    if (pConf->ItUpFcn != NULL) {
      /* Call update function for TIM6. */
      pConf->ItUpFcn();
    }
  }
}

/**
 * @brief  Period elapsed callback in non blocking mode
 * @param  htim TIM handle
 * @retval None
 */
void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef *htim)
{
  extern void TIM_PeriodElapsedCustomCallback(TIM_HandleTypeDef *htim);

  /* Handle this event from model side. */
  TIM_PeriodElapsedCustomCallback(htim);
}

/*******************************************************************************
 * Function Name  : TIM6_ItUpFcn
 * Description    : TIM6 update interrupt
 * Input          : None
 * TIM6_ItUpFcn is called from TIM_PeriodElapsedCustomCallback function
 * in xusiming_TIM.c file.
 *******************************************************************************/
void TIM6_ItUpFcn()
{
  {
    xusiming_B.TmpRTBAtSubsystem2Outport1 = xusiming_B.Timers1_o1;

    /* Output and update for function-call system: '<Root>/Subsystem1' */
    {
      real_T DiscreteTimeIntegrator;
      real_T rtb_Product;
      real_T rtb_Product1;
      real_T rtb_Sum1;
      uint32_T Subsystem1_ELAPS_T;

      /* Asynchronous task (with no priority assigned)
       * reads absolute time */
      switch (xusiming_M->Timing.rtmDbBufWriteBuf3) {
       case 0:
        xusiming_M->Timing.rtmDbBufReadBuf3 = 1;
        break;

       case 1:
        xusiming_M->Timing.rtmDbBufReadBuf3 = 0;
        break;

       default:
        xusiming_M->Timing.rtmDbBufReadBuf3 =
          xusiming_M->Timing.rtmDbBufLastBufWr3;
        break;
      }

      xusiming_M->Timing.clockTick3 = xusiming_M->
        Timing.rtmDbBufClockTick3[xusiming_M->Timing.rtmDbBufReadBuf3];
      xusiming_M->Timing.rtmDbBufReadBuf3 = 0xFF;
      if (xusiming_DW.Subsystem1_RESET_ELAPS_T) {
        Subsystem1_ELAPS_T = 0U;
      } else {
        Subsystem1_ELAPS_T = xusiming_M->Timing.clockTick3 -
          xusiming_DW.Subsystem1_PREV_T;
      }

      xusiming_DW.Subsystem1_PREV_T = xusiming_M->Timing.clockTick3;
      xusiming_DW.Subsystem1_RESET_ELAPS_T = false;

      {
        CAN_TxHeaderTypeDef txHeader = { 0 };

        uint32_t txMailbox = 0;
        uint8_t txData[8] = { 0 };

        /* Build frame to send */
        if (((uint16_T)0U) == CAN_ID_STD) {
          txHeader.StdId = (uint32_t)((uint16_T)48U);
          txHeader.ExtId = (uint32_t)0;
          txHeader.IDE = CAN_ID_STD;
        } else {
          txHeader.StdId = (uint32_t)0;
          txHeader.ExtId = (uint32_t)((uint16_T)48U);
          txHeader.IDE = CAN_ID_EXT;
        }

        txHeader.RTR = (uint32_t)((uint16_T)0U);
        txHeader.DLC = (uint32_t)((uint16_T)8U);
        txHeader.TransmitGlobalTime = DISABLE;
        txData[0] = xusiming_B.TmpRTBAtSubsystem2Outport1;
        txData[1] = xusiming_B.DataTypeConversion3;
        txData[2] = xusiming_B.DataTypeConversion;
        txData[3] = xusiming_B.DataTypeConversion1;
        txData[4] = 0U;
        txData[5] = 0U;
        txData[6] = 0U;
        txData[7] = 0U;

        {
          /* Request transmission. */
          if (HAL_CAN_AddTxMessage(&hcan1, &txHeader, &txData[0], &txMailbox)!=
              HAL_OK) {
            Error_Handler();
          }
        }
      }

      if (xusiming_DW.DiscreteTimeIntegrator1_SYSTEM_ENABLE != 0) {
        xusiming_B.DiscreteTimeIntegrator1 =
          xusiming_DW.DiscreteTimeIntegrator1_DSTATE;
      } else {
        xusiming_B.DiscreteTimeIntegrator1 = 0.001 * (real_T)Subsystem1_ELAPS_T *
          xusiming_DW.DiscreteTimeIntegrator1_PREV_U +
          xusiming_DW.DiscreteTimeIntegrator1_DSTATE;
      }

      DiscreteTimeIntegrator = floor(10.0 * xusiming_DW.ki);
      if (rtIsNaN(DiscreteTimeIntegrator) || rtIsInf(DiscreteTimeIntegrator)) {
        DiscreteTimeIntegrator = 0.0;
      } else {
        DiscreteTimeIntegrator = fmod(DiscreteTimeIntegrator, 256.0);
      }

      xusiming_B.DataTypeConversion = (uint8_T)(DiscreteTimeIntegrator < 0.0 ?
        (int32_T)(uint8_T)-(int8_T)(uint8_T)-DiscreteTimeIntegrator : (int32_T)
        (uint8_T)DiscreteTimeIntegrator);
      DiscreteTimeIntegrator = floor(10.0 * xusiming_DW.kp);
      if (rtIsNaN(DiscreteTimeIntegrator) || rtIsInf(DiscreteTimeIntegrator)) {
        DiscreteTimeIntegrator = 0.0;
      } else {
        DiscreteTimeIntegrator = fmod(DiscreteTimeIntegrator, 256.0);
      }

      xusiming_B.DataTypeConversion1 = (uint8_T)(DiscreteTimeIntegrator < 0.0 ?
        (int32_T)(uint8_T)-(int8_T)(uint8_T)-DiscreteTimeIntegrator : (int32_T)
        (uint8_T)DiscreteTimeIntegrator);
      DiscreteTimeIntegrator = floor(xusiming_DW.execpt);
      if (rtIsNaN(DiscreteTimeIntegrator) || rtIsInf(DiscreteTimeIntegrator)) {
        DiscreteTimeIntegrator = 0.0;
      } else {
        DiscreteTimeIntegrator = fmod(DiscreteTimeIntegrator, 256.0);
      }

      xusiming_B.DataTypeConversion3 = (uint8_T)(DiscreteTimeIntegrator < 0.0 ?
        (int32_T)(uint8_T)-(int8_T)(uint8_T)-DiscreteTimeIntegrator : (int32_T)
        (uint8_T)DiscreteTimeIntegrator);
      if (xusiming_DW.DiscreteTimeIntegrator_SYSTEM_ENABLE != 0) {
        DiscreteTimeIntegrator = xusiming_DW.DiscreteTimeIntegrator_DSTATE;
      } else {
        DiscreteTimeIntegrator = 0.001 * (real_T)Subsystem1_ELAPS_T
          * xusiming_DW.DiscreteTimeIntegrator_PREV_U +
          xusiming_DW.DiscreteTimeIntegrator_DSTATE;
      }

      rtb_Sum1 = xusiming_DW.execpt - (real_T)
        xusiming_B.TmpRTBAtSubsystem2Outport1;
      rtb_Product = xusiming_DW.ki * rtb_Sum1;
      rtb_Product1 = (rtb_Sum1 - xusiming_DW.Delay1_DSTATE) * xusiming_DW.kp;

      {
        HAL_GPIO_TogglePin(GPIOA, GPIO_PIN_6);
      }

      xusiming_DW.DiscreteTimeIntegrator1_SYSTEM_ENABLE = 0U;
      xusiming_DW.DiscreteTimeIntegrator1_DSTATE =
        xusiming_B.DiscreteTimeIntegrator1;
      xusiming_DW.DiscreteTimeIntegrator1_PREV_U = (0.0 * DiscreteTimeIntegrator
        + rtb_Product) + rtb_Product1;

      {
        if (xusiming_B.DiscreteTimeIntegrator1 != TIM1_Conf.CH4_duty) {
          TIM1_Conf.CH4_duty = xusiming_B.DiscreteTimeIntegrator1;
          if (xusiming_B.DiscreteTimeIntegrator1 >= 0) {
            /* Channe4 duty cycle is an input port. */
            __HAL_TIM_SET_COMPARE(&htim1,TIM_CHANNEL_4,(uint32_t)
                                  (xusiming_B.DiscreteTimeIntegrator1 * (&htim1
              )->Instance->ARR / 100));
          }
        }
      }

      xusiming_DW.Delay1_DSTATE = rtb_Sum1;
      xusiming_DW.DiscreteTimeIntegrator_SYSTEM_ENABLE = 0U;
      xusiming_DW.DiscreteTimeIntegrator_DSTATE = DiscreteTimeIntegrator;
      xusiming_DW.DiscreteTimeIntegrator_PREV_U = rtb_Sum1;
    }
  }
}

/*******************************************************************************
 * Function Name  : TIM3_ItUpFcn
 * Description    : TIM3 update interrupt
 * Input          : None
 * TIM3_ItUpFcn is called from TIM_PeriodElapsedCustomCallback function
 * in xusiming_TIM.c file.
 *******************************************************************************/
void TIM3_ItUpFcn()
{
  {
    /* Output and update for function-call system: '<Root>/Subsystem2' */
    {
      uint8_T rtb_TmpSignalConversionAtSFunctionInport1[5];

      /* Reset cpt request when Reset CNT is not 0. */
      if (((uint16_T)0U) != 0 ) {
        (&htim2)->Instance->CNT = 0;
      }

      xusiming_B.Timers1_o1 = (&htim2)->Instance->CNT;
      xusiming_B.Timers1_o2 = __HAL_TIM_IS_TIM_COUNTING_DOWN(&htim2);
      rtb_TmpSignalConversionAtSFunctionInport1[0] = 3U;
      rtb_TmpSignalConversionAtSFunctionInport1[1] = 252U;
      rtb_TmpSignalConversionAtSFunctionInport1[2] = xusiming_B.Timers1_o1;
      rtb_TmpSignalConversionAtSFunctionInport1[3] = 252U;
      rtb_TmpSignalConversionAtSFunctionInport1[4] = 3U;
      xusiming_B.BuffPtr = getBuffPtr
        (&rtb_TmpSignalConversionAtSFunctionInport1[0]);

      {
        if (((uint16_T)5U) != 0) {
          /* Copy data to send. */
          TX_CopyData(&USART2_TxConf, (uint8_t*)xusiming_B.BuffPtr, (uint16_t)
                      ((uint16_T)5U));
        }

        if (USART2_TxConf.nb2Send) {
          xusiming_B.USART_Send2 = 0;
          USART2_TX_SendData(&USART2_TxConf);
        }

        if (USART2_TxConf.txStatus != SERIAL_TX_ON) {
          xusiming_B.USART_Send2 = USART2_TxConf.nbSent;
        }
      }

      /* Reset cpt request when Reset CNT is not 0. */
      if (((uint16_T)1U) != 0 ) {
        (&htim2)->Instance->CNT = 0;
      }

      xusiming_B.Timers2_o1 = (&htim2)->Instance->CNT;
      xusiming_B.Timers2_o2 = __HAL_TIM_IS_TIM_COUNTING_DOWN(&htim2);

      {
      }

      {
      }
    }
  }
}

/* File trailer for Real-Time Workshop generated code.
 *
 * [EOF] xusiming_TIM.c
 */
