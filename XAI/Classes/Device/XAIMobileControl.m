//
//  XAIMobileControl.m
//  XAI
//
//  Created by office on 14-6-30.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIMobileControl.h"
#import "MQTT.h"

#import "XAIPacketCtrl.h"
#import "XAIPacketACK.h"
#import "XAIPacketIM.h"


#define _IM_ID 100

@implementation XAIMobileControl

- (void) startListene{
    
    MQTT* curMQTT = [MQTT shareMQTT];
    NSString* topic = [MQTTCover mobileCtrTopicWithAPNS:curMQTT.apsn luid:curMQTT.luid];
    
    [[MQTT shareMQTT].packetManager addPacketManager:self withKey:topic];
    [[MQTT shareMQTT].client subscribe:topic];
}

- (void) stopListene{
    
    MQTT* curMQTT = [MQTT shareMQTT];
    
    NSString* topic = [MQTTCover mobileCtrTopicWithAPNS:curMQTT.apsn luid:curMQTT.luid];
    [[MQTT shareMQTT].packetManager removePacketManager:self withKey:topic];
}


- (void) sendMsg:(NSString*)context toApsn:(XAITYPEAPSN)apsn toLuid:(XAITYPELUID)luid{
    
    if (context == nil || [context isEqualToString:@""]) {
        return;
    }

    MQTT* cur_MQTT = [MQTT shareMQTT];
    
    _xai_packet_param_IM*  param_IM = generatePacketParamIM();
    
    _xai_packet_param_data* context_data = generatePacketParamData();
    
    NSData* data = [context dataUsingEncoding:NSUTF8StringEncoding];
    xai_param_data_set(context_data, XAI_DATA_TYPE_ASCII_TEXT,
                       [data length], (void*)[context UTF8String],nil);
    
    
    xai_param_IM_set(param_IM, cur_MQTT.apsn, cur_MQTT.luid, apsn , luid, _IM_ID,
                       0, 0,[[NSDate new] timeIntervalSince1970], 1, context_data);
    
    
    _xai_packet* packet = generatePacketFromParamIM(param_IM);
    
    
    NSString* imTopic =  [MQTTCover mobileCtrTopicWithAPNS:apsn luid:luid];
    
    
    [[MQTT shareMQTT].client publish:packet->all_load size:packet->size
                             toTopic:imTopic
                             withQos:0
                              retain:NO];
    
    
    purgePacket(packet);
    purgePacketParamIMAndData(param_IM);
    
    


}


#pragma mark - delegate


- (void) reciveCtrlPacket:(void*)datas size:(int)size topic:(NSString*)topic{
    
    _xai_packet_param_ctrl*  ctrl = generateParamCtrlFromData(datas, size);
    
    if (ctrl == NULL) return;
    
    
    if (ctrl->oprId == _IM_ID) {
        
        XAITYPELUID fromLuid = luidFromGUID(ctrl->normal_param->from_guid);
        XAITYPEAPSN fromApsn = apsnFromGUID(ctrl->normal_param->from_guid);
        
        XAIMeg* newMsg = [[XAIMeg alloc] init];
        newMsg.fromAPSN = fromApsn;
        newMsg.fromLuid = fromLuid;
        newMsg.toAPSN = [MQTT shareMQTT].curUser.apsn;
        newMsg.toLuid = [MQTT shareMQTT].curUser.luid;
        
        
        NSMutableArray* msgs = [[NSMutableArray alloc] init];
        [msgs addObjectsFromArray:[XAIUser readIM:fromLuid apsn:fromApsn]];
        [msgs addObject:newMsg];
        
        
        [XAIUser saveIM:msgs luid:fromLuid apsn:fromApsn];
        
        if (_mobileDelegate != nil && [_mobileDelegate respondsToSelector:@selector(mobileControl:newMsg:)]) {
            
            [_mobileDelegate mobileControl:self newMsg:newMsg];
        }
        

        
    }else{
    
        if (_mobileDelegate != nil && [_mobileDelegate respondsToSelector:@selector(mobileControl:getCmd:)]) {
            
            [_mobileDelegate mobileControl:self getCmd:nil];
        }
        
    
    }
    
    

    
    
    purgePacketParamCtrlAndData(ctrl);
    
}


- (void) reciveIMPacket:(void*)datas size:(int)size topic:(NSString*)topic{
    
    _xai_packet_param_IM*  IM = generateParamIMFromData(datas, size);
    
    if (IM == NULL) return;
    
    
        
        XAITYPELUID fromLuid = luidFromGUID(IM->normal_param->from_guid);
        XAITYPEAPSN fromApsn = apsnFromGUID(IM->normal_param->from_guid);
        
        XAIMeg* newMsg = [[XAIMeg alloc] init];
        newMsg.fromAPSN = fromApsn;
        newMsg.fromLuid = fromLuid;
        newMsg.toAPSN = [MQTT shareMQTT].curUser.apsn;
        newMsg.toLuid = [MQTT shareMQTT].curUser.luid;
        
        _xai_packet_param_data* data = getParamDataFromParamIM(IM, 0);
        if (data != NULL && (data->data_type == XAI_DATA_TYPE_ASCII_TEXT) && data->data_len > 0){
            
            newMsg.context = [[NSString alloc] initWithBytes:data->data length:data->data_len encoding:NSUTF8StringEncoding];
        }
        

        
        
        NSMutableArray* msgs = [[NSMutableArray alloc] init];
        [msgs addObjectsFromArray:[XAIUser readIM:fromLuid apsn:fromApsn]];
        [msgs addObject:newMsg];
        
        
        [XAIUser saveIM:msgs luid:fromLuid apsn:fromApsn];
        
        if (_mobileDelegate != nil && [_mobileDelegate respondsToSelector:@selector(mobileControl:newMsg:)]) {
            
            [_mobileDelegate mobileControl:self newMsg:newMsg];
        }
        
        
    
    
    
    
    
    purgePacketParamIMAndData(IM);
    
}



- (void) reciveAck:(void*)datas size:(int)size topic:(NSString*)topic{
    
    _xai_packet_param_ack*  ack = generateParamACKFromData(datas,size);
    
    if (ack == NULL) return;
    
    
    if (ack->scid == _IM_ID) {
        

        if (_mobileDelegate != nil && [_mobileDelegate respondsToSelector:@selector(mobileControl:sendStatus:)]) {
            
            [_mobileDelegate mobileControl:self sendStatus:ack->err_no];
        }
        
    }
    
    
    
    purgePacketParamACKAndData(ack);
    
}



- (void) recivePacket:(void*)datas size:(int)size topic:(NSString*)topic{
    
    MQTT* curMQTT = [MQTT shareMQTT];
    
    if(![topic isEqualToString:[MQTTCover mobileCtrTopicWithAPNS:curMQTT.apsn luid:curMQTT.luid]]) return;
    
    _xai_packet_param_normal* param = generateParamNormalFromData(datas, size);
    
    
    switch (param->flag) {
        case XAI_PKT_TYPE_CONTROL:{
            
            [self reciveCtrlPacket:datas size:size topic:topic];
        }
            
            break;
            
        case XAI_PKT_TYPE_IM:{
            
            [self reciveIMPacket:datas size:size topic:topic];
        }
            
            break;
        case XAI_PKT_FLAG_ACK_CONTROL:{
        
            [self reciveAck:datas size:size topic:topic];
        }
            break;
            
        default:
            break;
    }
    
    
    purgePacketParamNormal(param);
}



@end


@implementation XAIMCCMD

@end