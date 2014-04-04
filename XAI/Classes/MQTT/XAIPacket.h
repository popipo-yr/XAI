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
    

    
void purgePacket(_xai_packet* packet);  //释放一个报文

_xai_packet*   generatePacketNormal(_xai_packet_param_normal* normal_param);  //依据参数生成一个普通的报文
_xai_packet_param_normal*   generateParamNormalFromPacket(const _xai_packet*  packet); //通过报文获取一般参数
void purgePacketParamNormal(_xai_packet_param_normal* normal_param); //释放一个报文参数

    
    
//helper
void packet_to_param_helper(char** to , uint8_t* from ,int start,int end);
void param_to_packet_helper(char* to , const char* from, int start, int end);


#ifdef __cplusplus
}
#endif
