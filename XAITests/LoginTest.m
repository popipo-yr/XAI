//
//  Login.m
//  XAI
//
//  Created by office on 14-4-9.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LoginTest.h"
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

@implementation LoginTest

- (void)setUp
{
    
    [super setUp];
    [MQTT shareMQTT].apsn = 1;
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)loginFinishWithStatus:(BOOL)status{

    if (status == TRUE) {
        
        _loginStatus = 1;
    }else{
    
        _loginStatus = 2;
    }
    
    [_lock unlockWithCondition:1];
}

//- (void)testExample2
//{
//    XAILogin*  login = [[XAILogin alloc] init];
//    login.delegate = self;
//    
//    
//    
//    // create the semaphore and lock it once before we start
//    // the async operation
//    NSConditionLock *tl = [NSConditionLock new];
//    _lock = tl;
//    
//    // start the async operation
//    _loginStatus = 0;
//    [login loginWithName:@"admin@00000001" Password:@"admin" Host:@"192.168.1.1"];
//    
//    // now lock the semaphore - which will block this thread until
//    // [self.theLock unlockWithCondition:1] gets invoked
//    [_lock lockWhenCondition:1];
//    
//    // make sure the async callback did in fact happen by
//    // checking whether it modified a variable
//    XCTAssertTrue (_loginStatus != 1, @"delegate did not get called");
//    
//    // we're done
//   
//    _lock = nil;
//    
//    //sleep(1000*1000*600);
//    
//    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
//}






- (void)testLoginWithName:(NSString*)name PWD:(NSString*)pwd
{
    XAILogin*  login = [[XAILogin alloc] init];
    login.delegate = self;
    [login loginWithName:name Password:pwd Host:@"192.168.1.1" apsn:0x1];
    
    _loginStatus = 0;
    
    runInMainLoop(^(BOOL * done) {
        
        if (_loginStatus > 0) {
            
            *done = YES;
        }
    });
    
    
    // make sure the async callback did in fact happen by
    // checking whether it modified a variable
    XCTAssertTrue (_loginStatus != 0, @"delegate did not get called");
    XCTAssertTrue (_loginStatus != 2, @"login faild");
    
    
    
    //sleep(1000*1000*600);
    
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}




- (void)testLogin
{
    XAILogin*  login = [[XAILogin alloc] init];
    login.delegate = self;
    [login loginWithName:@"admin" Password:@"admin" Host:@"192.168.1.1" apsn:0x1];
    
    _loginStatus = 0;

    runInMainLoop(^(BOOL * done) {
        
            if (_loginStatus > 0) {
                
                *done = YES;
            }
    });
    
    
    // make sure the async callback did in fact happen by
    // checking whether it modified a variable
    XCTAssertTrue (_loginStatus != 0, @"delegate did not get called");
    XCTAssertTrue (_loginStatus != 2, @"login faild");
    

    
    //sleep(1000*1000*600);
    
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}


@end
