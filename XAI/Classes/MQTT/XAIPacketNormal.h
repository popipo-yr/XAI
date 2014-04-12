//
//  XAIPacketNormal.h
//  XAI
//
//  Created by mac on 14-4-12.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#ifndef XAI_XAIPacketNormal_h
#define XAI_XAIPacketNormal_h

#ifdef __cplusplus
extern "C" {
#endif
    
#include "XAIPacket.h"
    
    
    /*----------------------normal-------------*/
    
    /*size*/
#define  _XPPS_N_FROM_GUID  12
#define  _XPPS_N_TO_GUID    12
#define  _XPPS_N_FLAG    1
#define  _XPPS_N_MSGID   2
#define  _XPPS_N_MAGIC_NUMBER  2
#define  _XPPS_N_LENGTH       2
#define  _XPPS_N_FIXED_ALL  (_XPPS_N_FROM_GUID+_XPPS_N_TO_GUID+_XPPS_N_FLAG \
+_XPPS_N_MSGID+_XPPS_N_MAGIC_NUMBER+_XPPS_N_LENGTH)
    
    /*start index 0*/
#define  _XPP_END_UNKOWN   -1  /*unkown index*/
    
#define  _XPP_N_FROM_GUID_START  0
#define  _XPP_N_FROM_GUID_END  11
#define  _XPP_N_TO_GUID_START   12
#define  _XPP_N_TO_GUID_END    23
#define  _XPP_N_FLAG_START    24
#define  _XPP_N_FLAG_END      24
#define  _XPP_N_MSGID_START   25
#define  _XPP_N_MSGID_END   26
#define  _XPP_N_MAGIC_NUMBER_START  27
#define  _XPP_N_MAGIC_NUMBER_END  28
#define  _XPP_N_LENGTH_START        29
#define  _XPP_N_LENGTH_END        30
#define  _XPP_N_DATA_START      31
#define  _XPP_N_DATA_END        _XPP_END_UNKOWN
    
    
    
    typedef struct _xai_packet_param_normal{
        
        uint8_t from_guid[12] ;
        uint8_t to_guid[12] ;
        uint8_t flag ;
        uint16_t msgid ;
        uint16_t magic_number ;
        uint16_t length ;
        void*  data ;
        
    }_xai_packet_param_normal;  /*normal packet param*/
    
    
    /**
     @to-do:   generate a packet struct from normal param struct
     @param:   param - a normal param struct pointer
     @returns: Pointer to binary packet
     */
    _xai_packet*   generatePacketFromParamNormal(_xai_packet_param_normal* param);
    
    
    /**
     @to-do:   generate normal param struct from packet struct
     @param:   packet - a  packet pointer
     @returns: Pointer to a param normal struct
     */
    _xai_packet_param_normal*   generateParamNormalFromPacket(const _xai_packet*  packet);
    
    /**
     @to-do:    generate normal param struct from binary data
     @param:    data - a binary data pointer
                size - binary data size
     @returns: Point to a param normal struct
     */
    _xai_packet_param_normal*   generateParamNormalFromData(void*  data,int  size);
    
    
    /**
     @to-do:   purge a normal param struct
     @param:   param -  a noraml param pointer
     @returns: void
     */
    void purgePacketParamNormal(_xai_packet_param_normal* param);
    
    
    /**
     @to-do:   generate an empty normal param struct
     @param:   void
     @returns: Pointer to a param normal struct
     */
    _xai_packet_param_normal*    generatePacketParamNormal();
    
    /**
     @to-do:    set normal param struct value
     @param:    param - be setting normal param struct
                from_apsn - from_guid part
                from_luid - frome_guid part
                to_apsn -  to_guid part
                to_luid -  to_guid part
                data  -  data 4 normal param struct
                dataSize - size of data (calculate 'length' with this)
     @returns:
     */
    void xai_param_normal_set(_xai_packet_param_normal* param,  XAITYPEAPSN  from_apsn,  XAITYPELUID from_luid,
                              XAITYPEAPSN to_apsn,  XAITYPELUID to_luid,  uint8_t flag,  uint16_t msgid,
                              uint16_t magic_number,  void* data,  size_t dataSize);
    
    
    
    
#ifdef __cplusplus
}
#endif

#endif
