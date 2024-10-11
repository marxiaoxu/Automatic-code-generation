/*
 * File: STM32SerialRtiostream-Rtiostream.h
 *
 * Processor-in-the-Loop (PIL) interface functions
 */

#ifndef __STM32SerialRtiostream_Rtiostream_H__
#define __STM32SerialRtiostream_Rtiostream_H__

#ifdef __cplusplus
extern "C" {
#endif

/***************** DEFINES ****************************************************/
#define RTIOSTREAM_NO_ERROR (0)
#define RTIOSTREAM_ERROR (-1)
#define SERVER_STREAM_ID (1) /* Allow a single server-side connection */

extern int rtIOStreamOpen(int argc, void * argv[]);
extern int rtIOStreamClose(int streamID);
extern int rtIOStreamSend(int streamID, const void * src, size_t size, size_t * sizeSent);
extern int rtIOStreamRecv(int streamID, void * dst, size_t size, size_t * sizeRecv);

#ifdef __cplusplus
}
#endif

#endif



