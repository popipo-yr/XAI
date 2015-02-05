//
//  XAILogin.m
//  XAI
//
//  Created by touchhy on 14-4-8.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILogin.h"
#import "XAIToken.h"
#import "XAIAlert.h"
#import "XAIPacketStatus.h"
#include "mqtt3_protocol.h"

//#include "openssl/ssl.h"

@implementation XAILogin

#pragma mark Outer methods

- (void) loginWithName:(NSString*)name Password:(NSString*)password Host:(NSString*)host apsn:(XAITYPEAPSN)apsn needCheckCloud:(BOOL)bNeed{
    
    _ip = host;
    _apsn = apsn;
    _name = name;
    _pawd = password;
    
    _isLogin = true;

    MosquittoClient*  mosq = [MQTT shareMQTT].client;

    
    NSString* nameWithAPSN = [NSString stringWithFormat:@"%@@%@",name,[MQTTCover apsnToString:apsn]];
    
	[mosq setHost: host];
    [mosq setUsername:nameWithAPSN];
    [mosq setPassword:password];
    [mosq setPort:9001];	
    
    [[MQTT shareMQTT].packetManager setConnectDelegate:self];
    
    //[mosq setWillB:0 toTopic:[MQTTCover mobileAllCtrTopicWithAPNS:apsn] withQos:2 retain:true];
    
    [mosq connect];
    
    _DEF_XTO_TIME_Start;
    
}


- (void) relogin:(NSString *)host needCheckCloud:(BOOL)bNeed{

    _isLogin = true;

    MosquittoClient*  mosq = [MQTT shareMQTT].client;
    
    _name = [MQTT shareMQTT].curUser.name;
    _apsn = [MQTT shareMQTT].apsn;
    _pawd = [MQTT shareMQTT].curUser.pawd;

    
    NSString* nameWithAPSN = [NSString stringWithFormat:@"%@@%@",_name,[MQTTCover apsnToString:_apsn]];
    
	[mosq setHost:host];
    [mosq setUsername:nameWithAPSN];
    [mosq setPassword:_pawd];
    [mosq setPort:9001];
    
    [[MQTT shareMQTT].packetManager setConnectDelegate:self];
    
    
    [mosq connect];
    

    _DEF_XTO_TIME_Start;

}

#pragma mark -- MQTTConnectDelegate

- (void) didConnect:(NSUInteger)code {
	
    if (!_isLogin) return;
    
    if (code == CONNACK_ACCEPTED) {
        
        [[XAIAlert shareAlert] startFocus];
        [[MQTT shareMQTT].packetManager setConnectDelegate:nil];
        
        _userService.apsn = _apsn;
        [_userService finderUserLuidHelper:_name];
        
    }else{
        
        
        [self loginOver:code == CONNACK_REFUSED_BAD_USERNAME_PASSWORD
                        ? XAILoginErr_UPErr : XAILoginErr_UnKnow];
    }
    
    _DEF_XTO_TIME_End;
    
}

- (void) didDisconnect:(NSUInteger)code {
    
     if (!_isLogin) return;
    
    [[XAIAlert shareAlert] stop];
    
    
    XAILoginErr loginErr = XAILoginErr_UnKnow;
    if (code ==  7 /*SSL_ERROR_WANT_CONNECT*/) {
        loginErr = XAILoginErr_UPErr;
    }

    [self loginOver:loginErr];

    
    _DEF_XTO_TIME_End;

}

-(void)timeout{
    
    [_timeout invalidate];
    _timeout = nil;

    [self loginOver:XAILoginErr_TimeOut];
}


-(void)loginOver:(XAILoginErr)err{
    
    _isLogin = false;
    [[MQTT shareMQTT].packetManager setConnectDelegate:nil];

    if (nil != _delegate && [_delegate respondsToSelector:@selector(loginFinishWithStatus:loginErr:)]){
        
        [_delegate loginFinishWithStatus:err == XAILoginErr_None
                                loginErr:err];
    }
}



#pragma mark -- XAIUserSerciveDelegate

- (void) userService:(XAIUserService *)userService findedUser:(XAITYPELUID)luid
            withName:(NSString *)name status:(BOOL)isSuccess errcode:(XAI_ERROR)errcode{
    
    XAILoginErr loginErr = XAILoginErr_UnKnow;
    
    if ( (YES == isSuccess) &&  [name isEqualToString:_name]) {
        
        MQTT* curMQTT = [MQTT shareMQTT];
        
        curMQTT.luid = luid;
        curMQTT.apsn = _apsn;
        
        
        /*设置当前用户*/
        XAIUser* user = [[XAIUser alloc] init];
        user.luid = luid;
        user.apsn = _apsn;
        user.name = _name;
        user.pawd = _pawd;
        
        curMQTT.curUser = user;
        
        loginErr = XAILoginErr_None;
        
    }else if(errcode == XAI_ERROR_TIMEOUT){
    
        loginErr = XAILoginErr_TimeOut;
        
    }else{
    
        loginErr = XAILoginErr_UPErr;
    }
    
    
    [self loginOver:loginErr];
    
}


#pragma mark -- Other

- (id) init{

    if (self = [super init]) {
        
        _userService = [[XAIUserService alloc] init];
        _userService.luid = MQTTCover_LUID_Server_03;
        _userService.userServiceDelegate = self;
        
        _isLogin =false;
        
    }
    
    return self;
}

- (void)dealloc{

    _userService.userServiceDelegate = nil;

}

@end
