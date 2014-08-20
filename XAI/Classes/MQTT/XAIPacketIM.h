//
//  AAViewController.h
//  XAI
//
//  Created by touchhy on 14-4-3.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#ifndef XAI_XAIPacketIM_h
#define XAI_XAIPacketIM_h

#include "XAIPacketNormal.h"

#ifdef __cplusplus
extern "C" {
#endif
    
    
    /*----------IM----------------*/
    
#define _XPPS_IM_TIME   4
#define _XPPS_IM_DATA_COUNT  1
#define _XPPS_IM_FIXED_ALL   (_XPPS_N_FIXED_ALL+_XPPS_IM_TIME+_XPPS_IM_DATA_COUNT)
    
    
#define _XPP_IM_TIME_START    31
#define _XPP_IM_TIME_END    34
#define _XPP_IM_DATA_COUNT_START   35
#define _XPP_IM_DATA_COUNT_END 35
#define  _XPP_IM_DATA_START      36
#define  _XPP_IM_DATA_END        _XPP_END_UNKOWN
    
    
    typedef struct _xai_packet_param_IM{
        
        _xai_packet_param_normal* normal_param;  /*packet noraml header*/
        uint32_t  time;
        uint8_t  data_count;
        _xai_packet_param_data*  data; /*packet param data list*/
        
    }_xai_packet_param_IM; /*control packet param*/
    
    
    /**
     @to-do:   generate a packet struct from control param struct
     @param:   param - a control param struct point
     @returns: Pointer to packet
     */
    _xai_packet*   generatePacketFromParamIM(_xai_packet_param_IM* param);
    
    
    /**
     @to-do:   generate control param from packet struct
     @param:   packet - a packet struct pointer
     @returns: Pointer to control param struct
     */
    _xai_packet_param_IM*   generateParamIMFromPacket(const _xai_packet*  packet);
    
    
    /**
     @to-do:    generate control param from binary data
     @param:    data -  a binary data pointer
                size -  size of binary data
     @returns:  Pointer to control param struct
     */
    _xai_packet_param_IM*   generateParamIMFromData(void* data,  int size);
    
    
    /**
     @to-do:   generate an empty control param struct
     @param:   void
     @returns: Pointer to control param struct
     */
    _xai_packet_param_IM*    generatePacketParamIM();
    
    
    /**
     @to-do:   purge an control param with it's data
     @param:   param - a pointer to control param struct
     @returns: void
     */
    void purgePacketParamIMAndData(_xai_packet_param_IM* param);
    
    
    /**
     @to-do:   only purge an control param , without it's data
     @param:   param - a pointer to control param struct
     @returns: void
     */
    void purgePacketParamIMNoData(_xai_packet_param_IM* param);
    
    
    /**
     @to-do:   get packer param data  from control param at index
     @param:   param - a pointer to control param struct
               index - the index  of  param data would to get
     @returns:  Pointer to param data
     */
    _xai_packet_param_data*  getParamDataFromParamIM(_xai_packet_param_IM* param, int index);
    
    
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
    void xai_param_IM_set(_xai_packet_param_IM* param,  XAITYPEAPSN  from_apsn,  XAITYPELUID from_luid,
                          XAITYPEAPSN to_apsn,  XAITYPELUID to_luid,  uint8_t flag,  uint16_t msgid,
                          uint16_t magic_number  ,uint32_t time,  uint8_t data_count,
                          _xai_packet_param_data* data);
    
    
    
#ifdef __cplusplus
}
#endif

#endif
