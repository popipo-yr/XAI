//
//  XAIPacketDevTypeInfo.h
//  XAI
//
//  Created by touchhy on 14-4-8.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#ifndef XAI_XAIPacketDevTypeInfo_h
#define XAI_XAIPacketDevTypeInfo_h


#include "XAIPacketNormal.h"

#ifdef __cplusplus
extern "C" {
#endif
    
    
    /*----------DEV TYPE INFO----------------*/
    
#define _XPPS_DTI_FLAG     1
#define _XPPS_DTI_VENDOR   8
#define _XPPS_DTI_MODEL  16
#define _XPPS_DTI_FIXED_ALL   (_XPPS_N_FIXED_ALL+1+8+16)
 
    
#define _XPP_DTI_FLAG_START     31
#define _XPP_DTI_FLAG_END     31
#define _XPP_DTI_VENDOR_START   32
#define _XPP_D_VENDOR_END   39
#define _XPP_DTI_MODEL_START  40
#define _XPP_DTI_MODEL_END  55
    
    
    typedef struct _xai_packet_param_dti{
        
        _xai_packet_param_normal* normal_param ; /*normal param header*/
        uint8_t  flag ;
        uint8_t  vender[8] ;
        uint8_t  model[16] ;
        
    }_xai_packet_param_dti; /*dti param struct*/
    
    
    /**
     @to-do:   generate a packet struct from dti param struct
     @param:   param - a dti param struct point
     @returns: Pointer to packet
     */
    _xai_packet*   generatePacketFromParamDTI(_xai_packet_param_dti* param);
    
    
    /**
     @to-do:   generate dti param from packet struct
     @param:   packet - a packet struct pointer
     @returns: Pointer to dti param struct
     */
    _xai_packet_param_dti*   generateParamDTIFromPacket(const _xai_packet*  packet);
    
    
    /**
     @to-do:    generate dti param from binary data
     @param:    data -  a binary data pointer
     size -  size of binary data
     @returns:  Pointer to dti param struct
     */
    _xai_packet_param_dti*   generateParamDTIFromData(void* data,  int size);
    
    
    /**
     @to-do:   generate an empty dti param struct
     @param:   void
     @returns: Pointer to dti param struct
     */
    _xai_packet_param_dti*    generatePacketParamDTI();
    
    
    /**
     @to-do:   purge an dti param
     @param:   param - a pointer to dti param struct
     @returns: void
     */
    void purgePacketParamDTI(_xai_packet_param_dti* param);
    
    
    
    
    /**
     @to-do:    set dti param struct value
     @param:    param - be setting dti param struct
                from_apsn - from_guid part
                from_luid - frome_guid part
                to_apsn -  to_guid part
                to_luid -  to_guid part
     @returns:  void
     */
    void xai_param_dti_set(_xai_packet_param_dti* param,XAITYPEAPSN  from_apsn,XAITYPELUID from_luid,
                           XAITYPEAPSN to_apsn,XAITYPELUID to_luid,
                           uint8_t flag, uint16_t msgid , uint16_t magic_number,
                           void* vender, size_t venderSize, void* model, size_t modelSize);
    

    
    
#ifdef __cplusplus
}
#endif




#endif
