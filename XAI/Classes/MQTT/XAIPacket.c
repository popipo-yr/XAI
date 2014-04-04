//
//  AAViewController.m
//  XAI
//
//  Created by touchhy on 14-4-3.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#include "XAIPacket.h"




void packet_to_param_helper(char** to , uint8_t* from ,int start,int end){
    
    *to = malloc(end - start + 1);
    strncpy(*to,(const char*)from+start, end - start + 1);
    
}

void param_to_packet_helper(char* to , const char* from, int start, int end){
    
    if ((strlen(from) + 1) > (end - start + 1)) {
        
        printf("XAI_ large STRING");
        return;
    }
    
    strcpy(to + start , from);
}


_xai_packet*   generateNormalPacket(_xai_packet_param_normal* normal_param){
    
    _xai_packet*  packet = malloc(sizeof(_xai_packet));
    
    
    char*  payload  =  malloc(1000);
    memset(payload,0,1000);
    
    if(!payload){
        
        return packet;
    }
    
    //存入固定格式
    param_to_packet_helper(payload, normal_param->from_guid,_XPP_N_FROM_GUID_START,_XPP_N_FROM_GUID_END);
    param_to_packet_helper(payload, normal_param->to_guid,_XPP_N_TO_GUID_START,_XPP_N_TO_GUID_END);
    param_to_packet_helper(payload, normal_param->flag, _XPP_N_FLAG_START, _XPP_N_FROM_GUID_END);
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

void purgePacketNormal(_xai_packet* packet){

    free(packet->pre_load);
    free(packet->data_load);
    free(packet->all_load);
    packet = NULL;

}


_xai_packet_param_normal*   generateNormalParamFromPacket(const _xai_packet*  packet){


    _xai_packet_param_normal* aParam = malloc(sizeof(_xai_packet_param_normal));
    
    //读取固定格式
    packet_to_param_helper((char**)(&aParam->from_guid), packet->all_load, _XPP_N_FROM_GUID_START, _XPP_N_FROM_GUID_END);
    packet_to_param_helper((char**)(&aParam->to_guid), packet->all_load, _XPP_N_TO_GUID_START, _XPP_N_TO_GUID_END);
    packet_to_param_helper((char**)(&aParam->flag), packet->all_load, _XPP_N_FLAG_START, _XPP_N_FLAG_END);
    packet_to_param_helper((char**)(&aParam->msgid), packet->all_load, _XPP_N_MSGID_START, _XPP_N_MSGID_END);
    packet_to_param_helper((char**)(&aParam->magic_number), packet->all_load, _XPP_N_MAGIC_NUMBER_START, _XPP_N_MAGIC_NUMBER_END);
    packet_to_param_helper((char**)(&aParam->length), packet->all_load, _XPP_N_LENGTH_START, _XPP_N_LENGTH_END);
    

    
    
    return aParam;

};






//_xai_packet*   generateControlPacket( const char* from_guid  //12Byte
//                              ,const char* to_guid   //12Byte
//                              ,const char* flag      //1Byte
//                              ,const char* msgid     //2Byte
//                              ,const char* magic_number //2byte
//                              ,const char* length       //2byte
//                              ,const char*  oprId      //2byte
//                              ,const char*  data_count //1byte
//                              ,const char*  data_len   //2byte
//                              ,const char*  data    //.......
//){
//
//
//    _xai_packet* nor_packet = generateNormalPacket(from_guid, to_guid, flag, msgid, magic_number, length, NULL);
//    
//
//    _xai_packet* ctrl_packet = malloc(sizeof(_xai_packet));
//    char*  payload  = malloc(1000);
//    
//  
//    strcpy(payload, (const char*)nor_packet->pre_load);
//    int pos = nor_packet->pos;
//    
//    
//    strcpy(payload+pos, oprId);
//    pos += 2;
//    
//    strcpy(payload+pos, data_count);
//    pos += 1;
//    
//    strcpy(payload+pos, data_len);
//    pos += 2;
//    
//    ctrl_packet->payload = (uint8_t*)payload;
//    ctrl_packet->pos = pos;
//    if (!data) ctrl_packet->data = (uint8_t*)strdup(data);
//    
//    
//    strcpy(payload+pos, data);
//    ctrl_packet->overload = (uint8_t*)strdup(payload);
//    
//    free(payload);
//    purgePacketNormal(nor_packet);
//    
//    
//    return ctrl_packet;
//
//}

