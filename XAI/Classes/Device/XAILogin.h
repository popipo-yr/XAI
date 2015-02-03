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


typedef NS_ENUM(NSUInteger, XAILoginErr){

    XAILoginErr_None,
    XAILoginErr_UPErr,
    XAILoginErr_TimeOut,
    XAILoginErr_CloudOff,
    XAILoginErr_CloudUnkown,
    XAILoginErr_UnKnow
};

@protocol XAILoginDelegate <NSObject>

- (void)  loginFinishWithStatus:(BOOL) status loginErr:(XAILoginErr)err;

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

- (void) relogin:(NSString*)host needCheckCloud:(BOOL)bNeed;
- (void) loginWithName:(NSString*)name Password:(NSString*)password Host:(NSString*)host apsn:(XAITYPEAPSN)apsn needCheckCloud:(BOOL)bNeed;;

@end
