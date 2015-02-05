//
//  XAIReLogin.m
//  XAI
//
//  Created by office on 14-6-12.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIReLogin.h"

#import "XAIData.h"
#import "XAIToken.h"

#import "XAIAppDelegate.h"


#import "Reachability.h"


#define findSuccess 1
#define findFail   2
#define findStart  0


@implementation XAIReLogin


-(id)init{

    if (self = [super init]) {
        
        _login = [[XAILogin alloc] init];
        _bRetry = false;
    }
    
    return self;
}


-(void)dealloc{

    _login.delegate = nil;
}

- (void) stop{
    
    _userService.userServiceDelegate = nil;
    _userService = nil;
    _devService.deviceServiceDelegate = nil;
    _devService = nil;
    _login.delegate = nil;
    
}
- (void) start{
    
    _bRetry = false;
}

- (void) relogin{


    //[_IPHelper getApserverIpWithApsn:[MQTT shareMQTT].apsn fromRoute:_Macro_Host];
    NSString*  apsnStr = [MQTTCover apsnToString:[MQTT shareMQTT].apsn];
    if (apsnStr.length == 10) {
        
        apsnStr = [apsnStr substringFromIndex:2];
        NSString* host = [NSString stringWithFormat:@"%@.xai.so",apsnStr];
        
        
        XSLog(@"name =%@ , pwd = %@",[MQTT shareMQTT].curUser.name , [MQTT shareMQTT].curUser.pawd);
        _login.delegate = self;
        
        NSString* nameWithAPSN = [NSString stringWithFormat:@"%@@%@"
                                  ,[MQTT shareMQTT].curUser.name,
                                  [MQTTCover apsnToString:[MQTT shareMQTT].apsn]];
        
        XAIAppDelegate *appDelegate = (XAIAppDelegate*)[UIApplication sharedApplication].delegate;
        [appDelegate changeMQTTClinetID:nameWithAPSN apsn:[MQTT shareMQTT].apsn];
        
        
        [_login relogin:host needCheckCloud:false];

    }else{
    
        [self overWithCide:XAIReLoginErr_GetRouteIP_Fail];
    }
}


- (void) pushToken{
    
    void* token = malloc(TokenSize+20);
    memset(token, 0, TokenSize);
    
    BOOL bl = [XAIToken getToken:&token size:NULL];
    
    if (bl) {
        
        [_userService pushToken:token size:TokenSize isBufang:[MQTT shareMQTT].isBufang];
    }
    
    free(token);
    
    
}


#pragma mark - Delegate

- (void) userService:(XAIUserService *)userService findedAllUser:(NSSet *)users status:(BOOL)isSuccess errcode:(XAI_ERROR)errcode{
    
    _userService.delegate = nil;
    
    _findUser =  isSuccess ? findSuccess : findFail;
    
    if (isSuccess) {
        
        /*存储数据 其他页面使用*/
        NSArray* userAry = [users allObjects];
        [[XAIData shareData] setUserList:userAry];
        
    }
    
    [self pushToken];
    [self getDateFinsh];
    
}


- (void)devService:(XAIDeviceService *)devService findedAllDevice:(NSArray *)devAry status:(BOOL)isSuccess errcode:(XAI_ERROR)errcode{

    _devService.delegate = nil;
    _findDev =  isSuccess ? findSuccess : findFail;
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        /*存储数据 其他页面使用*/
//        if (isSuccess) [[XAIData shareData] setObjList:devAry];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self getDateFinsh];
//        });
//    });
    
    if (isSuccess) {
        /*存储数据 其他页面使用*/
        [[XAIData shareData] setObjList:devAry];
    }
    
    [self getDateFinsh];
}

- (void)loginFinishWithStatus:(BOOL)status loginErr:(XAILoginErr)err{
    
    _login.delegate = nil;
    
    if (status) {
        
        
        
        _findDev = findStart;
        _findUser = findStart;
        
        /*获取设备列表,和用户列表*/
        _devService = [[XAIDeviceService alloc] initWithApsn:[MQTT shareMQTT].apsn Luid:MQTTCover_LUID_Server_03];
        _userService = [[XAIUserService alloc] initWithApsn:[MQTT shareMQTT].apsn Luid:MQTTCover_LUID_Server_03];
        _devService.deviceServiceDelegate = self;
        _userService.userServiceDelegate = self;
        
        
        
        [_userService finderAllUser];
        [_devService findAllDev];
        
    }else{
        
        [self overWithCide:XAIReLoginErr_LoginFail];
    }
    
    
    
}


- (void) getDateFinsh{
    
    
    XAIReLoginErr  err = XAIReLoginErr_NONE;
    
    
    if (_findUser == findStart || _findDev == findStart) return;
    
    if (_findDev == findFail || _findUser == findFail) {
        
        err = XAIReLoginErr_GetDataFail;
        
    }
    
    [self overWithCide:err];
    
}

- (void)overWithCide:(XAIReLoginErr)err{
    
    if (_bRetry == false && err != XAIReLoginErr_NONE) {  /*再进行一次*/
        
        [self relogin];
        _bRetry = true;
        return;
    }

    if (_delegate != nil && [_delegate respondsToSelector:@selector(XAIRelogin:loginErrCode:)]) {
        
        [_delegate XAIRelogin:self loginErrCode:err];
    }
    
    if (err != XAIReLoginErr_NONE) {

        XAIAppDelegate *appDelegate = (XAIAppDelegate*)[UIApplication sharedApplication].delegate;
        [appDelegate changeMQTTClinetID:nil apsn:0];
        
        [MQTT shareMQTT].isLogin = false;
    }
    
    _bRetry = false;
}

@end

