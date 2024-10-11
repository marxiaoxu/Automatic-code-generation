#include "getSpiDataValue.h"
#include <stdio.h>

char SPIMsgBuff[20];

/*******************************************************************************
* Function Name  : getSpiDataValue
* Description    : Return buffer address. This function is called from MATLAB script
*                  using coder.ceval('getBuffPtr',coder.rref(buffer))
*                  to get buffer address to send
* Input          : buffPtr
*******************************************************************************/
unsigned int getSpiDataValue(uint32_t buffPtr)
{
    unsigned int volt = 0;
    float value;

    volt = (*((uint8_t *)buffPtr + 1) & 0x0F) << 8;
    volt &= 0xF00;
    volt = volt | *((uint8_t *)buffPtr + 2);

    /*
     *   Volt = (*((unsigned char*)(buffPtr+1)) & 0x0F)<<8;
     *   Volt &= 0xF00;
     *   Volt = Volt + *((unsigned char*)(buffPtr+2));
     */

    value = (volt * 3.3) / 4095;
    sprintf(SPIMsgBuff, "ADC Val:%2.2f volt\n", value);
    return ((unsigned int)SPIMsgBuff);
}

