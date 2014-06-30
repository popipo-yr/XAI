//
//  Login.m
//  XAI
//
//  Created by office on 14-4-9.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LoginPlugin.h"

#define _init  (-1)
#define _start 0
#define _suc   1
#define _fail  2

//#import "XAILogin.h"
//
//@interface LoginTest : XCTestCase <XAILoginDelegate>{
//
//    NSConditionLock* _lock;
//    int  _loginStatus;
//    BOOL _done;
//
//}
//
//- (void)loginFinishWithStatus:(BOOL)status;
//
//@end

@implementation LoginPlugin

#define _K_APSN  0x210e2813  //0x210e2813  0x210e2813  0x2923aeea
#define _K_HOST @"114.215.178.75" // @"192.168.1.1"  @"114.215.178.75" @"192.168.0.33"


- (void)setUp
{
    
    [super setUp];
    //[MQTT shareMQTT].apsn = 0x210e2813;
    [MQTT shareMQTT].apsn = _K_APSN;
    _loginStatus = _init;
    _loginStatus_normal = _init;
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)loginFinishWithStatus:(BOOL)status isTimeOut:(BOOL)bTimeOut{

    if (_loginStatus == _start) {
        
        if (status == TRUE) {
            
            _loginStatus = _suc;
        }else{
            
            _loginStatus = _fail;
        }
    }
    
    
    if (_loginStatus_normal == _start) {
        
        if (status == TRUE) {
            
            _loginStatus_normal = _suc;
        }else{
            
            _loginStatus_normal = _fail;
        }
    }
    

    
    [_lock unlockWithCondition:1];
}


- (void)loginWithName:(NSString*)name PWD:(NSString*)pwd
{
    uint8_t token[32] = {0xff};
    NSData* data = [[NSData alloc] initWithBytes:token length:TokenSize];
    [XAIToken saveToken:data];
    
    if (_loginStatus_normal == _suc) {
        
        return;
    }
    
    _loginStatus = _init;
    
    
    XAILogin*  login = [[XAILogin alloc] init];
    login.delegate = self;
    //114.215.178.75
    
    
    
    [login loginWithName:name Password:pwd Host:_K_HOST apsn:_K_APSN];
    
    _loginStatus_normal = _start;
    
    runInMainLoop(^(BOOL * done) {
        
        if (_loginStatus_normal > _start) {
            
            *done = YES;
        }
    });
    

}



- (void)login{
    
    uint8_t token[32] = {0xff};
    NSData* data = [[NSData alloc] initWithBytes:token length:TokenSize];
    [XAIToken saveToken:data];
    
    if (_loginStatus == _suc) {
        
        return;
    }
    
    _loginStatus_normal = _init;
    
    //[[MQTT shareMQTT].client disconnect];
    
    XAILogin*  login = [[XAILogin alloc] init];
    login.delegate = self;
    [login loginWithName:@"admin" Password:@"admin" Host:_K_HOST apsn:_K_APSN];
    
    _loginStatus = _start;

    runInMainLoop(^(BOOL * done) {
        
            if (_loginStatus > _start) {
                
                *done = YES;
            }
    });
    
}


@end
