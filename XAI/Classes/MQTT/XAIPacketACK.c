//
//  XAIPacketACK.c
//  XAI
//
//  Created by office on 14-4-11.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#include "XAIPacketACK.h"


_xai_packet*   generatePacketFromParamACK(_xai_packet_param_ack* param){
    
    _xai_packet* nor_packet = generatePacketFromParamNormal(param->normal_param);
    
    
    _xai_packet* packet = generatePacket();
    
    
    char*  payload  = malloc(1000);
    memset(payload,0,1000);
    
    if(!payload){
        
        purgePacket(nor_packet);
        free(payload);
        return NULL;
    }
    //拷贝 normal 固定格式
    memcpy(payload, nor_packet->pre_load, nor_packet->fix_pos);
    
    //BIG
    uint16_t  big_errno = CFSwapInt16(param->err_no);
    
    //存入固定格式
    param_to_packet_helper(payload, &param->scid,_XPP_A_SCID_START,_XPP_A_SCID_END);
    param_to_packet_helper(payload, &big_errno, _XPP_A_ERRNO_START, _XPP_A_ERRNO_END);
    param_to_packet_helper(payload, &param->data_count, _XPP_A_DATA_COUNT_START, _XPP_A_DATA_COUNT_END);

    
    packet->pre_load = malloc(_XPPS_A_FIXED_ALL);
    memcpy(packet->pre_load, payload, _XPPS_A_FIXED_ALL);
    
    int pos =  _XPPS_A_FIXED_ALL;
    
    if (NULL != param->data) {
        
        packet->data_load = malloc(param->normal_param->length);
        memset(packet->data_load, 0, param->normal_param->length);
        
        
        _xai_packet*  data_packet = generatePacketFromParamDataList(param->data, param->data_count);
        
        memcpy(packet->data_load, data_packet->all_load, data_packet->size);
        
        
        param_to_packet_helper(payload, data_packet->all_load
                               , _XPPS_A_FIXED_ALL, _XPPS_A_FIXED_ALL+data_packet->size);
        
        pos +=  data_packet->size;
        
        purgePacket(data_packet);
        
    }else{
        
        packet->data_load = NULL;
    }
    
    
    
    packet->all_load = malloc(pos);
    memcpy(packet->all_load, payload, pos);
    
    packet->size = pos;
    
    free(payload);
    purgePacket(nor_packet);
    
    
    return packet;

}
_xai_packet_param_ack*   generateParamACKFromPacket(const _xai_packet*  packet){

    return generateParamACKFromData(packet->all_load, packet->size);

    
}
_xai_packet_param_ack*   generateParamACKFromData(void*  packet_data,int size){

    if (size < _XPPS_A_FIXED_ALL) {
        
        printf("XAI -  ACK PACKET FIXED DATA SIZE ENOUGH");
        return NULL;
    }
    
    _xai_packet_param_ack*  param = generatePacketParamACK();
    
    purgePacketParamNormal(param->normal_param);
    param->normal_param = generateParamNormalFromData(packet_data, size);
    
    if (NULL == param->normal_param) {
        
        purgePacketParamACKAndData(param);
        printf("XAI - GENERATE ACK PACKET PARAM ERRO");
        return NULL;
    }
    
    
    //fixed
    packet_to_param_helper(&param->scid, packet_data, _XPP_A_SCID_START, _XPP_A_SCID_END);
    packet_to_param_helper(&param->err_no, packet_data, _XPP_A_ERRNO_START, _XPP_A_ERRNO_END);
    packet_to_param_helper(&param->data_count, packet_data, _XPP_A_DATA_COUNT_START, _XPP_A_DATA_COUNT_END);
    
    //little
    param->err_no =  CFSwapInt16(param->err_no);
    
    //unfixed
    
    int data_size = size - _XPPS_A_FIXED_ALL;
    void*  data = (packet_data + _XPPS_A_FIXED_ALL);
    _xai_packet_param_data* ctrl_data = generateParamDataListFromData(data, data_size,param->data_count);
    
    
    param->data = ctrl_data;
    
    
    return param;

}
_xai_packet_param_ack*    generatePacketParamACK(){
    
    _xai_packet_param_ack*  param = malloc(sizeof(_xai_packet_param_ack));
    memset(param, 0, sizeof(_xai_packet_param_ack));
    
    param->normal_param = generatePacketParamNormal();
    param->data = NULL;
    param->data_count = 0;
    param->scid = 0;
    param->err_no = 0;
    
    return param;


}
void purgePacketParamACKAndData(_xai_packet_param_ack* param){
    
    if (NULL != param) {
        
        purgePacketParamNormal(param->normal_param);
        
        
        purgePacketParamData(param->data);
        
        free(param);
        
        param = NULL;
    }

}
void purgePacketParamACKNoData(_xai_packet_param_ack* param){
    
    if (NULL != param) {
        
        purgePacketParamNormal(param->normal_param);
        
        free(param);
        
        param = NULL;
    }

}


_xai_packet_param_data*  getParamDataFromParamACK(_xai_packet_param_ack* param, int index){

    if (NULL == param) {
        
        return NULL;
    }
    
    return paramDataAtIndex(param->data, index);
    
    
}
void xai_param_ack_set(_xai_packet_param_ack* param,XAITYPEAPSN  from_apsn,XAITYPELUID from_luid,
                       XAITYPEAPSN to_apsn,XAITYPELUID to_luid,
                       uint8_t flag , uint16_t msgid , uint16_t magic_number ,uint8_t scid, uint8_t err_no, uint8_t data_count , _xai_packet_param_data* data){

    
    if (NULL == param) {
        return;
    }
    
    xai_param_normal_set(param->normal_param, from_apsn, from_luid, to_apsn, to_luid, flag, msgid, magic_number, NULL, 0);
    
    
    
    param->scid = scid;
    param->err_no = err_no;
    
    param->data_count = data_count;
    param->data = data;
    
    size_t  dataSize = 0;
    
    for (int i = 0; i < data_count; i++) {
        
        _xai_packet_param_data* ctrl_data = paramDataAtIndex(param->data, i);
        
        if (NULL == ctrl_data) return;
        
        dataSize += ctrl_data->data_len;
    }
    
    param->normal_param->length =  _XPPS_A_FIXED_ALL - _XPPS_N_FIXED_ALL + data_count*_XPPS_CD_FIXED_ALL + dataSize;


}


