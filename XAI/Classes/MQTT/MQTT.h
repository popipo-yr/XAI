//
//  MQTT.h
//  XAI
//
//  Created by touchhy on 14-4-8.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XAIMQTTDEF.h"
#import "MQTTCover.h"
#import "MosquittoClient.h"
#import "MQTTPacketManager.h"
#import "XAIUser.h"

//@class XAIUser;
@interface MQTT : NSObject{

    
    XAITYPEAPSN _apsn;
    XAITYPELUID _luid;
    
    BOOL _isLogin;

}

@property (nonatomic,assign) BOOL isLogin;

@property (nonatomic, strong) MQTTPacketManager* packetManager;
@property (nonatomic, strong) MosquittoClient* client;

@property (nonatomic, assign) XAITYPEAPSN apsn;
@property (nonatomic, assign) XAITYPELUID luid;
//@property (nonatomic, strong) NSString* curUserName;
@property (nonatomic, strong) XAIUser* curUser;

@property (nonatomic, assign) BOOL isFromRoute; /*yes 就不是指连*/
@property (nonatomic, assign) BOOL isBufang;

@property (nonatomic, assign) XAITYPEAPSN tmpApsn;


+ (MQTT*) shareMQTT;


@end
