//
//  DeviceTest.m
//  XAI
//
//  Created by office on 14-4-16.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LoginTest.h"
#import "XAIDevice.h"

@interface DeviceTest : LoginTest <XAIDeviceStatusDelegate>{

    int _getStatus;
    XAIDevice* _device;
    

}

@end

@implementation DeviceTest

- (void)setUp
{
    _device = [[XAIDevice alloc] init];
    _device.delegate = self;
    
    _device.apsn = 0x1;
    //_device.luid = 0x124b0003d430b6;
    _device.luid = 0x00124B000413C8D8;
    //00-12-4B-00-04-13-C8-D8
    
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

- (void)testGetStatus
{
    [self testLogin];
    
    if (_loginStatus == Success) {
        
        
        
        [_device getDeviceStatus];
        
        
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

- (void)getStatus:(XAIDeviceStatus)status withFinish:(BOOL)finish{

    if (finish) {
        
        _getStatus = Success;
    }else{
    
        _getStatus = Fail;
    
    }

}

@end
