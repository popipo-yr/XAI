//
//  XAIPacketDevTypeInfo.c
//  XAI
//
//  Created by touchhy on 14-4-8.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//


#include "XAIPacketDevTypeInfo.h"



_xai_packet*   generatePacketFromParamDTI(_xai_packet_param_dti* dti_param){
    
    _xai_packet* nor_packet = generatePacketFromParamNormal(dti_param->normal_param);
    
    
    _xai_packet* dti_packet = generatePacket();
    
    
    char*  payload  = malloc(1000);
    memset(payload,0,1000);
    
    if(!payload){
        
        purgePacket(nor_packet);
        return NULL;
    }
    //拷贝 normal 固定格式
    memcpy(payload, nor_packet->pre_load, nor_packet->fix_pos);
    
    
    //存入固定格式
    param_to_packet_helper(payload, &dti_param->flag,_XPP_DTI_FLAG_START,_XPP_DTI_MODEL_END);
    param_to_packet_helper(payload, dti_param->model, _XPP_DTI_MODEL_START, _XPP_DTI_MODEL_END);
    param_to_packet_helper(payload, dti_param->vender, _XPP_DTI_VENDOR_START, _XPP_D_VENDOR_END);
    
    dti_packet->pre_load = malloc(_XPPS_DTI_FIXED_ALL);
    memcpy(dti_packet->pre_load, payload, _XPPS_DTI_FIXED_ALL);
    
    int pos =  _XPPS_DTI_FIXED_ALL;
    
    dti_packet->data_load = NULL;
    
    dti_packet->all_load = malloc(pos);
    memcpy(dti_packet->all_load, payload, pos);
    
    dti_packet->size = pos;
    
    free(payload);
    purgePacket(nor_packet);
    
    
    return dti_packet;
}
_xai_packet_param_dti*   generateParamDTIFromPacket(const _xai_packet*  packet){
    
    return generateParamDTIFromData(packet->all_load, packet->size);
}

_xai_packet_param_dti*   generateParamDTIFromData(void*  packet_data,int size){
    
    if (size < _XPPS_DTI_FIXED_ALL) {
        
        printf("XAI -  DEV TYPE INFO PACKET FIXED DATA SIZE ENOUGH");
        return NULL;
    }
    
    _xai_packet_param_dti*  dti_param = generatePacketParamDTI();
    
    purgePacketParamNormal(dti_param->normal_param);
    dti_param->normal_param = generateParamNormalFromData(packet_data, size);
    
    if (NULL == dti_param->normal_param) {
        
        purgePacketParamDTI(dti_param);
        printf("XAI - GENERATE DEV TYPE INFO PACKET PARAM ERRO");
        return NULL;
    }
    
    
    //fixed
    packet_to_param_helper(&dti_param->flag, packet_data, _XPP_DTI_FLAG_START, _XPP_DTI_FLAG_END);
    packet_to_param_helper(dti_param->vender, packet_data, _XPP_DTI_VENDOR_START, _XPP_D_VENDOR_END);
    packet_to_param_helper(dti_param->model, packet_data, _XPP_DTI_MODEL_START, _XPP_DTI_MODEL_END);

    
    
    return dti_param;
    
}


void purgePacketParamDTI(_xai_packet_param_dti* dti_param){
    
    if (NULL != dti_param) {
        
        purgePacketParamNormal(dti_param->normal_param);
        
        free(dti_param);
        
        dti_param = NULL;
    }
    
}

_xai_packet_param_dti*    generatePacketParamDTI(){
    
    _xai_packet_param_dti*  param_dti = malloc(sizeof(_xai_packet_param_dti));
    memset(param_dti, 0, sizeof(_xai_packet_param_dti));
    
    param_dti->normal_param = generatePacketParamNormal();
    param_dti->flag = 0x00;

    memset(param_dti->vender, 0, sizeof(param_dti->vender));
    memset(param_dti->model, 0, sizeof(param_dti->model));
    
    return param_dti;
}



void xai_param_dti_set(_xai_packet_param_dti* param,XAITYPEAPSN  from_apsn,XAITYPELUID from_luid,
                       XAITYPEAPSN to_apsn,XAITYPELUID to_luid,
                       uint8_t flag, uint16_t msgid , uint16_t magic_number,
                       void* vender, size_t venderSize, void* model, size_t modelSize){
    
    if (NULL == param) {
        return;
    }
    
    xai_param_normal_set(param->normal_param, from_apsn, from_luid, to_apsn, to_luid, flag, msgid, magic_number, NULL, 0);
    
    

    param->normal_param->length =  0;
    
    byte_data_copy(param->vender, vender, sizeof(param->vender), venderSize);
    byte_data_copy(param->model, model, sizeof(param->model), modelSize);
    
}


