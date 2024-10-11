These examples describe GPIO tests launched from Simulink tool. 
These tests have been validated with following parameters:

* Hardware and Software environment
-	HW used: STM32F407G_DISC1
-	SW used: CubeMX_5.1.0 and MATLAB Version: 9.5.0.1033004 (R2018b)



1) F4VGTx_4Exti: 
- Project configuration: F4VGTx_4Exti.ioc and F4VGTx_4Exti.slx
- Behavior: This use case allows to toggle GPIOD Pins depending on GPIO external interrupt event. At the start of the board, connect the different pins one by one (PA1,PA2 and PA3)
			with connectors directly on VDD. LEDS (Orange,Red and Blue) will toggle. Press the button USER corresponding to pin PA0 to toggle the LED (green).


2) GPIO_Sequence:
- Project configuration: GPIO_Sequence.ioc and GPIO_Sequence.slx
- Behavior: Element A writes value to the specified data store. This value corresponds to GPIOA Pin0 (PA0:User button). When User button is pressed ,DataStoreRead equals to true and the
			the GPIOD Pin 12 (LED green) will toggle. if DataStoreRead is equals to false, no LED toggle.


		
3) ReadWrite:
- Project configuration: ReadWrite.ioc and ReadWrite.slx
- Behavior: 3 LEDs will toggle (LD3,LD5,LD6) and by pressing User button also LED4 (Green).


4) SimpleGPIO:
- Project configuration: SimpleGPIO.ioc and SimpleGPIO.slx
- Behavior: 2 LEDs will toggle (Orange and Red) corresponding to GPIOD 13 and 14.
