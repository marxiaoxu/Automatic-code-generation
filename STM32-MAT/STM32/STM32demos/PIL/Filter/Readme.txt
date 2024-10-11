The IIR_Filter_int32_PIL (Model Block PIL with shared configuration) PIL simulation has run with the following configurations:

 - F429ZITx @ 180 Mhz, USART1(PA9,PA10):  664 µs (MDK-ARM)
 - F429ZITx @ 180 Mhz, USART1(PA9,PA10):  673 µs (arm-none-eabi-gcc) (518 µs with O2)

 - F401RETx @  84 Mhz, USART2:  861 µs (IAR arm)
 - F401RETx @  84 Mhz, USART2:  1112 µs (arm-none-eabi-gcc) (847 µs with O2)

 - L476RG   @  80 Mhz, USART2: 1241 µs (IAR arm)
 - L476RG   @  80 Mhz, USART2: 2116 µs (arm-none-eabi-gcc) (1728 µs with O2)

 - G431RBTx @ 170 Mhz, USART2:  909 µs (IAR arm)
 - G431RBTx @ 170 Mhz, USART2: 1167 µs (arm-none-eabi-gcc) ( 978 µs with O2)

 - F302R8Tx @  64 Mhz, USART2: 1907 µs (IAR arm)
 - F302R8Tx @  64 Mhz, USART2: 1893 µs (arm-none-eabi-gcc) (1558 µs with O2)

 - G474RE   @ 170 Mhz, USART2(PA2,PA3):  938 µs (IAR arm)
 - G474RE   @ 170 Mhz, USART2(PA2,PA3): 2039 µs (arm-none-eabi-gcc) (1101 µs with -Ofast)


 - H743ZI2  @ 480 Mhz, USART3(PD8,PD9):  107 µs (IAR arm)
 - H743ZI2  @ 480 Mhz, USART3(PD8,PD9):  119 µs (arm-none-eabi-gcc) (-Ofast)



There are known issues with project generated for SW4STM32 or STM32CubeIDE:

- Includes may not be correctly set/formatted in build settings of IIR_Filter_int32 eclipse project.

  for instance
   replace     ../../../../Program Files/MATLAB/R2018b/extern/include
        by "../../../../../Program Files/MATLAB/R2018b/extern/include"

   replace ../..
        by ../../..



If lacking, the caches for H7 can be activated with the following code snippet:

int main(void)
...
  /* Enable I-Cache */
  SCB_EnableICache();

  /* Enable D-Cache */
  SCB_EnableDCache();

  /* USER CODE END 1 */
...





The Simulink model in details.

- Test_PIL_IIR_Filter.mdl                   The top model where from the RUN is started.
- IIR_Filter_int32.mdl                      The model in Normal simulation mode.
- IIR_Filter_int32.mdl                      The model in PIL simulation mode.

- iir_startup.m                             Script run in pre-load of the Test_PIL_IIR_Filter model.
- testdata.txt                              Data computed and loaded in workspace as input for the simulation.
                                            1000 noisy sine wave values for 1 second of simulation.

- Test_PIL_IIR_Filter_config_ref.mat        Configuration as reference shared with other models.
                                            (stm32.tlc for the System target file)

- C:\MATLAB\STM32-MAT                       The current directory in the MATLAB session.
- C:\MATLAB\STM32-MAT\IIR_Filter_int32_PIL  The directory that contains
                                            the IIR_Filter_int32.ioc and customized files for STM32cubeMX tool.
                                            These files are generated during the Simulink RUN process.
