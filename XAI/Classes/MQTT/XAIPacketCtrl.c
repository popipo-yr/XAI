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
        
        purgePacket(nor_packet);
        return NULL;
    }
    //拷贝 normal 固定格式
    memcpy(payload, nor_packet->pre_load, nor_packet->fix_pos);
    
    
    //存入固定格式
    param_to_packet_helper(payload, &ctrl_param->oprId,_XPP_C_OPRID_START,_XPP_C_OPRID_END);
    param_to_packet_helper(payload, &ctrl_param->time, _XPP_C_TIME_START, _XPP_C_TIME_END);
    param_to_packet_helper(payload, &ctrl_param->data_count, _XPP_C_DATA_COUNT_START, _XPP_C_DATA_COUNT_END);
    param_to_packet_helper(payload, &ctrl_param->data_type, _XPP_C_DATA_TYPE_START, _XPP_C_DATA_TYPE_END);
    param_to_packet_helper(payload, &ctrl_param->data_len, _XPP_C_DATA_LEN_START, _XPP_C_DATA_LEN_END);
    
    ctrl_packet->pre_load = malloc(_XPPS_C_FIXED_ALL);
    memcpy(ctrl_packet->pre_load, payload, _XPPS_C_FIXED_ALL);
    
    int pos =  _XPPS_C_FIXED_ALL;
    
    if (NULL != ctrl_param->data) {
        
        ctrl_packet->data_load = malloc(ctrl_param->data_len);
        memset(ctrl_packet->data_load, 0, ctrl_param->data_len);
        memcpy(ctrl_packet->data_load, ctrl_param->data, ctrl_param->data_len);
        
        param_to_packet_helper(payload, ctrl_param->data, _XPPS_C_FIXED_ALL, _XPPS_C_FIXED_ALL+ctrl_param->data_len);
        memcpy(payload+pos, ctrl_param->data, ctrl_param->data_len);
        
        pos +=  ctrl_param->data_len;
        
    }else{
        
        ctrl_packet->data_load = NULL;
    }
    
    
    
    ctrl_packet->all_load = malloc(pos);
    memcpy(ctrl_packet->all_load, payload, pos);
    
    ctrl_packet->size = pos;
    
    free(payload);
    purgePacket(nor_packet);
    
    
    return ctrl_packet;
}
_xai_packet_param_ctrl*   generateParamCtrlFromPacket(const _xai_packet*  packet){
    
    return generateParamCtrlFromPacketData(packet->all_load, packet->size);
}

_xai_packet_param_ctrl*   generateParamCtrlFromPacketData(void*  packet_data,int size){
    
    if (size < _XPPS_C_FIXED_ALL) {
        
        printf("XAI -  CTRL PACKET FIXED DATA SIZE ENOUGH");
        return NULL;
    }
    
    _xai_packet_param_ctrl*  ctrl_param = generatePacketParamCtrl();
    
    purgePacketParamNormal(ctrl_param->normal_param);
    ctrl_param->normal_param = generateParamNormalFromPacketData(packet_data, size);
    
    if (NULL == ctrl_param->normal_param) {
        
        purgePacketParamCtrl(ctrl_param);
        printf("XAI - GENERATE CTRL PACKET PARAM ERRO");
        return NULL;
    }
    
    
    //fixed
    packet_to_param_helper(&ctrl_param->oprId, packet_data, _XPP_C_OPRID_START, _XPP_C_OPRID_END);
    packet_to_param_helper(&ctrl_param->time, packet_data, _XPP_C_TIME_START, _XPP_C_TIME_END);
    packet_to_param_helper(&ctrl_param->data_type, packet_data, _XPP_C_DATA_TYPE_START, _XPP_C_DATA_TYPE_END);
    packet_to_param_helper(&ctrl_param->data_count, packet_data, _XPP_C_DATA_COUNT_START, _XPP_C_DATA_COUNT_END);
    packet_to_param_helper(&ctrl_param->data_len, packet_data, _XPP_C_DATA_LEN_START, _XPP_C_DATA_LEN_END);
    
    if (size < _XPPS_C_FIXED_ALL + ctrl_param->data_len) {
        
        purgePacketParamCtrl(ctrl_param);
        printf("XAI -  CTRL PACKET UNFIXED DATA SIZE ENOUGH");
        return NULL;
    }
    
    //unfixed
    ctrl_param->data = malloc(ctrl_param->data_len);
    memset(ctrl_param->data, 0, ctrl_param->data_len);
    packet_to_param_helper(ctrl_param->data, packet_data, _XPP_C_DATA_START, _XPP_C_DATA_START+ctrl_param->data_len);
    
    
    return ctrl_param;
    
}


void purgePacketParamCtrl(_xai_packet_param_ctrl* ctrl_param){
    
    if (NULL != ctrl_param) {
        
        purgePacketParamNormal(ctrl_param->normal_param);
        
        free(ctrl_param->data);
        free(ctrl_param);
        
        ctrl_param = NULL;
    }
    
}

_xai_packet_param_ctrl*    generatePacketParamCtrl(){
    
    _xai_packet_param_ctrl*  param_ctrl = malloc(sizeof(_xai_packet_param_ctrl));
    memset(param_ctrl, 0, sizeof(_xai_packet_param_ctrl));
    
    param_ctrl->normal_param = generatePacketParamNormal();
    param_ctrl->data = NULL;
    param_ctrl->data_count = 0;
    param_ctrl->data_len = 0;
    param_ctrl->data_type = 0;
    param_ctrl->oprId = 0;
    param_ctrl->time = 0;
    
    return param_ctrl;
}

