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

#pragma mark - delegate


- (void) reciveCtrlPacket:(void*)datas size:(int)size topic:(NSString*)topic{
    
    _xai_packet_param_ctrl*  ctrl = generateParamCtrlFromData(datas, size);
    
    if (ctrl == NULL) return;
    
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(mobileControl:getCmd:)]) {
        
        [_delegate mobileControl:self getCmd:nil];
    }
    
    
    
    purgePacketParamCtrlAndData(ctrl);
    
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
            
        default:
            break;
    }
    
    
    purgePacketParamNormal(param);
}



@end


@implementation XAIMCCMD

@end