These examples describe USART tests launched from Simulink.  
These tests have been validated with following parameters:

* Hardware and Software environment
-	HW used: STM32F429_DISC1
-	SW used: CubeMX_5.1.0 and MATLAB Version: 9.5.0.1033004 (R2018b)
- 	Hyperterminal configuration: (STLink Virtual Port com used here)
	Baud Rate: 115200 Bits/s
	Data: 8 bits
	Parity: none
	Stop: 1 bit
	Flow control: none
	
USART1 is used per default to access STLink virtual com port.


1) USART_1_Receive: Interrupt mode
- Project configuration: USART_1_Receive.ioc and USART_1_Receive.slx
- Behavior: Wait 10 characters on USART_Rx and send characters back to USART_Tx



2) USART_1_Receive_Char: Interrupt mode
- Project configuration: USART_1_Receive_Char.ioc and USART_1_Receive_Char.slx
- Behavior: Wait for 10 characters on USART_Rx and send characters back to USART_Tx.LED3 (Green) corresponding to GPIOG Pin 13 will be toggled 
	    when the fourth characters (index3 in simulink) is the number "1".


		
3) USART_1_Receive_Send: DMA mode
- Project configuration: USART_1_Receive_Send.ioc and USART_1_Receive_Send.slx
- Behavior: Wait 10 characters on USART_Rx and send characters back to USART_Tx. A SW interrupt occurs when 10 characters have been transmitted and after a GPIOG Pin 13
	    will be toggled.
