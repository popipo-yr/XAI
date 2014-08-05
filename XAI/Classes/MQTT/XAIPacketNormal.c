//
//  XAIPacketNormal.c
//  XAI
//
//  Created by mac on 14-4-12.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#include "XAIPacketNormal.h"

_xai_packet*   generatePacketFromParamNormal(_xai_packet_param_normal* normal_param){
    
    _xai_packet*  packet = generatePacket();
    
    
    uint8_t*  payload  =  malloc(1000);
    memset(payload,0,1000);
    
    if(!payload){
        
        return NULL;
    }
    
    uint16_t big_msgid = CFSwapInt16(normal_param->msgid);
    uint16_t big_magic_number = CFSwapInt16(normal_param->magic_number);
    uint16_t big_length = CFSwapInt16(normal_param->length);
    
    void* big_from = generateSwapGUID(normal_param->from_guid);
    void* big_to  = generateSwapGUID(normal_param->to_guid);
    
    //存入固定格式
    param_to_packet_helper(payload, big_from,_XPP_N_FROM_GUID_START,_XPP_N_FROM_GUID_END);
    param_to_packet_helper(payload, big_to  ,_XPP_N_TO_GUID_START,_XPP_N_TO_GUID_END);
    
    param_to_packet_helper(payload, &normal_param->flag, _XPP_N_FLAG_START, _XPP_N_FLAG_END);
    param_to_packet_helper(payload, &big_msgid, _XPP_N_MSGID_START, _XPP_N_MSGID_END);
    param_to_packet_helper(payload, &big_magic_number, _XPP_N_MAGIC_NUMBER_START, _XPP_N_MAGIC_NUMBER_END);
    param_to_packet_helper(payload, &big_length, _XPP_N_LENGTH_START, _XPP_N_LENGTH_END);
    
    
    purgeGUID(big_from);
    purgeGUID(big_to);
    
    
    /*fixed  size  */
    packet->fix_pos = _XPPS_N_FIXED_ALL;  //固定格式位置
    unsigned int pos = _XPPS_N_FIXED_ALL;
    
    /*preload --- fixed*/
    packet->pre_load =   malloc(pos);
    memset(packet->pre_load, 0, pos);
    memcpy(packet->pre_load, payload, pos);
    
    /*allload*/
    
    if (NULL !=  normal_param->data &&  0 != normal_param->length){
        
        packet->data_load = malloc(normal_param->length);
        memset(packet->data_load, 0, normal_param->length);
        memcpy(packet->data_load, normal_param->data, normal_param->length);
        
        param_to_packet_helper(payload, normal_param->data, _XPPS_N_FIXED_ALL, _XPPS_N_FIXED_ALL+normal_param->length);
        memcpy(payload+pos, normal_param->data, normal_param->length);
        
        pos +=  normal_param->length;
        
        
    }else{
        
        packet->data_load = NULL;
        
    }
    
    
    //复制内存到all
    packet->all_load = malloc(pos);
    memset(packet->all_load, 0, pos);
    memcpy(packet->all_load,payload,pos);
    
    packet->size = pos;
    
    free(payload);
    
    return packet;
}




_xai_packet_param_normal*   generateParamNormalFromPacket(const _xai_packet*  packet){
    
    return generateParamNormalFromData(packet->all_load, packet->size);
    
}

_xai_packet_param_normal*   generateParamNormalFromData(void*  packetData,int size){
    
    
    if (size < _XPPS_N_FIXED_ALL) { //长度不够
        
        printf("XAI -  NORMAL PACKET FIXED DATA SIZE ENOUGH");
        return NULL;
    }
    
    if (packetData == NULL) {
        printf("XAI - Normal packet is null");
        return NULL;
    }
    
    
    _xai_packet_param_normal* aParam = generatePacketParamNormal();
    
    
    //读取固定格式
    packet_to_param_helper(aParam->from_guid, packetData, _XPP_N_FROM_GUID_START, _XPP_N_FROM_GUID_END);
    packet_to_param_helper(aParam->to_guid, packetData, _XPP_N_TO_GUID_START, _XPP_N_TO_GUID_END);
    packet_to_param_helper(&aParam->flag, packetData, _XPP_N_FLAG_START, _XPP_N_FLAG_END);
    packet_to_param_helper(&aParam->msgid, packetData, _XPP_N_MSGID_START, _XPP_N_MSGID_END);
    packet_to_param_helper(&aParam->magic_number, packetData, _XPP_N_MAGIC_NUMBER_START, _XPP_N_MAGIC_NUMBER_END);
    packet_to_param_helper(&aParam->length, packetData, _XPP_N_LENGTH_START, _XPP_N_LENGTH_END);
    
    void* lit_from = generateSwapGUID(aParam->from_guid);
    void* lit_to  = generateSwapGUID(aParam->to_guid);
    
    byte_data_copy(aParam->from_guid, lit_from, sizeof(aParam->from_guid), lengthOfGUID());
    byte_data_copy(aParam->to_guid, lit_to, sizeof(aParam->to_guid), lengthOfGUID());
    
    purgeGUID(lit_from);
    purgeGUID(lit_to);
    
    aParam->msgid = CFSwapInt32(aParam->msgid);
    aParam->magic_number = CFSwapInt16(aParam->magic_number);
    aParam->length = CFSwapInt16(aParam->length);
    
    if (size < _XPPS_N_FIXED_ALL + aParam->length) {
        
        purgePacketParamNormal(aParam);
        
        printf("XAI -  NORMAL PACKET UNFIXED DATA SIZE ENOUGH");
        return NULL;
    }
    
    //unfixed
    aParam->data = malloc(aParam->length);
    memset(aParam->data, 0, aParam->length);
    packet_to_param_helper(aParam->data, packetData, _XPP_N_DATA_START, _XPP_N_DATA_START+aParam->length);
    
    
    return aParam;
    
    
}

void purgePacketParamNormal(_xai_packet_param_normal* normal_param){
    
    if (NULL != normal_param) {
        if (normal_param->data != NULL) {
            free(normal_param->data);
            normal_param->data = NULL;
        }
        free(normal_param);
        normal_param = NULL;
    }
    
}


_xai_packet_param_normal*    generatePacketParamNormal(){
    
    _xai_packet_param_normal*  param = malloc(sizeof(_xai_packet_param_normal));
    memset(param, 0, sizeof(_xai_packet_param_normal));
    //memset(param->from_guid, 0, sizeof(param->from_guid));
    //memset(param->to_guid, 0, sizeof(param->to_guid));
    param->data = NULL;
    param->flag = 0;
    param->length = 0;
    param->msgid = 0;
    param->magic_number = 0;
    
    return param;
    
}

void xai_param_normal_set(_xai_packet_param_normal* normal_param,XAITYPEAPSN  from_apsn,XAITYPELUID from_luid,
                          XAITYPEAPSN to_apsn,XAITYPELUID to_luid,uint8_t flag , uint16_t msgid , uint16_t magic_number
                          ,void* data ,size_t dataSize){
    
    
    if (NULL == normal_param) {
        return;
    }
    
    
    
    void* from_guid = generateGUID(from_apsn, from_luid);
    void* to_guid = generateGUID(to_apsn , to_luid);
    
    
    byte_data_copy(normal_param->from_guid, from_guid, sizeof(normal_param->from_guid), lengthOfGUID());
    byte_data_copy(normal_param->to_guid, to_guid, sizeof(normal_param->to_guid), lengthOfGUID());
    
    purgeGUID(from_guid);
    purgeGUID(to_guid);
    
    normal_param->flag  = flag;
    normal_param->msgid = msgid;
    normal_param->magic_number = magic_number;
    normal_param->length  =   dataSize;
    
    if (NULL != normal_param->data) {
        
        free(normal_param->data);
        normal_param->data = NULL;
    }
    
    if (dataSize > 0) {
        
        normal_param->data = malloc(dataSize);
        memset(normal_param->data, 0, dataSize);
        
        byte_data_copy(normal_param->data, data, dataSize, dataSize);
    }
    
    
    
}
