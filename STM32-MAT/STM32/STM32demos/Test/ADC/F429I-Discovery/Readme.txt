These examples describe ADC tests launched from Simulink tool. 
These tests have been validated with following parameters:

* Hardware and Software environment
-	HW used: STM32F429_DISC1
-	SW used: CubeMX_5.1.0 and MATLAB Version: 9.5.0.1033004 (R2018b)



1) F429_OneADC: ADC Regular conversion in the DMA mode (one channel)
- Behavior: This use case allows to show conversion is started by external trigger (Timer2) and DMA request occurs at end of conversion for one channel. 
Connect PA0 pin to VDD or GND and see values 3.3V or 0V on hyperterminal. 

2) F429_ADC1_IT: ADC Regular conversion in the IT mode (one channel)
- Behavior: This use case allows to show conversion is started by software through start bit and Interrupt request occurs at end of conversion for one channel.


3) F429_ADC1_2ch_DMA: ADC Regular conversion in the DMA mode (2 channels)
- Behavior: This use case allows to read ADC value from DMA for channel 0 and channel 1 (PA0 and PA1).



