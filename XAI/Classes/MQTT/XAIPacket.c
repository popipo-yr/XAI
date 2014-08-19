//
//  AAViewController.m
//  XAI
//
//  Created by touchhy on 14-4-3.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#include "XAIPacket.h"

#pragma mark --XAI_PARAM_DATA
//生成一个数据段
_xai_packet_param_data*    generatePacketParamData(){
    
    _xai_packet_param_data*  param_ctrl_data = malloc(sizeof(_xai_packet_param_data));
    memset(param_ctrl_data, 0, sizeof(_xai_packet_param_data));
    
    
    param_ctrl_data->data_type = 0;
    param_ctrl_data->data_len = 0;
    param_ctrl_data->data = NULL;
    param_ctrl_data->next = NULL;
    
    return param_ctrl_data;
    
}
void purgePacketParamData(_xai_packet_param_data* ctrl_param_data){
    
    if (NULL != ctrl_param_data) {
        
        purgePacketParamData(ctrl_param_data->next);
        
        free(ctrl_param_data->data);
        free(ctrl_param_data);
        
        ctrl_param_data = NULL;
    }
    
}
_xai_packet_param_data*   generateParamDataListFromData(void*  data,int data_size ,int count){
    
    
    void* cur_data = data;
    int  cur_data_size = data_size;
    
    _xai_packet_param_data* begin_ctrl_data = NULL;
    _xai_packet_param_data* cur_ctr_data = NULL;
    
    for (int i = 0; i < count; i++) {
        
        _xai_packet_param_data*  a_data = generateParamDataOneFromData(cur_data, cur_data_size);
        
        if (NULL == a_data) {
            
            purgePacketParamData(begin_ctrl_data);
            printf("XAI -  PARAM DATA ERRO");
            return NULL;
        }
        
        if (i == 0) {
            begin_ctrl_data = a_data;
            
        }else{
            
            cur_ctr_data->next = a_data;
        }
        
        cur_data = cur_data + a_data->data_len + _XPPS_CD_FIXED_ALL;
        cur_data_size = cur_data_size - (a_data->data_len + _XPPS_CD_FIXED_ALL);
        cur_ctr_data =  a_data;
    }
    
    
    return begin_ctrl_data;
    
}

_xai_packet_param_data*    generateParamDataOneFromData(void*  data,int size){
    
    if (size < _XPPS_CD_FIXED_ALL) {
        
        printf("XAI -  CTRL DATA FIXED DATA SIZE ENOUGH");
        return NULL;
    }
    
    _xai_packet_param_data*  ctrl_param_data = generatePacketParamData();
    
    
    //fixed
    packet_to_param_helper(&ctrl_param_data->data_type, data, _XPP_CD_TYPE_START, _XPP_CD_TYPE_END);
    packet_to_param_helper(&ctrl_param_data->data_len, data, _XPP_CD_LEN_START, _XPP_CD_LEN_END);
    
    ctrl_param_data->data_len = CFSwapInt16(ctrl_param_data->data_len);
    
    if (size < _XPPS_CD_FIXED_ALL + ctrl_param_data->data_len) {
        
        purgePacketParamData(ctrl_param_data);
        printf("XAI -  CTRL DATA UNFIXED DATA SIZE ENOUGH");
        return NULL;
    }
    
    
    
    /*type  大端 小端转化*/
    
    void* in_data =  malloc(ctrl_param_data->data_len);
    memset(in_data, 0, ctrl_param_data->data_len);
    memcpy(in_data, data+_XPP_CD_DATA_START, ctrl_param_data->data_len);
    //packet_to_param_helper(in_data, data, _XPP_CD_DATA_START, _XPP_CD_DATA_START+ctrl_param_data->data_len);
    
    
    
    if (XAI_DATA_TYPE_BIN_DIGITAL_UNSIGN == ctrl_param_data->data_type) {
        
        SwapBytes(in_data, ctrl_param_data->data_len);
    }
    
    if (XAI_DATA_TYPE_BIN_APSN == ctrl_param_data->data_type) {
        
        SwapBytes(in_data, ctrl_param_data->data_len);
    }
    
    if (XAI_DATA_TYPE_BIN_LUID == ctrl_param_data->data_type) {
        
        SwapBytes(in_data, ctrl_param_data->data_len);
    }
    
    if (XAI_DATA_TYPE_DELAY == ctrl_param_data->data_type) {
        SwapBytes(in_data, ctrl_param_data->data_len);
    }
    
    
   
    
    //unfixed
    ctrl_param_data->data = malloc(ctrl_param_data->data_len);
    memset(ctrl_param_data->data, 0, ctrl_param_data->data_len);
    //packet_to_param_helper(ctrl_param_data->data, data, _XPP_CD_DATA_START, _XPP_CD_DATA_START+ctrl_param_data->data_len);
    
    packet_to_param_helper(ctrl_param_data->data, in_data, 0, ctrl_param_data->data_len);
    free(in_data);
    
    return ctrl_param_data;
}



_xai_packet_param_data* generateParamDataCopyOther(_xai_packet_param_data* param_data){

    if (param_data == NULL) return NULL;
    
    _xai_packet_param_data* new_param = generatePacketParamData();
    _xai_packet_param_data* next_param = generateParamDataCopyOther(param_data->next);
    xai_param_data_set(new_param, param_data->data_type, param_data->data_len, param_data->data, next_param);
    
    return new_param;
}


_xai_packet* generatePacketFromeDataOne(_xai_packet_param_data* ctrl_param_data){
    
    
    if (ctrl_param_data == NULL) return NULL;
    
    
    _xai_packet* ctrl_data = generatePacket();
    
    
    char*  payload  = malloc(1000);
    memset(payload,0,1000);
    
    if(!payload) return NULL;
    
    //big
    uint16_t big_len = CFSwapInt16(ctrl_param_data->data_len);
    
    //存入固定格式
    param_to_packet_helper(payload, &ctrl_param_data->data_type, _XPP_CD_TYPE_START, _XPP_CD_TYPE_END);
    param_to_packet_helper(payload, &big_len, _XPP_CD_LEN_START, _XPP_CD_LEN_END);
    
    ctrl_data->pre_load = malloc(_XPPS_CD_FIXED_ALL);
    memcpy(ctrl_data->pre_load, payload, _XPPS_CD_FIXED_ALL);
    
    int pos =  _XPPS_CD_FIXED_ALL;
    
    if (NULL != ctrl_param_data->data) {
        
        
        /*type  大端 小端转化*/
        
        void* in_data =  malloc(ctrl_param_data->data_len);
        memset(in_data, 0, ctrl_param_data->data_len);
        memcpy(in_data, ctrl_param_data->data, ctrl_param_data->data_len);
        
        
        if (XAI_DATA_TYPE_BIN_DIGITAL_UNSIGN == ctrl_param_data->data_type) {
            
            
            SwapBytes(in_data, ctrl_param_data->data_len);
            
        }
        if (XAI_DATA_TYPE_BIN_APSN == ctrl_param_data->data_type) {
            
            
            SwapBytes(in_data, ctrl_param_data->data_len);
            
        }
        if (XAI_DATA_TYPE_BIN_LUID == ctrl_param_data->data_type) {
            
            
            SwapBytes(in_data, ctrl_param_data->data_len);
            
        }
        
        if (XAI_DATA_TYPE_DELAY == ctrl_param_data->data_type) {
            
            SwapBytes(in_data, ctrl_param_data->data_len);
        }
        
        
        
        ctrl_data->data_load = malloc(ctrl_param_data->data_len);
        memset(ctrl_data->data_load, 0, ctrl_param_data->data_len);
        memcpy(ctrl_data->data_load, in_data, ctrl_param_data->data_len);
        
        //param_to_packet_helper(payload, in_data, 0 , 0 + ctrl_param_data->data_len);
        
        memcpy(payload+pos, in_data, ctrl_param_data->data_len);
        
        pos +=  ctrl_param_data->data_len;

        free(in_data);
        in_data = NULL;

        
    }else{
        
        ctrl_data->data_load = NULL;
    }
    
    
    
    ctrl_data->all_load = malloc(pos);
    memcpy(ctrl_data->all_load, payload, pos);
    
    ctrl_data->size = pos;
    
    free(payload);
    
    
    return ctrl_data;
    
    
}


//数据段转为data
_xai_packet* generatePacketFromParamDataList(_xai_packet_param_data* ctrl_param_data , int count){
    
    _xai_packet*  packet = generatePacket();
    
    void* data_load = malloc(1000);
    memset(data_load, 0, 1000);
    
    int  dataPos = 0;
    
    for (int i = 0; i < count; i++) {
        
        _xai_packet_param_data* ctrl_data = paramDataAtIndex(ctrl_param_data, i);
        if (NULL ==  ctrl_data) {
            
            free(data_load);
            purgePacket(packet);
            
            printf("CTRL  DATA NULL");
            //abort();
            return NULL;
        }
        
        _xai_packet*  ctrl_data_packet = generatePacketFromeDataOne(ctrl_data);
        
        memcpy(data_load + dataPos, ctrl_data_packet->all_load, ctrl_data_packet->size);
        
        dataPos += ctrl_data_packet->size;
        
        purgePacket(ctrl_data_packet);
    }
    
    
    packet->all_load = data_load;
    packet->size = dataPos;
    
    return packet;
    
}

_xai_packet_param_data*  paramDataAtIndex(_xai_packet_param_data* ctrl_param_data, int index){
    
    
    if ( 0 >index || NULL == ctrl_param_data ) {
        
        return NULL;
    }
    
    _xai_packet_param_data* cur_data =  ctrl_param_data;
    
    for (int cur = 0; cur < index; cur++) {
        
        if (NULL == cur_data->next) {
            
            return NULL;
        }
        
        cur_data = cur_data->next;
        
    }
    
    return cur_data;
    
}

void xai_param_data_set(_xai_packet_param_data* ctrlData ,XAI_DATA_TYPE type , size_t len , void* data,
                        _xai_packet_param_data* next){
    
    if (NULL ==  ctrlData) {
        return;
    }
    
    ctrlData->data_len = len;
    ctrlData->data_type = type;
    byte_data_set(&ctrlData->data, data, len);
    
    ctrlData->next = next;
    
}

#pragma mark --XAI_PACKET


_xai_packet* generatePacket(void){
    
    _xai_packet* packet = malloc(sizeof(_xai_packet));
    memset(packet,0,sizeof(_xai_packet));
    
//    char*  payload  = malloc(1000);
//    memset(payload,0,1000);
    
    packet->pre_load = NULL;
    packet->all_load = NULL;
    packet->data_load = NULL;
    
    packet->fix_pos = 0;
    packet->size = 0;
    
    return packet;
}


void purgePacket(_xai_packet* packet){
    
    free(packet->pre_load);
    free(packet->data_load);
    free(packet->all_load);
    packet->pre_load = NULL;
    packet->all_load = NULL;
    packet->data_load = NULL;
    
    free(packet);
    packet = NULL;
    
}

void SwapBytes(void* to, size_t size){

    if (NULL == to) return;
    
    void* temp = malloc(size);
    memcpy(temp, to, size);
    
    
    for (int i = 0; i < size / 2; i++) {
        
        Byte aByte = *((Byte*)(temp + i));
        *((Byte*)(temp + i)) = *((Byte*)(temp + size - i - 1));
        *((Byte*)(temp + size - i - 1)) = aByte;
    }
    
    memcpy(to, temp, size);
    free(temp);
    temp = NULL;
    
    //free(to);
    //to = temp;
}

#pragma mark --GUID

void* generateGUID(XAITYPEAPSN apsn,XAITYPELUID luid){
    
    void* guid = malloc(12);
    memset(guid, 0, 12);
    
    memcpy(guid, &apsn , 4);
    memcpy(guid +4, &luid, 8);
    
    return guid;
    
    
}

bool GUIDToApsnAndLuid(XAITYPEAPSN* apsn,XAITYPELUID* luid,void* guid,size_t size){

    if (size != sizeof(XAITYPEAPSN) + sizeof(XAITYPELUID)) return false;
    
    memcpy(apsn, guid, sizeof(XAITYPEAPSN));
    memcpy(luid, guid + sizeof(XAITYPEAPSN), sizeof(XAITYPELUID));
    
    return false;
    
    
}

void purgeGUID(void* guid){
    
    free(guid);
}

void* generateSwapGUID(void* guid){
    
    void* newGuid = malloc(12);
    memset(newGuid, 0, 12);
    
    //读取
    XAITYPEAPSN apsn = 0;
    XAITYPELUID  luid = 0;
    
    memcpy(&apsn, guid, 4);
    memcpy(&luid, guid+4, 8);
    
    //zhuanhuan
    apsn = CFSwapInt32(apsn);
    luid = CFSwapInt64(luid);
    
    //cunru
    memcpy(newGuid, &apsn , 4);
    memcpy(newGuid +4, &luid, 8);
    
    return newGuid;
    
    
    
    
}

size_t lengthOfGUID(){
    
    
    return sizeof(XAITYPEAPSN) + sizeof(XAITYPELUID);
}


XAITYPELUID luidFromGUID(void* guid){

    XAITYPELUID luid = 0x0;
    memcpy(&luid, guid+4, 8);
    return luid;
}

XAITYPEAPSN apsnFromGUID(void* guid){

    XAITYPEAPSN apsn = 0x0;
    memcpy(&apsn, guid, 4);
    return apsn;
}


#pragma mark --HELPER

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




