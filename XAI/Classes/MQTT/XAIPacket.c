//
//  AAViewController.m
//  XAI
//
//  Created by touchhy on 14-4-3.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#include "XAIPacket.h"

_xai_normal_packet*   generateNormalPacket( const char* from_guid  //12Byte
                             ,const char* to_guid   //12Byte
                             ,const char* flag      //1Byte
                             ,const char* msgid     //2Byte
                             ,const char* magic_number //2byte
                             ,const char* length       //2byte
                             ,const char*  data       //.....
){
    
    _xai_normal_packet*  packet = malloc(sizeof(_xai_normal_packet));
    
    
    char*  payload  =  malloc(1000);
    memset(payload,0,1000);
    unsigned int pos = 0;
    if(!payload){
        
        return packet;
    }
    
    strcpy(((char*)payload + pos),from_guid);
    pos += 12;
    strcpy(payload + pos,to_guid);
    pos += 12;
    strcpy(payload + pos,flag);
    pos +=  1;
    strcpy(payload + pos,msgid);
    pos += 2;
    strcpy(payload + pos,magic_number);
    pos += 2;
    strcpy(payload + pos, length);
    pos += 2;
     //strncpy(payload, from_guid, 12);
    
    
    packet->payload =  (uint8_t*)strdup(payload);
    packet->pos = pos;
    //if (!data) packet->data = strdup(data);
    
    if (NULL != data){
        
        strcpy(payload+pos, data);
        pos +=  strlen(data);
        pos += 1; //加'\0'
        

        
       
    
    }
    
    
    packet->overload = malloc(pos);
    
    memcpy(packet->overload,payload,pos);
    

    
    free(payload);
    
    return packet;
}

void purgeNormalPacket(_xai_normal_packet* packet){

    free(packet->payload);
    free(packet->data);
    free(packet->overload);
    packet = NULL;

}


_xai_normal_packet_param*   normalPacketToParam(const _xai_normal_packet*  packet){


    _xai_normal_packet_param* aParam = malloc(sizeof(_xai_normal_packet_param));
    
    int pos = 0;
    
    char*  from_g = malloc(12);
    strncpy(from_g, (const char*)packet->overload+pos, 12);
    aParam->from_guid = strdup(from_g);
    free(from_g);
    pos += 12;
    
    char*  to_g = malloc(12);
    strncpy(to_g, (const char*)packet->overload+pos, 12);
    aParam->to_guid = strdup(to_g);
    free(to_g);
    pos += 12;
    
    return aParam;

};



_xai_ctrl_packet*   generateControlPacket( const char* from_guid  //12Byte
                              ,const char* to_guid   //12Byte
                              ,const char* flag      //1Byte
                              ,const char* msgid     //2Byte
                              ,const char* magic_number //2byte
                              ,const char* length       //2byte
                              ,const char*  oprId      //2byte
                              ,const char*  data_count //1byte
                              ,const char*  data_len   //2byte
                              ,const char*  data    //.......
){


    _xai_normal_packet* nor_packet = generateNormalPacket(from_guid, to_guid, flag, msgid, magic_number, length, NULL);
    

    _xai_ctrl_packet* ctrl_packet = malloc(sizeof(_xai_ctrl_packet));
    char*  payload  = malloc(1000);
    
  
    strcpy(payload, (const char*)nor_packet->payload);
    int pos = nor_packet->pos;
    
    
    strcpy(payload+pos, oprId);
    pos += 2;
    
    strcpy(payload+pos, data_count);
    pos += 1;
    
    strcpy(payload+pos, data_len);
    pos += 2;
    
    ctrl_packet->payload = (uint8_t*)payload;
    ctrl_packet->pos = pos;
    if (!data) ctrl_packet->data = (uint8_t*)strdup(data);
    
    
    strcpy(payload+pos, data);
    ctrl_packet->overload = (uint8_t*)strdup(payload);
    
    free(payload);
    purgeNormalPacket(nor_packet);
    
    
    return ctrl_packet;

}

