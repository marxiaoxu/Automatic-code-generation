These examples describe ADC tests launched from Simulink tool. 
These tests have been validated with following parameters:

* Hardware and Software environment
-	HW used: STM32F407G_DISC1
-	SW used: CubeMX_5.1.0 and MATLAB Version: 9.5.0.1033004 (R2018b)



1) F4VGTx_OneADC: ADC Regular conversion in the DMA mode (one channel)
- Project configuration: F4VGTx_OneADC.ioc and F4VGTx_OneADC.slx
- Behavior: This use case allows to show conversion is started by external trigger (Timer2) and DMA request occurs at end of conversion for one channel. 
Connect PA0 pin to VDD or GND and see values 3.3V or 0V on hyperterminal. 

2) F4VGTx_ADC: ADC Regular conversion in the IT mode (one channel)
- Project configuration: F4VGTx_ADC.ioc and F4VGTx_ADC.slx
- Behavior: This use case allows to show conversion is started by software through start bit and Interrupt request occurs at end of conversion for one channel.



3) F4VGTx_ADC1_2ch_DMA: ADC Regular conversion in the DMA mode (2 channels)
- Project configuration: F4VGTx_ADC1_2ch_DMA.ioc and F4VGTx_ADC1_2ch_DMA.slx
- Behavior: This use case allows to read ADC value from DMA for channel 0 and channel 1 (PA0 and PA1).


4) F4VGTx_ADCTrippleMode: Not applicable
- Project configuration: F4VGTx_ADCTrippleMode.ioc and F4VGTx_ADCTrippleMode.slx
- Behavior:
