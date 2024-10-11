These examples describe Timer tests launched from Simulink tool. 
These tests have been validated with following parameters:

* Hardware and Software environment
-	HW used: STM32F407G_DISC1
-	SW used: CubeMX_5.1.0 and MATLAB Version: 9.5.0.1033004 (R2018b)


1) Tim1PWM_IRQ: 
- Project configuration: 
Tim1PWM_IRQ.ioc and Tim1PWM_IRQ.slx

- Behavior:
This example shows how to configure the TIM1 peripheral in PWM (Pulse Width Modulation) mode.
The TIM1 update interrupt is generated and in the handler routine, at each second PD.12,PD.13,PD.15 are toggled.
A Generation of 2 PWM waveforms with corresponding duty cycles CH1/CH4 are displayed using an oscilloscope



2) Tim7_IRQ:
- Project configuration: 
Tim7_IRQ.ioc and Tim7_IRQ.slx

- Behavior: 
This example shows how to configure the TIM7 peripheral to generate a time base of 
one second with the corresponding Interrupt request. When the counter value reaches the auto-reload register value, the TIM7 update 
interrupt is generated and, in the handler routine, at each second PD.13 (LED orange)is toggled with the following frequency: - PD.13: 0.5Hz


		
3) Tim4_OC:
- Project configuration: 
Tim4_OC.ioc and Tim4_OC.slx

- Behavior: 
This example shows how to configure the TIM peripheral to generate four different signals with four different frequencies.
PD.12,PD.13,PD.15 are toggled



4) Tim1PWM_Tim3IC:
- Project configuration: Tim1PWM_Tim3IC.ioc and Tim1PWM_Tim3IC.slx

- Behavior: 
This example shows how to configure the TIM3 peripheral in PWM Input Capture mode.
The TIM1 generates 4 PWM waveforms with corresponding duty cycles CH1 to CH4 visible by using an oscilloscope
TIM3 input capture CH1 to CH4 get frequency and duty cycle.

