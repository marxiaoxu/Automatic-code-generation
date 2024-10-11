


How to configure the CAN peripheral to send and receive CAN frames in 
normal mode. 

The sent frames are used to control LEDs by pressing KEY Push Button.
	
The CAN serial communication link is a bus to which a number of units may be
connected. This number has no theoretical limit. Practically the total number
of units will be limited by delay times and/or electrical loads on the bus line.

This program behaves as follows:
  - After reset, all LEDs are OFF on the N eval boards
  - By Pressing on KEY Push Button : LED1 turns ON and all other LEDs are OFF, on the N
    eval boards connected to the bus. 
  - Press on KEY Push Button again to send CAN Frame to command LEDn+1 ON, all other LEDs 
    are OFF on the N eval boards.
    
In STM32CubeMX project file:

  The CAN1 is configured as follows:
    - Bit Rate   = 1 Mbit/s  
    - CAN Clock  = external clock (HSE)
    - ID Filter  = All identifiers are allowed
    - RTR = Data
    - DLC = 1 byte
    - Data: Led number that should be turned ON


Hardware and Software environment

  - This example runs on STM32F429xx/STM32F439xx devices.
  - This example has been tested with STM32429I-DISC1 board.

  - STM324x9I-EVAL Set-up 
    - Use LED1, LED2, LED3 and LED4 connected respectively to PG.06, PG.07, PG.10
      and PG.12 pins
    - Use KEY Push Button connected to PC.13
    - Connect a female/female CAN cable between at least 2 EVAL CAN connectors (CN22)
    - You have to configure the jumpers as follows:


 