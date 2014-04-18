//
//  SwitchTest.m
//  XAI
//
//  Created by office on 14-4-17.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LoginTest.h"
#import "XAIDevSwitch.h"

@interface SwitchTest : LoginTest <XAIDevSwitchDelegate,XAIDeviceStatusDelegate>{

    
    XAIDevSwitch* _devSwitch;
    
    int _getOne;
    int _getTwo;
    int _getStatus;
    
    int _setOne;
    int _setTwo;
    

}



@end

@implementation SwitchTest

- (void)setUp
{
    _devSwitch = [[XAIDevSwitch alloc] init];
    _devSwitch.delegate = self;
    _devSwitch.swiDelegate = self;
    _devSwitch.apsn = 0x1;
    _devSwitch.luid= 0x124b0003d4317c;
                     
    
    //    _luidDev = 0x124b0003d4317c;
    //    _luidDev = 0x124b0003d430b7;
    //    _luidDev = 0x124b0002292580;
    //    _luidDev = 0x124b00023f0c6c;
    
//    0x124b0003d431
//    0x124b00023f0c
//    0x124b0003d430
//    0x124b00022925
    
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


//static inline void runInMainLoop(void(^block)(BOOL *done)) {
//    __block BOOL done = NO;
//    
//    while (!done) {
//        
//        block(&done);
//        [[NSRunLoop mainRunLoop] runUntilDate:
//         [NSDate dateWithTimeIntervalSinceNow:.1]];
//    }
//}

- (void)testGetDeviceStatus
{
    [self testLogin];
    
    if (_loginStatus == Success) {
        
        
        
        [_devSwitch getDeviceStatus];
        
        
        _getStatus = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_getStatus > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_getStatus != start, @"delegate did not get called");
        XCTAssertTrue (_getStatus != Fail, @"get dev status faild");
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
}


- (void)testGetCircuitOneStatus
{
    
    [self testLogin];
    
    if (_loginStatus == Success) {
        
        
        
        [_devSwitch getCircuitOneStatus];
        
        
        _getOne = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_getOne > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_getOne != start, @"delegate did not get called");
        XCTAssertTrue (_getOne != Fail, @"get switch one status faild");
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
}


- (void) testGetCircuitTwoStatus{
    
    [self testLogin];
    
    if (_loginStatus == Success) {
        
        
        
        [_devSwitch getCircuitTwoStatus];
        
        
        _getTwo = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_getTwo > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_getTwo != start, @"delegate did not get called");
        XCTAssertTrue (_getTwo != Fail, @"get switch two status faild");
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }

    
}


- (void) testsetCircuitOneStatus{
    
    
    [self testLogin];
    
    if (_loginStatus == Success) {
        
        
        
        [_devSwitch setCircuitOneStatus:XAIDevCircuitStatusOpen];
        
        
        _setOne = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_setOne > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_setOne != start, @"delegate did not get called");
        XCTAssertTrue (_setOne != Fail, @"set switch one open status faild");
        
        
        [_devSwitch setCircuitOneStatus:XAIDevCircuitStatusClose];
        
        
        _setOne = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_setOne > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_setOne != start, @"delegate did not get called");
        XCTAssertTrue (_setOne != Fail, @"set switch one close status faild");

        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }

}

- (void) testsetCircuitTwoStatus{
    
    [self testLogin];
    
    if (_loginStatus == Success) {
        
        
        [_devSwitch setCircuitTwoStatus:XAIDevCircuitStatusOpen];
        
        _setTwo = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_setTwo > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_setTwo != start, @"delegate did not get called");
        XCTAssertTrue (_setTwo != Success, @"set switch two open status not should success");
        
        
        [_devSwitch setCircuitTwoStatus:XAIDevCircuitStatusClose];
        
        
        _setTwo = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_setTwo > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_setTwo != start, @"delegate did not get called");
        XCTAssertTrue (_setTwo != Success, @"set switch two close status not should sucess");
        
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
}


- (void) circuitOneGetSuccess:(BOOL)isSuccess curStatus:(XAIDevCircuitStatus)status{

    if (isSuccess) {
        
        _getOne = Success;
    }else{
    
        _getOne = Fail;
    }
}
- (void) circuitOneSetSuccess:(BOOL)isSuccess{
    
    if (isSuccess) {
        
        _setOne = Success;
    }else{
        
        _setOne = Fail;
    }

}

- (void) circuitTwoGetSuccess:(BOOL)isSuccess curStatus:(XAIDevCircuitStatus)status{
    
    if (isSuccess) {
        
        _getTwo = Success;
    }else{
        
        _getTwo = Fail;
    }

}
- (void) circuitTwoSetSuccess:(BOOL)isSuccess{

    if (isSuccess) {
        
        _setTwo = Success;
        
    }else{
        
        _setTwo = Fail;
    }


}

- (void) getStatus:(XAIDeviceStatus)status withFinish:(BOOL)finish{

    if (finish) {
        
        _getStatus = Success;
        
    }else{
        
        _getStatus = Fail;
        
    }
}

@end
