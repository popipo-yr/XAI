//
//  XAIPacketACK.h
//  XAI
//
//  Created by office on 14-4-11.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#ifndef XAI_XAIPacketACK_h
#define XAI_XAIPacketACK_h

#include "XAIPacketNormal.h"


#ifdef __cplusplus
extern "C" {
#endif
    
    
    /*----------ctrl----------------*/
    
#define _XPPS_A_SCID     1
#define _XPPS_A_ERRNO   1
#define _XPPS_A_DATA_COUNT  1
#define _XPPS_A_FIXED_ALL   (_XPPS_N_FIXED_ALL+_XPPS_A_SCID+_XPPS_A_ERRNO+_XPPS_A_DATA_COUNT)
    
    
#define _XPP_A_SCID_START  31
#define _XPP_A_SCID_END    31
#define _XPP_A_ERRNO_START    32
#define _XPP_A_ERRNO_END    32
#define _XPP_A_DATA_COUNT_START   33
#define _XPP_A_DATA_COUNT_END 33
#define _XPP_A_DATA_START      34
#define _XPP_A_DATA_END        _XPP_END_UNKOWN
    
    typedef struct _xai_packet_param_ack{
        
        _xai_packet_param_normal* normal_param ; /*packet noraml header*/
        uint8_t  scid ;
        uint8_t  err_no ;
        uint8_t  data_count ;
        _xai_packet_param_data*  data ; /*packet param data list*/
        
        
    }_xai_packet_param_ack; /* ack param struct*/
    
    
    /**
     @to-do:   generate packet from param ack
     @param:   param - a param ack pointer
     @returns: Pointer to packet
     */
    _xai_packet*   generatePacketFromParamACK(_xai_packet_param_ack* param);
    
    
    /**
     @to-do:   generate param ack from packet
     @param:   packet - a packet pointer
     @returns: Pointer to param ack
     */
    _xai_packet_param_ack*   generateParamACKFromPacket(const _xai_packet*  packet);
    
    
    /**
     @to-do:   generate param ack from binary data
     @param:   data - a binary data pointer
               size - size of binary data
     @returns: Pointer to param ack
     */
    _xai_packet_param_ack*   generateParamACKFromData(void*  data,int size);
    
    
    /**
     @to-do:   generate an empty param ack
     @param:   void
     @returns: Pointer to param ack
     */
    _xai_packet_param_ack*    generatePacketParamACK();
    
    
    /**
     @to-do:   purge a param ack with param data
     @param:   param - a param ack pointer
     @returns: void
     */
    void purgePacketParamACKAndData(_xai_packet_param_ack* param);
    
    
    /**
     @to-do:   purge a param ack without param data
     @param:   param - a param ack pointer
     @returns: void
     */
    void purgePacketParamACKNoData(_xai_packet_param_ack* param);
    
    
    /**
     @to-do:   get param data from param ack at index
     @param:   index - index of param ack data whick would to get
     @returns: Pointer to param data
     */
    _xai_packet_param_data*  getParamDataFromParamACK(_xai_packet_param_ack* ctrl_param, int index); //通过index获取data
    
    /**
     @to-do:    set control param struct value
     @param:    param - be setting ack param struct
                from_apsn - from_guid part
                from_luid - frome_guid part
                to_apsn -  to_guid part
                to_luid -  to_guid part
                data  -   param data list pointer
     @returns:  void
     */
    void xai_param_ack_set(_xai_packet_param_ack* param,  XAITYPEAPSN  from_apsn, XAITYPELUID from_luid,
                           XAITYPEAPSN to_apsn,  XAITYPELUID to_luid,  uint8_t flag,  uint16_t msgid,
                           uint16_t magic_number,  uint8_t scid,  uint8_t err_no,  uint8_t data_count ,
                           _xai_packet_param_data* data);
    
    
    
#ifdef __cplusplus
}
#endif

#endif
