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


@end


@interface XAIUserService : NSObject <MQTTPacketManagerDelegate>
{

    NSString* _usernameFind;
}

@property (nonatomic,weak) id<XAIUserServiceDelegate> delegate;

- (void) addUser:(NSString*)username Password:(NSString*)password apsn:(XAITYPEAPSN) apsn;

- (void) delUser:(XAITYPELUID) luid apsn:(XAITYPEAPSN) apsn;
- (void) changeUser:(XAITYPELUID)luid withName:(NSString*)newUsername apsn:(XAITYPEAPSN) apsn;
- (void) changeUser:(XAITYPELUID)luid oldPassword:(NSString*)oldPassword to:(NSString*)newPassword apsn:(XAITYPEAPSN) apsn;



- (void) finderUserLuidHelper:(NSString*)username apsn:(XAITYPEAPSN) apsn;

@end
