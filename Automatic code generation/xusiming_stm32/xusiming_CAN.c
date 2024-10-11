/*
 * File: xusiming_CAN.c
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
#include "xusiming_CAN.h"

/* Interrupt pointer callback function definition. */
void (* Rx_ItFcn1)(void) = NULL;
void (* Tx_ItFcn1)(void) = NULL;
void (* Error_ItFcn1)(void) = NULL;

/**
 * @brief  Rx FIFO 0 message pending callback.
 * @param  hcan pointer to a CAN_HandleTypeDef structure that contains
 *         the configuration information for the specified CAN.
 * @retval None
 */
void HAL_CAN_RxFifo0MsgPendingCallback(CAN_HandleTypeDef *hcan)
{
  if (Rx_ItFcn1 != NULL) {
    Rx_ItFcn1();
  } else {
    Error_Handler();
  }
}

/**
 * @brief  Rx FIFO 1 message pending callback.
 * @param  hcan pointer to a CAN_HandleTypeDef structure that contains
 *         the configuration information for the specified CAN.
 * @retval None
 */
void HAL_CAN_RxFifo1MsgPendingCallback(CAN_HandleTypeDef *hcan)
{
  if (Rx_ItFcn1 != NULL) {
    Rx_ItFcn1();
  } else {
    Error_Handler();
  }
}

/**
 * @brief  Rx FIFO 0 full callback.
 * @param  hcan pointer to a CAN_HandleTypeDef structure that contains
 *         the configuration information for the specified CAN.
 * @retval None
 */
void HAL_CAN_RxFifo0FullCallback(CAN_HandleTypeDef *hcan)
{
  if (Rx_ItFcn1 != NULL) {
    Rx_ItFcn1();
  } else {
    Error_Handler();
  }
}

/**
 * @brief  Rx FIFO 1 full callback.
 * @param  hcan pointer to a CAN_HandleTypeDef structure that contains
 *         the configuration information for the specified CAN.
 * @retval None
 */
void HAL_CAN_RxFifo1FullCallback(CAN_HandleTypeDef *hcan)
{
  if (Rx_ItFcn1 != NULL) {
    Rx_ItFcn1();
  } else {
    Error_Handler();
  }
}

/**
 * @brief  Transmission Mailbox 0 complete callback.
 * @param  hcan pointer to a CAN_HandleTypeDef structure that contains
 *         the configuration information for the specified CAN.
 * @retval None
 */
void HAL_CAN_TxMailbox0CompleteCallback(CAN_HandleTypeDef *hcan)
{
  /* Call CANx transmit complete function. */
  if (Tx_ItFcn1 != NULL) {
    Tx_ItFcn1();
  } else {
    Error_Handler();
  }
}

/**
 * @brief  Transmission Mailbox 1 complete callback.
 * @param  hcan pointer to a CAN_HandleTypeDef structure that contains
 *         the configuration information for the specified CAN.
 * @retval None
 */
void HAL_CAN_TxMailbox1CompleteCallback(CAN_HandleTypeDef *hcan)
{
  /* Call CANx transmit complete function. */
  if (Tx_ItFcn1 != NULL) {
    Tx_ItFcn1();
  } else {
    Error_Handler();
  }
}

/**
 * @brief  Transmission Mailbox 2 complete callback.
 * @param  hcan pointer to a CAN_HandleTypeDef structure that contains
 *         the configuration information for the specified CAN.
 * @retval None
 */
void HAL_CAN_TxMailbox2CompleteCallback(CAN_HandleTypeDef *hcan)
{
  /* Call CANx transmit complete function. */
  if (Tx_ItFcn1 != NULL) {
    Tx_ItFcn1();
  } else {
    Error_Handler();
  }
}

/**
 * @brief  Transmission Mailbox 0 Cancellation callback.
 * @param  hcan pointer to an CAN_HandleTypeDef structure that contains
 *         the configuration information for the specified CAN.
 * @retval None
 */
void HAL_CAN_TxMailbox0AbortCallback(CAN_HandleTypeDef *hcan)
{
  UNUSED(hcan);
}

/**
 * @brief  Transmission Mailbox 1 Cancellation callback.
 * @param  hcan pointer to an CAN_HandleTypeDef structure that contains
 *         the configuration information for the specified CAN.
 * @retval None
 */
void HAL_CAN_TxMailbox1AbortCallback(CAN_HandleTypeDef *hcan)
{
  UNUSED(hcan);
}

/**
 * @brief  Transmission Mailbox 2 Cancellation callback.
 * @param  hcan pointer to an CAN_HandleTypeDef structure that contains
 *         the configuration information for the specified CAN.
 * @retval None
 */
void HAL_CAN_TxMailbox2AbortCallback(CAN_HandleTypeDef *hcan)
{
  UNUSED(hcan);
}

/**
 * @brief  Sleep callback.
 * @param  hcan pointer to a CAN_HandleTypeDef structure that contains
 *         the configuration information for the specified CAN.
 * @retval None
 */
void HAL_CAN_SleepCallback(CAN_HandleTypeDef *hcan)
{
  UNUSED(hcan);
}

/**
 * @param  hcan pointer to a CAN_HandleTypeDef structure that contains
 *         the configuration information for the specified CAN.
 * @retval None
 */
void HAL_CAN_WakeUpFromRxMsgCallback(CAN_HandleTypeDef *hcan)
{
  UNUSED(hcan);
}

/**
 * @brief  Error CAN callback.
 * @param  hcan pointer to a CAN_HandleTypeDef structure that contains
 *         the configuration information for the specified CAN.
 * @retval None
 */
void HAL_CAN_ErrorCallback(CAN_HandleTypeDef* hcan)
{
  /* Call CANx error function. */
  if (Error_ItFcn1 != NULL) {
    Error_ItFcn1();
  } else {
    Error_Handler();
  }
}

/*******************************************************************************
 * Function Name  : CAN1_Rx_ItFcn
 * Description    : CAN1 End of receive interrupt
 * Input          : None
 *******************************************************************************/
void CAN1_Rx_ItFcn()
{
  xusiming_ASYNC5(0);
}

/*******************************************************************************
 * Function Name  : CAN1_Tx_ItFcn
 * Description    : CAN1 End of transmit interrupt
 * Input          : None
 *******************************************************************************/
void CAN1_Tx_ItFcn()
{
  xusiming_ASYNC5(1);
}

/* File trailer for Real-Time Workshop generated code.
 *
 * [EOF] xusiming_CAN.c
 */
