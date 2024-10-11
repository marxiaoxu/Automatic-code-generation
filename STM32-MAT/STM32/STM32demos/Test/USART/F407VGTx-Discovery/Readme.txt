These examples describe USART tests launched from Simulink.  
These tests have been validated with following parameters:

* Hardware and Software environment
-	HW used: STM32F407G_DISC1
-	SW used: CubeMX_5.0.1 and MATLAB Version: 9.5.0.1033004 (R2018b)
- 	Hyperterminal configuration: (STLink Virtual Port com used here)
	Baud Rate: 115200 Bits/s
	Data: 8 bits
	Parity: none
	Stop: 1 bit
	Flow control: none

USART3 Rx and TX should be connected to another board to access virtual com port to visualize the content on hyperterminal. (as example nucleo F401RE on Rx and Tx) 

1) USART_3_Receive: Interrupt mode
- Project configuration: USART_3_Receive.ioc and USART_3_Receive.slx
- Behavior: Wait 10 characters on USART_Rx and send characters back to USART_Tx



2) USART_3_Receive_Char: Interrupt mode
- Project configuration: USART_3_Receive_Char.ioc and USART_3_Receive_Char.slx
- Behavior: Wait for 10 characters on USART_Rx and send characters back to USART_Tx.LED6 (Blue) corresponding to GPIOD Pin 15 will be toggled 
	    when the fourth characters (index3 in simulink) is the number "1".


		
3) USART_3_Receive_Send: DMA mode
- Project configuration: USART_3_Receive_Send.ioc and USART_3_Receive_Send.slx
- Behavior: Wait 10 characters on USART_Rx and send characters back to USART_Tx. A SW interrupt occurs when 10 characters have been transmitted and after a GPIOD Pin 15
	    will be toggled.
