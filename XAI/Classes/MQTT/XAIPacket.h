//
//  AAViewController.h
//  XAI
//
//  Created by touchhy on 14-4-3.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#ifndef XAI_XAIPacket_h
#define XAI_XAIPacket_h

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "XAIMQTTDEF.h"

#include <CoreFoundation/CoreFoundation.h>


/*
 packet big-endian
 param  little-endian
 */

#ifdef __cplusplus
extern "C" {
#endif
    
    
    
    
    /*------------ data----------------------*/
#define _XPP_CD_TYPE_START    0
#define _XPP_CD_TYPE_END    0
#define _XPP_CD_LEN_START 1
#define _XPP_CD_LEN_END   2
#define  _XPP_CD_DATA_START      3
#define  _XPP_CD_DATA_END        _XPP_END_UNKOWN
    
    
#define _XPPS_CD_TYPE  1
#define _XPPS_CD_DATA_LEN    2
#define _XPPS_CD_FIXED_ALL   (_XPPS_CD_TYPE+_XPPS_CD_DATA_LEN)
    
    
    typedef struct _xai_packet{
        
        uint8_t* all_load;     /*all packet binary*/
        uint8_t* pre_load;     /*fixed part packet binary*/
        unsigned int fix_pos;  /*fixed part end positon on packet binary*/
        unsigned int size;     /*size of packet binary*/
        uint8_t* data_load;    /*unfixed part packet binary*/
        
    }_xai_packet; /*packet binary struct*/
    
    
    typedef struct _xai_packet_param_data{
        
        void*   data  ; /*pointer to  binary data */
        uint8_t  data_type; /*type of data*/
        uint16_t  data_len ;  /*length of  data*/
        struct _xai_packet_param_data*  next; /*pointer to next binary data*/
        
        
    }_xai_packet_param_data; /*packer param data struct*/
    
    /**
     @to-do:generate
     @param:  void
     @returns: Pointer to a param data struct
     */
    _xai_packet_param_data*    generatePacketParamData();
    
    
    /**
     @to-do: purge a param data
     @param:   param_data - a packet param data pointer to purge
     @returns: void
     */
    void purgePacketParamData(_xai_packet_param_data* param_data);
    
    
    /**
     @to-do:  generate all param data from binary data
     @param:     data - data start address in memory
     data_size -  size of data in memory
     count -  count of param data in memory
     @returns: Pointer to a param data struct
     */
    _xai_packet_param_data*   generateParamDataListFromData(void*  data,int data_size ,int count);
    
    
    /**
     @to-do: generate a param data from binary data
     @param:    data - binary data start address
     size - size of binary data
     @returns: Pointer to a param data struct
     */
    _xai_packet_param_data*    generateParamDataOneFromData(void*  data,int size);
    
    
    /**
     @to-do: generate a param data from other if has next same copy
     @param:    param_data - other
     @returns: Pointer to a param data struct
     */
    _xai_packet_param_data* generateParamDataCopyOther(_xai_packet_param_data* param_data);
    
    
    /**
     @to-do: generate a packet from a param data  list
     @param:    param_data - a param data struct first pointer
     count - count of param data struct
     @returns: Pointer to a packet struct
     */
    _xai_packet* generatePacketFromParamDataList(_xai_packet_param_data* param_data , int count);
    
    
    /**
     @to-do: generate a packet from a param data struct
     @param:     param_data - a param data struct pointer
     @returns: Pointer to a packet struct
     */
    _xai_packet* generatePacketFromeDataOne(_xai_packet_param_data* param_data);
    
    
    
    /**
     @to-do:   find index param data in param data list
     @param:   param_data -  first param data struct pointer in param data list
     @returns: Point to a param data
     */
    _xai_packet_param_data*  paramDataAtIndex(_xai_packet_param_data* param_data, int index); //通过index获取data
    
    /**
     @to-do:    set param data value
     @param:    param - a param data pointer
                type  - param data type
                len   - param data length
                data  - param data binary 
                next  - next param data pointer
     @returns: void
     */
    void xai_param_data_set(_xai_packet_param_data* param,  XAI_DATA_TYPE type,  size_t len,
                            void* data,  _xai_packet_param_data* next);
    
    
    /**
     @to-do: generate an empty packet
     @param: void
     @returns: Pointer to generate packet
     */
    _xai_packet* generatePacket(void);
    
    
    /**
     @to-do:   purge am packet
     @param:   packet - a packet pointer
     @returns: void
     */
    void purgePacket(_xai_packet* packet);
    
    
    /**
     @to-do:   swap a unsigned data
     @param : to -  swap data's address
              size - swap data's size
     @return: void
     */
    void SwapBytes(void* to, size_t size);
    
    /**
     @to-do:   generate guid from apsn and luid
     @param:   apsn - APSN
     luid - local unique identify
     @returns: a 8 bytes guid
     */
    void* generateGUID(XAITYPEAPSN apsn,XAITYPELUID luid);
    
    
    /**
     @to-do:
     @param:   apsn - APSN
     luid - local unique identify
     @returns:
     */
    bool GUIDToApsnAndLuid(XAITYPEAPSN* apsn,XAITYPELUID* luid,void* guid,size_t size);
    
    /**
     @to-do:   swap guid bytes－sequence （Little-endian Big-endian）
     @param:   guid -  pointer to guid binary
     @returns: Pointer to swap end guid binary
     */
    void* generateSwapGUID(void* guid);
    
    /**
     @to-do:   pruge guid
     @param:   guid - pointer to guid binary
     @returns: void
     */
    void purgeGUID(void* guid);
    
    /**
     @to-do:   length of guid binary
     @param:   void
     @returns: size of guid
     */
    size_t lengthOfGUID();
    
    
    /**
     @to-do:   write  to packet from data
     @param:    to  - write to packet binary address
     from - write from data binary addree
     start - write to packet binarty  start address
     end - write to  packet binary  end address
     @returns:  void
     */
    void param_to_packet_helper(void* to , void* from, int start, int end);
    
    
    /**
     @to-do:   write to data  frome packet
     @param:    to _ write to data binary address
     from - write from packet binary address
     start - write to data binary start address
     end - write to data binary end address
     @returns:
     */
    void packet_to_param_helper(void* to , void* from ,int start,int end);
    
    /**
     @to-do:   copy binary data (not malloc memory)
     @param:    to - copy to address
     from - copy from address
     toSize - size of to binary data
     fromSize - size of from binary data
     @returns: void
     */
    void byte_data_copy(void* to, const void* from, int toSize,int fromSize);
    
    /**
     @to-do:   set binary data (will malloc memory)
     @param:    to - set binary data address pointer
     from - from binary data address
     size - size of from binary
     @returns: void
     */
    void byte_data_set(void** to, const void* from, int size); //将产生内存分配
    
    
    
    
#ifdef __cplusplus
}
#endif


#endif
