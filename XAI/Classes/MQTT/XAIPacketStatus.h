//
//  XAIPacketStatus.h
//  XAI
//
//  Created by touchhy on 14-4-4.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//


#ifndef XAI_XAIPacketStatus_h
#define XAI_XAIPacketStatus_h

#include "XAIPacketNormal.h"  

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
#define _XPPS_S_FIXED_ALL   (_XPPS_N_FIXED_ALL+_XPPS_S_OPRID+_XPPS_S_NAME+_XPPS_S_TRIGGER_GUID \
                            +_XPPS_S_TIME+_XPPS_S_DATA_COUNT+_XPPS_S_DATA_TYPE+_XPPS_S_DATA_LEN)
    
    
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
        
        _xai_packet_param_normal* normal_param ; /*normal param header*/
        uint8_t  oprId ;
        uint8_t  name[16] ;
        uint8_t  trigger_guid[12] ;
        uint32_t  time ;
        uint8_t  data_count ;
        _xai_packet_param_data* data; /*param data list*/
        
    }_xai_packet_param_status; /* status param struct*/
    
    
    
    
    /**
     @to-do:   generate a packet struct from status param struct
     @param:   param - a status param struct point
     @returns: Pointer to packet
     */
    _xai_packet*   generatePacketFromParamStatus(_xai_packet_param_status* param);
    
    
    /**
     @to-do:   generate status param from packet struct
     @param:   packet - a packet struct pointer
     @returns: Pointer to status param struct
     */
    _xai_packet_param_status*   generateParamStatusFromPacket(const _xai_packet*  packet);
    
    
    /**
     @to-do:    generate status param from binary data
     @param:    data -  a binary data pointer
                size -  size of binary data
     @returns:  Pointer to status param struct
     */
    _xai_packet_param_status*   generateParamStatusFromData(void*  packet_data,int size);
    
    
    /**
     @to-do:   generate an empty status param struct
     @param:   void
     @returns: Pointer to status param struct
     */
    _xai_packet_param_status*    generatePacketParamStatus();
    
    
    /**
     @to-do:   purge an status param with it's data
     @param:   param - a pointer to status param struct
     @returns: void
     */
    void purgePacketParamStatusAndData(_xai_packet_param_status* param);
    
    
    /**
     @to-do:   only purge an status param , without it's data
     @param:   param - a pointer to status param struct
     @returns: void
     */
    void purgePacketParamStatusNoData(_xai_packet_param_status* param);
    
    
    /**
     @to-do:   get packer param data  from status param at index
     @param:   param - a pointer to status param struct
               index - the index  of  param data would to get
     @returns: Pointer to param data
     */
    _xai_packet_param_data*  getParamDataFromParamStatus(_xai_packet_param_status* param, int index);
    
    
    /**
     @to-do:    set status param struct value
     @param:    param - be setting status param struct
                from_apsn - from_guid part
                from_luid - frome_guid part
                to_apsn -  to_guid part
                to_luid -  to_guid part
                data  -   param data list pointer
     @returns:  void
     */
    void xai_param_status_set(_xai_packet_param_status* param,  XAITYPEAPSN  from_apsn,
                              XAITYPELUID from_luid, XAITYPEAPSN to_apsn,  XAITYPELUID to_luid,
                              uint8_t flag,  uint16_t msgid,  uint16_t magic_number, uint8_t  oprId,
                              void* name, size_t nameSize,  void* triggerGuid, size_t triggerGuidSize,
                              uint32_t  time , uint8_t  data_count,  _xai_packet_param_data* data);


    
    
#ifdef __cplusplus
}
#endif

#endif
