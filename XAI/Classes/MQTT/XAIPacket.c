//
//  AAViewController.m
//  XAI
//
//  Created by touchhy on 14-4-3.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#include "XAIPacket.h"


//helper
void byte_data_copy(void* to, const void* from, int toSize,int fromSize){

    int copySize = (toSize >= fromSize ? fromSize : toSize);
    memcpy(to, from, copySize);
}

void byte_data_set(void** to, const void* from, int size){

    if (*to != NULL) {
        
        free(*to);
    }
    
    *to = malloc(size);
    
    byte_data_copy(*to, from, size, size);

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
    
    
    aParam->msgid = CFSwapInt32(aParam->msgid);
    aParam->msgid = CFSwapInt16(aParam->magic_number);
    aParam->msgid = CFSwapInt16(aParam->length);
    
    if (size < _XPPS_N_FIXED_ALL + aParam->length) {
        
        purgePacketParamNormal(aParam);
        
        printf("XAI -  NORMAL PACKET UNFIXED DATA SIZE ENOUGH");
        //return NULL;
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

void xai_param_normal_set(_xai_packet_param_normal* normal_param,XAITYPEAPSN  from_apsn,XAITYPELUID from_luid,
                          XAITYPEAPSN to_apsn,XAITYPELUID to_luid,uint8_t flag , uint16_t msgid , uint16_t magic_number
                          ,void* data ,size_t dataSize){


    if (NULL == normal_param) {
        return;
    }

    
    
    void* from_guid = generateGUID(CFSwapInt32(from_apsn), CFSwapInt64(from_luid));
    void* to_guid = generateGUID(CFSwapInt32(to_apsn) , CFSwapInt64(to_luid));
    
    
    byte_data_copy(normal_param->from_guid, from_guid, sizeof(normal_param->from_guid), lengthOfGUID());
    byte_data_copy(normal_param->to_guid, to_guid, sizeof(normal_param->to_guid), lengthOfGUID());
    
    purgeGUID(from_guid);
    purgeGUID(to_guid);
    
    normal_param->flag  = flag;
    normal_param->msgid = CFSwapInt16(msgid);
    normal_param->magic_number = CFSwapInt16(magic_number);
    normal_param->length  =   CFSwapInt16(dataSize);
    
    if (NULL != normal_param->data) {
        
        free(normal_param->data);
        normal_param->data = NULL;
    }
    
    if (dataSize > 0) {
        
        normal_param->data = malloc(dataSize);
        memset(normal_param->data, 0, dataSize);
        
        byte_data_copy(normal_param->data, data, dataSize, dataSize);
    }
    


}


void* generateGUID(XAITYPEAPSN apsn,XAITYPELUID luid){

    void* guid = malloc(12);
    memset(guid, 0, 12);
    
    memcpy(guid, &apsn , 4);
    memcpy(guid +4, &luid, 8);

    return guid;


}

void purgeGUID(void* guid){

    free(guid);
}

size_t lengthOfGUID(){


    return sizeof(XAITYPEAPSN) + sizeof(XAITYPELUID);
}



