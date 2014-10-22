//
//  XAIPakageIMCtrl.m
//  XAI
//
//  Created by office on 14/10/20.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#include "XAIPacketIMCtrl.h"


_xai_packet_param_IM_Ctrl*    generatePacketParamIMCtrl(){
    
    _xai_packet_param_IM_Ctrl*  param = malloc(sizeof(_xai_packet_param_IM_Ctrl));
    memset(param, 0, sizeof(_xai_packet_param_IM_Ctrl));

    return param;
}


_xai_packet_param_IM_Ctrl*   generateParamIMCtrFromData(void* data,  int size){

    if (size < _XPPS_IM_Ctrl_FIXED_ALL) {
        
        printf("XAI -  IM Ctrl PACKET FIXED DATA SIZE ENOUGH");
        return NULL;
    }
    
    _xai_packet_param_IM_Ctrl*  param = generatePacketParamIMCtrl();
    
    
    //fixed
    packet_to_param_helper(param->name, data,
                           _XPP_IM_Ctrl_Name_START, _XPP_IM_Ctrl_Name_END);
    packet_to_param_helper(&param->time, data,
                           _XPP_IM_Ctrl_Time_START, _XPP_IM_Ctrl_Time_END);
    packet_to_param_helper(&param->action, data,
                           _XPP_IM_Ctrl_Action_START, _XPP_IM_Ctrl_Action_END);
    packet_to_param_helper(&param->Icon, data,
                           _XPP_IM_Ctrl_Icon_START  , _XPP_IM_Ctrl_Icon_END);
    packet_to_param_helper(&param->topic, data,
                           _XPP_IM_Ctrl_Topic_START  , _XPP_IM_Ctrl_Topic_End);
    
    //little endian
    param->time = CFSwapInt32(param->time);
    
    //unfixed
    int data_size = size - _XPPS_IM_Ctrl_FIXED_ALL;
    void*  action_data = (data + _XPPS_IM_Ctrl_FIXED_ALL);
    
    void* other = malloc(data_size);
    memset(other, 0, data_size);
    memcpy(other, action_data, data_size);
    
    param->data = other;
    param->dataSize = data_size;
    
    
    return param;

}


void purgePacketParamIMCtrlAndData(_xai_packet_param_IM_Ctrl* param){

    if (param == NULL) return;
    if (param->data != NULL && param->dataSize > 0) {
        free(param->data);
        param->data = NULL;
    }
    
    free(param);
    param = NULL;

}




