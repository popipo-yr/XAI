//
//  XAIPacketDevTypeInfo.h
//  XAI
//
//  Created by touchhy on 14-4-8.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#ifndef XAI_XAIPacketDevTypeInfo_h
#define XAI_XAIPacketDevTypeInfo_h


#include "XAIPacket.h"

#ifdef __cplusplus
extern "C" {
#endif
    
    
    /*----------DEV TYPE INFO----------------*/
    
#define _XPPS_D_FLAG     1
#define _XPPS_D_VENDOR   8
#define _XPPS_D_MODEL  16
#define _XPPS_D_FIXED_ALL   (_XPPS_N_FIXED_ALL+1+8+16)
 
    
#define _XPP_D_FLAG_START     31
#define _XPP_D_FLAG_END     31
#define _XPP_D_VENDOR_START   32
#define _XPP_D_VENDOR_END   39
#define _XPP_D_MODEL_START  40
#define _XPP_D_MODEL_END  55
    
    
    
    
    typedef struct _xai_packet_param_dti{
        
        
        _xai_packet_param_normal* normal_param
        ;uint8_t  flag
        ;uint8_t  vender[8]
        ;uint16_t  model[16]
        ;
        
    }_xai_packet_param_dti; //
    
    
    
    _xai_packet*   generatePacketDTI(_xai_packet_param_dti* dti_param);  //依据参数生成一个控制的报文
    _xai_packet_param_dti*   generateParamDTIFromPacket(const _xai_packet*  packet); //通过报文获控制参数
    _xai_packet_param_dti*   generateParamDTIFromPacketData(void*  packet_data,int size);
    void purgePacketParamDTI(_xai_packet_param_dti* dti_param); //释放一个控制报文参数
    
    
    _xai_packet_param_dti*    generatePacketParamDTI(); //生成一个报文参数
    
    
#ifdef __cplusplus
}
#endif




#endif
