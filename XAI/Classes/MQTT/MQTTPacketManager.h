//
//  MQTTPacketManager.h
//  XAI
//
//  Created by mac on 14-4-7.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MosquittoClient.h"
@protocol MQTTPacketManagerDelegate <NSObject>

@optional

- (void) didPublish: (NSUInteger)messageId;
- (void) didSubscribe: (NSUInteger)messageId grantedQos:(NSArray*)qos;
- (void) didUnsubscribe: (NSUInteger)messageId;

- (void) sendPacketIsSuccess:(BOOL) bl;
- (void) recivePacket:(void*)datas size:(int)size topic:(NSString*)topic;

@end


@protocol MQTTConnectDelegate <NSObject>

@optional

- (void) didConnect:(NSUInteger)code ;
- (void) didDisconnect;
@end


@interface MQTTPacketManager : NSObject <MosquittoClientDelegate>{
    
    NSMutableDictionary*  _delegates;
    
}

@property (nonatomic, weak) id<MQTTConnectDelegate> connectDelegate;

- (void) addPacketManager: (id<MQTTPacketManagerDelegate>) aPro  withKey:(NSString*)key;
- (void) removePacketManager: (id<MQTTPacketManagerDelegate>) aPro  withKey:(NSString*)key;

@end
