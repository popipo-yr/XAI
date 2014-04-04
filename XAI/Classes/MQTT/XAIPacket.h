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
#include "XAIMQTTDEF.h"

#ifdef __cplusplus
extern "C" {
#endif


typedef struct _xai_packet{

    uint8_t* all_load;     //所有报文信息
    uint8_t* pre_load;     //固定报文信息
    unsigned int pos;      //固定报文位置
    uint8_t* data_load;    //可变报文信息

}_xai_packet; //普通报文包


//typedef struct _xai_packet{
//    
//    uint8_t* overload;
//    uint8_t* payload;
//    unsigned int pos;
//    uint8_t* data;
//    
//}_xai_packet; //控制报文包
    


    
    

    
typedef struct _xai_packet_param_normal{
    
    
     const char* from_guid  //12Byte
    ;const char* to_guid   //12Byte
    ;const char* flag      //1Byte
    ;const char* msgid     //2Byte
    ;const char* magic_number //2byte
    ;const char* length       //2byte
    ;const char*  data       //.....
    ;
    
}_xai_packet_param_normal;  //普通报文参数
    

typedef struct _xai_ctrl_packet_param{
    
    
    _xai_packet_param_normal normal_param
    ;const char*  oprId      //2byte
    ;const char*  data_count //1byte
    ;const char*  data_len   //2byte
    ;const char*  data    //.......
    ;
    
}_xai_ctrl_packet_param; //控制报文参数


_xai_packet*   generateNormalPacket(_xai_packet_param_normal* normal_param);  //依据参数生成一个普通的报文
void purgePacketNormal(_xai_packet* packet);  //释放一个普通报文
_xai_packet_param_normal*   generateNormalParamFromPacket(const _xai_packet*  packet); //通过报文获取一般参数
void purgeNormalPacketParam(_xai_packet_param_normal* normal_param); //释放一个报文参数


_xai_packet*   generateControlPacket( const char* from_guid  //12Byte
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
