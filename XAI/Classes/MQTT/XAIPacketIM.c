//
//  AAViewController.m
//  XAI
//
//  Created by touchhy on 14-4-3.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#include "XAIPacketIM.h"





_xai_packet*   generatePacketFromParamIM(_xai_packet_param_IM* IM_param){
    
    if (IM_param == NULL) return NULL;
    
    _xai_packet* nor_packet = generatePacketFromParamNormal(IM_param->normal_param);
    
    
    _xai_packet* IM_packet = generatePacket();
    
    
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
    uint32_t big_time = CFSwapInt32(IM_param->time);
    
    //存入固定格式
    param_to_packet_helper(payload, &big_time, _XPP_IM_TIME_START, _XPP_IM_TIME_END);
    param_to_packet_helper(payload, &IM_param->data_count, _XPP_IM_DATA_COUNT_START, _XPP_IM_DATA_COUNT_END);

    
    IM_packet->pre_load = malloc(_XPPS_IM_FIXED_ALL);
    memcpy(IM_packet->pre_load, payload, _XPPS_IM_FIXED_ALL);
    
    int pos =  _XPPS_IM_FIXED_ALL;
    
    if (NULL != IM_param->data) {
        
        IM_packet->data_load = malloc(IM_param->normal_param->length);
        memset(IM_packet->data_load, 0, IM_param->normal_param->length);
        
        
        _xai_packet*  data_packet = generatePacketFromParamDataList(IM_param->data, IM_param->data_count);
        
        if (data_packet == NULL) {
            
            free(payload);
            purgePacket(nor_packet);
            purgePacket(IM_packet);
            
            return NULL;
        }
        
        memcpy(IM_packet->data_load, data_packet->all_load, data_packet->size);
        
        
        param_to_packet_helper(payload, data_packet->all_load
                               , _XPPS_IM_FIXED_ALL, _XPPS_IM_FIXED_ALL+data_packet->size);
        
        pos +=  data_packet->size;
        
        purgePacket(data_packet);
        
    }else{
        
        IM_packet->data_load = NULL;
    }
    
    
    
    IM_packet->all_load = malloc(pos);
    memcpy(IM_packet->all_load, payload, pos);
    
    IM_packet->size = pos;
    
    free(payload);
    purgePacket(nor_packet);
    
    
    return IM_packet;
}
_xai_packet_param_IM*   generateParamIMFromPacket(const _xai_packet*  packet){
    
    if (packet == NULL) return NULL;
    return generateParamIMFromData(packet->all_load, packet->size);
}

_xai_packet_param_IM*   generateParamIMFromData(void*  packet_data,int size){
    
    if (size < _XPPS_IM_FIXED_ALL) {
        
        printf("XAI -  IM PACKET FIXED DATA SIZE ENOUGH");
        return NULL;
    }
    
    _xai_packet_param_IM*  IM_param = generatePacketParamIM();
    
    purgePacketParamNormal(IM_param->normal_param);
    IM_param->normal_param = generateParamNormalFromData(packet_data, size);
    
    if (NULL == IM_param->normal_param) {
        
        purgePacketParamIMAndData(IM_param);
        printf("XAI - GENERATE IM PACKET PARAM ERRO");
        return NULL;
    }
    
    
    //fixed
    packet_to_param_helper(&IM_param->time, packet_data, _XPP_IM_TIME_START, _XPP_IM_TIME_END);
    packet_to_param_helper(&IM_param->data_count, packet_data, _XPP_IM_DATA_COUNT_START, _XPP_IM_DATA_COUNT_END);
    
    
    //little endian
    IM_param->time = CFSwapInt16(IM_param->time);
    
    //unfixed
    
    int data_size = size - _XPPS_IM_FIXED_ALL;
    void*  data = (packet_data + _XPPS_IM_FIXED_ALL);
    _xai_packet_param_data* IM_data = generateParamDataListFromData(data, data_size,IM_param->data_count);

    
    IM_param->data = IM_data;
    
    
    return IM_param;
    
}


void purgePacketParamIMAndData(_xai_packet_param_IM* IM_param){
    
    if (NULL != IM_param) {
        
        purgePacketParamNormal(IM_param->normal_param);
        
        
        purgePacketParamData(IM_param->data);
        
        free(IM_param);
        
        IM_param = NULL;
    }
    
}

void purgePacketParamIMNoData(_xai_packet_param_IM* IM_param){
    
    if (NULL != IM_param) {
        
        purgePacketParamNormal(IM_param->normal_param);
        
        free(IM_param);
        
        IM_param = NULL;
    }
    
}


_xai_packet_param_IM*    generatePacketParamIM(){
    
    _xai_packet_param_IM*  param_IM = malloc(sizeof(_xai_packet_param_IM));
    memset(param_IM, 0, sizeof(_xai_packet_param_IM));
    
    param_IM->normal_param = generatePacketParamNormal();
    param_IM->data = NULL;
    param_IM->data_count = 0;
    param_IM->time = 0;
    
    return param_IM;
}


_xai_packet_param_data*  getParamDataFromParamIM(_xai_packet_param_IM* IM_param, int index){

    if (NULL == IM_param) {
        
        return NULL;
    }
    

    
    return paramDataAtIndex(IM_param->data, index);

}


void xai_param_IM_set(_xai_packet_param_IM* param_IM,XAITYPEAPSN  from_apsn,XAITYPELUID from_luid,
                        XAITYPEAPSN to_apsn,XAITYPELUID to_luid,
                        uint8_t flag , uint16_t msgid , uint16_t magic_number, uint32_t time, uint8_t data_count , _xai_packet_param_data* data){

    if (NULL == param_IM) {
        return;
    }
    
    xai_param_normal_set(param_IM->normal_param, from_apsn, from_luid, to_apsn, to_luid, flag, msgid, magic_number, NULL, 0);
    
    
    
    param_IM->time = time;
    
    param_IM->data_count = data_count;
    param_IM->data = data;
    
    size_t  dataSize = 0;
    
    for (int i = 0; i < data_count; i++) {
        
        _xai_packet_param_data* IM_data = paramDataAtIndex(param_IM->data, i);
        
        if (NULL == IM_data) return;
        
        dataSize += IM_data->data_len;
    }
    
    param_IM->normal_param->length =  (_XPPS_IM_FIXED_ALL - _XPPS_N_FIXED_ALL) + data_count*_XPPS_CD_FIXED_ALL + dataSize;


}

