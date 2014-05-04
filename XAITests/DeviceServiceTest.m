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
    
    int _findOnlineStatus;
    
    NSString* _name4Change;
    
    NSString* _name4Change_end;
    
    
    XAITYPELUID  _luidDev;
    
}

@end

@implementation DeviceServiceTest

- (void)setUp
{
    _devService = [[XAIDeviceService alloc] init];
    
    [MQTT shareMQTT].apsn = 0x1;
    
    _devService.apsn = 0x1;
    _devService.luid = MQTTCover_LUID_Server_03;
    _devService.deviceServiceDelegate = self;
    
    
    _name4Change = [NSString stringWithFormat:@"NAME1111111"];
    _name4Change_end = [NSString stringWithFormat:@"NAME112222"];
    
//    _luidDev = 0x124b0003d430b6 ;
    
//    _luidDev = 0x124b000257d985 ;
//    _luidDev = 0x124b0002d5786f ;
//    _luidDev = 0x124b0002623bed ;
//    _luidDev = 0x124b000229251c ;

    
//    _luidDev = 0x124b000413c8d8 ;
    
//    _luidDev = 0x124b0003d4317c;
//    _luidDev = 0x124b0003d430b7;
//    _luidDev = 0x124b0002292580;
//    _luidDev = 0x124b00023f0c6c;
//    _luidDev = 0x124b000257d991;
    
    
    //开关
//    _luidDev = 0x00124B000413C85C;
    _luidDev = 0x00124B000413CD9D;
    
    
    
    _name4Change = [NSString stringWithFormat:@"%@%llX",@"NAME1",_luidDev];
    _name4Change_end = @"NAME2";

    
    
    
    
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    _devService = nil;
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



- (void)testAdd
{
    
    [self testLogin];
    
    if (_loginStatus == Success) {
        
        
        [_devService addDev:_luidDev  withName:_name4Change];
        
        
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
        
        
        [_devService changeDev:_luidDev withName:_name4Change_end];
         

        
        
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
        
        
        
        [_devService findAllDev];
        
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

- (void) testFindAllOnline{
    
    [self testLogin];
    
    if (_loginStatus == Success) {
        
        
        
        [_devService findAllOnlineDevWithuseSecond:10];
        
        _findOnlineStatus = start;
        
        
        runInMainLoop(^(BOOL * done) {
            
            if (_findOnlineStatus > 0) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_findOnlineStatus != start, @"delegate did not get called");
        XCTAssertTrue (_findOnlineStatus != Fail, @"Find faild");
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
}





- (void)testDel
{
    
    [self testLogin];
    
    if (_loginStatus == Success) {
        
        
        
        [_devService delDev:_luidDev];
        
        
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




- (void) devService:(XAIDeviceService*)devService addDevice:(BOOL)isSuccess errcode:(XAI_ERROR)errcode{
    
    if (isSuccess == TRUE) {
        
        _addStatus = 1;
    }else{
        
        _addStatus = 2;
    }
    
}
- (void) devService:(XAIDeviceService*)devService delDevice:(BOOL)isSuccess errcode:(XAI_ERROR)errcode{
    
    if (isSuccess == TRUE) {
        
        _delStatus = Success;
    }else{
        
        _delStatus = Fail;
    }
    
    
}
- (void) devService:(XAIDeviceService*)devService changeDevName:(BOOL)isSuccess errcode:(XAI_ERROR)errcode{
    
    if (isSuccess == TRUE) {
        
        _changeNameStatus = Success;
    }else{
        
        _changeNameStatus = Fail;
    }
    
    
}

- (void) devService:(XAIDeviceService*)devService findedAllDevice:(NSArray*) devAry
             status:(BOOL)isSuccess errcode:(XAI_ERROR)errcode{

    
    if (isSuccess == TRUE) {
        
        _findStatus = Success;
    }else{
        
        _findStatus = Fail;
    }


}

- (void) devService:(XAIDeviceService*)devService finddedAllOnlineDevices:(NSSet*) luidAry
             status:(BOOL)isSuccess errcode:(XAI_ERROR)errcode{


        _findOnlineStatus = Success;


}

@end
