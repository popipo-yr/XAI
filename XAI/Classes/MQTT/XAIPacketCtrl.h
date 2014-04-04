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
    
    
    
    typedef struct _xai_packet_param_ctrl{
        
        
        _xai_packet_param_normal* normal_param
        ;const char*  oprId      //2byte
        ;const char*  data_count //1byte
        ;const char*  data_len   //2byte
        ;const char*  data    //.......
        ;const char*  time //4
        ;const char*  data_type
        ;
        
    }_xai_packet_param_ctrl; //控制报文参数
    
    
    
    _xai_packet*   generatePacketCtrl(_xai_packet_param_ctrl* ctrl_param);  //依据参数生成一个控制的报文
    _xai_packet_param_ctrl*   generateParamCtrlFromPacket(const _xai_packet*  packet); //通过报文获控制参数
    void purgePacketParamCtrl(_xai_packet_param_ctrl* ctrl_param); //释放一个控制报文参数
    
    
    
#ifdef __cplusplus
}
#endif
