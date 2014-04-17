//
//  DoorContactTest.m
//  XAI
//
//  Created by office on 14-4-17.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LoginTest.h"

#import "XAIDevDoorContact.h"

@interface DoorContactTest : LoginTest <XAIDevDoorContactDelegate,XAIDeviceStatusDelegate>{

    XAIDevDoorContact* _ddc;

    int _getDevStatus;
    int _getStatus;
    int _getPower;
}

@end

@implementation DoorContactTest

- (void)setUp
{
    _ddc = [[XAIDevDoorContact alloc] init];
    _ddc.delegate = self;
    _ddc.dcDelegate = self;
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetDeviceStatus
{
    [self testLogin];
    
    if (_loginStatus == Success) {
        
        
        
        [_ddc getDeviceStatus];
        
        
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
    
    [self testLogin];
    
    if (_loginStatus == Success) {
        
        
        
        [_ddc getDoorContactStatus];
        
        
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
    
    [self testLogin];
    
    if (_loginStatus == Success) {
        
        
        
        [_ddc getPower];
        
        
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

- (void)getStatus:(XAIDeviceStatus)status withFinish:(BOOL)finish{
    
    if (finish) {
        
        _getDevStatus = Success;
    }else{
    
        _getDevStatus = Fail;
    }

}

- (void)doorContactPowerGetSuccess:(BOOL)isSuccess curPower:(float)power{

    if (isSuccess) {
        
        _getPower = Success;
        
    }else{
        
        _getPower = Fail;
    }

}

- (void)doorContactStatusGetSuccess:(BOOL)isSuccess curStatus:(XAIDevDoorContactStatus)status{

    if (isSuccess) {
        
        _getStatus = Success;
        
    }else{
        
        _getStatus = Fail;
    }


}


@end
