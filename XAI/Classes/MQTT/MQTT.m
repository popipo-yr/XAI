//
//  MQTT.m
//  XAI
//
//  Created by touchhy on 14-4-8.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "MQTT.h"

@implementation MQTT


static MQTT*  _MQTTSTATIC = NULL;

+ (MQTT*) shareMQTT{
    
    if (NULL == _MQTTSTATIC) {
        
        _MQTTSTATIC = [[MQTT alloc] init];
        _MQTTSTATIC.client = NULL;
        _MQTTSTATIC.packetManager = NULL;
    }

    return _MQTTSTATIC;
    
}

@end
