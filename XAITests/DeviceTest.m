//
//  DeviceTest.m
//  XAI
//
//  Created by office on 14-4-16.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LoginPlugin.h"
#import "XAIDevice.h"

@interface DeviceTest : LoginPlugin <XAIDeviceStatusDelegate>{

    int _getStatus;
    int _getInfo;
    XAIDevice* _device;
    

}

@end

@implementation DeviceTest

- (void)setUp
{
        [super setUp];
    
    _device = [[XAIDevice alloc] init];
    _device.delegate = self;
    
    _device.apsn = [MQTT shareMQTT].apsn;
    //_device.luid = 0x124b0003d430b6;
    _device.luid = 0x0004000000000001;
    //00-12-4B-00-04-13-C8-D8
    

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

- (void)testGetDevStatus
{
    [self login];
    
    if (_loginStatus == Success) {
        
        
        
        [_device getDeviceStatus];
        
        
        _getStatus = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_getStatus > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_getStatus != start, @"delegate did not get called");
        XCTAssertTrue (_getStatus != Fail, @"no, Get dev status should success");
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    

}


- (void)testGetDevStatus_err
{
    [self login];
    
    if (_loginStatus == Success) {
        
        
        
        _device.luid = 0x333;
        [_device getDeviceStatus];
        
        
        _getStatus = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_getStatus > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_getStatus != start, @"delegate did not get called");
        XCTAssertTrue (_getStatus != Success, @"no, Get dev status should fail");
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
}


- (void)testGetDevInfo
{
    [self login];
    
    if (_loginStatus == Success) {
        
        
        
        [_device getDeviceInfo];
        
        
        _getInfo = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_getInfo > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_getInfo != start, @"delegate did not get called");
        XCTAssertTrue (_getInfo != Fail, @"no, Get dev Info should success");
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
}




- (void)device:(XAIDevice*)device getStatus:(XAIDeviceStatus)status isSuccess:(BOOL)finish isTimeOut:(BOOL)bTimeOut{

    if (finish) {
        
        _getStatus = Success;
    }else{
    
        _getStatus = Fail;
    
    }

}


-(void)device:(XAIDevice *)device getInfoIsSuccess:(BOOL)bSuccess isTimeOut:(BOOL)bTimeOut{
    
    if (bSuccess) {
        
        _getInfo = Success;
        
    }else{
    
        _getInfo = Fail;
    }

}

@end
