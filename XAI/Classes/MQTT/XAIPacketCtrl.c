//
//  AAViewController.m
//  XAI
//
//  Created by touchhy on 14-4-3.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#include "XAIPacketCtrl.h"





_xai_packet*   generatePacketCtrl(_xai_packet_param_ctrl* ctrl_param){
    
    _xai_packet* nor_packet = generatePacketNormal(ctrl_param->normal_param);
    
    
    _xai_packet* ctrl_packet = malloc(sizeof(_xai_packet));
    
    
    char*  payload  = malloc(1000);
    memset(payload,0,1000);
    
    if(!payload){
        
        return NULL;
    }
    //拷贝 normal 固定格式
    memcpy(payload, nor_packet->pre_load, nor_packet->pos);
    
    
    //存入固定格式
    param_to_packet_helper(payload, ctrl_param->oprId,_XPP_C_OPRID_START,_XPP_C_OPRID_END);
    param_to_packet_helper(payload, ctrl_param->time, _XPP_C_TIME_START, _XPP_C_TIME_END);
    param_to_packet_helper(payload, ctrl_param->data_count, _XPP_C_DATA_COUNT_START, _XPP_C_DATA_COUNT_END);
    param_to_packet_helper(payload, ctrl_param->data_type, _XPP_C_DATA_TYPE_START, _XPP_C_DATA_TYPE_END);
    param_to_packet_helper(payload, ctrl_param->data_len, _XPP_C_DATA_LEN_START, _XPP_C_DATA_LEN_END);
    
    ctrl_packet->pre_load = malloc(_XPPS_C_FIXED_ALL);
    memcpy(ctrl_packet->pre_load, payload, _XPPS_C_FIXED_ALL);
    
    int pos =  _XPPS_C_FIXED_ALL;
    
    if (NULL != ctrl_param->data) {
        ctrl_packet->data_load = (uint8_t*)strdup(ctrl_param->data);
        
        strcpy(payload + pos, ctrl_param->data);
        pos += strlen(ctrl_param->data);
        pos += 1;
        
    }else{
        
        ctrl_packet->data_load = NULL;
    }
    
    
    
    ctrl_packet->all_load = malloc(pos);
    memcpy(ctrl_packet->all_load, payload, pos);
    
    
    free(payload);
    purgePacket(nor_packet);
    
    
    return ctrl_packet;
}
_xai_packet_param_ctrl*   generateParamCtrlFromPacket(const _xai_packet*  packet){
    
    _xai_packet_param_ctrl*  ctrl_param = malloc(sizeof(_xai_packet_param_ctrl));
    memset(ctrl_param, 0, sizeof(_xai_packet_param_ctrl));
    
    _xai_packet_param_normal*  nor_param =  generateParamNormalFromPacket(packet);
    ctrl_param->normal_param = nor_param;
    
    packet_to_param_helper((char**)&ctrl_param->oprId, packet->all_load, _XPP_C_OPRID_START, _XPP_C_OPRID_END);
    packet_to_param_helper((char**)&ctrl_param->data_count, packet->all_load, _XPP_C_DATA_COUNT_START, _XPP_C_DATA_COUNT_END);
    packet_to_param_helper((char**)&ctrl_param->data_len, packet->all_load, _XPP_C_DATA_LEN_START, _XPP_C_DATA_LEN_END);
    
    packet_to_param_helper((char**)&ctrl_param->data, packet->all_load, _XPP_C_DATA_START, _XPP_C_DATA_END);
    packet_to_param_helper((char**)&ctrl_param->time, packet->all_load, _XPP_C_TIME_START, _XPP_C_TIME_END);
    packet_to_param_helper((char**)&ctrl_param->data_type, packet->all_load, _XPP_C_DATA_TYPE_START, _XPP_C_DATA_TYPE_END);
    
    
    return ctrl_param;
    
}
void purgePacketParamCtrl(_xai_packet_param_ctrl* ctrl_param){
    
    purgePacketParamNormal(ctrl_param->normal_param);
    
    free((void*)ctrl_param->oprId);
    free((void*)ctrl_param->data_count);
    free((void*)ctrl_param->data_len);
    free((void*)ctrl_param->data);
    free((void*)ctrl_param->time);
    free((void*)ctrl_param->data_type);
    free(ctrl_param);
    
    ctrl_param = NULL;
}


