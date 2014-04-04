//
//  AAViewController.m
//  XAI
//
//  Created by touchhy on 14-4-3.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#include "XAIPacket.h"


void packet_to_param_helper(char** to , uint8_t* from ,int size,int* pos){
    
    *to = malloc(size);
    strncpy(*to,(const char*)from+(*pos), size);
    *pos += size;
    
}

void param_to_packet_helper(char* to , const char* from, int size, unsigned int* pos){
    
    strcpy(to + *pos , from);
    *pos += size;
}

_xai_packet*   generateNormalPacket(_xai_packet_param_normal* normal_param){
    
    _xai_packet*  packet = malloc(sizeof(_xai_packet));
    
    
    char*  payload  =  malloc(1000);
    memset(payload,0,1000);
    unsigned int pos = 0;
    if(!payload){
        
        return packet;
    }
    
    //存入固定格式
    param_to_packet_helper(payload, normal_param->from_guid,_XPPS_N_from_guid,&pos);
    param_to_packet_helper(payload, normal_param->to_guid,_XPPS_N_to_guid,&pos);
    param_to_packet_helper(payload, normal_param->flag, _XPPS_N_flag, &pos);
    param_to_packet_helper(payload, normal_param->msgid, _XPPS_N_mggid, &pos);
    param_to_packet_helper(payload, normal_param->magic_number, _XPPS_N_magic_number, &pos);
    param_to_packet_helper(payload, normal_param->length, _XPPS_N_length, &pos);
    
    
    
    packet->pos = pos;  //固定格式位置
    
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
    
    int pos = 0;
    
    //读取固定格式
    packet_to_param_helper((char**)(&aParam->from_guid), packet->all_load, _XPPS_N_from_guid, &pos);
    packet_to_param_helper((char**)(&aParam->to_guid), packet->all_load, _XPPS_N_to_guid, &pos);
    packet_to_param_helper((char**)(&aParam->flag), packet->all_load, _XPPS_N_flag, &pos);
    
    
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

