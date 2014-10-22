//
//  XAIPakageIMCtrl.h
//  XAI
//
//  Created by office on 14/10/20.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#ifndef XAI_XAIPakageIMCtrl_h
#define XAI_XAIPakageIMCtrl_h

#ifdef __cplusplus
extern "C" {
#endif
    
#include "XAIPacket.h"
    
    /*----------IM----------------*/
    
#define _XPPS_IM_Ctrl_Name   12
#define _XPPS_IM_Ctrl_Icon    1
#define _XPPS_IM_Ctrl_Time    4
#define _XPPS_IM_Ctrl_Action    1
#define _XPPS_IM_Ctrl_Topic    128
#define _XPPS_IM_Ctrl_FIXED_ALL   (_XPPS_IM_Ctrl_Name + _XPPS_IM_Ctrl_Icon \
                             +_XPPS_IM_Ctrl_Time + _XPPS_IM_Ctrl_Topic + _XPPS_IM_Ctrl_Action)
    
    
#define _XPP_IM_Ctrl_Name_START    0
#define _XPP_IM_Ctrl_Name_END    11
#define _XPP_IM_Ctrl_Icon_START    12
#define _XPP_IM_Ctrl_Icon_END    12
#define _XPP_IM_Ctrl_Time_START    13
#define _XPP_IM_Ctrl_Time_END    16
#define _XPP_IM_Ctrl_Action_START    17
#define _XPP_IM_Ctrl_Action_END    17
#define _XPP_IM_Ctrl_Topic_START       18
#define _XPP_IM_Ctrl_Topic_End       145
#define _XPP_IM_Ctrl_Action_Data_START       146
#define _XPP_IM_Ctrl_Action_Data_END        _XPP_END_UNKOWN
    
    
    typedef struct _xai_packet_param_IM_Ctrl{
        
        uint32_t  time;
        uint8_t  name[12];
        uint8_t  Icon;
        uint8_t  action;
        uint8_t  topic[128];
        uint8_t*  data; /*packet param data list*/
        size_t  dataSize;
        
    }_xai_packet_param_IM_Ctrl; /*IM-control packet param*/
    
    
    
    /**
     @to-do:   generate an empty IM control param struct
     @param:   void
     @returns: Pointer to IM control param struct
     */
    _xai_packet_param_IM_Ctrl*    generatePacketParamIMCtrl();
    
    /**
     @to-do:    generate IM control param from binary data
     @param:    data -  a binary data pointer
     size -  size of binary data
     @returns:  Pointer to IM control param struct
     */
    _xai_packet_param_IM_Ctrl*   generateParamIMCtrFromData(void* data,  int size);
    
    
    void purgePacketParamIMCtrlAndData(_xai_packet_param_IM_Ctrl* param);
    
    
    
    
    
#ifdef __cplusplus
}
#endif



#endif


