//
//  XAIDevSwitch.m
//  XAI
//
//  Created by office on 14-4-16.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIDevSwitch.h"

#import "XAIPacketACK.h"
#import "XAIPacketStatus.h"
#import "XAIPacketCtrl.h"





@implementation XAIDevSwitch


- (XAITYPEBOOL) coverCircuitToPacketBOOL:(XAIDevCircuitStatus) circuitStatus{

    XAITYPEBOOL retBOOL = XAITYPEBOOL_UNKOWN;
    
    if (circuitStatus == XAIDevCircuitStatusClose) {
        
        retBOOL = XAITYPEBOOL_FALSE;
        
    }else if(circuitStatus == XAIDevCircuitStatusOpen){
    
        retBOOL = XAITYPEBOOL_TRUE;
    
    }
    
    return retBOOL;
}

- (XAIDevCircuitStatus) coverPacketBOOLToCircuit:(XAITYPEBOOL)typeBool{

    XAIDevCircuitStatus retStatus = XAIDevCircuitUnkown;
    
    if (typeBool == XAITYPEBOOL_TRUE) {
        
        retStatus = XAIDevCircuitStatusOpen;
    
    }else if(typeBool == XAITYPEBOOL_FALSE){
    
        retStatus = XAIDevCircuitStatusClose;
    
    }
    
    return retStatus;
}

/**
 @to-do:   获取线路一的状态
 */
- (void) getCircuitOneStatus{
    
    //_isGetOneStatus = true;
    
    NSString* topicStr = [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_CircuitOneStatusID];
    
    [[MQTT shareMQTT].client subscribe:topicStr withQos:2];
    
    _devOpr = XAIDevSwitchOpr_GetOneStatus;
    _DEF_XTO_TIME_Start
    
    //[[MQTT shareMQTT].packetManager addPacketManager:self withKey:topicStr];

}

/**
 @to-do:   获取线路二的状态
 */
- (void) getCircuitTwoStatus{


    //_isGetTwoStatus = true;
    
    NSString* topicStr = [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_CircuitTwoStatusID];
    
    [[MQTT shareMQTT].client subscribe:topicStr withQos:2];
    
    _devOpr = XAIDevSwitchOpr_GetTwoStatus;
    _DEF_XTO_TIME_Start
    
    //[[MQTT shareMQTT].packetManager addPacketManager:self withKey:topicStr];
}


- (void) setCircuitStatus:(XAIDevCircuitStatus)status which:(int)num{
    
    
    MQTT* cur_MQTT = [MQTT shareMQTT];
    
    _xai_packet_param_ctrl*  param_ctrl = generatePacketParamCtrl();
    
    _xai_packet_param_data* param_data = generatePacketParamData();
    
    XAITYPEBOOL typeBool =  [self coverCircuitToPacketBOOL:status];
    
    xai_param_data_set(param_data, XAI_DATA_TYPE_BIN_BOOL, sizeof(XAITYPEBOOL)
                       , &typeBool, NULL);
    
    xai_param_ctrl_set(param_ctrl, cur_MQTT.apsn, cur_MQTT.luid, _apsn , _luid, XAI_PKT_TYPE_CONTROL, 0, 0,
                       num,[[NSDate new] timeIntervalSince1970], 1, param_data);
    
    
    _xai_packet* packet = generatePacketFromParamCtrl(param_ctrl);
    
    NSString* ctrlTopic =  [MQTTCover nodeCtrlTopicWithAPNS:_apsn luid:_luid];
    
    [[MQTT shareMQTT].packetManager addPacketManagerACK:self];
    
    [[MQTT shareMQTT].client publish:packet->all_load size:packet->size
                             toTopic:ctrlTopic
                             withQos:0
                              retain:NO];
    
    
    purgePacket(packet);
    purgePacketParamCtrlAndData(param_ctrl);
    
    
}


/**
 @to-do:  设置线路一的状态
 */

- (void) setCircuitOneStatus:(XAIDevCircuitStatus)status{

    [self setCircuitStatus:status which:Key_CircuitOneCtrlID];
    
    _devOpr = XAIDevSwitchOpr_SetOne;
    _DEF_XTO_TIME_Start

}

/**
 @to-do:   设置线路二的状态
 */
- (void) setCircuitTwoStatus:(XAIDevCircuitStatus)status{

   
    [self setCircuitStatus:status which:Key_CircuitTwoCtrlID];

    _devOpr = XAIDevSwitchOpr_SetTwo;
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
            
        case Key_CircuitOneCtrlID:{
            
            
            if ((nil != _swiDelegate) && [_swiDelegate respondsToSelector:@selector(switch_:setCircuitOneErr:)]) {
                
                [_swiDelegate switch_:self setCircuitOneErr:err];
            }

            
            [[MQTT shareMQTT].packetManager removePacketManagerACK:self];
            

            _DEF_XTO_TIME_END_TRUE(_devOpr, XAIDevSwitchOpr_SetOne);
            
            
        }break;
            
        case Key_CircuitTwoCtrlID:{
            
            
            if ((nil != _swiDelegate) && [_swiDelegate respondsToSelector:@selector(switch_:setCircuitTwoErr:)]) {
                
                [_swiDelegate switch_:self setCircuitTwoErr:err];
            }
            
            
            [[MQTT shareMQTT].packetManager removePacketManagerACK:self];
            
            _DEF_XTO_TIME_END_TRUE(_devOpr, XAIDevSwitchOpr_SetTwo);
            
        }break;
            
            
            
        default:break;
    }
    
    purgePacketParamACKAndData(ack);
    
}


- (void) reciveStatusPacket:(void*)datas size:(int)size topic:(NSString*)topic{
    
    [super recivePacket:datas size:size topic:topic];
    
    if (![topic isEqualToString:
          [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_CircuitTwoStatusID]]
        &&![topic isEqualToString:
           [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_CircuitOneStatusID]]) {
        
        return;
    }
    
    _xai_packet_param_status* param = generateParamStatusFromData(datas, size);
    
    if (param == NULL) {
        return;
    }
    

    XAI_ERROR err = XAI_ERROR_UNKOWEN;
    
    XAIDevCircuitStatus curStatus = XAIDevCircuitUnkown;
    
    do {
        
        if (NULL == param) break;
        
        _xai_packet_param_data* data = getParamDataFromParamStatus(param, 0);
        
        if (data == NULL || (data->data_type != XAI_DATA_TYPE_BIN_BOOL) || data->data_len <= 0)break;
        
        XAITYPEBOOL isOpen = 0;
        
        byte_data_copy(&isOpen, data->data, sizeof(XAITYPEBOOL), data->data_len);
        
        curStatus = [self coverPacketBOOLToCircuit:isOpen];
        
        err = XAI_ERROR_NONE;
        
        
    } while (0);

    switch (param->oprId) {
            
        case Key_CircuitOneStatusID:{
            
            if (nil != _swiDelegate && [_swiDelegate respondsToSelector:
                                        @selector(switch_:getCircuitOneStatus:err:)]) {
                
                [_swiDelegate switch_:self getCircuitOneStatus:curStatus err:err];
            }
            
            _DEF_XTO_TIME_END_TRUE(_devOpr, XAIDevSwitchOpr_GetOneStatus);
            
        }break;
            
        case Key_CircuitTwoStatusID:{
            
            if (nil != _swiDelegate && [_swiDelegate respondsToSelector:
                                        @selector(switch_:getCircuitTwoStatus:err:)]) {
                
                [_swiDelegate  switch_:self getCircuitTwoStatus:curStatus err:err];
            }
            
            
            _DEF_XTO_TIME_END_TRUE(_devOpr, XAIDevSwitchOpr_GetTwoStatus);
            
        }
            
        default:break;
    }
    
    purgePacketParamStatusAndData(param);
}


- (void) recivePacket:(void*)datas size:(int)size topic:(NSString*)topic{
    
    _xai_packet_param_normal* param = generateParamNormalFromData(datas, size);
    
    
    switch (param->flag) {
        case XAI_PKT_FLAG_ACK_CONTROL:{
            
            [self reciveACKPacket:datas size:size topic:topic];
        }
            
            break;
            
        case XAI_PKT_TYPE_STATUS:
        {
            [self reciveStatusPacket:datas size:size topic:topic];
            
        }break;
            
        default:
            break;
    }
    
    
    purgePacketParamNormal(param);
}

- (void) startFocusStatus{
    
    NSString* topicStr = [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_CircuitOneStatusID];
    
    [[MQTT shareMQTT].client subscribe:topicStr];
    
    [[MQTT shareMQTT].packetManager addPacketManager:self withKey:topicStr];
    
    
    
    topicStr = [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_CircuitTwoStatusID];
    
    [[MQTT shareMQTT].client subscribe:topicStr];
    
    [[MQTT shareMQTT].packetManager addPacketManager:self withKey:topicStr];

}
- (void) endFocusStatus{
    
    NSString* topicStr = [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_CircuitOneStatusID];
    
    [[MQTT shareMQTT].packetManager removePacketManager:self withKey:topicStr];
    
    topicStr = [MQTTCover nodeStatusTopicWithAPNS:_apsn luid:_luid other:Key_CircuitTwoStatusID];
    
    [[MQTT shareMQTT].packetManager removePacketManager:self withKey:topicStr];
}

-(void)timeout{

    
    
    if (_devOpr == XAIDevSwitchOpr_GetOneStatus &&
        (nil != _swiDelegate) &&
        [_swiDelegate respondsToSelector:@selector(switch_:getCircuitOneStatus:err:)]) {
        
            [_swiDelegate switch_:self getCircuitOneStatus:XAIDevCircuitUnkown err:XAI_ERROR_TIMEOUT];

        
    }else if(_devOpr == XAIDevSwitchOpr_GetTwoStatus&&
             (nil != _swiDelegate) &&
             [_swiDelegate respondsToSelector:@selector(switch_:getCircuitTwoStatus:err:)]){
    
        [_swiDelegate switch_:self getCircuitTwoStatus:XAIDevCircuitUnkown err:XAI_ERROR_TIMEOUT];
    
    }else if(_devOpr == XAIDevSwitchOpr_SetOne&&
             (nil != _swiDelegate) &&
             [_swiDelegate respondsToSelector:@selector(switch_:setCircuitOneErr:)]){
        
        [[MQTT shareMQTT].packetManager removePacketManagerACK:self];
        [_swiDelegate switch_:self setCircuitOneErr:XAI_ERROR_TIMEOUT];
        
    
    }else if(_devOpr == XAIDevSwitchOpr_SetTwo&&
             (nil != _swiDelegate) &&
             [_swiDelegate respondsToSelector:@selector(switch_:setCircuitTwoErr:)]){
    
        [[MQTT shareMQTT].packetManager removePacketManagerACK:self];
        [_swiDelegate switch_:self setCircuitTwoErr:XAI_ERROR_TIMEOUT];
    
    }
    
    [super timeout];
}


-(id)init{

    if (self = [super init]) {
        
        _isGetOneStatus = false;
        _isGetTwoStatus = false;
    }
    
    return self;
}

#pragma mark Linkage
-(NSArray *)getCirculeOneLinkageUseInfos{
    
    
    XAILinkageUseInfoCtrl* openone = [[XAILinkageUseInfoCtrl alloc] init];
    
    _xai_packet_param_data* true_data = generatePacketParamData();
    XAITYPEBOOL typetrue =  XAITYPEBOOL_TRUE;
    xai_param_data_set(true_data, XAI_DATA_TYPE_BIN_BOOL, sizeof(XAITYPEBOOL), &typetrue, NULL);
    
    [openone setApsn:_apsn Luid:_luid ID:Key_CircuitTwoCtrlID Datas:true_data];
    
    
    XAILinkageUseInfoCtrl* closeone = [[XAILinkageUseInfoCtrl alloc] init];
    
    _xai_packet_param_data* false_data = generatePacketParamData();
    XAITYPEBOOL typefalse =  XAITYPEBOOL_FALSE;
    xai_param_data_set(false_data, XAI_DATA_TYPE_BIN_BOOL, sizeof(XAITYPEBOOL), &typefalse, NULL);
    
    [closeone setApsn:_apsn Luid:_luid ID:Key_CircuitTwoCtrlID Datas:false_data];
    
    
    return [NSArray arrayWithObjects:openone, closeone, nil];
}

-(NSArray *)getCirculeTwoLinkageUseInfos{


    XAILinkageUseInfoCtrl* opentwo = [[XAILinkageUseInfoCtrl alloc] init];
    
    _xai_packet_param_data* true_data = generatePacketParamData();
    XAITYPEBOOL typetrue =  XAITYPEBOOL_TRUE;
    xai_param_data_set(true_data, XAI_DATA_TYPE_BIN_BOOL, sizeof(XAITYPEBOOL), &typetrue, NULL);
    
    [opentwo setApsn:_apsn Luid:_luid ID:Key_CircuitTwoCtrlID Datas:true_data];
    
    
    XAILinkageUseInfoCtrl* closetwo = [[XAILinkageUseInfoCtrl alloc] init];
    
    _xai_packet_param_data* false_data = generatePacketParamData();
    XAITYPEBOOL typefalse =  XAITYPEBOOL_FALSE;
    xai_param_data_set(false_data, XAI_DATA_TYPE_BIN_BOOL, sizeof(XAITYPEBOOL), &typefalse, NULL);
    
    [closetwo setApsn:_apsn Luid:_luid ID:Key_CircuitTwoCtrlID Datas:false_data];
    
    
    return [NSArray arrayWithObjects:opentwo, closetwo, nil];
    
}

@end


