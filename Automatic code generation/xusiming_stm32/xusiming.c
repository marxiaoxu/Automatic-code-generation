/*
 * File: xusiming.c
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
#include "xusiming_private.h"
#include "rtwtypes.h"
#include <math.h>
#include "rt_nonfinite.h"
#include "zero_crossing_types.h"

/* Block signals (default storage) */
B_xusiming xusiming_B;

/* Block states (default storage) */
DW_xusiming xusiming_DW;

/* Previous zero-crossings (trigger) states */
PrevZCX_xusiming xusiming_PrevZCX;

/* Real-time model */
static RT_MODEL_xusiming xusiming_M_;
RT_MODEL_xusiming *const xusiming_M = &xusiming_M_;
void xusiming_ASYNC5(int controlPortIdx)
{
  xusiming_Subsystem5();
}

/* Output and update for function-call system: '<Root>/Subsystem5' */
void xusiming_Subsystem5(void)
{
  {
    CAN_RxHeaderTypeDef rxHeader = { 0 };

    uint8_t rxData[8] = { 0 };

    /* Get received frame. */
    if (HAL_CAN_GetRxMessage(&hcan1, CAN_RX_FIFO0, &rxHeader, &rxData[0])!=
        HAL_OK) {
      xusiming_B.CAN_Read_Data_o1 = (uint8_t)0;
    } else {
      /* Update Read_Data:output 0: ready. */
      xusiming_B.CAN_Read_Data_o1 = (uint8_t)1;

      {
        /* Update output 2. */
        xusiming_B.CAN_Read_Data_o2 = (uint8_t)rxHeader.IDE;

        /* Update output 3. */
        xusiming_B.CAN_Read_Data_o4 = (uint8_t)rxHeader.RTR;

        /* Update output 4. */
        xusiming_B.CAN_Read_Data_o5 = (uint16_t)rxHeader.DLC;

        /* Update output 5. */
        memcpy(&xusiming_B.CAN_Read_Data_o6[0],&rxData[0],(size_t)rxHeader.DLC);
        if (rxHeader.IDE == CAN_ID_STD) {
          xusiming_B.CAN_Read_Data_o3 = (uint32_t)rxHeader.StdId;
        } else {
          xusiming_B.CAN_Read_Data_o3 = (uint32_t)rxHeader.ExtId;
        }
      }
    }
  }

  if (xusiming_B.CAN_Read_Data_o1 == 1) {
    if (xusiming_B.CAN_Read_Data_o6[0] == 1) {
      xusiming_DW.execpt++;
    }

    if (xusiming_B.CAN_Read_Data_o6[0] == 2) {
      xusiming_DW.execpt--;
    }

    if (xusiming_B.CAN_Read_Data_o6[0] == 3) {
      xusiming_DW.ki += 0.1;
    }

    if (xusiming_B.CAN_Read_Data_o6[0] == 4) {
      xusiming_DW.ki -= 0.1;
    }

    if (xusiming_B.CAN_Read_Data_o6[0] == 5) {
      xusiming_DW.kp += 0.1;
    }

    if (xusiming_B.CAN_Read_Data_o6[0] == 6) {
      xusiming_DW.kp -= 0.1;
    }
  }
}

/* Model step function */
void xusiming_step(void)
{
  ZCEventType zcEvent;

  {
    /* Get number of pending message for CAN1 CAN_RX_FIFO0 */
    xusiming_B.CAN_NbPendingMsg = HAL_CAN_GetRxFifoFillLevel(&hcan1,
      CAN_RX_FIFO0);
  }

  {
    xusiming_B.GPIO_Read = (boolean_T)HAL_GPIO_ReadPin(GPIOE, GPIO_PIN_3);
  }

  {
    xusiming_B.GPIO_Read1 = (boolean_T)HAL_GPIO_ReadPin(GPIOE, GPIO_PIN_4);
  }

  zcEvent = rt_ZCFcn(FALLING_ZERO_CROSSING,&xusiming_PrevZCX.Subsystem4_Trig_ZCE,
                     (xusiming_B.GPIO_Read1));
  if (zcEvent != NO_ZCEVENT) {
    {
      HAL_GPIO_TogglePin(GPIOE, GPIO_PIN_13);
    }

    {
      HAL_GPIO_TogglePin(GPIOA, GPIO_PIN_7);
    }
  }

  {
  }

  {
  }

  /* Update absolute time for base rate */
  /* The "clockTick0" counts the number of times the code of this task has
   * been executed. The resolution of this integer timer is 0.001, which is the step size
   * of the task. Size of "clockTick0" ensures timer will not overflow during the
   * application lifespan selected.
   */
  xusiming_M->Timing.clockTick0++;
  switch (xusiming_M->Timing.rtmDbBufReadBuf3) {
   case 0:
    xusiming_M->Timing.rtmDbBufWriteBuf3 = 1;
    break;

   case 1:
    xusiming_M->Timing.rtmDbBufWriteBuf3 = 0;
    break;

   default:
    xusiming_M->Timing.rtmDbBufWriteBuf3 =
      !xusiming_M->Timing.rtmDbBufLastBufWr3;
    break;
  }

  xusiming_M->Timing.rtmDbBufClockTick3[xusiming_M->Timing.rtmDbBufWriteBuf3] =
    xusiming_M->Timing.clockTick0;
  xusiming_M->Timing.rtmDbBufLastBufWr3 = xusiming_M->Timing.rtmDbBufWriteBuf3;
  xusiming_M->Timing.rtmDbBufWriteBuf3 = 0xFF;
}

/* Model initialize function */
void xusiming_initialize(void)
{
  /* Registration code */

  /* initialize non-finites */
  rt_InitInfAndNaN(sizeof(real_T));
  xusiming_M->Timing.rtmDbBufReadBuf3 = 0xFF;
  xusiming_M->Timing.rtmDbBufWriteBuf3 = 0xFF;
  xusiming_M->Timing.rtmDbBufLastBufWr3 = 0;

  {
    /* user code (Start function Header) */
    {
      /* TIM1 initialization. */
      /* Store TIM1 informations and its handler. */
      G_TIM_Conf[G_TIM_Count] = &TIM1_Conf;
      G_TIM_Handler[G_TIM_Count] = &htim1;
      G_TIM_Count++;

      /* Store TIM information. */
      TIM1_Conf.TIM_Prescaler = 167;
      TIM1_Conf.TIM_APBClock = 168000000;
      TIM1_Conf.TIM_ARR = 1000 - 1;
      TIM1_Conf.TIM_Clock = 1.0E+6;
      TIM1_Conf.TIM_Freq = 1000.0;
      TIM1_Conf.CH1_duty = 0.0;
      TIM1_Conf.CH2_duty = 0.0;
      TIM1_Conf.CH3_duty = 10.0;
      TIM1_Conf.CH4_duty = 5.0;
      TIM1_Conf.CH1_type = UNKNOWN;
      TIM1_Conf.CH2_type = UNKNOWN;
      TIM1_Conf.CH3_type = OUTPUT_PWM;
      TIM1_Conf.CH4_type = OUTPUT_PWM;

      /* Interrupt handler default initialization. */
      TIM1_Conf.ItUpFcn = NULL;
      TIM1_Conf.ItTrgFcn = NULL;
      TIM1_Conf.ItComFcn = NULL;
      TIM1_Conf.ItBrkFcn = NULL;
      TIM1_Conf.ItCcFcn = NULL;

      /* Auto-reload preload enable */
      /*****Bugzilla 63376 *****/
      /*SET_BIT((&htim1)->Instance->CR1,TIM_CR1_ARPE);*/

      /* Update register value with blockset value. */
      /* Prescaler. */
      __HAL_TIM_SET_PRESCALER(&htim1,TIM1_Conf.TIM_Prescaler);

      /* Autoreload: ARR. */
      __HAL_TIM_SET_AUTORELOAD(&htim1,1000 - 1);

      /* Set CH4 Pulse value. */
      __HAL_TIM_SET_COMPARE(&htim1,TIM_CHANNEL_4,(uint32_t)(50));

      /* Update registers before start operation to come. */
      HAL_TIM_GenerateEvent(&htim1,TIM_EVENTSOURCE_UPDATE);
    }

    {
      /* TIM2 initialization. */
      /* Store TIM2 informations and its handler. */
      G_TIM_Conf[G_TIM_Count] = &TIM2_Conf;
      G_TIM_Handler[G_TIM_Count] = &htim2;
      G_TIM_Count++;

      /* Store TIM information. */
      TIM2_Conf.TIM_Prescaler = 3;
      TIM2_Conf.TIM_APBClock = 84000000;
      TIM2_Conf.TIM_ARR = 2100 - 1;
      TIM2_Conf.TIM_Clock = 2.1E+7;
      TIM2_Conf.TIM_Freq = 10000.0;
      TIM2_Conf.CH1_duty = 0.0;
      TIM2_Conf.CH2_duty = 0.0;
      TIM2_Conf.CH3_duty = 0.0;
      TIM2_Conf.CH4_duty = 0.0;
      TIM2_Conf.CH1_type = INPUT_ENCODER;
      TIM2_Conf.CH2_type = INPUT_ENCODER;
      TIM2_Conf.CH3_type = UNKNOWN;
      TIM2_Conf.CH4_type = UNKNOWN;

      /* Interrupt handler default initialization. */
      TIM2_Conf.ItUpFcn = NULL;
      TIM2_Conf.ItTrgFcn = NULL;
      TIM2_Conf.ItComFcn = NULL;
      TIM2_Conf.ItBrkFcn = NULL;
      TIM2_Conf.ItCcFcn = NULL;

      /* Auto-reload preload enable */
      /*****Bugzilla 63376 *****/
      /*SET_BIT((&htim2)->Instance->CR1,TIM_CR1_ARPE);*/

      /* Update register value with blockset value. */
      /* Prescaler. */
      __HAL_TIM_SET_PRESCALER(&htim2,TIM2_Conf.TIM_Prescaler);

      /* Autoreload: ARR. */
      __HAL_TIM_SET_AUTORELOAD(&htim2,2100 - 1);

      /* Update registers before start operation to come. */
      HAL_TIM_GenerateEvent(&htim2,TIM_EVENTSOURCE_UPDATE);
    }

    {
      /* TIM6 initialization. */
      /* Store TIM6 informations and its handler. */
      G_TIM_Conf[G_TIM_Count] = &TIM6_Conf;
      G_TIM_Handler[G_TIM_Count] = &htim6;
      G_TIM_Count++;

      /* Store TIM information. */
      TIM6_Conf.TIM_Prescaler = 8399;
      TIM6_Conf.TIM_APBClock = 84000000;
      TIM6_Conf.TIM_ARR = 200 - 1;
      TIM6_Conf.TIM_Clock = 10000.0;
      TIM6_Conf.TIM_Freq = 50.0;
      TIM6_Conf.CH1_duty = 0.0;
      TIM6_Conf.CH2_duty = 0.0;
      TIM6_Conf.CH3_duty = 0.0;
      TIM6_Conf.CH4_duty = 0.0;
      TIM6_Conf.CH1_type = UNKNOWN;
      TIM6_Conf.CH2_type = UNKNOWN;
      TIM6_Conf.CH3_type = UNKNOWN;
      TIM6_Conf.CH4_type = UNKNOWN;

      /* Interrupt handler default initialization. */
      TIM6_Conf.ItUpFcn = NULL;
      TIM6_Conf.ItTrgFcn = NULL;
      TIM6_Conf.ItComFcn = NULL;
      TIM6_Conf.ItBrkFcn = NULL;
      TIM6_Conf.ItCcFcn = NULL;

      /* Update interrupt function. */
      TIM6_Conf.ItUpFcn = TIM6_ItUpFcn;

      /* Auto-reload preload enable */
      /*****Bugzilla 63376 *****/
      /*SET_BIT((&htim6)->Instance->CR1,TIM_CR1_ARPE);*/

      /* Update register value with blockset value. */
      /* Prescaler. */
      __HAL_TIM_SET_PRESCALER(&htim6,TIM6_Conf.TIM_Prescaler);

      /* Autoreload: ARR. */
      __HAL_TIM_SET_AUTORELOAD(&htim6,200 - 1);

      /* Update registers before start operation to come. */
      HAL_TIM_GenerateEvent(&htim6,TIM_EVENTSOURCE_UPDATE);
    }

    {
      /* TIM3 initialization. */
      /* Store TIM3 informations and its handler. */
      G_TIM_Conf[G_TIM_Count] = &TIM3_Conf;
      G_TIM_Handler[G_TIM_Count] = &htim3;
      G_TIM_Count++;

      /* Store TIM information. */
      TIM3_Conf.TIM_Prescaler = 8399;
      TIM3_Conf.TIM_APBClock = 84000000;
      TIM3_Conf.TIM_ARR = 100 - 1;
      TIM3_Conf.TIM_Clock = 10000.0;
      TIM3_Conf.TIM_Freq = 100.0;
      TIM3_Conf.CH1_duty = 0.0;
      TIM3_Conf.CH2_duty = 0.0;
      TIM3_Conf.CH3_duty = 0.0;
      TIM3_Conf.CH4_duty = 0.0;
      TIM3_Conf.CH1_type = UNKNOWN;
      TIM3_Conf.CH2_type = UNKNOWN;
      TIM3_Conf.CH3_type = UNKNOWN;
      TIM3_Conf.CH4_type = UNKNOWN;

      /* Interrupt handler default initialization. */
      TIM3_Conf.ItUpFcn = NULL;
      TIM3_Conf.ItTrgFcn = NULL;
      TIM3_Conf.ItComFcn = NULL;
      TIM3_Conf.ItBrkFcn = NULL;
      TIM3_Conf.ItCcFcn = NULL;

      /* Update interrupt function. */
      TIM3_Conf.ItUpFcn = TIM3_ItUpFcn;

      /* Auto-reload preload enable */
      /*****Bugzilla 63376 *****/
      /*SET_BIT((&htim3)->Instance->CR1,TIM_CR1_ARPE);*/

      /* Update register value with blockset value. */
      /* Prescaler. */
      __HAL_TIM_SET_PRESCALER(&htim3,TIM3_Conf.TIM_Prescaler);

      /* Autoreload: ARR. */
      __HAL_TIM_SET_AUTORELOAD(&htim3,100 - 1);

      /* Update registers before start operation to come. */
      HAL_TIM_GenerateEvent(&htim3,TIM_EVENTSOURCE_UPDATE);
    }

    /* user code (Start function Body) */
    {
      /* TIM1 Start. */

      /* Wait for htim1 State READY. */
      while ((&htim1)->State == HAL_TIM_STATE_BUSY) {
      }

      HAL_TIM_PWM_Start(&htim1,TIM_CHANNEL_4);
    }

    {
      /* TIM2 Start. */
      HAL_TIM_Encoder_Start_IT(&htim2,TIM_CHANNEL_ALL);

      /* Wait for htim2 State READY. */
      while ((&htim2)->State == HAL_TIM_STATE_BUSY) {
      }

      /* Wait for htim2 State READY. */
      while ((&htim2)->State == HAL_TIM_STATE_BUSY) {
      }
    }

    /* USART2 initialization for send. */
    USART2_Tx_Initialization();

    {
      /* TIM6 Start. */
      /* Starts the TIM Base generation in interrupt mode. */
      HAL_TIM_Base_Start_IT(&htim6);

      /* Start interrupt for Update event*/
      HAL_TIM_Base_Start_IT(&htim6);
    }

    {
      /* TIM3 Start. */
      /* Starts the TIM Base generation in interrupt mode. */
      HAL_TIM_Base_Start_IT(&htim3);

      /* Start interrupt for Update event*/
      HAL_TIM_Base_Start_IT(&htim3);
    }

    {
      /* HAL CAN1 filter configuration structure definition. */
      CAN_FilterTypeDef sFilterConfig = { 0 };

      sFilterConfig.FilterIdHigh = 0x0;
      sFilterConfig.FilterIdLow = 0x0;
      sFilterConfig.FilterMaskIdHigh = 0x0;
      sFilterConfig.FilterMaskIdLow = 0x0;
      sFilterConfig.FilterFIFOAssignment = CAN_FILTER_FIFO0;
      sFilterConfig.FilterBank = 0;
      sFilterConfig.FilterMode = CAN_FILTERMODE_IDMASK;
      sFilterConfig.FilterScale = CAN_FILTERSCALE_16BIT;
      sFilterConfig.FilterActivation = ENABLE;
      sFilterConfig.SlaveStartFilterBank = 14;

      /* Configure CAN1 filter on dedicated FIFO0. */
      if (HAL_CAN_ConfigFilter(&hcan1, &sFilterConfig)!= HAL_OK) {
        Error_Handler();
      }
    }

    {
      /* Interrupt case. */
      {
        /* Activate CAN RX notifications on dedicated FIFO0. */
        const uint32_t activeITs = CAN_IT_RX_FIFO0_MSG_PENDING|
          CAN_IT_RX_FIFO0_FULL|CAN_IT_RX_FIFO0_OVERRUN;
        if (HAL_CAN_ActivateNotification(&hcan1, activeITs) != HAL_OK) {
          Error_Handler();
        }
      }
    }

    xusiming_DW.execpt = 10.0;
    xusiming_DW.kp = 1.0;
    xusiming_DW.ki = 1.0;
  }

  xusiming_PrevZCX.Subsystem4_Trig_ZCE = UNINITIALIZED_ZCSIG;

  /* Set Rx interrupt function for CAN1 */
  Rx_ItFcn1 = CAN1_Rx_ItFcn;

  /* Set Tx interrupt function for CAN1 */
  Tx_ItFcn1 = CAN1_Tx_ItFcn;

  /* Activate CAN Error notifications. */
  {
    const uint32_t activeITs = CAN_IT_ERROR_WARNING|CAN_IT_ERROR_PASSIVE|
      CAN_IT_LAST_ERROR_CODE| CAN_IT_ERROR;
    if (HAL_CAN_ActivateNotification(&hcan1, activeITs) != HAL_OK) {
      Error_Handler();
    }
  }

  /* System initialize for function-call system: '<Root>/Subsystem1' */

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
    xusiming_M->Timing.rtmDbBufReadBuf3 = xusiming_M->Timing.rtmDbBufLastBufWr3;
    break;
  }

  xusiming_M->Timing.clockTick3 = xusiming_M->
    Timing.rtmDbBufClockTick3[xusiming_M->Timing.rtmDbBufReadBuf3];
  xusiming_M->Timing.rtmDbBufReadBuf3 = 0xFF;

  {
    /* Interrupt case. */
    /* Activate CAN TX notifications. */
    {
      const uint32_t activeITs = CAN_IT_TX_MAILBOX_EMPTY;
      if (HAL_CAN_ActivateNotification(&hcan1, activeITs) != HAL_OK) {
        Error_Handler();
      }
    }

    /* Start CAN1. */
    if (HAL_CAN_Start(&hcan1) != HAL_OK) {
      Error_Handler();
    }
  }

  ;
}

/* File trailer for Real-Time Workshop generated code.
 *
 * [EOF] xusiming.c
 */
