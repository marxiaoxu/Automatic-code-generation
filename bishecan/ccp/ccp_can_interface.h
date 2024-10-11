#include "ccppar.h"
#include "ccp.h"
#ifndef CCP_CAN_INTERFACE_H
#define CCP_CAN_INTERFACE_H

 //#define CCP_MTABYTEPTR CCP_BYTE CCP_MEM_ROM *

//#define CCP_BYTEPTR unsigned char
void disable_interrupt(void);//失能全局中断
void enable_interrupt(void); //使能全局中断
void ccpsend( CCP_BYTEPTR mSg );
MTABYTEPTR ccpGetPointer(CCP_BYTE_addr ext, CCP_DWORD addr );
BYTE ccpDisableNormalOperation( MTABYTEPTR a,WORD S );
void ccpsetcalPage(CCP_DWORD a);
void ccpInitcalPage( void );
void ccp_DAQ_Callback(void);
void CCP_Init(void);
void ccp_recv(void);
//xusiming

#endif /* CCP CAN INTERFACE H_*/

