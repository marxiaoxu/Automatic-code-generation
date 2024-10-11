//#include "ccp_can_interface.h"
#include "can.h"
int test(int i,int j)
{
	i=j+1;
	return i;
	
}

//void callback_function(unsigned int instance,can_event_t eventType,unsigned int objIdx,void *driverstate)
//{
//	//(void)instance;
//	//(void)driverState;//xusiming32
//	//(void)objIdx;
//	
//CAN_Receive(&can_pall instance,RX_MAILBOX,&recvMsg);
//	
//	
//			switch(eventType)
//			{
//			case CAN_EVENT_RX_COMPLETE:
//			/*接收完成则标志位置1*/
//			IRO_hand=1;
//			break;
//			case CAN_EVENT_TX_COMPLETE:
//			break;
//			default:
//			break;
//			}
//		if(IRQ_hand==1)
//		{
//		/* Toggle output value LED0 */
//		PINS_DRV_TogglePins(PTD,(1<<0));
//		CAN_Receive(&can pall instance, RX MAILBOX,&recvMsg);
//		CCP_recv();
//		}
//}

