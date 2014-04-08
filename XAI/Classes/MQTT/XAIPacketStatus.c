//
//  XAIPacketStatus.m
//  XAI
//
//  Created by touchhy on 14-4-4.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#include "XAIPacketStatus.h"


_xai_packet*   generatePacketStatus(_xai_packet_param_status* status_param){
    
    _xai_packet* nor_packet = generatePacketNormal(status_param->normal_param);
    
    
    _xai_packet* status_packet = malloc(sizeof(_xai_packet));
    
    
    char*  payload  = malloc(1000);
    memset(payload,0,1000);
    
    if(!payload){
        
        purgePacket(nor_packet);
        return NULL;
    }
    //拷贝 normal 固定格式
    memcpy(payload, nor_packet->pre_load, nor_packet->fix_pos);
    
    
    //存入固定格式
    param_to_packet_helper(payload, &status_param->oprId,_XPP_S_OPRID_START,_XPP_S_OPRID_END);
    param_to_packet_helper(payload, &status_param->time, _XPP_S_TIME_START, _XPP_S_TIME_END);
    param_to_packet_helper(payload, &status_param->data_count, _XPP_S_DATA_COUNT_START, _XPP_S_DATA_COUNT_END);
    param_to_packet_helper(payload, &status_param->data_type, _XPP_S_DATA_TYPE_START, _XPP_S_DATA_TYPE_END);
    param_to_packet_helper(payload, &status_param->data_len, _XPP_S_DATA_LEN_START, _XPP_S_DATA_LEN_END);
    
    param_to_packet_helper(payload, status_param->name, _XPP_S_NAME_START, _XPP_S_NAME_END);
    param_to_packet_helper(payload, status_param->trigger_guid, _XPP_S_TRIGGER_GUID_START, _XPP_S_TRIGGER_GUID_END);
    
    status_packet->pre_load = malloc(_XPPS_S_FIXED_ALL);
    memcpy(status_packet->pre_load, payload, _XPPS_S_FIXED_ALL);
    
    int pos =  _XPPS_S_FIXED_ALL;
    
    if (NULL != status_param->data) {
        
        status_packet->data_load = malloc(status_param->data_len);
        memset(status_packet->data_load, 0, status_param->data_len);
        memcpy(status_packet->data_load, status_param->data, status_param->data_len);
        
        param_to_packet_helper(payload, status_param->data, _XPPS_S_FIXED_ALL, _XPPS_S_FIXED_ALL+status_param->data_len);
        memcpy(payload+pos, status_param->data, status_param->data_len);
        
        pos +=  status_param->data_len;
        
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
    
    return generateParamStatusFromPacketData(packet->all_load, packet->size);
}

_xai_packet_param_status*   generateParamStatusFromPacketData(void*  packet_data,int size){
    
    if (size < _XPPS_S_FIXED_ALL) {
        
        printf("XAI -  STATUS PACKET FIXED DATA SIZE ENOUGH");
        return NULL;
    }
    
    _xai_packet_param_status*  status_param = generatePacketParamStatus();
    
    purgePacketParamNormal(status_param->normal_param);
    status_param->normal_param = generateParamNormalFromPacketData(packet_data, size);
    
    if (NULL == status_param->normal_param) {
        
        purgePacketParamStatus(status_param);
        printf("XAI - GENERATE STATUS PACKET PARAM ERRO");
        return NULL;
    }
    
    
    //fixed
    packet_to_param_helper(&status_param->oprId, packet_data, _XPP_S_OPRID_START, _XPP_S_OPRID_END);
    packet_to_param_helper(&status_param->time, packet_data, _XPP_S_TIME_START, _XPP_S_TIME_END);
    packet_to_param_helper(&status_param->data_type, packet_data, _XPP_S_DATA_TYPE_START, _XPP_S_DATA_TYPE_END);
    packet_to_param_helper(&status_param->data_count, packet_data, _XPP_S_DATA_COUNT_START, _XPP_S_DATA_COUNT_END);
    packet_to_param_helper(&status_param->data_len, packet_data, _XPP_S_DATA_LEN_START, _XPP_S_DATA_LEN_END);
    
    packet_to_param_helper(status_param->name, packet_data, _XPP_S_NAME_START, _XPP_S_NAME_END);
    param_to_packet_helper(status_param->trigger_guid, packet_data, _XPP_S_TRIGGER_GUID_START, _XPP_S_TRIGGER_GUID_END);
    
    
    if (size < _XPPS_S_FIXED_ALL + status_param->data_len) {
        
        purgePacketParamStatus(status_param);
        printf("XAI -  CTRL PACKET UNFIXED DATA SIZE ENOUGH");
        return NULL;
    }
    
    //unfixed
    status_param->data = malloc(status_param->data_len);
    memset(status_param->data, 0, status_param->data_len);
    packet_to_param_helper(status_param->data, packet_data, _XPP_S_DATA_START, _XPP_S_DATA_START+status_param->data_len);
    
    
    return status_param;
    
}


void purgePacketParamStatus(_xai_packet_param_status* status_param){
    
    if (NULL != status_param) {
        purgePacketParamNormal(status_param->normal_param);
        
        free(status_param->data);
        free(status_param);
        
        status_param = NULL;
    }
    
}

_xai_packet_param_status*    generatePacketParamStatus(){
    
    _xai_packet_param_status*  param_status = malloc(sizeof(_xai_packet_param_status));
    memset(param_status, 0, sizeof(_xai_packet_param_status));
    
    param_status->normal_param = generatePacketParamNormal();
    param_status->data = NULL;
    param_status->data_count = 0;
    param_status->data_len = 0;
    param_status->data_type = 0;
    param_status->oprId = 0;
    param_status->time = 0;
    
    memset(param_status->name, 0, sizeof(param_status->name));
    memset(param_status->trigger_guid, 0, sizeof(param_status->trigger_guid));
    
    return param_status;
}
