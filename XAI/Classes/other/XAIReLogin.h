//
//  XAIReLogin.h
//  XAI
//
//  Created by office on 14-6-12.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XAILogin.h"
#import "XAIUserService.h"
#import "XAIDeviceService.h"
#import "XAIScanVC.h"
#import "XAIIPHelper.h"

typedef enum XAIReLoginErr{
    
    XAIReLoginErr_NONE  = 0,
    XAIReLoginErr_GetRouteIP_Fail,
    XAIReLoginErr_LoginFail,
    XAIReLoginErr_GetDataFail,
    XAIReLoginErr_UnKown

}XAIReLoginErr;

@protocol XAIReLoginDelegate ;
@interface XAIReLogin : NSObject
<XAILoginDelegate,XAIDeviceServiceDelegate,XAIUserServiceDelegate,XAIIPHelperDelegate>{
    
    
    XAILogin*  _login;
    XAIIPHelper* _IPHelper;
    
    XAIUserService* _userService;
    XAIDeviceService* _devService;
    
    BOOL _bRetry;
    
    int _findUser;
    int _findDev;
}

@property (nonatomic,weak) id<XAIReLoginDelegate> delegate;

- (void) relogin;
- (void) stop;
- (void) start;


@end


@protocol XAIReLoginDelegate <NSObject>

-(void)XAIRelogin:(XAIReLogin*)reLogin loginErrCode:(XAIReLoginErr)err;

@end


