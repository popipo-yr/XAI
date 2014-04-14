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

    NSMutableArray*  oldAry = [_delegates objectForKey:key];
    
    if (nil == oldAry) {
        
        oldAry = [[NSMutableArray alloc] init];
    }
    
    [oldAry addObject:aPro];
    
    [_delegates setObject:oldAry forKey:key];
}

- (void) removePacketManager: (id<MQTTPacketManagerDelegate>) aPro  withKey:(NSString*)key{

    NSMutableArray*  oldAry = [_delegates objectForKey:key];
    
    if (nil == oldAry) return;
    

    [oldAry removeObject:aPro];

}

#pragma mark -----------------------
#pragma mark MosquittoClientDelegate

- (void) didReceiveMessage:(MosquittoMessage*) mosq_msg {
    
    NSMutableArray*  delegeteAry  = [_delegates objectForKey:mosq_msg.topic];
    
    for (int i = 0; i < [delegeteAry count]; i++) {
        
        id<MQTTPacketManagerDelegate> apro = [delegeteAry objectAtIndex:i];
        if (apro != NULL
            && [apro conformsToProtocol:@protocol(MQTTPacketManagerDelegate)]
            && [apro respondsToSelector:@selector(recivePacket:size:topic:)]) {
            
            [apro recivePacket:[mosq_msg getPayloadbyte] size:mosq_msg.payloadlen topic:mosq_msg.topic];
        }
        

    }
    
    
    
}

- (void) didConnect:(NSUInteger)code {
    
    [_connectDelegate didConnect:code];
}

- (void) didDisconnect {
    
    [_connectDelegate didDisconnect];
}




- (void) didPublish: (NSUInteger)messageId {}
- (void) didSubscribe: (NSUInteger)messageId grantedQos:(NSArray*)qos {}
- (void) didUnsubscribe: (NSUInteger)messageId {}


@end
