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


@class XAIUser;
@interface MQTT : NSObject{

    
    XAITYPEAPSN _apsn;
    XAITYPELUID _luid;

}


@property (nonatomic, weak) MQTTPacketManager* packetManager;
@property (nonatomic, weak) MosquittoClient* client;

@property (nonatomic, assign) XAITYPEAPSN apsn;
@property (nonatomic, assign) XAITYPELUID luid;
//@property (nonatomic, strong) NSString* curUserName;
@property (nonatomic, strong) XAIUser* curUser;


+ (MQTT*) shareMQTT;


@end
