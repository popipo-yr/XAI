//
//  DoorContactTest.m
//  XAI
//
//  Created by office on 14-4-17.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LoginPlugin.h"

#import "XAIDevDoorContact.h"

@interface DoorContactTest : LoginPlugin <XAIDevDoorContactDelegate>{

    XAIDevDoorContact* _ddc;

    int _getDevStatus;
    int _getStatus;
    int _getPower;
    
    XAITYPELUID _err_luid;
    XAI_ERROR _err;
}

@end

@implementation DoorContactTest

- (void)setUp
{
    _ddc = [[XAIDevDoorContact alloc] init];
    _ddc.dcDelegate = self;
    
    _ddc.apsn = 0x1;
    _ddc.luid = 0x124b00039affd6;
    
    [_ddc startFocusStatus];
    
    _err_luid = 0x12989430909437;
   // _ddc.luid = 0x00124B000413CCC2;
    
    //    _luidDev = 0x124b0003d430b7;
    //    _luidDev = 0x124b0002292580;
    //    _luidDev = 0x124b00023f0c6c;
    
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    
    [_ddc  endFocusStatus];
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}



- (void)testGetStatus
{
    
    [self login];
    
    if (_loginStatus == Success) {
        
        
        
        [_ddc getDoorContactStatus];
        
        
        _getStatus = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_getStatus > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_getStatus != start, @"delegate did not get called");
        XCTAssertTrue (_getStatus != Fail, @"no,Get ddc status should be suc.");
        
        XCTAssert(_err == XAI_ERROR_NONE, @"err : %d",_err);
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
}


- (void)testGetStatus_err
{
    
    [self login];
    
    if (_loginStatus == Success) {
        
        
        
        _ddc.luid = _err_luid;
        [_ddc getDoorContactStatus];
        
        
        _getStatus = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_getStatus > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_getStatus != start, @"delegate did not get called");
        XCTAssertTrue (_getStatus != Fail, @"no,Get ddc status should be fail with err luid");
        XCTAssert(_err == XAI_ERROR_NONE, @"err : %d",_err);
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
}


- (void) testGetPoser{
    
    [self login];
    
    if (_loginStatus == Success) {
        
        
        
        [_ddc getPower];
        
        
        _getPower = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_getPower > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_getPower != start, @"delegate did not get called");
        XCTAssertTrue (_getPower != Fail, @"no, Get power should be suc.");
        XCTAssert(_err == XAI_ERROR_NONE, @"err : %d",_err);
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
}


- (void) testGetPoser_err{
    
    [self login];
    
    if (_loginStatus == Success) {
        
        
        _ddc.luid = _err_luid;
        [_ddc getPower];
        
        
        _getPower = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_getPower > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_getPower != start, @"delegate did not get called");
        XCTAssertTrue (_getPower != Fail, @"no, Get power should be fail with err luid.");
        XCTAssert(_err == XAI_ERROR_NONE, @"err : %d",_err);
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
}



- (void)doorContact:(XAIDevDoorContact *)dc curPower:(float)power err:(XAI_ERROR)err{

    if (_getPower != start) return;
    
    if (XAI_ERROR_NONE == err) {
        
        _getPower = Success;

        
    }else{
        
        _getPower = Fail;
    }

    _err = err;
}

- (void)doorContact:(XAIDevDoorContact *)dc curStatus:(XAIDevDoorContactStatus)status err:(XAI_ERROR)err{

    if (_getStatus != start) return;
    
    if (XAI_ERROR_NONE == err) {
        
        _getStatus = Success;
        
    }else{
        
        _getStatus = Fail;
    }

    _err = err;

}


@end
