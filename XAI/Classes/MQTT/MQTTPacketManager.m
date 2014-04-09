//
//  MQTTPacketManager.m
//  XAI
//
//  Created by mac on 14-4-7.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "MQTTPacketManager.h"

@implementation MQTTPacketManager

- (id) init{

    if (self = [super init]) {
        
        _delegates = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void) addPacketManager: (id<MQTTPacketManagerDelegate>) aPro withKey:(NSString*)key{

}

#pragma mark -----------------------
#pragma mark MosquittoClientDelegate

- (void) didReceiveMessage:(MosquittoMessage*) mosq_msg {
    
    
    id<MQTTPacketManagerDelegate> apro = [_delegates objectForKey:mosq_msg.topic];
    if (apro != NULL) {
        
        [apro recivePacket:[mosq_msg getPayloadbyte] size:mosq_msg.payloadlen];
    }
    
}

- (void) didConnect:(NSUInteger)code {
}

- (void) didDisconnect {
}




- (void) didPublish: (NSUInteger)messageId {}
- (void) didSubscribe: (NSUInteger)messageId grantedQos:(NSArray*)qos {}
- (void) didUnsubscribe: (NSUInteger)messageId {}


@end
