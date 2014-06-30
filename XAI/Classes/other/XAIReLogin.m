//
//  XAIReLogin.m
//  XAI
//
//  Created by office on 14-6-12.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIReLogin.h"

#import "XAIData.h"

#import "Reachability.h"


#define findSuccess 1
#define findFail   2
#define findStart  0


@implementation XAIReLogin


-(id)init{

    if (self = [super init]) {
        
        _IPHelper = [[XAIIPHelper alloc] init];
        
        _login = [[XAILogin alloc] init];
    }
    
    return self;
}


-(void)dealloc{

    _IPHelper.delegate = nil;
    _login.delegate = nil;
}


- (void) relogin{

    _IPHelper.delegate = self;

    [_IPHelper getApserverIpWithApsn:[MQTT shareMQTT].apsn fromRoute:_Macro_Host];
}


-(void)xaiIPHelper:(XAIIPHelper *)helper getIp:(NSString *)ip errcode:(_err)rc{
   
    _IPHelper.delegate = nil;
    
    if (rc == _err_none) {
        
        
        MQTT* curMQTT =  [MQTT shareMQTT];
        
        _login.delegate = self;
        [_login loginWithName:curMQTT.curUser.name Password:curMQTT.curUser.pawd Host:ip apsn:curMQTT.apsn];
        
    }else{
        /*提示获取失败 返回登录页面*/
        
        if (_delegate != nil && [_delegate respondsToSelector:@selector(XAIRelogin:loginErrCode:)]) {
            
            [_delegate XAIRelogin:self loginErrCode:XAIReLoginErr_GetRouteIP_Fail];
        }
        
    }
    

    
}



#pragma mark - Delegate

- (void) userService:(XAIUserService *)userService findedAllUser:(NSSet *)users status:(BOOL)isSuccess errcode:(XAI_ERROR)errcode{
    
    _userService.delegate = nil;
    
    _findUser =  isSuccess ? findSuccess : findFail;
    
    if (isSuccess) {
        
        /*存储数据 其他页面使用*/
        [[XAIData shareData] setUserList:[users allObjects]];
        
    }
    
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
        
        
        if (_delegate != nil && [_delegate respondsToSelector:@selector(XAIRelogin:loginErrCode:)]) {
            
            [_delegate XAIRelogin:self loginErrCode:XAIReLoginErr_LoginFail];
        }
    }
    
    
}


- (void) getDateFinsh{
    
    
    XAIReLoginErr  err = XAIReLoginErr_NONE;
    
    
    if (_findUser == findStart || _findDev == findStart) return;
    
    if (_findDev == findFail || _findUser == findFail) {
        
        err = XAIReLoginErr_GetDataFail;
        
    }
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(XAIRelogin:loginErrCode:)]) {
        
        [_delegate XAIRelogin:self loginErrCode:err];
    }

    
}

@end

