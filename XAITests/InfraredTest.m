//
//  InfraredTest.m
//  XAI
//
//  Created by office on 14-4-17.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "LoginPlugin.h"

#import "XAIDevInfrared.h"

@interface InfraredTest : LoginPlugin <XAIDeviceStatusDelegate,XAIDevInfraredDelegate>{

    XAIDevInfrared * _din;
    
    int _getDevStatus;
    int _getStatus;
    int _getPower;
    
}

@end

@implementation InfraredTest

- (void)setUp
{
    _din = [[XAIDevInfrared alloc] init];
    _din.delegate = self;
    _din.infDelegate = self;
    
    _din.apsn = 0x1;
    _din.luid = 0x124b0002292580;
    
    [_din startFocusStatus];
    [super setUp];

    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    [_din endFocusStatus];
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetDeviceStatus
{
    [self login];
    
    if (_loginStatus == Success) {
        
        
        
        [_din getDeviceStatus];
        
        
        _getDevStatus = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_getDevStatus > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_getDevStatus != start, @"delegate did not get called");
        XCTAssertTrue (_getDevStatus != Fail, @"get dev status faild");
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
}


- (void)testGetStatus
{
    
    [self login];
    
    if (_loginStatus == Success) {
        
        
        
        [_din getInfraredStatus];
        
        
        _getStatus = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_getStatus > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_getStatus != start, @"delegate did not get called");
        XCTAssertTrue (_getStatus != Fail, @"get ddc one status faild");
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
}


- (void) testGetPoser{
    
    [self login];
    
    if (_loginStatus == Success) {
        
        
        
        [_din getPower];
        
        
        _getPower = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_getPower > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_getPower != start, @"delegate did not get called");
        XCTAssertTrue (_getPower != Fail, @"get powder status faild");
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
}

- (void)getStatus:(XAIDeviceStatus)status withFinish:(BOOL)finish isTimeOut:(BOOL)bTimeOut{
    
    if (finish) {
        
        _getDevStatus = Success;
    }else{
        
        _getDevStatus = Fail;
    }
    
}

- (void)infrared:(XAIDevInfrared *)inf curPower:(float)power err:(XAIDevInfraredErr)err{
    
    if (err == XAIDevInfraredErr_NONE) {
        
        _getPower = Success;
        
    }else{
        
        _getPower = Fail;
    }
    
}

- (void)infrared:(XAIDevInfrared *)inf curStatus:(XAIDevInfraredStatus)status err:(XAIDevInfraredErr)err{
    
    if (err == XAIDevInfraredErr_NONE) {
        
        _getStatus = Success;
        
    }else{
        
        
        _getStatus = Fail;
    }
    
    
}


@end
