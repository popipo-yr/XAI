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
- (void) didDisconnect:(NSUInteger)code ;
@end


@interface MQTTPacketManager : NSObject <MosquittoClientDelegate>{
    
    NSMutableDictionary*  _delegates;
    NSMutableArray*  _allDelegate;
    
    NSMutableArray* _forceRemove;
    NSMutableArray* _normalRemove;
    NSMutableArray* _normalAdd;
    
    BOOL _isPostMsg;
}

@property (nonatomic, weak) id<MQTTConnectDelegate> connectDelegate;

- (void) addPacketManagerACK: (NSObject*) aPro;
- (void) addPacketManager: (NSObject*) aPro  withKey:(NSString*)key;




- (void) removePacketManagerACK: (NSObject*) aPro;
- (void) removePacketManager: (NSObject*) aPro  withKey:(NSString*)key;

/*force remove delegate*/
- (void) forceRemovePacketManager:(NSObject*)aPro;

/*接受未被其他接受的报文*/
- (void) addPacketManagerNoAccept: (id<MQTTPacketManagerDelegate>) aPro;
- (void) removePacketManagerNoAccept: (id<MQTTPacketManagerDelegate>) aPro;

@end


@interface MQTTPacketManagerDelgInfo : NSObject{

    NSObject*  _refObj;
    int  _refrenceCount;
}

@property (nonatomic, strong) NSObject* refObj;
@property (nonatomic, assign) int refrenceCount;

@end
