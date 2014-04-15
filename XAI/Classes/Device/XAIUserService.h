//
//  XAIUserService.h
//  XAI
//
//  Created by office on 14-4-11.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQTT.h"

@protocol XAIUserServiceDelegate <NSObject>

- (void) findedUser:(BOOL) isFinded Luid:(XAITYPELUID) luid withName:(NSString*) name;
- (void) addUser:(BOOL) isSuccess;
- (void) delUser:(BOOL) isSuccess;
- (void) changeUserName:(BOOL) isSuccess;
- (void) changeUserPassword:(BOOL)isSuccess;



@end


@interface XAIUserService : NSObject <MQTTPacketManagerDelegate>
{

    NSString* _usernameFind;
}

@property (nonatomic,weak) id<XAIUserServiceDelegate> delegate;

- (void) addUser:(NSString*)uname Password:(NSString*)password apsn:(XAITYPEAPSN)apsn luid:(XAITYPELUID)luid;

- (void) delUser:(XAITYPELUID) uluid apsn:(XAITYPEAPSN) apsn luid:(XAITYPELUID)luid;

- (void) changeUser:(XAITYPELUID)uluid withName:(NSString*)newUsername
               apsn:(XAITYPEAPSN) apsn luid:(XAITYPELUID)luid;

- (void) changeUser:(XAITYPELUID)luid oldPassword:(NSString*)oldPassword to:(NSString*)newPassword
               apsn:(XAITYPEAPSN) apsn luid:(XAITYPELUID)luid;



- (void) finderUserLuidHelper:(NSString*)username apsn:(XAITYPEAPSN)apsn luid:(XAITYPELUID)luid;

@end
