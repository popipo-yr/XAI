//
//  XAILogin.h
//  XAI
//
//  Created by touchhy on 14-4-8.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAITimeOut.h"
#import "MQTT.h"
#import "XAIUserService.h"

@protocol XAILoginDelegate <NSObject>

- (void)  loginFinishWithStatus:(BOOL) status isTimeOut:(BOOL)bTimeOut;

@end

@interface XAILogin : XAITimeOut <MQTTConnectDelegate,XAIUserServiceDelegate>{


    NSString*  _name;
    NSString*  _pawd;
    XAIUserService* _userService;
    
    NSString* _ip;
    XAITYPEAPSN _apsn;
    
    BOOL _isLogin ;


}

@property (nonatomic,weak) id <XAILoginDelegate> delegate;


- (void) relogin;
- (void) loginWithName:(NSString*)name Password:(NSString*)password Host:(NSString*)host apsn:(XAITYPEAPSN)apsn;

@end
