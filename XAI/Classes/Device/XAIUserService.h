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

@protocol XAIUserServiceDelegate;


@interface XAIUserService : XAIDevice <MQTTPacketManagerDelegate>
{

    NSString* _usernameFind;
    BOOL findingAUser;
}

@property (nonatomic,weak) id<XAIUserServiceDelegate> userServiceDelegate;


- (void) addUser:(NSString*)uname Password:(NSString*)password;

- (void) delUser:(XAITYPELUID) uluid;

- (void) changeUser:(XAITYPELUID)uluid withName:(NSString*)newUsername;

- (void) changeUser:(XAITYPELUID)luid oldPassword:(NSString*)oldPassword to:(NSString*)newPassword;


- (void) finderUserLuidHelper:(NSString*)username;

- (void) finderAllUser;


- (void) pushToken:(void*)token size:(size_t)size user:(XAITYPELUID)uluid;


@end

#pragma mark ------------------


@protocol XAIUserServiceDelegate <NSObject>

@optional

- (void) userService:(XAIUserService*)userService addUser:(BOOL) isSuccess errcode:(XAI_ERROR)errcode;
- (void) userService:(XAIUserService*)userService delUser:(BOOL) isSuccess errcode:(XAI_ERROR)errcode;
- (void) userService:(XAIUserService*)userService changeUserName:(BOOL) isSuccess errcode:(XAI_ERROR)errcode;
- (void) userService:(XAIUserService*)userService changeUserPassword:(BOOL)isSuccess errcode:(XAI_ERROR)errcode;
- (void) userService:(XAIUserService*)userService pushToken:(BOOL)isSuccess errcode:(XAI_ERROR)errcode;

- (void) userService:(XAIUserService*)userService findedUser:(XAITYPELUID)luid
            withName:(NSString*)name status:(BOOL)isSuccess errcode:(XAI_ERROR)errcode;

- (void) userService:(XAIUserService*)userService findedAllUser:(NSSet*)users
             status:(BOOL)isSuccess errcode:(XAI_ERROR)errcode;

@end

typedef NS_ENUM(NSUInteger,_XAIUserServiceOpr){
    
    XAIUserServiceOpr_add = __Dev_lastItem,
    XAIUserServiceOpr_del,
    XAIUserServiceOpr_changeName,
    XAIUserServiceOpr_changePSWD,
    XAIUserServiceOpr_findAll,
    XAIUserServiceOpr_find,
    XAIUserServiceOpr_push,
    __UserService_lastItem,
};