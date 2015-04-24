//
//  XAIDevDWCtrl.m
//  XAI
//
//  Created by office on 15/3/30.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import "XAIDevDWCtrl.h"

#import "XAIPacketACK.h"
#import "XAIPacketStatus.h"
#import "XAIPacketCtrl.h"


#define Key_StatusID 1
#define Key_CtrlID 1

#define Key_StatusWeatherID 2

@implementation XAIDevDWCtrl



- (int8_t) coverDwcToPacketUint:(XAIDevDWCtrlOpr) opr{
    
    int8_t ret = -99;
    
    if (opr == XAIDevDWCtrlStatusClose) {
        
        ret = -1;
        
    }else if(opr == XAIDevDWCtrlStatusOpen){
        
        ret = 1;
    }else if(opr == XAIDevDWCtrlStatusStop){
        
        ret = 0;
    }
    
    return ret;
}

- (XAIDevDWCtrlStatus) coverPacketUintToDwc:(uint8_t)status_uint{
    
    XAIDevDWCtrlStatus retStatus = XAIDevDWCtrlStatusUnkown;
    
    if (status_uint == 3) {
        
        retStatus = XAIDevDWCtrlStatusOpen;
        
    }else if(status_uint == 2){
        
        retStatus = XAIDevDWCtrlStatusOpening;
        
    }else if(status_uint == 0){
        
        retStatus = XAIDevDWCtrlStatusClose;
        
    }else if(status_uint == 1){
        
        retStatus = XAIDevDWCtrlStatusClosing;
        
    }else if(status_uint == 4){
        
        retStatus = XAIDevDWCtrlStatusStop;
        
    }
    
    return retStatus;
}



- (XAIDevDWCtrlWeatherStatus) coverPacketBOOLToWeatherStatus:(XAITYPEBOOL)oneBool{
    
    XAIDevDWCtrlWeatherStatus retStatus = XAIDevDWCtrlWeatherStatus_Unknow;
    
    if (oneBool == XAITYPEBOOL_TRUE) {
        
        retStatus = XAIDevDWCtrlWeatherStatus_Rain;
        
    }else if(oneBool == XAITYPEBOOL_FALSE){
        
        oneBool = XAIDevDWCtrlWeatherStatus_Sun;
        
    }
    
    return retStatus;
}


- (void) getDwcStatus{
    
    
    NSString* topicStr = [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_StatusID];
    
    [[MQTT shareMQTT].client subscribe:topicStr withQos:2];
    
    _devOpr = XAIDevDWCtrlOpr_GetCurStatus;
    _DEF_XTO_TIME_Start
    
}


- (void) getWeatherStatus{

    NSString* topicStr = [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid
                                                      other:Key_StatusWeatherID];
    
    [[MQTT shareMQTT].client subscribe:topicStr withQos:2];
    
    _devOpr = XAIDevDWCtrlOpr_GetWeatherStatus;
    _DEF_XTO_TIME_Start
}


- (void) startOpr:(XAIDevDWCtrlOpr)opr{
    
    
    MQTT* cur_MQTT = [MQTT shareMQTT];
    
    _xai_packet_param_ctrl*  param_ctrl = generatePacketParamCtrl();
    
    _xai_packet_param_data* param_data = generatePacketParamData();
    
    int8_t opr_packet =  [self coverDwcToPacketUint:opr];
    
    xai_param_data_set(param_data, XAI_DATA_TYPE_BIN_DIGITAL_SIGN,
                       sizeof(int8_t)
                       , &opr_packet, NULL);
    
    xai_param_ctrl_set(param_ctrl, cur_MQTT.apsn, cur_MQTT.luid, _apsn , _luid, XAI_PKT_TYPE_CONTROL, 0, 0,
                       Key_CtrlID,[[NSDate new] timeIntervalSince1970], 1, param_data);
    
    
    _xai_packet* packet = generatePacketFromParamCtrl(param_ctrl);
    
    NSString* ctrlTopic =  [MQTTCover nodeCtrlTopicWithAPNS:_apsn luid:_luid];
    
    [[MQTT shareMQTT].packetManager addPacketManagerACK:self];
    
    [[MQTT shareMQTT].client publish:packet->all_load size:packet->size
                             toTopic:ctrlTopic
                             withQos:0
                              retain:NO];
    
    
    purgePacket(packet);
    purgePacketParamCtrlAndData(param_ctrl);
    
    _devOpr = XAIDevDWCtrlOpr_SetStatus;
    _DEF_XTO_TIME_Start
}


#pragma mark - MQTTPacketManagerDelegate


- (void) reciveACKPacket:(void*)datas size:(int)size topic:(NSString*)topic{
    
    _xai_packet_param_ack*  ack = generateParamACKFromData(datas,size);
    
    if (ack == NULL) return;
    
    XAI_ERROR err = XAI_ERROR_UNKOWEN;
    
    if (ack->err_no == 0) {
        
        err = XAI_ERROR_NONE;
        
    }
    
    switch (ack->scid) {
            
        case Key_CtrlID:{
            
            
            if ((nil != _dwcDelegate) && [_dwcDelegate respondsToSelector:
                                          @selector(devDWCtrl:setOpr:err:)]) {
                
                [_dwcDelegate devDWCtrl:self setOpr:XAIDevDWCtrlOprUnkown err:err];
            }
            
            
            [[MQTT shareMQTT].packetManager removePacketManagerACK:self];
            
            
            _DEF_XTO_TIME_END_TRUE(_devOpr, XAIDevDWCtrlOpr_SetStatus);
            
            
        }break;
            
            
            
        default:break;
    }
    
    purgePacketParamACKAndData(ack);
    
}

- (void) reciveNodeStatusPacket:(void*)datas size:(int)size topic:(NSString*)topic mosqMsg:(MosquittoMessage *)mosq_msg{

    _xai_packet_param_status* param = generateParamStatusFromData(datas, size);
    
    if (param == NULL){
        XSLog(@"packer err");
        return;
    }
    
    
    
    XAI_ERROR err = XAI_ERROR_UNKOWEN;
    
    XAIDevDWCtrlStatus curStatus = XAIDevDWCtrlStatusUnkown;
    
    do {
        
        if (NULL == param) break;
        
        _xai_packet_param_data* data = getParamDataFromParamStatus(param, 0);
        
        if (data == NULL || (data->data_type != XAI_DATA_TYPE_BIN_DIGITAL_UNSIGN) || data->data_len != 1)break;
        
        uint8_t oneStatus = 0;
        
        byte_data_copy(&oneStatus, data->data, sizeof(uint8_t), data->data_len);
        
        curStatus = [self coverPacketUintToDwc:oneStatus];
        
        err = XAI_ERROR_NONE;
        
        
    } while (0);
    
    switch (param->oprId) {
            
        case Key_StatusID:{
            
            if (nil != _dwcDelegate && [_dwcDelegate respondsToSelector:
                                        @selector(devDWCtrl:curStatus:err:otherInfo:)]) {
                
                XAIOtherInfo* otherInfo = [[XAIOtherInfo alloc] init];
                otherInfo.time = param->time;
                otherInfo.msgid = mosq_msg.mid;
                otherInfo.error = err;
                otherInfo.fromluid =  luidFromGUID(param->normal_param->from_guid);
                
                
                [_dwcDelegate devDWCtrl:self curStatus:curStatus err:err otherInfo:otherInfo];
            }
            
            _DEF_XTO_TIME_END_TRUE(_devOpr, XAIDevDWCtrlOpr_GetCurStatus);
            
        }break;
            
            
        default:break;
    }
    
    purgePacketParamStatusAndData(param);


}


- (void) reciveWeatherStatusPacket:(void*)datas size:(int)size topic:(NSString*)topic mosqMsg:(MosquittoMessage *)mosq_msg{
    
    
    _xai_packet_param_status* param = generateParamStatusFromData(datas, size);
    
    if (param == NULL){
        XSLog(@"packer err");
        return;
    }
    
    
    
    XAI_ERROR err = XAI_ERROR_UNKOWEN;
    
    XAIDevDWCtrlWeatherStatus weatherStatus = XAIDevDWCtrlWeatherStatus_Unknow;
    
    do {
        
        if (NULL == param) break;
        
        _xai_packet_param_data* data = getParamDataFromParamStatus(param, 0);
        
        if (data == NULL || (data->data_type != XAI_DATA_TYPE_BIN_BOOL) || data->data_len <= 0)break;
        
        XAITYPEBOOL oneBool;
        
        byte_data_copy(&oneBool, data->data, sizeof(XAITYPEBOOL), data->data_len);
        
        
        weatherStatus = [self coverPacketBOOLToWeatherStatus:oneBool];
        
        err = XAI_ERROR_NONE;
        
        
    } while (0);
    
    switch (param->oprId) {
            
        case Key_StatusWeatherID:{
            
            if (nil != _dwcDelegate && [_dwcDelegate respondsToSelector:
                                        @selector(devDWCtrl:weatherStatus:err:otherInfo:)]) {
                
                XAIOtherInfo* otherInfo = [[XAIOtherInfo alloc] init];
                otherInfo.time = param->time;
                otherInfo.msgid = mosq_msg.mid;
                otherInfo.error = err;
                otherInfo.fromluid =  luidFromGUID(param->normal_param->from_guid);
                
                
                [_dwcDelegate devDWCtrl:self weatherStatus:weatherStatus err:err otherInfo:otherInfo];
            }
            
            _DEF_XTO_TIME_END_TRUE(_devOpr, XAIDevDWCtrlOpr_GetWeatherStatus);
            
        }break;
            
            
        default:break;
    }
    
    purgePacketParamStatusAndData(param);
    

}



- (void) reciveStatusPacket:(void*)datas size:(int)size topic:(NSString*)topic mosqMsg:(MosquittoMessage *)mosq_msg{
    
    [super recivePacket:datas size:size topic:topic mosqMsg:mosq_msg];
    
    if ([topic isEqualToString:
          [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_StatusID]]) {
        
        [self reciveNodeStatusPacket:datas size:size topic:topic mosqMsg:mosq_msg];
        
    }else if([topic isEqualToString:
               [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_StatusWeatherID]]){
    
        [self reciveWeatherStatusPacket:datas size:size topic:topic mosqMsg:mosq_msg];
    }
    
}


- (void) recivePacket:(void*)datas size:(int)size topic:(NSString*)topic mosqMsg:(MosquittoMessage *)mosq_msg{
    
    _xai_packet_param_normal* param = generateParamNormalFromData(datas, size);
    
    if (param == NULL){
        XSLog(@"packer err");
        return;
    }
    
    
    switch (param->flag) {
        case XAI_PKT_FLAG_ACK_CONTROL:{
            
            [self reciveACKPacket:datas size:size topic:topic];
        }
            
            break;
            
        case XAI_PKT_TYPE_STATUS:
        {
            [self reciveStatusPacket:datas size:size topic:topic mosqMsg:mosq_msg];
            
        }break;
            
        default:
            break;
    }
    
    
    purgePacketParamNormal(param);
}

- (void) startFocusStatus{
    
    NSString* topicStr = [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_StatusID];
    
    [[MQTT shareMQTT].client subscribe:topicStr withQos:2];
    
    [[MQTT shareMQTT].packetManager addPacketManager:self withKey:topicStr];
    
    
    NSString* topicStr2 = [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid
                                                      other:Key_StatusWeatherID];
    
    [[MQTT shareMQTT].client subscribe:topicStr2 withQos:2];
    [[MQTT shareMQTT].packetManager addPacketManager:self withKey:topicStr2];
    

}
- (void) endFocusStatus{
    
    NSString* topicStr = [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_StatusID];
    
    [[MQTT shareMQTT].packetManager removePacketManager:self withKey:topicStr];
    
    NSString* topicStr2 = [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid
                                                       other:Key_StatusWeatherID];
    
    [[MQTT shareMQTT].packetManager removePacketManager:self withKey:topicStr2];
}

-(void)timeout{
    
    
    if (_devOpr == XAIDevDWCtrlOpr_GetCurStatus &&
        (nil != _dwcDelegate) &&
        [_dwcDelegate respondsToSelector:@selector(devDWCtrl:curStatus:err:otherInfo:)]) {
        
        [_dwcDelegate devDWCtrl:self curStatus:XAIDevDWCtrlStatusUnkown err:XAI_ERROR_TIMEOUT];
        
        
    }else if(_devOpr == XAIDevDWCtrlOpr_SetStatus &&
             (nil != _dwcDelegate) &&
             [_dwcDelegate respondsToSelector:@selector(devDWCtrl:setOpr:err:)]){
        
        [[MQTT shareMQTT].packetManager removePacketManagerACK:self];
        [_dwcDelegate devDWCtrl:self setOpr:XAIDevDWCtrlOprUnkown err:XAI_ERROR_TIMEOUT];
        
    }else if(_devOpr == XAIDevDWCtrlOpr_GetWeatherStatus &&
             (nil != _dwcDelegate) &&
             [_dwcDelegate respondsToSelector:@selector(devDWCtrl:weatherStatus:err:)]){
        
        [[MQTT shareMQTT].packetManager removePacketManagerACK:self];
        [_dwcDelegate devDWCtrl:self weatherStatus:XAIDevDWCtrlWeatherStatus_Unknow err:XAI_ERROR_TIMEOUT];
        
    }
    
    [super timeout];
}



#pragma mark Linkage

- (BOOL) dwcLinkageInfoIsEqual:(XAILinkageUseInfo*)useInfo index:(int)index{
    
    
    if (useInfo.dev_apsn == self.apsn
        && useInfo.dev_luid == self.luid
        && useInfo.some_id == Key_StatusID) {
        
        XAIDevDWCtrlStatus status = [self linkageInfoStatus:useInfo];
        
        if ((index == 0 && status == XAIDevDWCtrlStatusOpen)
            || (index == 1 && status == XAIDevDWCtrlStatusClose)
            || (index == 2 && status == XAIDevDWCtrlStatusStop)) {
            return true;
        }
    }
    
    return false;
}



-(NSArray *)getLinkageUseStatusInfos{
    
    
    XAILinkageUseInfoCtrl* open = [[XAILinkageUseInfoCtrl alloc] init];
    
    _xai_packet_param_data* true_data = generatePacketParamData();
    XAITYPEBOOL typetrue =  XAITYPEBOOL_TRUE;
    xai_param_data_set(true_data, XAI_DATA_TYPE_BIN_BOOL, sizeof(XAITYPEBOOL), &typetrue, NULL);
    
    [open setApsn:_apsn Luid:_luid ID:Key_StatusID Datas:true_data];
    
    
    XAILinkageUseInfoCtrl* close = [[XAILinkageUseInfoCtrl alloc] init];
    
    _xai_packet_param_data* false_data = generatePacketParamData();
    XAITYPEBOOL typefalse =  XAITYPEBOOL_FALSE;
    xai_param_data_set(false_data, XAI_DATA_TYPE_BIN_BOOL, sizeof(XAITYPEBOOL), &typefalse, NULL);
    
    [close setApsn:_apsn Luid:_luid ID:Key_StatusID Datas:false_data];
    
    purgePacketParamData(true_data);
    purgePacketParamData(false_data);
    
    return [NSArray arrayWithObjects:open, close, nil];
}




-(XAIDevDWCtrlStatus) linkageInfoStatus:(XAILinkageUseInfo*)useInfo{
    
    XAIDevDWCtrlStatus status = XAIDevDWCtrlStatusUnkown;
    
    do {
        
        if (useInfo.datas == NULL) break;
        if (useInfo.datas->data_type != XAI_DATA_TYPE_BIN_BOOL) break;
        
        int8_t oneStatus = 0;
        
        byte_data_copy(&oneStatus, useInfo.datas->data, sizeof(int8_t), useInfo.datas->data_len);
        
        status = [self coverPacketUintToDwc:oneStatus];
        
    } while (0);
    
    
    return status;
    
}



@end
