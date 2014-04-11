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
        free(payload);
        return NULL;
    }
    //拷贝 normal 固定格式
    memcpy(payload, nor_packet->pre_load, nor_packet->fix_pos);
    
    
    //存入固定格式
    param_to_packet_helper(payload, &ctrl_param->oprId,_XPP_C_OPRID_START,_XPP_C_OPRID_END);
    param_to_packet_helper(payload, &ctrl_param->time, _XPP_C_TIME_START, _XPP_C_TIME_END);
    param_to_packet_helper(payload, &ctrl_param->data_count, _XPP_C_DATA_COUNT_START, _XPP_C_DATA_COUNT_END);
    //param_to_packet_helper(payload, &ctrl_param->data_type, _XPP_C_DATA_TYPE_START, _XPP_C_DATA_TYPE_END);
    //param_to_packet_helper(payload, &ctrl_param->data_len, _XPP_C_DATA_LEN_START, _XPP_C_DATA_LEN_END);
    
    ctrl_packet->pre_load = malloc(_XPPS_C_FIXED_ALL);
    memcpy(ctrl_packet->pre_load, payload, _XPPS_C_FIXED_ALL);
    
    int pos =  _XPPS_C_FIXED_ALL;
    
    if (NULL != ctrl_param->data) {
        
        ctrl_packet->data_load = malloc(ctrl_param->normal_param->length);
        memset(ctrl_packet->data_load, 0, ctrl_param->normal_param->length);
        
        
        _xai_packet*  data_packet = generatePacketCtrlData(ctrl_param->data, ctrl_param->data_count);
        
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
        
        purgePacketParamCtrlAndData(ctrl_param);
        printf("XAI - GENERATE CTRL PACKET PARAM ERRO");
        return NULL;
    }
    
    
    //fixed
    packet_to_param_helper(&ctrl_param->oprId, packet_data, _XPP_C_OPRID_START, _XPP_C_OPRID_END);
    packet_to_param_helper(&ctrl_param->time, packet_data, _XPP_C_TIME_START, _XPP_C_TIME_END);
    packet_to_param_helper(&ctrl_param->data_count, packet_data, _XPP_C_DATA_COUNT_START, _XPP_C_DATA_COUNT_END);
    
    //unfixed
    
    int data_size = size - _XPPS_C_FIXED_ALL;
    void*  data = (packet_data + _XPPS_C_FIXED_ALL);
    _xai_packet_param_ctrl_data* ctrl_data = generateParamCtrlDataFromPacketData(data, data_size,ctrl_param->data_count);

    
    ctrl_param->data = ctrl_data;
    
    
    return ctrl_param;
    
}


void purgePacketParamCtrlAndData(_xai_packet_param_ctrl* ctrl_param){
    
    if (NULL != ctrl_param) {
        
        purgePacketParamNormal(ctrl_param->normal_param);
        
        
        purgePacketParamCtrlData(ctrl_param->data);
        
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
    //param_ctrl->data_len = 0;
    //param_ctrl->data_type = 0;
    param_ctrl->oprId = 0;
    param_ctrl->time = 0;
    
    return param_ctrl;
}

//生成一个数据段
_xai_packet_param_ctrl_data*    generatePacketParamCtrlData(){
    
    _xai_packet_param_ctrl_data*  param_ctrl_data = malloc(sizeof(_xai_packet_param_ctrl_data));
    memset(param_ctrl_data, 0, sizeof(_xai_packet_param_ctrl_data));
    
    
    param_ctrl_data->data_type = 0;
    param_ctrl_data->data_len = 0;
    param_ctrl_data->data = NULL;
    param_ctrl_data->next = NULL;

    return param_ctrl_data;

}
void purgePacketParamCtrlData(_xai_packet_param_ctrl_data* ctrl_param_data){

    if (NULL != ctrl_param_data) {
        
        purgePacketParamCtrlData(ctrl_param_data->next);
        
        free(ctrl_param_data->data);
        free(ctrl_param_data);
        
        ctrl_param_data = NULL;
    }

}
_xai_packet_param_ctrl_data*   generateParamCtrlDataFromPacketData(void*  data,int data_size ,int count){

    
    void* cur_data = data;
    int  cur_data_size = data_size;
    
    _xai_packet_param_ctrl_data* begin_ctrl_data = NULL;
    _xai_packet_param_ctrl_data* cur_ctr_data = NULL;
    
    for (int i = 0; i < count; i++) {
        
        _xai_packet_param_ctrl_data*  a_data = generateParamCtrlDataFromPacketDataOne(cur_data, cur_data_size);
        
        if (NULL == a_data) {

            purgePacketParamCtrlData(begin_ctrl_data);
            printf("XAI -  CTRL DATA ERRO");
            return NULL;
        }
        
        if (i == 0) {
            begin_ctrl_data = a_data;
            
        }else{
            
            cur_ctr_data->next = a_data;
        }
        
        cur_data = cur_data + a_data->data_len;
        cur_data_size = cur_data_size - a_data->data_len;
        cur_data =  a_data;
    }

    
    return begin_ctrl_data;

}

_xai_packet_param_ctrl_data*    generateParamCtrlDataFromPacketDataOne(void*  data,int size){

    if (size < _XPPS_CD_FIXED_ALL) {
        
        printf("XAI -  CTRL DATA FIXED DATA SIZE ENOUGH");
        return NULL;
    }
    
    _xai_packet_param_ctrl_data*  ctrl_param_data = generatePacketParamCtrlData();
    
    
    //fixed
    packet_to_param_helper(&ctrl_param_data->data_type, data, _XPP_CD_TYPE_START, _XPP_CD_TYPE_END);
    packet_to_param_helper(&ctrl_param_data->data_len, data, _XPP_CD_LEN_START, _XPP_CD_LEN_END);
    
    if (size < _XPPS_CD_FIXED_ALL + ctrl_param_data->data_len) {
        
        purgePacketParamCtrlData(ctrl_param_data);
        printf("XAI -  CTRL DATA UNFIXED DATA SIZE ENOUGH");
        return NULL;
    }
    
    //unfixed
    ctrl_param_data->data = malloc(ctrl_param_data->data_len);
    memset(ctrl_param_data->data, 0, ctrl_param_data->data_len);
    packet_to_param_helper(ctrl_param_data->data, data, _XPP_CD_DATA_START, _XPP_CD_DATA_START+ctrl_param_data->data_len);
    
    
    return ctrl_param_data;
}

_xai_packet* generatePacketCtrlDataOne(_xai_packet_param_ctrl_data* ctrl_param_data){

    
    
    _xai_packet* ctrl_data = malloc(sizeof(_xai_packet));
    
    
    char*  payload  = malloc(1000);
    memset(payload,0,1000);
    
    if(!payload){

        return NULL;
    }
    
    
    //存入固定格式
    param_to_packet_helper(payload, &ctrl_param_data->data_type, _XPP_CD_TYPE_START, _XPP_CD_TYPE_END);
    param_to_packet_helper(payload, &ctrl_param_data->data_len, _XPP_CD_LEN_START, _XPP_CD_LEN_END);
    
    ctrl_data->pre_load = malloc(_XPPS_CD_FIXED_ALL);
    memcpy(ctrl_data->pre_load, payload, _XPPS_CD_FIXED_ALL);
    
    int pos =  _XPPS_CD_FIXED_ALL;
    
    if (NULL != ctrl_param_data->data) {
        
        ctrl_data->data_load = malloc(ctrl_param_data->data_len);
        memset(ctrl_data->data_load, 0, ctrl_param_data->data_len);
        memcpy(ctrl_data->data_load, ctrl_param_data->data, ctrl_param_data->data_len);
        
        param_to_packet_helper(payload, ctrl_param_data->data, _XPPS_CD_FIXED_ALL
                               , _XPPS_CD_FIXED_ALL+ctrl_param_data->data_len);
        
        memcpy(payload+pos, ctrl_param_data->data, ctrl_param_data->data_len);
        
        pos +=  ctrl_param_data->data_len;
        
    }else{
        
        ctrl_data->data_load = NULL;
    }
    
    
    
    ctrl_data->all_load = malloc(pos);
    memcpy(ctrl_data->all_load, payload, pos);
    
    ctrl_data->size = pos;
    
    free(payload);
    
    
    return ctrl_data;


}


//数据段转为data
_xai_packet* generatePacketCtrlData(_xai_packet_param_ctrl_data* ctrl_param_data , int count){

    _xai_packet*  packet = malloc(sizeof(_xai_packet));
    memset(packet, 0, sizeof(_xai_packet));
    
    void* data_load = malloc(1000);
    memset(data_load, 0, 1000);
    
    int  dataPos = 0;
    
    for (int i = 0; i < count; i++) {
        
        _xai_packet_param_ctrl_data* ctrl_data = getCtrlData(ctrl_param_data, i);
        if (NULL ==  ctrl_data) {
            
            free(data_load);
            
            printf("CTRL  DATA NULL");
            return NULL;
        }
        
        _xai_packet*  ctrl_data_packet = generatePacketCtrlDataOne(ctrl_data);
        
        memcpy(data_load + dataPos, ctrl_data_packet->all_load, ctrl_data_packet->size);
        
        dataPos += ctrl_data_packet->size;
        
        purgePacket(ctrl_data_packet);
    }
    
    
    //param_to_packet_helper(data_load, ctrl_packet->data_load, _XPPS_C_FIXED_ALL, _XPPS_C_FIXED_ALL+dataPos);
    //memcpy(payload+pos, ctrl_packet->data_load, dataPos);
    
    //pos +=  dataPos;
    
    packet->all_load = data_load;
    packet->size = dataPos;

    return packet;

}

_xai_packet_param_ctrl_data*  getCtrlDataFrom(_xai_packet_param_ctrl* ctrl_param, int index){

    if (NULL == ctrl_param) {
        
        return NULL;
    }
    

    
    return getCtrlData(ctrl_param->data, index);

}

_xai_packet_param_ctrl_data*  getCtrlData(_xai_packet_param_ctrl_data* ctrl_param_data, int index){


    if ( 0 >index || NULL == ctrl_param_data ) {
        
        return NULL;
    }
    
    _xai_packet_param_ctrl_data* cur_data =  ctrl_param_data;
    
    for (int cur = 0; cur < index; cur++) {
        
        if (NULL == cur_data->next) {
            
            return NULL;
        }
        
        cur_data = cur_data->next;
        
    }
    
    return cur_data;

}

void xai_param_ctrl_data_set(_xai_packet_param_ctrl_data* ctrlData ,XAI_DATA_TYPE type , size_t len , void* data,
                             _xai_packet_param_ctrl_data* next){

    if (NULL ==  ctrlData) {
        return;
    }
    
    ctrlData->data_len = CFSwapInt16(len);
    ctrlData->data_type = type;
    byte_data_set(&ctrlData->data, data, len);
    
    ctrlData->next = next;
    
}

void xai_param_ctrl_set(_xai_packet_param_ctrl* param_ctrl,XAITYPEAPSN  from_apsn,XAITYPELUID from_luid,
                        XAITYPEAPSN to_apsn,XAITYPELUID to_luid,
                        uint8_t flag , uint16_t msgid , uint16_t magic_number, uint8_t oprId, uint32_t time, uint8_t data_count , _xai_packet_param_ctrl_data* data){

    if (NULL == param_ctrl) {
        return;
    }
    
    xai_param_normal_set(param_ctrl->normal_param, from_apsn, from_luid, to_apsn, to_luid, flag, msgid, magic_number, NULL, 0);
    
    
    
    param_ctrl->oprId = oprId;
    param_ctrl->time = CFSwapInt16(time);
    
    param_ctrl->data_count = data_count;
    param_ctrl->data = data;
    
    size_t  dataSize = 0;
    
    for (int i = 0; i < data_count; i++) {
        
        _xai_packet_param_ctrl_data* ctrl_data = getCtrlData(param_ctrl->data, 0);
        
        if (NULL == ctrl_data) return;
        
        dataSize += ctrl_data->data_len;
    }
    
    param_ctrl->normal_param->length =  CFSwapInt16HostToBig(data_count*_XPPS_CD_FIXED_ALL + dataSize);


}

