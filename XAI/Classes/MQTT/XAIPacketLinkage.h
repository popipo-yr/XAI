//
//  XAIPacketLinkage.h
//  XAI
//
//  Created by office on 14-6-4.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#ifndef XAI_XAIPacketLinkage_h
#define XAI_XAIPacketLinkage_h

/*
 packet big-endian
 param  little-endian
 */

#ifdef __cplusplus
extern "C" {
#endif
    
    #include "XAIPacket.h"
    
    
    /*size*/
#define  _XPPS_L_GUID  12
#define  _XPPS_L_ID    1
#define  _XPPS_L_CONDITION    1
#define  _XPPS_L_FIXED_ALL  (_XPPS_L_GUID+_XPPS_L_ID+_XPPS_L_CONDITION)

#define  _XPP_L_GUID_START  0
#define  _XPP_L_GUID_END  11
#define  _XPP_L_ID_START   12
#define  _XPP_L_ID_END    12
#define  _XPP_L_CONDITION_START    13
#define  _XPP_L_CONDITION_END      13
#define  _XPP_L_DATA_START      14
#define  _XPP_L_DATA_END        _XPP_END_UNKOWN
    
    
    
    typedef struct _xai_packet_param_linkage{
        
        uint8_t guid[12] ;  /*设备的guid*/
        uint8_t some_id ;   /*设备控制,状态id*/
        uint8_t condition;  /*条件*/
        _xai_packet_param_data*  data; /*数据 最多一个数据z*/
        
        uint16_t  _length; /*不会写入packet,程序使用*/
        
        
    }_xai_packet_param_linkage;  /*linkage packet param*/
    
    
    /**
     @to-do:   generate a packet struct from linkage param struct
     @param:   param - a linkage param struct pointer
     @returns: Pointer to binary packet
     */
    _xai_packet*   generatePacketFromParamLinkage(_xai_packet_param_linkage* param);
    
    
    /**
     @to-do:   generate Linkage param struct from packet struct
     @param:   packet - a  packet pointer
     @returns: Pointer to a param Linkage struct
     */
    _xai_packet_param_linkage*   generateParamLinkageFromPacket(const _xai_packet*  packet);
    
    /**
     @to-do:    generate Linkage param struct from binary data
     @param:    data - a binary data pointer
     size - binary data size
     @returns: Point to a param Linkage struct
     */
    _xai_packet_param_linkage*   generateParamLinkageFromData(void*  data,int  size);
    
    
    /**
     @to-do:   purge a Linkage param struct
     @param:   param -  a noraml param pointer
     @returns: void
     */
    void purgePacketParamLinkage(_xai_packet_param_linkage* param);
    
    
    /**
     @to-do:   generate an empty Linkage param struct
     @param:   void
     @returns: Pointer to a param Linkage struct
     */
    _xai_packet_param_linkage*    generatePacketParamLinkage();
    
    /**
     @to-do:    set Linkage param struct value
     @param:    param - be setting Linkage param struct
     @returns:
     */
    void xai_param_Linkage_set(_xai_packet_param_linkage* param,  XAITYPEAPSN  apsn,  XAITYPELUID luid,
                               uint8_t some_id,  uint8_t condition, _xai_packet_param_data* param_data);
    
    
    

    


#ifdef __cplusplus
}
#endif


#endif
