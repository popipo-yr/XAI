//
//  MQTT.m
//  XAI
//
//  Created by touchhy on 14-4-8.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "MQTT.h"

@implementation MQTT


#define _K_Bufang @"_K_Bufang"


static MQTT*  _MQTTSTATIC = NULL;

+ (MQTT*) shareMQTT{
    
    if (NULL == _MQTTSTATIC) {
        
        _MQTTSTATIC = [[MQTT alloc] init];
        _MQTTSTATIC.client = NULL;
        _MQTTSTATIC.packetManager = NULL;
        _MQTTSTATIC.isLogin = false;
        _MQTTSTATIC.isFromRoute = true;
       
    }

    return _MQTTSTATIC;
    
}

-(id)init{

    if (self = [super init]) {
       
         self.isBufang  = [[NSUserDefaults standardUserDefaults] boolForKey:_K_Bufang];
    }
    
    return self;
}

-(void)setIsBufang:(BOOL)isBufang{

    [[NSUserDefaults standardUserDefaults] setBool:isBufang forKey:_K_Bufang];
    _isBufang = isBufang;
    
}

@end
