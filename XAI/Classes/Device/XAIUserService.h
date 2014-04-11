//
//  XAIUserService.h
//  XAI
//
//  Created by office on 14-4-11.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQTT.h"



@interface XAIUserService : NSObject <MQTTPacketManagerDelegate>

- (void) addUser:(NSString*)username Password:(NSString*)password;

- (void) delUser:(XAITYPELUID) luid;
- (void) changeUser:(XAITYPELUID)luid withName:(NSString*)newUsername;
- (void) changeUser:(XAITYPELUID)luid oldPassword:(NSString*)oldPassword to:(NSString*)newPassword;


@end
