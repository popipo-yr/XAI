//
//  XAILogin.m
//  XAI
//
//  Created by touchhy on 14-4-8.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILogin.h"
#import "XAIPacketStatus.h"
//#include "openssl/ssl.h"

@implementation XAILogin

- (void) loginWithName:(NSString*)name Password:(NSString*)password Host:(NSString*)host{

    MosquittoClient*  mosq = [MQTT shareMQTT].client;

    host = @"192.168.1.1";
    name = @"admin@0x00000001";
    password = @"admin";
    
    [_name setString:name];
    
    
	[mosq setHost: host];
    [mosq setUsername:name];
    [mosq setPassword:password];
    [mosq setPort:9001];	
    
    [[MQTT shareMQTT].packetManager setConnectDelegate:self];
    
    [mosq connect];

}

- (void) didConnect:(NSUInteger)code {
	
    
    [_userService finderUserLuidHelper:@"admin" apsn:[MQTT shareMQTT].apsn];
    
}

- (void) didDisconnect {
	
    if ( (nil != _delegate) && [_delegate respondsToSelector:@selector(loginFinishWithStatus:)]) {
        
        [_delegate loginFinishWithStatus:false];
    }

}

#pragma mark -------------
#pragma makr PacketPro


- (void) recivePacket:(void*)datas size:(int)size topic:topic{
    
    //test.....
    
    
//    switch (ack->scid) {
//        case AddUserID:{
//            
//            if (ack->err_no == 0) {
//                
//            }else{
//                
//                NSLog(@"FAILD ADD USER ");
//            }
//            
//            [[MQTT shareMQTT].packetManager removePacketManager:self withKey:topic];
//        }
//            
//            break;
//            
//        default:
//            break;
//    }
    
    
    NSLog(@"anc");
    
}

#pragma mark -- XAIUserSerciveDelegate
- (void) findedUser:(BOOL)isFinded Luid:(XAITYPELUID)luid withName:(NSString *)name{

    
    
    if ((YES == isFinded) &&  [name isEqualToString:_name]) {
        
        [MQTT shareMQTT].luid = luid;
        
    }
    
    if ( (nil != _delegate) && [_delegate respondsToSelector:@selector(loginFinishWithStatus:)]) {
        
        [_delegate loginFinishWithStatus:isFinded];
    }

    

}


- (id) init{

    if (self = [super init]) {
        
        _userService = [[XAIUserService alloc] init];
        _userService.delegate = self;
        
        _name = [[NSMutableString alloc] init];
        
    }
    
    return self;
}

- (void)dealloc{

    _userService.delegate = NULL;

}

@end
