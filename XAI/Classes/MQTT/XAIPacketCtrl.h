//
//  AAViewController.h
//  XAI
//
//  Created by touchhy on 14-4-3.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#ifndef XAI_XAIPacketCtrl_h
#define XAI_XAIPacketCtrl_h

#include "XAIPacketNormal.h"

#ifdef __cplusplus
extern "C" {
#endif
    
    
    /*----------ctrl----------------*/
    
#define _XPPS_C_OPRID     1
#define _XPPS_C_TIME   4
#define _XPPS_C_DATA_COUNT  1
#define _XPPS_C_FIXED_ALL   (_XPPS_N_FIXED_ALL+_XPPS_C_OPRID+_XPPS_C_TIME+_XPPS_C_DATA_COUNT)
    
    
#define _XPP_C_OPRID_START  31
#define _XPP_C_OPRID_END    31
#define _XPP_C_TIME_START    32
#define _XPP_C_TIME_END    35
#define _XPP_C_DATA_COUNT_START   36
#define _XPP_C_DATA_COUNT_END 36
#define  _XPP_C_DATA_START      37
#define  _XPP_C_DATA_END        _XPP_END_UNKOWN
    
    
    typedef struct _xai_packet_param_ctrl{
        
        _xai_packet_param_normal* normal_param;  /*packet noraml header*/
        uint8_t  oprId;
        uint32_t  time;
        uint8_t  data_count;
        _xai_packet_param_data*  data; /*packet param data list*/
        
    }_xai_packet_param_ctrl; /*control packet param*/
    
    
    /**
     @to-do:   generate a packet struct from control param struct
     @param:   param - a control param struct point
     @returns: Pointer to packet
     */
    _xai_packet*   generatePacketFromParamCtrl(_xai_packet_param_ctrl* param);
    
    
    /**
     @to-do:   generate control param from packet struct
     @param:   packet - a packet struct pointer
     @returns: Pointer to control param struct
     */
    _xai_packet_param_ctrl*   generateParamCtrlFromPacket(const _xai_packet*  packet);
    
    
    /**
     @to-do:    generate control param from binary data
     @param:    data -  a binary data pointer
                size -  size of binary data
     @returns:  Pointer to control param struct
     */
    _xai_packet_param_ctrl*   generateParamCtrlFromData(void* data,  int size);
    
    
    /**
     @to-do:   generate an empty control param struct
     @param:   void
     @returns: Pointer to control param struct
     */
    _xai_packet_param_ctrl*    generatePacketParamCtrl();
    
    
    /**
     @to-do:   purge an control param with it's data
     @param:   param - a pointer to control param struct
     @returns: void
     */
    void purgePacketParamCtrlAndData(_xai_packet_param_ctrl* param);
    
    
    /**
     @to-do:   only purge an control param , without it's data
     @param:   param - a pointer to control param struct
     @returns: void
     */
    void purgePacketParamCtrlNoData(_xai_packet_param_ctrl* param);
    
    
    /**
     @to-do:   get packer param data  from control param at index
     @param:   param - a pointer to control param struct
               index - the index  of  param data would to get
     @returns:  Pointer to param data
     */
    _xai_packet_param_data*  getParamDataFromParamCtrl(_xai_packet_param_ctrl* param, int index);
    
    
    /**
     @to-do:    set control param struct value
     @param:    param - be setting control param struct
                from_apsn - from_guid part
                from_luid - frome_guid part
                to_apsn -  to_guid part
                to_luid -  to_guid part
                data  -   param data list pointer
     @returns:  void
     */
    void xai_param_ctrl_set(_xai_packet_param_ctrl* param,  XAITYPEAPSN  from_apsn,  XAITYPELUID from_luid,
                            XAITYPEAPSN to_apsn,  XAITYPELUID to_luid,  uint8_t flag,  uint16_t msgid,
                            uint16_t magic_number,  uint8_t oprId,  uint32_t time,  uint8_t data_count,
                            _xai_packet_param_data* data);
    
    
    
#ifdef __cplusplus
}
#endif

#endif
