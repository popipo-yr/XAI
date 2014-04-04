//
//  AAViewController.m
//  XAI
//
//  Created by touchhy on 14-4-3.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#include "XAIPacket.h"


void packet_to_param_helper(char** to , uint8_t* from ,int start,int end){
    
    if (end != _XPP_END_UNKOWN) {
        
        *to = malloc(end - start + 1);
        memset(*to, 0, end - start + 1);
        strncpy(*to,(const char*)from+start, end - start + 1);
        
    }else{
        
        
//        strcpy(*to, (const char*)from+start);
        char* tmp = malloc(1000);
        memset(tmp, 0, 1000);
        strcpy(tmp,(const char*)from + start);
        *to = strdup(tmp);
        free(tmp);
        
    
    }
    

    
}

void param_to_packet_helper(char* to , const char* from, int start, int end){
    
    //if ((strlen(from) + 1) > (end - start + 1)) {
    if (strlen(from) > (end - start + 1)) {
        
        printf("XAI_ large STRING");
        return;
    }
    
    strcpy(to + start , from);
}


void purgePacket(_xai_packet* packet){
    
    free(packet->pre_load);
    free(packet->data_load);
    free(packet->all_load);
    free(packet);
    packet = NULL;
    
}


_xai_packet*   generatePacketNormal(_xai_packet_param_normal* normal_param){
    
    _xai_packet*  packet = malloc(sizeof(_xai_packet));
    
    
    char*  payload  =  malloc(1000);
    memset(payload,0,1000);
    
    if(!payload){
        
        return NULL;
    }
    
    //存入固定格式
    param_to_packet_helper(payload, normal_param->from_guid,_XPP_N_FROM_GUID_START,_XPP_N_FROM_GUID_END);
    param_to_packet_helper(payload, normal_param->to_guid,_XPP_N_TO_GUID_START,_XPP_N_TO_GUID_END);
    param_to_packet_helper(payload, normal_param->flag, _XPP_N_FLAG_START, _XPP_N_FLAG_END);
    param_to_packet_helper(payload, normal_param->msgid, _XPP_N_MSGID_START, _XPP_N_MSGID_END);
    param_to_packet_helper(payload, normal_param->magic_number, _XPP_N_MAGIC_NUMBER_START, _XPP_N_MAGIC_NUMBER_END);
    param_to_packet_helper(payload, normal_param->length, _XPP_N_LENGTH_START, _XPP_N_LENGTH_END);
    

    
    
    
    packet->pos = _XPPS_N_FIXED_ALL;  //固定格式位置
    unsigned int pos = _XPPS_N_FIXED_ALL;
    
    packet->pre_load =   malloc(pos);
    memset(packet->pre_load, 0, pos);
    memcpy(packet->pre_load, payload, pos);
    
    if (NULL !=  normal_param->data){
        
        packet->data_load = (uint8_t*)strdup(normal_param->data);
        
        strcpy(payload+pos,  normal_param->data);
        
        pos +=  strlen(normal_param->data);
        pos += 1; //加'\0'的占位
        
    
    }else{
    
        packet->data_load = NULL;
    
    }
    
    
    //复制内存到all
    packet->all_load = malloc(pos);
    memset(packet->all_load, 0, pos);
    memcpy(packet->all_load,payload,pos);
    
    free(payload);
    
    return packet;
}




_xai_packet_param_normal*   generateParamNormalFromPacket(const _xai_packet*  packet){


    _xai_packet_param_normal* aParam = malloc(sizeof(_xai_packet_param_normal));
    
    //读取固定格式
    packet_to_param_helper((char**)(&aParam->from_guid), packet->all_load, _XPP_N_FROM_GUID_START, _XPP_N_FROM_GUID_END);
    packet_to_param_helper((char**)(&aParam->to_guid), packet->all_load, _XPP_N_TO_GUID_START, _XPP_N_TO_GUID_END);
    packet_to_param_helper((char**)(&aParam->flag), packet->all_load, _XPP_N_FLAG_START, _XPP_N_FLAG_END);
    packet_to_param_helper((char**)(&aParam->msgid), packet->all_load, _XPP_N_MSGID_START, _XPP_N_MSGID_END);
    packet_to_param_helper((char**)(&aParam->magic_number), packet->all_load, _XPP_N_MAGIC_NUMBER_START, _XPP_N_MAGIC_NUMBER_END);
    packet_to_param_helper((char**)(&aParam->length), packet->all_load, _XPP_N_LENGTH_START, _XPP_N_LENGTH_END);
    
    packet_to_param_helper((char**)(&aParam->data), packet->all_load, _XPP_N_DATA_START, _XPP_N_DATA_END);
    
    
    return aParam;

};


void purgePacketParamNormal(_xai_packet_param_normal* normal_param){

    
    free((void*)normal_param->from_guid);
    free((void*)normal_param->to_guid);
    free((void*)normal_param->flag);
    free((void*)normal_param->msgid);
    free((void*)normal_param->magic_number);
    free((void*)normal_param->length);
    free((void*)normal_param->data);
    free(normal_param);
    normal_param = NULL;
    
}



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
    param_to_packet_helper(payload, ctrl_param->data_count, _XPP_C_DATA_COUNT_START, _XPP_C_DATA_COUNT_END);
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
    
    
    return ctrl_param;

}
void purgePacketParamCtrl(_xai_packet_param_ctrl* ctrl_param){

    purgePacketParamNormal(ctrl_param->normal_param);
    
    free((void*)ctrl_param->oprId);
    free((void*)ctrl_param->data_count);
    free((void*)ctrl_param->data_len);
    free((void*)ctrl_param->data);
    free(ctrl_param);
    
    ctrl_param = NULL;
}


