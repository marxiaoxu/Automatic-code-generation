

* To localize the firmware the STM32CubeMX is using in its ioc file have a look in the STM32CubeMX project:

  GENERATE CODE > Project Manager > Project 

  Update preferences with this location:
  updatePrefs('set','CustomerFirmwarePackage','E:\STM32\STM32CubeRepository\STM32Cube_FW_F3_V1.11.0');


* Verify that all files are copied from the Firmware location during the code generation by STM32CubeMX

  GENERATE CODE > Project Manager > Code Generator [x] Copy all used libraries into the project folder
