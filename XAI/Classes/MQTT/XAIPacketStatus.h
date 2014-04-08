//
//  XAIPacketStatus.h
//  XAI
//
//  Created by touchhy on 14-4-4.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#include "XAIPacket.h"  
#ifdef __cplusplus
extern "C" {
#endif
    
    
    /*----------ctrl----------------*/
    
#define _XPPS_S_OPRID     1
#define _XPPS_S_NAME   16
#define _XPPS_S_TRIGGER_GUID  12
#define _XPPS_S_TIME   4
#define _XPPS_S_DATA_COUNT  1
#define _XPPS_S_DATA_TYPE  1
#define _XPPS_S_DATA_LEN    2
#define _XPPS_S_FIXED_ALL   (_XPPS_N_FIXED_ALL+1+16+12+4+1+1+2)
    
    
#define _XPP_S_OPRID_START  31
#define _XPP_S_OPRID_END    31
#define _XPP_S_NAME_START    32
#define _XPP_S_NAME_END    47
#define _XPP_S_TRIGGER_GUID_START    48
#define _XPP_S_TRIGGER_GUID_END    59
#define _XPP_S_TIME_START    60
#define _XPP_S_TIME_END    63
#define _XPP_S_DATA_COUNT_START   64
#define _XPP_S_DATA_COUNT_END 64
#define _XPP_S_DATA_TYPE_START    65
#define _XPP_S_DATA_TYPE_END    65
#define _XPP_S_DATA_LEN_START 66
#define _XPP_S_DATA_LEN_END   67
#define _XPP_S_DATA_START      68
#define _XPP_S_DATA_END        _XPP_END_UNKOWN
    
    
    typedef struct _xai_packet_param_status{
        
        
        _xai_packet_param_normal* normal_param
        ;uint8_t  oprId      //2byte
        ;uint8_t  name[16]
        ;uint8_t  trigger_guid[12] //1byte
        ;uint32_t  time   //2byte
        ;uint8_t  data_count    //.......
        ;uint8_t  data_type //4
        ;uint16_t data_len
        ;void*    data
        ;
        
    }_xai_packet_param_status; //控制报文参数
    
    
    _xai_packet*   generatePacketStatus(_xai_packet_param_status* status_param);  //依据参数生成一个状态报文
    _xai_packet_param_status*   generateParamStatusFromPacket(const _xai_packet*  packet); //通过报文获控制参数
    _xai_packet_param_status*   generateParamStatusFromPacketData(void*  packet_data,int size);
    void purgePacketParamStatus(_xai_packet_param_status* status_param); //释放一个控制报文参数
    
    
    _xai_packet_param_status*    generatePacketParamStatus(); //生成一个报文参数

    
    
#ifdef __cplusplus
}
#endif
