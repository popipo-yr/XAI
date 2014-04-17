//
//  MQTTPacketManager.m
//  XAI
//
//  Created by mac on 14-4-7.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "MQTTPacketManager.h"
#import "MQTT.h"
#import "MQTTCover.h"

@implementation MQTTPacketManager

- (id) init{

    if (self = [super init]) {
        
        _delegates = [[NSMutableDictionary alloc] init];
        _allDelegate = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void) addPacketManagerACK: (id<MQTTPacketManagerDelegate>) aPro{

    [self addPacketManager:aPro withKey:[MQTTCover mobileCtrTopicWithAPNS:[MQTT shareMQTT].apsn
                                                                     luid:[MQTT shareMQTT].luid]];

}

- (void) removePacketManagerACK: (id<MQTTPacketManagerDelegate>) aPro{

    
    
    [self removePacketManager:aPro withKey:[MQTTCover mobileCtrTopicWithAPNS:[MQTT shareMQTT].apsn
                                                                     luid:[MQTT shareMQTT].luid]];

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

- (void) addPacketManagerAll: (id<MQTTPacketManagerDelegate>) aPro{

    [_allDelegate addObject:aPro];
}


- (void) removePacketManagerAll:(id<MQTTPacketManagerDelegate>)aPro{

    [_allDelegate removeObject:aPro];
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
    
    /*通知接受全部的消息*/
    for (int i = 0; i < [_allDelegate count]; i++) {
        
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
