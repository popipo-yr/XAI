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

@interface MQTT : NSObject


@property (nonatomic, weak) MQTTPacketManager* packetManager;
@property (nonatomic, weak) MosquittoClient* client;


+ (MQTT*) shareMQTT;


@end
