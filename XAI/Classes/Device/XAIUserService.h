//
//  XAIUserService.h
//  XAI
//
//  Created by office on 14-4-11.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQTT.h"
#import "XAIUser.h"

#import "XAIDevice.h"


@protocol XAIUserServiceDelegate <XAIDeviceStatusDelegate>

@optional
- (void) findedUser:(BOOL) isFinded Luid:(XAITYPELUID) luid withName:(NSString*) name;
- (void) addUser:(BOOL) isSuccess;
- (void) delUser:(BOOL) isSuccess;
- (void) changeUserName:(BOOL) isSuccess;
- (void) changeUserPassword:(BOOL)isSuccess;

@optional
- (void) findedAllUser:(BOOL) isFinded users:(NSSet*) name;



@end


@interface XAIUserService : XAIDevice <MQTTPacketManagerDelegate>
{

    NSString* _usernameFind;
    BOOL findingAUser;
    __weak id <XAIUserServiceDelegate> _delegate;

}

@property (nonatomic,weak,setter = setDelegate:) id<XAIUserServiceDelegate> delegate;


- (void) addUser:(NSString*)uname Password:(NSString*)password;

- (void) delUser:(XAITYPELUID) uluid;

- (void) changeUser:(XAITYPELUID)uluid withName:(NSString*)newUsername;

- (void) changeUser:(XAITYPELUID)luid oldPassword:(NSString*)oldPassword to:(NSString*)newPassword;



- (void) finderUserLuidHelper:(NSString*)username;

- (void) finderAllUser;

@end
