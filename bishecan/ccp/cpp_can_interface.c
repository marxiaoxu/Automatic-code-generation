#include "main.h"
#include "ccp_can_interface.h"
/*��Ҫ�õ��ı���*/
/*���͵ı���*/
//extern unsigned char message;
///*���յı���*/
//extern unsigned char recvMsg;
//extern 
unsigned char IRQ_hand;
uint8_t ccpSendFlag;
//Current Calibration page
CCP_BYTE ccpCalPage =0;// Default ROM
/*���ձ�����ɵı�־λ*/
/*���ͱ��ı�־λ*/

/*Transmit the Cp message */
/* Id is CCP DTo ID, which is configured at compile time in CAN.C */
void disable_interrupt()//ʧ��ȫ���ж�
{
	int xusiming=0;
}
void enable_interrupt()//ʹ��ȫ���ж�
{
		int xusiming=0;
}

//Ƥ�Գ���
/*ccpsend�����ӿ�*/
void ccpSend(CCP_BYTEPTR msg)
{
/*CAN���ͺ���*/
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
/*ssppginter������������*/
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



/*CCP��ʼ��������*/
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
//����Ľ��պ������ص�
/*ccp���պ���*/
void CCP_recv(void)
{
if(IRQ_hand)/*������ɵ��жϱ�־λ*/
{
IRQ_hand = 0;

/*��־λ����callback function����0��������������g*/
/*�����յ��ı��Ĵ��뵽ccpcommandͼ����*/
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
