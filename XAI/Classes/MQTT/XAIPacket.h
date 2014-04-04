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
    

typedef struct _xai_packet_param_ctrl{
    
    
    _xai_packet_param_normal* normal_param
    ;const char*  oprId      //2byte
    ;const char*  data_count //1byte
    ;const char*  data_len   //2byte
    ;const char*  data    //.......
    ;
    
}_xai_packet_param_ctrl; //控制报文参数

    
void purgePacket(_xai_packet* packet);  //释放一个报文

_xai_packet*   generatePacketNormal(_xai_packet_param_normal* normal_param);  //依据参数生成一个普通的报文
_xai_packet_param_normal*   generateParamNormalFromPacket(const _xai_packet*  packet); //通过报文获取一般参数
void purgePacketParamNormal(_xai_packet_param_normal* normal_param); //释放一个报文参数

    
    
_xai_packet*   generatePacketCtrl(_xai_packet_param_ctrl* ctrl_param);  //依据参数生成一个控制的报文
_xai_packet_param_ctrl*   generateParamCtrlFromPacket(const _xai_packet*  packet); //通过报文获控制参数
void purgePacketParamCtrl(_xai_packet_param_ctrl* ctrl_param); //释放一个控制报文参数



#ifdef __cplusplus
}
#endif
