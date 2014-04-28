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
    NSMutableArray*  _allDelegate;
    
}

@property (nonatomic, weak) id<MQTTConnectDelegate> connectDelegate;

- (void) addPacketManagerACK: (id<MQTTPacketManagerDelegate>) aPro;
- (void) addPacketManager: (id<MQTTPacketManagerDelegate>) aPro  withKey:(NSString*)key;




- (void) removePacketManagerACK: (id<MQTTPacketManagerDelegate>) aPro;
- (void) removePacketManager: (id<MQTTPacketManagerDelegate>) aPro  withKey:(NSString*)key;

/*force remove delegate*/
- (void) forceRemovePacketManager:(id<MQTTPacketManagerDelegate>)aPro;

/*接受所有的报文*/
//- (void) addPacketManagerAll: (id<MQTTPacketManagerDelegate>) aPro;
//- (void) removePacketManagerAll: (id<MQTTPacketManagerDelegate>) aPro;

@end


@interface MQTTPacketManagerDelgInfo : NSObject{

    id <MQTTPacketManagerDelegate>  _refObj;
    int  _refrenceCount;
}

@property (nonatomic, strong) id <MQTTPacketManagerDelegate> refObj;
@property (nonatomic, assign) int refrenceCount;

@end
