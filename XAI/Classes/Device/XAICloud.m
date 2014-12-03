//
//  XAICloud.m
//  XAI
//
//  Created by office on 14-10-8.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAICloud.h"


#define Key_CloudStatusID 0x4
#define Key_CloudOtherId  0xFF

#define _Key_Status  100

@implementation XAICloud


- (void) bridgeStatus{

    NSString* topicStr = [MQTTCover serverStatusTopicWithAPNS:_apsn
                                                         luid:Key_CloudStatusID
                                                        other:Key_CloudOtherId];
    
    [[MQTT shareMQTT].client subscribe:topicStr];
    [[MQTT shareMQTT].packetManager addPacketManager:self withKey:topicStr];

    
    _devOpr = _Key_Status;
    _DEF_XTO_TIME_Start
}


- (void) recivePacket:(void*)datas size:(int)size topic:(NSString*)topic{
    
    [super recivePacket:datas size:size topic:topic];
    
    NSString* topicStr = [MQTTCover serverStatusTopicWithAPNS:_apsn
                                                         luid:Key_CloudStatusID
                                                        other:Key_CloudOtherId];
    
    if (![topic isEqual:topicStr]) return;
    
    
    if (size != 1) return;
    
    uint8_t some = 0;
    memcpy(&some, datas, 1);
    
    XAICloudStatus status = XAICloudStatus_UNKown;
    
    if (some == '0') {
        status =  XAICloudStatus_OFF;
    }else if(some == '1'){
        status = XAICloudStatus_ON;
    }
    
    
    if (_devOpr == _Key_Status &&
        (nil != _cloudDelegate) &&
        [_cloudDelegate respondsToSelector:@selector(cloud:status:err:)]) {
    
        
        [_cloudDelegate cloud:self status:status err:XAI_ERROR_NONE];
        
    }
    
    
    
    [[MQTT shareMQTT].packetManager removePacketManager:self withKey:topicStr];
    _DEF_XTO_TIME_END_TRUE(_devOpr, _Key_Status);

}




-(void)timeout{
    
    
    if (_devOpr == _Key_Status &&
        (nil != _cloudDelegate) &&
        [_cloudDelegate respondsToSelector:@selector(cloud:status:err:)]) {
        
        NSString* topicStr = [MQTTCover serverStatusTopicWithAPNS:_apsn
                                                             luid:Key_CloudStatusID
                                                            other:Key_CloudStatusID];
        
        [[MQTT shareMQTT].packetManager removePacketManager:self withKey:topicStr];
        
        [_cloudDelegate cloud:self status:XAICloudStatus_UNKown err:XAI_ERROR_TIMEOUT];
        
    }
    
    [super timeout];
}


@end
