//
//  XAIPacketLinkage.c
//  XAI
//
//  Created by office on 14-6-4.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#include "XAIPacketLinkage.h"

_xai_packet*   generatePacketFromParamLinkage(_xai_packet_param_linkage* linkage_param){
    
    if (linkage_param == NULL) return NULL;
    
    
    _xai_packet*  packet = generatePacket();
    
    
    uint8_t*  payload  =  malloc(1000);
    memset(payload,0,1000);
    
    if(!payload) return NULL;
    
    
    void* big_guid = generateSwapGUID(linkage_param->guid);
    
    //存入固定格式
    param_to_packet_helper(payload, big_guid,_XPP_L_GUID_START,_XPP_L_GUID_END);
   
    param_to_packet_helper(payload, &linkage_param->some_id, _XPP_L_ID_START, _XPP_L_ID_END);
    param_to_packet_helper(payload, &linkage_param->condition, _XPP_L_CONDITION_START, _XPP_L_CONDITION_END);
    
    
    purgeGUID(big_guid);

    
    
    /*fixed  size  */
    packet->fix_pos = _XPPS_L_FIXED_ALL;  //固定格式位置
    unsigned int pos = _XPPS_L_FIXED_ALL;
    
    /*preload --- fixed*/
    packet->pre_load =   malloc(pos);
    memset(packet->pre_load, 0, pos);
    memcpy(packet->pre_load, payload, pos);
    
    /*allload*/
    
    if (NULL !=  linkage_param->data){
        
         _xai_packet* param_p =  generatePacketFromParamDataList(linkage_param->data, 1);
        
        if (param_p != NULL) {/*目前可以为空*/
         
            packet->data_load = malloc(param_p->size);
            memset(packet->data_load, 0, param_p->size);
            memcpy(packet->data_load, param_p->all_load, param_p->size);
            
            param_to_packet_helper(payload, param_p->all_load, _XPPS_L_FIXED_ALL, _XPPS_L_FIXED_ALL+param_p->size);
            memcpy(payload+pos, param_p->all_load, param_p->size);
            
            pos +=  param_p->size;
        }
        
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




_xai_packet_param_linkage*   generateParamLinkageFromPacket(const _xai_packet*  packet){
    
    if (packet == NULL) return NULL;
    return generateParamLinkageFromData(packet->all_load, packet->size);
    
}

_xai_packet_param_linkage*   generateParamLinkageFromData(void*  packetData,int size){
    
    
    if (size < _XPPS_L_FIXED_ALL) { //长度不够
        
        printf("XAI -  linkage PACKET FIXED DATA SIZE ENOUGH");
        return NULL;
    }
    
    if (packetData == NULL) {
        printf("XAI - linkage packet is null");
        return NULL;
    }
    
    
    _xai_packet_param_linkage* aParam = generatePacketParamLinkage();
    
    
    //读取固定格式
    packet_to_param_helper(aParam->guid, packetData, _XPP_L_GUID_START, _XPP_L_GUID_END);
    packet_to_param_helper(&aParam->some_id, packetData, _XPP_L_ID_START, _XPP_L_ID_END);
    packet_to_param_helper(&aParam->condition, packetData, _XPP_L_CONDITION_START, _XPP_L_CONDITION_END);
    
    void* lit_guid = generateSwapGUID(aParam->guid);
    
    byte_data_copy(aParam->guid, lit_guid, sizeof(aParam->guid), lengthOfGUID());
    
    purgeGUID(lit_guid);
    
    
    if (size > _XPPS_L_FIXED_ALL) {
        
        _xai_packet_param_data* data = generateParamDataListFromData(packetData+_XPPS_L_FIXED_ALL, size - _XPPS_L_FIXED_ALL, 1);
        
        if (data == NULL) {
            
            purgePacketParamLinkage(aParam);
            
            printf("XAI -  linkage PACKET UNFIXED DATA SIZE ENOUGH");
            return NULL;
        }
        
        
        //unfixed
        aParam->data = data;

        
    }
    
    return aParam;
}

void purgePacketParamLinkage(_xai_packet_param_linkage* linkage_param){
    
    if (NULL != linkage_param) {
        
        purgePacketParamData(linkage_param->data);
        free(linkage_param);
        linkage_param = NULL;
    }
    
}


_xai_packet_param_linkage*    generatePacketParamLinkage(){
    
    _xai_packet_param_linkage*  param = malloc(sizeof(_xai_packet_param_linkage));
    memset(param->guid, 0, sizeof(param->guid));
    param->data = NULL;

    param->some_id = 0;
    param->condition = 0;
    
    return param;
    
}

void xai_param_Linkage_set(_xai_packet_param_linkage* linkage_param,  XAITYPEAPSN  apsn,  XAITYPELUID luid,
                           uint8_t some_id,  uint8_t condition, _xai_packet_param_data* param_data){
    
    
    if (NULL == linkage_param) {
        return;
    }
    
    
    
    void* guid = generateGUID(apsn, luid);
    
    
    byte_data_copy(linkage_param->guid, guid, sizeof(linkage_param->guid), lengthOfGUID());
    
    purgeGUID(guid);

    
    linkage_param->some_id  = some_id;
    linkage_param->condition = condition;

    
    if (NULL != linkage_param->data) {
        
        purgePacketParamData(linkage_param->data);
        linkage_param->data = NULL;
    }
    
    if (param_data != NULL) {
        
        linkage_param->data = generateParamDataCopyOther(param_data);
    }
    
}
