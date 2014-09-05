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
        
        _IPHelper = [[XAIIPHelper alloc] init];
        
        _login = [[XAILogin alloc] init];
        _bRetry = false;
    }
    
    return self;
}


-(void)dealloc{

    _IPHelper.delegate = nil;
    _login.delegate = nil;
}

- (void) stop{
    
    _userService.userServiceDelegate = nil;
    _userService = nil;
    _devService.deviceServiceDelegate = nil;
    _devService = nil;
    _IPHelper.delegate = nil;
    _login.delegate = nil;
    
}
- (void) start{
    
    _bRetry = false;
}

- (void) relogin{

    _IPHelper.delegate = self;

    [_IPHelper getApserverIpWithApsn:[MQTT shareMQTT].apsn fromRoute:_Macro_Host];
}


-(void)xaiIPHelper:(XAIIPHelper *)helper getIp:(NSString *)ip errcode:(_err)rc{
   
    _IPHelper.delegate = nil;
    
    if (rc == _err_none) {

        if (helper.getStep == _XAIIPHelper_GetStep_FromRoute) {
            [MQTT shareMQTT].isFromRoute = true;
        }else{
            [MQTT shareMQTT].isFromRoute = false;
        }
        
        XSLog(@"name =%@ , pwd = %@",[MQTT shareMQTT].curUser.name , [MQTT shareMQTT].curUser.pawd);
        _login.delegate = self;
        
        NSString* nameWithAPSN = [NSString stringWithFormat:@"%@@%@"
                                  ,[MQTT shareMQTT].curUser.name,
                                  [MQTTCover apsnToString:[MQTT shareMQTT].apsn]];
        
        XAIAppDelegate *appDelegate = (XAIAppDelegate*)[UIApplication sharedApplication].delegate;
        [appDelegate changeMQTTClinetID:nameWithAPSN];
        
        
        [_login relogin:ip];
        
    }else{
        /*提示获取失败 返回登录页面*/
        
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

- (void) devService:(XAIDeviceService *)devService finddedAllOnlineDevices:(NSSet *)devs status:(BOOL)isSuccess errcode:(XAI_ERROR)errcode{
    
//    _findDev =  isSuccess ? findSuccess : findFail;
//    
//    if (isSuccess) {
//        
//        /*存储数据 其他页面使用*/
//        [[XAIData shareData] setObjList:[devs allObjects]];
//        
//    }
//    
//    
//    [self getDateFinsh];
    
}

- (void)devService:(XAIDeviceService *)devService findedAllDevice:(NSArray *)devAry status:(BOOL)isSuccess errcode:(XAI_ERROR)errcode{

    _devService.delegate = nil;
    _findDev =  isSuccess ? findSuccess : findFail;
    
    if (isSuccess) {
        /*存储数据 其他页面使用*/
        [[XAIData shareData] setObjList:devAry];
    }
    
    [self getDateFinsh];
}

- (void)loginFinishWithStatus:(BOOL)status isTimeOut:(BOOL)bTimeOut{
    
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
        //[_devService findAllOnlineDevWithuseSecond:2];
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
        [MQTT shareMQTT].isLogin = false;
        
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
    
    if (err == XAIReLoginErr_NONE) {
//        uint8_t isOnline = 1;
//        XAIUser* curUser = [MQTT shareMQTT].curUser;
//        [[MQTT shareMQTT].client publish:&isOnline
//                                    size:1
//                                 toTopic:[MQTTCover mobileStatusTopicWithAPNS:curUser.apsn
//                                                                         luid:curUser.luid
//                                                                        other:0x7f]
//                                 withQos:2
//                                  retain:true];
        
        
//        XAIUser* curUser = [MQTT shareMQTT].curUser;
//
//        
//        [[MQTT shareMQTT].client publish:NULL
//                                    size:0
//                                 toTopic:[MQTTCover mobileCtrTopicWithAPNS:curUser.apsn
//                                                                         luid:curUser.luid
//                                                                    ]
//                                 withQos:0
//                                  retain:true];
    }
    
    _bRetry = false;
}

@end

