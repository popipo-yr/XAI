//
//  XAIPacketStatus.m
//  XAI
//
//  Created by touchhy on 14-4-4.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#include "XAIPacketStatus.h"


_xai_packet*   generatePacketFromParamStatus(_xai_packet_param_status* status_param){
    
       if (status_param == NULL) return NULL;
    
    _xai_packet* nor_packet = generatePacketFromParamNormal(status_param->normal_param);
    
    
    _xai_packet* status_packet = generatePacket();
    
    
    char*  payload  = malloc(1000);
    memset(payload,0,1000);
    
    if(!payload){
        
        purgePacket(nor_packet);
        return NULL;
    }
    //拷贝 normal 固定格式
    memcpy(payload, nor_packet->pre_load, nor_packet->fix_pos);
    
    
    //转为大端模式
    uint32_t big_time = CFSwapInt32(status_param->time);
    void* big_trigger_guid = generateSwapGUID(status_param->trigger_guid);
    
    //存入固定格式
    param_to_packet_helper(payload, &status_param->oprId,_XPP_S_OPRID_START,_XPP_S_OPRID_END);
    param_to_packet_helper(payload, &big_time, _XPP_S_TIME_START, _XPP_S_TIME_END);
    param_to_packet_helper(payload, &status_param->data_count, _XPP_S_DATA_COUNT_START, _XPP_S_DATA_COUNT_END);
        
//    param_to_packet_helper(payload, status_param->name, _XPP_S_NAME_START, _XPP_S_NAME_END);
//    param_to_packet_helper(payload, big_trigger_guid, _XPP_S_TRIGGER_GUID_START,
//                           _XPP_S_TRIGGER_GUID_END);
    
    purgeGUID(big_trigger_guid);
    
    status_packet->pre_load = malloc(_XPPS_S_FIXED_ALL);
    memcpy(status_packet->pre_load, payload, _XPPS_S_FIXED_ALL);
    
    int pos =  _XPPS_S_FIXED_ALL;
    
    if (NULL != status_param->data) {
        
        status_packet->data_load = malloc(status_param->normal_param->length);
        memset(status_packet->data_load, 0, status_param->normal_param->length);
        
        
        _xai_packet*  data_packet = generatePacketFromParamDataList(status_param->data,
                                                                    status_param->data_count);
        
        
        if (data_packet == NULL) {
            
            free(payload);
            purgePacket(nor_packet);
            purgePacket(status_packet);
            
            return NULL;
        }
        
        memcpy(status_packet->data_load, data_packet->all_load, data_packet->size);
        
        
        param_to_packet_helper(payload, data_packet->all_load
                               , _XPPS_S_FIXED_ALL, _XPPS_S_FIXED_ALL+data_packet->size);
        
        pos +=  data_packet->size;
        
        purgePacket(data_packet);
        
    }else{
        
        status_packet->data_load = NULL;
    }
    
    
    status_packet->all_load = malloc(pos);
    memcpy(status_packet->all_load, payload, pos);
    
    status_packet->size = pos;
    
    free(payload);
    purgePacket(nor_packet);
    
    
    return status_packet;
}

_xai_packet_param_status*   generateParamStatusFromPacket(const _xai_packet*  packet){
    
    if (packet == NULL) return NULL;
    return generateParamStatusFromData(packet->all_load, packet->size);
}

_xai_packet_param_status*   generateParamStatusFromData(void*  packet_data,int size){
    
    if (size < _XPPS_S_FIXED_ALL) {
        
        printf("XAI -  STATUS PACKET FIXED DATA SIZE ENOUGH");
        return NULL;
    }
    
    _xai_packet_param_status*  status_param = generatePacketParamStatus();
    
    purgePacketParamNormal(status_param->normal_param);
    status_param->normal_param = generateParamNormalFromData(packet_data, size);
    
    if (NULL == status_param->normal_param) {
        
        purgePacketParamStatusAndData(status_param);
        printf("XAI - GENERATE STATUS PACKET PARAM ERRO");
        return NULL;
    }
    
    
    //fixed
    packet_to_param_helper(&status_param->oprId, packet_data, _XPP_S_OPRID_START, _XPP_S_OPRID_END);
    packet_to_param_helper(&status_param->time, packet_data, _XPP_S_TIME_START, _XPP_S_TIME_END);
    packet_to_param_helper(&status_param->data_count, packet_data, _XPP_S_DATA_COUNT_START, _XPP_S_DATA_COUNT_END);
    //packet_to_param_helper(status_param->name, packet_data, _XPP_S_NAME_START, _XPP_S_NAME_END);
    //param_to_packet_helper(status_param->trigger_guid, packet_data, _XPP_S_TRIGGER_GUID_START, _XPP_S_TRIGGER_GUID_END);
    
    status_param->time = CFSwapInt32(status_param->time);
    
    void* lit_trigger = generateSwapGUID(status_param->trigger_guid);
    
    byte_data_copy(status_param->trigger_guid, lit_trigger,
                   sizeof(status_param->trigger_guid), lengthOfGUID());

    
    purgeGUID(lit_trigger);

    
    
    int data_size = size - _XPPS_S_FIXED_ALL;
    void*  data = (packet_data + _XPPS_S_FIXED_ALL);
    _xai_packet_param_data* param_data = generateParamDataListFromData(data, data_size,
                                                                      status_param->data_count);
    
    
    status_param->data = param_data;
    
    
    return status_param;
}


_xai_packet_param_status*    generatePacketParamStatus(){
    
    _xai_packet_param_status*  param_status = malloc(sizeof(_xai_packet_param_status));
    memset(param_status, 0, sizeof(_xai_packet_param_status));
    
    param_status->normal_param = generatePacketParamNormal();
    param_status->data = NULL;
    param_status->data_count = 0;
    param_status->oprId = 0;
    param_status->time = 0;
    
    memset(param_status->name, 0, sizeof(param_status->name));
    memset(param_status->trigger_guid, 0, sizeof(param_status->trigger_guid));
    
    return param_status;
}


void purgePacketParamStatusAndData(_xai_packet_param_status* param){
    
    if (NULL != param) {
        
        purgePacketParamNormal(param->normal_param);
        param->normal_param = NULL;
        purgePacketParamData(param->data);
        
        free(param);
        
        param = NULL;
    }
    
}

void purgePacketParamStatusNoData(_xai_packet_param_status* param){
    
    if (NULL != param) {
        
        purgePacketParamNormal(param->normal_param);
        
        free(param);
        
        param = NULL;
    }
    
}



 _xai_packet_param_data*  getParamDataFromParamStatus(_xai_packet_param_status* param, int index){
    
    if (NULL == param) {
        
        return NULL;
    }
    
    
    return paramDataAtIndex(param->data, index);
    
}


void xai_param_status_set(_xai_packet_param_status* param,  XAITYPEAPSN  from_apsn,
                          XAITYPELUID from_luid, XAITYPEAPSN to_apsn,  XAITYPELUID to_luid,
                          uint8_t flag,  uint16_t msgid,  uint16_t magic_number, uint8_t  oprId,
                          void* name, size_t nameSize,  void* triggerGuid, size_t triggerGuidSize,
                          uint32_t  time , uint8_t  data_count,  _xai_packet_param_data* data){
    
    
    if (NULL == param) {
        return;
    }
    
    xai_param_normal_set(param->normal_param, from_apsn, from_luid, to_apsn, to_luid, flag, msgid, magic_number, NULL, 0);
    
    
    
    param->oprId = oprId;
    param->time = time;
    
    param->data_count = data_count;
    param->data = data;
    
    
    byte_data_copy(param->name, name, sizeof(param->name), nameSize);
    byte_data_copy(param->trigger_guid, triggerGuid, sizeof(param->trigger_guid), triggerGuidSize);
    
    
    size_t  dataSize = 0;
    
    for (int i = 0; i < data_count; i++) {
        
        _xai_packet_param_data* param_data = paramDataAtIndex(param->data, i);
        
        if (NULL == param_data) return;
        
        dataSize += param_data->data_len;
    }
    
    param->normal_param->length =  (_XPPS_S_FIXED_ALL - _XPPS_N_FIXED_ALL) + data_count*_XPPS_CD_FIXED_ALL + dataSize;
    
    
}

