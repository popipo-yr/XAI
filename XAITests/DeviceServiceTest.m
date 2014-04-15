//
//  DeviceServiceTest.m
//  XAI
//
//  Created by office on 14-4-15.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "XAIDeviceService.h"


#import "LoginTest.h"


@interface DeviceServiceTest  : LoginTest <XAIDeviceServiceDelegate> {
    
    
    XAIDeviceService*  _devService;
    
    
    int _addStatus;
    int _delStatus;
    int _changeNameStatus;
    
    int _findStatus;
    
    NSString* _name4Change;
    
    NSString* _name4Change_end;
    
    
    XAITYPELUID  _luidDev;
    
}

@end

@implementation DeviceServiceTest

- (void)setUp
{
    _devService = [[XAIDeviceService alloc] init];
    _devService.delegate = self;
    
    
    _name4Change = @"NAME1";
    _name4Change_end = @"NAME2";
    
    _luidDev = 0x124b0003d430b6 ;
    
    
    
    
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    _devService = nil;
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

static inline void runInMainLoop(void(^block)(BOOL *done)) {
    __block BOOL done = NO;
    
    while (!done) {
        
        block(&done);
        [[NSRunLoop mainRunLoop] runUntilDate:
         [NSDate dateWithTimeIntervalSinceNow:.1]];
    }
}



- (void)testAdd
{
    
    [self testLogin];
    
    if (_loginStatus == Success) {
        
        
        [_devService addDev:_luidDev  withName:_name4Change apsn:[MQTT shareMQTT].apsn luid:MQTTCover_LUID_Server_03];
        
        
        _addStatus = 0;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_addStatus > 0) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_addStatus != 0, @"delegate did not get called");
        XCTAssertTrue (_addStatus != 2, @"add faild");
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
    
}




- (void)testChangeName
{
    
    [self testLogin];
    
    if (_loginStatus == Success) {
        
        
        [_devService changeDev:_luidDev withName:_name4Change_end apsn:[MQTT shareMQTT].apsn luid:MQTTCover_LUID_Server_03];
         

        
        
        _changeNameStatus = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_changeNameStatus > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_changeNameStatus != start, @"delegate did not get called");
        XCTAssertTrue (_changeNameStatus != Fail, @"change name faild");
        
        
        if (_changeNameStatus == Success) {
            
            NSString* swap = _name4Change;
            _name4Change = _name4Change_end;
            _name4Change_end = swap;
        }
        
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
}

- (void) testFindAll{

    [self testLogin];
    
    if (_loginStatus == Success) {
        
        
        
        [_devService findAllDevWithApsn:[MQTT shareMQTT].apsn luid:MQTTCover_LUID_Server_03];
        
        _findStatus = start;
        
        
        runInMainLoop(^(BOOL * done) {
            
            if (_findStatus > 0) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_findStatus != start, @"delegate did not get called");
        XCTAssertTrue (_findStatus != Fail, @"Find faild");
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }

}




- (void)testDel
{
    
    [self testLogin];
    
    if (_loginStatus == Success) {
        
        
        
        [_devService delDev:_luidDev apsn:[MQTT shareMQTT].apsn luid:MQTTCover_LUID_Server_03];
        
        
        _delStatus = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_delStatus > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_delStatus != start, @"delegate did not get called");
        XCTAssertTrue (_delStatus != Fail, @"del user faild");
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
}




- (void) addDevice:(BOOL)isSuccess{
    
    if (isSuccess == TRUE) {
        
        _addStatus = 1;
    }else{
        
        _addStatus = 2;
    }
    
}
- (void) delDevice:(BOOL)isSuccess{
    
    if (isSuccess == TRUE) {
        
        _delStatus = Success;
    }else{
        
        _delStatus = Fail;
    }
    
    
}
- (void) changeDeviceName:(BOOL)isSuccess{
    
    if (isSuccess == TRUE) {
        
        _changeNameStatus = Success;
    }else{
        
        _changeNameStatus = Fail;
    }
    
    
}

- (void) findedAllDevice:(BOOL)isSuccess datas:(NSArray *)devAry{

    
    if (isSuccess == TRUE) {
        
        _findStatus = Success;
    }else{
        
        _findStatus = Fail;
    }


}

@end
