//
//  Light.h
//  XAI
//
//  Created by mac on 14-4-7.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQTT.h"



@protocol LightPro <NSObject>

- (void) onLightIsSucees:(BOOL)bl;
- (void) offLightIsSucees:(BOOL)bl;
- (void) currentLightStatus:(BOOL)bl;

@end


@interface LightNode : NSObject <MQTTPacketManagerDelegate>

@property  (weak) id <LightPro> delegate;

- (void) openLight;
- (void) closeLight;
- (void) getCurrentStatus;


@end
