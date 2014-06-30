//
//  XAILogin.m
//  XAI
//
//  Created by touchhy on 14-4-8.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILogin.h"
#import "XAIToken.h"
#import "XAIPacketStatus.h"
//#include "openssl/ssl.h"

@implementation XAILogin

#pragma mark Outer methods

- (void) loginWithName:(NSString*)name Password:(NSString*)password Host:(NSString*)host apsn:(XAITYPEAPSN)apsn{
    
    _ip = host;
    _apsn = apsn;
    _isLogin = true;

    MosquittoClient*  mosq = [MQTT shareMQTT].client;

    //host = @"192.168.1.1";
    //name = @"admin@0x00000001";
    //password = @"admin";
    
    _name = name;
    _pawd = password;
    
    NSString* nameWithAPSN = [NSString stringWithFormat:@"%@@%@",name,[MQTTCover apsnToString:apsn]];
    
	[mosq setHost: host];
    [mosq setUsername:nameWithAPSN];
    [mosq setPassword:password];
    [mosq setPort:9001];	
    
    [[MQTT shareMQTT].packetManager setConnectDelegate:self];
    
    //[MQTT shareMQTT].apsn = apsn;
    
    [mosq connect];
    
    _DEF_XTO_TIME_Start;
    
}

#pragma mark -- MQTTConnectDelegate

- (void) didConnect:(NSUInteger)code {
	
    if (!_isLogin) return;
    
    _userService.apsn = _apsn;
    [_userService finderUserLuidHelper:_name];
    
    _DEF_XTO_TIME_End;
    
}

- (void) didDisconnect {
    
     if (!_isLogin) return;
	
    if ( (nil != _delegate) && [_delegate respondsToSelector:@selector(loginFinishWithStatus:isTimeOut:)]) {
        
        [_delegate loginFinishWithStatus:false isTimeOut:false];
    }
    
    _DEF_XTO_TIME_End;

}

-(void)timeout{
    
    [_timeout invalidate];
    _timeout = nil;

    if ( (nil != _delegate) && [_delegate respondsToSelector:@selector(loginFinishWithStatus:isTimeOut:)]) {
        
        [_delegate loginFinishWithStatus:false isTimeOut:true];
    }
    
    [[MQTT shareMQTT].client disconnect];
    [[MQTT shareMQTT].packetManager setConnectDelegate:nil];
}




#pragma mark -- XAIUserSerciveDelegate

- (void) userService:(XAIUserService *)userService findedUser:(XAITYPELUID)luid
            withName:(NSString *)name status:(BOOL)isSuccess errcode:(XAI_ERROR)errcode{
    
    void* token = malloc(TokenSize);
    memset(token, 0, TokenSize);

    BOOL bl = [XAIToken getToken:&token size:NULL];
    
    if (bl && (YES == isSuccess) &&  [name isEqualToString:_name]) {
        
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

        
        /*订阅主题*/
        [curMQTT.client subscribe:[MQTTCover serverStatusTopicWithAPNS:curMQTT.apsn
                                                                  luid:MQTTCover_LUID_Server_03]];
        
        
        [curMQTT.client subscribe:[MQTTCover mobileCtrTopicWithAPNS:curMQTT.apsn luid:curMQTT.luid]];
        
        
        [_userService pushToken:token size:TokenSize user:luid];
        
    }else{
        
        _isLogin = false;
        if ( (nil != _delegate) && [_delegate respondsToSelector:@selector(loginFinishWithStatus:isTimeOut:)]) {
            
            [_delegate loginFinishWithStatus:false isTimeOut:false];
        }
    }
    
    free(token);

}

-(void)userService:(XAIUserService *)userService pushToken:(BOOL)isSuccess errcode:(XAI_ERROR)errcode{

    if ((YES == isSuccess) &&  (errcode == XAI_ERROR_NONE)) {
        
        MQTT* curMQTT = [MQTT shareMQTT];
        curMQTT.isLogin = true;
        
    }
    
    if ( (nil != _delegate) && [_delegate respondsToSelector:@selector(loginFinishWithStatus:isTimeOut:)]) {
        
        [_delegate loginFinishWithStatus:isSuccess isTimeOut:false];
    }

    _isLogin = false;
}


#pragma mark -- Other

- (id) init{

    if (self = [super init]) {
        
        _userService = [[XAIUserService alloc] init];
        _userService.luid = MQTTCover_LUID_Server_03;
        _userService.userServiceDelegate = self;
        
        //_name = [[NSMutableString alloc] init];
        _isLogin =false;
        
    }
    
    return self;
}

- (void)dealloc{

    _userService.userServiceDelegate = NULL;

}

@end
