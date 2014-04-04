//
//  AAViewController.h
//  XAI
//
//  Created by touchhy on 14-4-3.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#ifdef __cplusplus
extern "C" {
#endif


typedef struct _xai_normal_packet{

    uint8_t* overload;
    uint8_t* payload;
    unsigned int pos;
    uint8_t* data;

}_xai_normal_packet;


typedef struct _xai_ctrl_packet{
    
    uint8_t* overload;
    uint8_t* payload;
    unsigned int pos;
    uint8_t* data;
    
}_xai_ctrl_packet;


typedef struct _xai_normal_packet_param{
    
    
    const char* from_guid  //12Byte
    ;const char* to_guid   //12Byte
    ;const char* flag      //1Byte
    ;const char* msgid     //2Byte
    ;const char* magic_number //2byte
    ;const char* length       //2byte
    ;const char*  data       //.....
    ;
    
}_xai_normal_packet_param;


_xai_normal_packet*   generateNormalPacket( const char* from_guid  //12Byte
                                           ,const char* to_guid   //12Byte
                                           ,const char* flag      //1Byte
                                           ,const char* msgid     //2Byte
                                           ,const char* magic_number //2byte
                                           ,const char* length       //2byte
                                           ,const char*  data       //.....
);

_xai_normal_packet_param*   normalPacketToParam(const _xai_normal_packet*  packet);
void purgeNormalPacket(_xai_normal_packet* packet);


_xai_ctrl_packet*   generateControlPacket( const char* from_guid  //12Byte
                                          ,const char* to_guid   //12Byte
                                          ,const char* flag      //1Byte
                                          ,const char* msgid     //2Byte
                                          ,const char* magic_number //2byte
                                          ,const char* length       //2byte
                                          ,const char*  oprId      //2byte
                                          ,const char*  data_count //1byte
                                          ,const char*  data_len   //2byte
                                          ,const char*  data    //.......
);


/*

struct _mosquitto_packet{
	uint8_t command;
	uint8_t have_remaining;
	uint8_t remaining_count;
	uint16_t mid;
	uint32_t remaining_mult;
	uint32_t remaining_length;
	uint32_t packet_length;
	uint32_t to_process;
	uint32_t pos;
	uint8_t *payload;
	struct _mosquitto_packet *next;
    
    
    packet->payload[packet->pos] = byte;
	packet->pos++;
};

*/


#ifdef __cplusplus
}
#endif
