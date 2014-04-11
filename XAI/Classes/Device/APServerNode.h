//
//  APServer.h
//  XAI
//
//  Created by office on 14-4-9.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQTT.h"

@interface APServerNode : NSObject


- (void) addUser:(NSString*)username Password:(NSString*)password;

//- (void) delUser:(XAITYPELUID) luid;
//- (void) changeUser:(XAITYPELUID)luid withName:(NSString*)newUsername;
//- (void) changeUser:(XAITYPELUID)luid oldPassword:(NSString*)oldPassword to:(NSString*)newPassword;
//
//- (void) addDev:(XAITYPELUID)luid  withName:(NSString*)devName;
//- (void) delDev:(XAITYPELUID)luid;
//- (void) changeDev:(XAITYPELUID)luid withName:(NSString*)newName;

@end
