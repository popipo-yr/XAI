//
//  AAViewController.h
//  XAI
//
//  Created by touchhy on 14-4-3.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#include "XAIPacket.h"

#ifdef __cplusplus
extern "C" {
#endif
    
    
    /*----------ctrl----------------*/
    
#define _XPPS_C_OPRID     1
#define _XPPS_C_TIME   4
#define _XPPS_C_DATA_COUNT  1
#define _XPPS_C_DATA_TYPE  1
#define _XPPS_C_DATA_LEN    2
#define _XPPS_C_FIXED_ALL   (_XPPS_N_FIXED_ALL+1+4+1+1+2)
    
    
#define _XPP_C_OPRID_START  31
#define _XPP_C_OPRID_END    31
#define _XPP_C_TIME_START    32
#define _XPP_C_TIME_END    35
#define _XPP_C_DATA_COUNT_START   36
#define _XPP_C_DATA_COUNT_END 36
#define _XPP_C_DATA_TYPE_START    37
#define _XPP_C_DATA_TYPE_END    37
#define _XPP_C_DATA_LEN_START 38
#define _XPP_C_DATA_LEN_END   39
#define  _XPP_C_DATA_START      40
#define  _XPP_C_DATA_END        _XPP_END_UNKOWN
    
    
    
    typedef struct _xai_packet_param_ctrl{
        
        
        _xai_packet_param_normal* normal_param
        ;uint8_t  oprId      //2byte
        ;uint8_t  data_count //1byte
        ;uint16_t  data_len   //2byte
        ;void*  data    //.......
        ;uint32_t  time //4
        ;uint8_t  data_type
        ;
        
    }_xai_packet_param_ctrl; //控制报文参数
    
    
    
    _xai_packet*   generatePacketCtrl(_xai_packet_param_ctrl* ctrl_param);  //依据参数生成一个控制的报文
    _xai_packet_param_ctrl*   generateParamCtrlFromPacket(const _xai_packet*  packet); //通过报文获控制参数
    _xai_packet_param_ctrl*   generateParamCtrlFromPacketData(void*  packet_data,int size); 
    void purgePacketParamCtrl(_xai_packet_param_ctrl* ctrl_param); //释放一个控制报文参数
    
    
    _xai_packet_param_ctrl*    generatePacketParamCtrl(); //生成一个报文参数
    
    
#ifdef __cplusplus
}
#endif
