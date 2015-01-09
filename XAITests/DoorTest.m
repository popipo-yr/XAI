//
//  DoorTest.m
//  XAI
//
//  Created by office on 14-5-12.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LoginPlugin.h"
#import "XAIDoor.h"

@interface DoorTest : LoginPlugin<XAIDoorDelegate>{
    
    XAIDoor* _door;
    
    int _status;
    int _power;
    
    XAITYPELUID _err_luid;
    
}

@end

@implementation DoorTest

- (void)setUp
{
    [super setUp];
    
    _door = [[XAIDoor alloc] init];
    _door.delegate = self;
    _door.apsn = [MQTT shareMQTT].apsn;
    _door.luid= 0x0004000000000001;//0x00124B000413C85C;
    
    _err_luid = 0x0004000000100001;
    
    
    [_door startControl];
    
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    
    [_door endControl];
    
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testStatus
{
    [self login];
    
    if (_loginStatus == Success) {
        
        [_door getCurStatus];
        
        
        _status = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_status > start) {
                
                //*done = YES;
            }
        });
        
        
        XCTAssertTrue(_status != start, @"delegate did not get called");
        XCTAssertTrue(_status != Fail, @"no, Get door status shoule be suc");
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
}


- (void)testStatus_err;
{
    [self login];
    
    if (_loginStatus == Success) {
        
        _door.luid = _err_luid;
        [_door startControl];
        [_door getCurStatus];
        
        
        _status = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_status > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue(_status != start, @"delegate did not get called");
        XCTAssertTrue(_status != Success, @"no, Get door status shoule be fail with err luid.");
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
}


- (void) testPower{
    
    
    [self login];
    
    if (_loginStatus == Success) {
        
        
        
        [_door getPower];
        
        
        _power = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_power > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_power != start, @"delegate did not get called");
        XCTAssertTrue (_power != Fail, @"no, Get door power should be suc.");
        
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
}

- (void) testPower_err{
    
    
    [self login];
    
    if (_loginStatus == Success) {
        
        
        _door.luid = _err_luid;
        [_door startControl];
        [_door getPower];
        
        
        _power = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_power > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_power != start, @"delegate did not get called");
        XCTAssertTrue (_power != Success, @"no, Get door power should be fail with err luid");
        
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
}

-(void)door:(XAIDoor *)door curPower:(float)power getIsSuccess:(BOOL)isSuccess{
    
    if (isSuccess) {
        
        _power = Success;
    }else{
        
        
        _power = Fail;
    }
}


-(void)door:(XAIDoor *)door curStatus:(XAIDoorStatus)status getIsSuccess:(BOOL)isSuccess{
    
    if (isSuccess) {
        
        _status = Success;
    }else{
        
        
        _status = Fail;
    }
    
}


@end
