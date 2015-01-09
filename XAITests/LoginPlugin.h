//
//  LoginTest.h
//  XAI
//
//  Created by office on 14-4-15.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//




#import <XCTest/XCTest.h>

#import "XAILogin.h"

#import "XAIToken.h"


#define Success 1
#define Fail   2
#define start  0


#define _K_APSN  0x010e2b26  //0x210e2b26  0x210e2813  0x2923aeea
#define _K_HOST @"192.168.0.1"//@"114.215.178.75" // @"192.168.1.1"  @"114.215.178.75" @"192.168.0.33"   0x210e2757

@interface LoginPlugin : XCTestCase <XAILoginDelegate>{
    
    NSConditionLock* _lock;
    int  _loginStatus;
    BOOL _done;
    
    int  _loginStatus_normal;
    
}

- (void) login;
//- (void)loginFinishWithStatus:(BOOL)status;
- (void)loginWithName:(NSString*)name PWD:(NSString*)pwd;


@end

static  inline void runInMainLoop(void(^block)(BOOL *done)) {
    __block BOOL done = NO;
    
    while (!done) {
        
        block(&done);
        [[NSRunLoop mainRunLoop] runUntilDate:
         [NSDate dateWithTimeIntervalSinceNow:.1]];
    }
}
