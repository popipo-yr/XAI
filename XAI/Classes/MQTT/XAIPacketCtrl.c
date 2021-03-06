//
//  AAViewController.m
//  XAI
//
//  Created by touchhy on 14-4-3.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#include "XAIPacketCtrl.h"





_xai_packet*   generatePacketFromParamCtrl(_xai_packet_param_ctrl* ctrl_param){
    
    if (ctrl_param == NULL) return NULL;
    
    _xai_packet* nor_packet = generatePacketFromParamNormal(ctrl_param->normal_param);
    
    
    _xai_packet* ctrl_packet = generatePacket();
    
    
    char*  payload  = malloc(1000);
    memset(payload,0,1000);
    
    if(!payload){
        
        purgePacket(nor_packet);
        free(payload);
        return NULL;
    }
    //拷贝 normal 固定格式
    memcpy(payload, nor_packet->pre_load, nor_packet->fix_pos);
    
    //转为大端模式
    uint32_t big_time = CFSwapInt32(ctrl_param->time);
    
    //存入固定格式
    param_to_packet_helper(payload, &ctrl_param->oprId,_XPP_C_OPRID_START,_XPP_C_OPRID_END);
    param_to_packet_helper(payload, &big_time, _XPP_C_TIME_START, _XPP_C_TIME_END);
    param_to_packet_helper(payload, &ctrl_param->data_count, _XPP_C_DATA_COUNT_START, _XPP_C_DATA_COUNT_END);

    
    ctrl_packet->pre_load = malloc(_XPPS_C_FIXED_ALL);
    memcpy(ctrl_packet->pre_load, payload, _XPPS_C_FIXED_ALL);
    
    int pos =  _XPPS_C_FIXED_ALL;
    
    if (NULL != ctrl_param->data) {
        
        ctrl_packet->data_load = malloc(ctrl_param->normal_param->length);
        memset(ctrl_packet->data_load, 0, ctrl_param->normal_param->length);
        
        
        _xai_packet*  data_packet = generatePacketFromParamDataList(ctrl_param->data, ctrl_param->data_count);
        
        if (data_packet == NULL) {
            
            free(payload);
            purgePacket(nor_packet);
            purgePacket(ctrl_packet);
            
            return NULL;
        }
        
        memcpy(ctrl_packet->data_load, data_packet->all_load, data_packet->size);
        
        
        param_to_packet_helper(payload, data_packet->all_load
                               , _XPPS_C_FIXED_ALL, _XPPS_C_FIXED_ALL+data_packet->size);
        
        pos +=  data_packet->size;
        
        purgePacket(data_packet);
        
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
    
    if (packet == NULL) return NULL;
    return generateParamCtrlFromData(packet->all_load, packet->size);
}

_xai_packet_param_ctrl*   generateParamCtrlFromData(void*  packet_data,int size){
    
    if (size < _XPPS_C_FIXED_ALL) {
        
        printf("XAI -  CTRL PACKET FIXED DATA SIZE ENOUGH");
        return NULL;
    }
    
    _xai_packet_param_ctrl*  ctrl_param = generatePacketParamCtrl();
    
    purgePacketParamNormal(ctrl_param->normal_param);
    ctrl_param->normal_param = generateParamNormalFromData(packet_data, size);
    
    if (NULL == ctrl_param->normal_param) {
        
        purgePacketParamCtrlAndData(ctrl_param);
        printf("XAI - GENERATE CTRL PACKET PARAM ERRO");
        return NULL;
    }
    
    
    //fixed
    packet_to_param_helper(&ctrl_param->oprId, packet_data, _XPP_C_OPRID_START, _XPP_C_OPRID_END);
    packet_to_param_helper(&ctrl_param->time, packet_data, _XPP_C_TIME_START, _XPP_C_TIME_END);
    packet_to_param_helper(&ctrl_param->data_count, packet_data, _XPP_C_DATA_COUNT_START, _XPP_C_DATA_COUNT_END);
    
    
    //little endian
    ctrl_param->time = CFSwapInt16(ctrl_param->time);
    
    //unfixed
    
    int data_size = size - _XPPS_C_FIXED_ALL;
    void*  data = (packet_data + _XPPS_C_FIXED_ALL);
    _xai_packet_param_data* ctrl_data = generateParamDataListFromData(data, data_size,ctrl_param->data_count);

    
    ctrl_param->data = ctrl_data;
    
    
    return ctrl_param;
    
}


void purgePacketParamCtrlAndData(_xai_packet_param_ctrl* ctrl_param){
    
    if (NULL != ctrl_param) {
        
        purgePacketParamNormal(ctrl_param->normal_param);
        
        
        purgePacketParamData(ctrl_param->data);
        
        free(ctrl_param);
        
        ctrl_param = NULL;
    }
    
}

void purgePacketParamCtrlNoData(_xai_packet_param_ctrl* ctrl_param){
    
    if (NULL != ctrl_param) {
        
        purgePacketParamNormal(ctrl_param->normal_param);
        
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
    param_ctrl->oprId = 0;
    param_ctrl->time = 0;
    
    return param_ctrl;
}


_xai_packet_param_data*  getParamDataFromParamCtrl(_xai_packet_param_ctrl* ctrl_param, int index){

    if (NULL == ctrl_param) {
        
        return NULL;
    }
    

    
    return paramDataAtIndex(ctrl_param->data, index);

}


void xai_param_ctrl_set(_xai_packet_param_ctrl* param_ctrl,XAITYPEAPSN  from_apsn,XAITYPELUID from_luid,
                        XAITYPEAPSN to_apsn,XAITYPELUID to_luid,
                        uint8_t flag , uint16_t msgid , uint16_t magic_number, uint8_t oprId, uint32_t time, uint8_t data_count , _xai_packet_param_data* data){

    if (NULL == param_ctrl) {
        return;
    }
    
    xai_param_normal_set(param_ctrl->normal_param, from_apsn, from_luid, to_apsn, to_luid, flag, msgid, magic_number, NULL, 0);
    
    
    
    param_ctrl->oprId = oprId;
    param_ctrl->time = time;
    
    param_ctrl->data_count = data_count;
    param_ctrl->data = data;
    
    size_t  dataSize = 0;
    
    for (int i = 0; i < data_count; i++) {
        
        _xai_packet_param_data* ctrl_data = paramDataAtIndex(param_ctrl->data, i);
        
        if (NULL == ctrl_data) return;
        
        dataSize += ctrl_data->data_len;
    }
    
    param_ctrl->normal_param->length =  (_XPPS_C_FIXED_ALL - _XPPS_N_FIXED_ALL) + data_count*_XPPS_CD_FIXED_ALL + dataSize;


}

