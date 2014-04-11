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

#include <CoreFoundation/CoreFoundation.h>


/* packet 都是大端
    param  都是小端
 */

#ifdef __cplusplus
extern "C" {
#endif
    
    
    typedef struct _xai_packet{
        
        uint8_t* all_load;     //所有报文信息
        uint8_t* pre_load;     //固定报文信息
        unsigned int fix_pos;      //固定报文位置
        unsigned int size;     //全部的大小
        uint8_t* data_load;    //可变报文信息
        
    }_xai_packet; //普通报文包
    
    
    
    typedef struct _xai_packet_param_normal{
        
        
        
        uint8_t from_guid[12]  //12Byte
        ;uint8_t to_guid[12]   //12Byte
        ;uint8_t flag      //1Byte
        ;uint16_t msgid     //2Byte
        ;uint16_t magic_number //2byte
        ;uint16_t length       //2byte
        ;void*  data       //.....
        ;
        
    }_xai_packet_param_normal;  //普通报文参数
    
    
    void purgePacket(_xai_packet* packet);  //释放一个报文
    
    _xai_packet*   generatePacketNormal(_xai_packet_param_normal* normal_param);  //依据参数生成一个普通的报文
    _xai_packet_param_normal*   generateParamNormalFromPacket(const _xai_packet*  packet); //通过报文获取一般参数
    _xai_packet_param_normal*   generateParamNormalFromPacketData(void*  packetData,int  size); //通过报文获取一般参数
    void purgePacketParamNormal(_xai_packet_param_normal* normal_param); //释放一个报文参数
    
    _xai_packet_param_normal*    generatePacketParamNormal(); //生成一个普通报文参数
    
    
    void xai_param_normal_set(_xai_packet_param_normal* param_normal,XAITYPEAPSN  from_apsn,XAITYPELUID from_luid,
                            XAITYPEAPSN to_apsn,XAITYPELUID to_luid,
                            uint8_t flag , uint16_t msgid , uint16_t magic_number, void* data ,size_t dataSize);
    
    //helper
    void param_to_packet_helper(void* to , void* from, int start, int end);
    void packet_to_param_helper(void* to , void* from ,int start,int end);
    
    //helper
    void byte_data_copy(void* to, const void* from, int toSize,int fromSize); //不会产生内存分配
    void byte_data_set(void** to, const void* from, int size); //将产生内存分配
    
    
    //GUID helper
    void* generateGUID(XAITYPEAPSN apsn,XAITYPELUID luid);
    void purgeGUID(void* guid);
    void* generateSwapGUID(void* guid);
    size_t lengthOfGUID();
    
#ifdef __cplusplus
}
#endif
