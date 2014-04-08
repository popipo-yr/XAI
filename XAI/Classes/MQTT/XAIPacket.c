//
//  AAViewController.m
//  XAI
//
//  Created by touchhy on 14-4-3.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#include "XAIPacket.h"


//helper
void copybyteArray(void* to, const void* from, int toSize,int fromSize){

    int copySize = (toSize >= fromSize ? fromSize : toSize);
    memcpy(to, from, copySize);
}

void param_to_packet_helper(void* to , void* from, int start, int end){
    
    memcpy(to + start, from, (end - start + 1));

}



void packet_to_param_helper(void* to , void* from ,int start,int end){
        
        //*to = malloc(end - start + 1);
        //memset(*to, 0, end - start + 1);
        memcpy(to, from + start, end - start + 1);
    
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
    
    
    uint8_t*  payload  =  malloc(1000);
    memset(payload,0,1000);
    
    if(!payload){
        
        return NULL;
    }
    
    //存入固定格式
    param_to_packet_helper(payload, normal_param->from_guid,_XPP_N_FROM_GUID_START,_XPP_N_FROM_GUID_END);
    param_to_packet_helper(payload, normal_param->to_guid,_XPP_N_TO_GUID_START,_XPP_N_TO_GUID_END);
    param_to_packet_helper(payload, &normal_param->flag, _XPP_N_FLAG_START, _XPP_N_FLAG_END);
    param_to_packet_helper(payload, &normal_param->msgid, _XPP_N_MSGID_START, _XPP_N_MSGID_END);
    param_to_packet_helper(payload, &normal_param->magic_number, _XPP_N_MAGIC_NUMBER_START, _XPP_N_MAGIC_NUMBER_END);
    param_to_packet_helper(payload, &normal_param->length, _XPP_N_LENGTH_START, _XPP_N_LENGTH_END);
    

    
    
    /*fixed  size  */
    packet->fix_pos = _XPPS_N_FIXED_ALL;  //固定格式位置
    unsigned int pos = _XPPS_N_FIXED_ALL;
    
    /*preload --- fixed*/
    packet->pre_load =   malloc(pos);
    memset(packet->pre_load, 0, pos);
    memcpy(packet->pre_load, payload, pos);
    
    /*allload*/
    
    if (NULL !=  normal_param->data &&  0 != normal_param->length){
        
        packet->data_load = malloc(normal_param->length);
        memset(packet->data_load, 0, normal_param->length);
        memcpy(packet->data_load, normal_param->data, normal_param->length);
        
        param_to_packet_helper(payload, normal_param->data, _XPPS_N_FIXED_ALL, _XPPS_N_FIXED_ALL+normal_param->length);
        memcpy(payload+pos, normal_param->data, normal_param->length);
        
        pos +=  normal_param->length;
        
    
    }else{
    
        packet->data_load = NULL;
    
    }
    
    
    //复制内存到all
    packet->all_load = malloc(pos);
    memset(packet->all_load, 0, pos);
    memcpy(packet->all_load,payload,pos);
    
    packet->size = pos;
    
    free(payload);
    
    return packet;
}




_xai_packet_param_normal*   generateParamNormalFromPacket(const _xai_packet*  packet){

    return generateParamNormalFromPacketData(packet->all_load, packet->size);

}

_xai_packet_param_normal*   generateParamNormalFromPacketData(void*  packetData,int size){

    
    if (size < _XPPS_N_FIXED_ALL) { //长度不够
        
        printf("XAI -  NORMAL PACKET FIXED DATA SIZE ENOUGH");
        return NULL;
    }
    
    
    _xai_packet_param_normal* aParam = generatePacketParamNormal();
    
    
    //读取固定格式
    packet_to_param_helper(aParam->from_guid, packetData, _XPP_N_FROM_GUID_START, _XPP_N_FROM_GUID_END);
    packet_to_param_helper(aParam->to_guid, packetData, _XPP_N_TO_GUID_START, _XPP_N_TO_GUID_END);
    packet_to_param_helper(&aParam->flag, packetData, _XPP_N_FLAG_START, _XPP_N_FLAG_END);
    packet_to_param_helper(&aParam->msgid, packetData, _XPP_N_MSGID_START, _XPP_N_MSGID_END);
    packet_to_param_helper(&aParam->magic_number, packetData, _XPP_N_MAGIC_NUMBER_START, _XPP_N_MAGIC_NUMBER_END);
    packet_to_param_helper(&aParam->length, packetData, _XPP_N_LENGTH_START, _XPP_N_LENGTH_END);
    
    if (size < _XPPS_N_FIXED_ALL + aParam->length) {
        
        purgePacketParamNormal(aParam);
        
        printf("XAI -  NORMAL PACKET UNFIXED DATA SIZE ENOUGH");
        return NULL;
    }
    
    //unfixed
    aParam->data = malloc(aParam->length);
    memset(aParam->data, 0, aParam->length);
    packet_to_param_helper(aParam->data, packetData, _XPP_N_DATA_START, _XPP_N_DATA_START+aParam->length);
    
    
    return aParam;


}

void purgePacketParamNormal(_xai_packet_param_normal* normal_param){

    if (NULL != normal_param) {
        
        free(normal_param->data);
        free(normal_param);
        normal_param = NULL;
    }
    
}


_xai_packet_param_normal*    generatePacketParamNormal(){

    _xai_packet_param_normal*  param = malloc(sizeof(_xai_packet_param_normal));
    memset(param->from_guid, 0, sizeof(param->from_guid));
    memset(param->to_guid, 0, sizeof(param->to_guid));
    param->data = NULL;
    param->flag = 0;
    param->length = 0;
    param->msgid = 0;
    param->magic_number = 0;
    
    return param;

}



