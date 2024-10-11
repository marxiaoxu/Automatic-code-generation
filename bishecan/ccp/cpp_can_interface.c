#include "main.h"
#include "ccp_can_interface.h"
/*需要用到的变量*/
/*发送的报文*/
//extern unsigned char message;
///*接收的报文*/
//extern unsigned char recvMsg;
//extern 
unsigned char IRQ_hand;
uint8_t ccpSendFlag;
//Current Calibration page
CCP_BYTE ccpCalPage =0;// Default ROM
/*接收报文完成的标志位*/
/*发送报文标志位*/

/*Transmit the Cp message */
/* Id is CCP DTo ID, which is configured at compile time in CAN.C */
void disable_interrupt()//失能全局中断
{
	int xusiming=0;
}
void enable_interrupt()//使能全局中断
{
		int xusiming=0;
}

//皮以出点
/*ccpsend函数接口*/
void ccpSend(CCP_BYTEPTR msg)
{
/*CAN发送函数*/
//		message.id=CCP_DTO_ID;
//		message.length=8;
//		message.data[0]= msg[0];
//		message.data[1]= msg[1];
//		message.data[2]= msg[2];
//		message.data[3]= msg[3]++;
//		message.data[4]= msg[4];
//		message.data[5]= msg[5];
//		message.data[6]= msg[6];
//		message.data[7]= msg[7];

	
	
	
//		CAN_Send(&can pal1 instance,1UL,&message);//XUSIMING32
		ccpSendFlag =1;
}
/*ssppginter函数不做配置*/
	MTABYTEPTR ccpGetPointer( CCP_BYTE_addr ext, CCP_DWORD addr )
	{

		return(MTABYTEPTR)addr;
	}

uint8_t ccpDisab1ration( MTABYTEPTR a,WORD s)
{
disable_interrupt();
return 1;
}
// disables all interrupts,e.g.


void ccpsetcalPage(CCP_DWORD a)
{
ccpCalPage =(CCP_BYTE)a;
if(ccpCalPage==1)
	{/* RAM */
//#pragma asm
//moy DPP1,#11h
//#pragma endasm}
	}
	else
	{
	/* ROM */
	//#tpragma asm
	//mov DPP1,#05h
	//#tpragma endasm
	}
}
void ccpInitcalPage(void)
{
#define CALROM ADDR x14000
#define CALRAM ADDR x44000
//unsigned char *p1 =(unsigned char *)CALROM_ADDR;//XUSIMING
//unsigned char *p2=(unsigned char *)CALRAM_ADDR;
	unsigned char *p1 =(unsigned char *)0X80000;//XUSIMING
unsigned char *p2=(unsigned char *)0X80000;
unsigned int i;
for(i=0;i<0x4000;i++){
}
}

void CCP_DAQ_callback(void)
{
// 10 ms
// Data Acquisition on Channel 2
ccpDaq(1);
}



/*CCP初始化函数来*/
void CCP_Init(void)
{
// initialize Calibration RAM
ccpInitcalPage();
//Initialize CCp driver
ccpInit();
}
void ccpUserBackground(void)
	{
	
	}
//下面的接收函数是重点
/*ccp接收函数*/
void CCP_recv(void)
{
if(IRQ_hand)/*接收完成的中断标志位*/
{
IRQ_hand = 0;

/*标志位已在callback function中置0，本处无需再置g*/
/*将接收到的报文传入到ccpcommand图数中*/
//ccpCommand(&recvMsg.data[0]);//XUSIMING
//Check for pending CCp transmit m
}
//essages(DTO)
//if(ccpSendFlag)
//ccpSendFlag =0;
{
	ccpSendCallBack();
}
	ccpBackground();
}
