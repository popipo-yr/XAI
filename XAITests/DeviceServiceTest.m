//
//  DeviceServiceTest.m
//  XAI
//
//  Created by office on 14-4-15.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//


#import <XCTest/XCTestObserver.h>

#import <XCTest/XCTest.h>
#import "XAIDeviceService.h"


#import "LoginPlugin.h"


@interface DeviceServiceTest  : LoginPlugin <XAIDeviceServiceDelegate> {
    
    
    XAIDeviceService*  _devService;
    
    
    int _addStatus;
    int _delStatus;
    int _changeNameStatus;
    
    int _findStatus;
    
    int _findOnlineStatus;
    
    NSString* _name4Change;
    
    NSString* _name4Change_end;
    
    
    XAITYPELUID  _luidDev;
    
    XAITYPELUID _luidNotExist;
    
    
    XAI_ERROR _err;
    
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
//    _luidDev = 0x00124B000413C85C;  //21
//     _luidDev = 0x00124B000413C931;
//_luidDev = 0x00124B000413CCC2;
    
    
    _luidDev = 0x00124B000413CDCF;  //26
    
    
    _luidNotExist = 0x89375;
    
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



- (void)test_1_1_Add_TRUE
{
    
    [self login];
    
    _addStatus = start;
    
    if (_loginStatus == Success) {
        
        
        [_devService addDev:_luidDev  withName:_name4Change];
        
        
        _addStatus = 0;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_addStatus > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_addStatus != start, @"delegate did not get called");
        XCTAssertTrue (_addStatus != Fail, @"add faild");
        
         XCTAssert(_err == XAI_ERROR_NONE, @"yes. it add success");
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
}


- (void)test_1_2_Add_LUIDJOINED
{
    
    [self login];
    
    _addStatus = start;
    
    if (_loginStatus == Success) {
        
        
        [_devService addDev:_luidDev  withName:_name4Change];
        
        
        _addStatus = 0;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_addStatus > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_addStatus != start, @"delegate did not get called");
        XCTAssertTrue (_addStatus != Success, @"add faild");
        
        XCTAssert(_err == XAI_ERROR_LUID_EXISTED, @"yes. it joned before");
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
}



- (void)test_1_3_Add_NameExist
{
    
    [self login];
    
    _addStatus = start;
    
    XAITYPELUID  new_luidDev = _luidDev + 1;  //26
    
    if (_loginStatus == Success) {
        
        
        [_devService addDev:new_luidDev  withName:_name4Change];
        
        
        _addStatus = 0;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_addStatus > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_addStatus != start, @"delegate did not get called");
        XCTAssertTrue (_addStatus != Success, @"add faild");
        
        XCTAssert(_err == XAI_ERROR_NAME_EXISTED, @"yes. name is exist");
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
}


- (void)test_1_4_Add_LUIDNotExist
{
    
    [self login];
    
    _addStatus = start;
    //26
    
    if (_loginStatus == Success) {
        
        
        [_devService addDev:_luidNotExist  withName:_name4Change];
        
        
        _addStatus = 0;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_addStatus > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_addStatus != start, @"delegate did not get called");
        XCTAssertTrue (_addStatus != Success, @"add faild");
        XCTAssert(_err == XAI_ERROR_LUID_INVALID, @"yes, it is not invalid dev");
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
}


- (void)test_1_5_Add_NULL_NAME
{
    
    [self login];
    
    _addStatus = start;
    
    
    if (_loginStatus == Success) {
        
        
        [_devService addDev:_luidDev  withName:NULL];
        
        
        _addStatus = 0;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_addStatus > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_addStatus != start, @"delegate did not get called");
        XCTAssertTrue (_addStatus != Success, @"add faild");
        
        XCTAssert(_err == XAI_ERROR_NULL_POINTER, @"yes, name is null");
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
}







- (void)test_2_1_ChangeName_TRUE
{
    
    [self login];
    
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
        
        XCTAssert(_err == XAI_ERROR_NONE, @"yes.it be true");
        
        
        if (_changeNameStatus == Success) {
            
            NSString* swap = _name4Change;
            _name4Change = _name4Change_end;
            _name4Change_end = swap;
        }
        
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
}


- (void)test_2_2_ChangeName_LUIDNotExist
{
    
    [self login];
    
    if (_loginStatus == Success) {
        
        
        [_devService changeDev:_luidNotExist withName:_name4Change_end];
        
        
        
        
        _changeNameStatus = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_changeNameStatus > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_changeNameStatus != start, @"delegate did not get called");
        XCTAssertTrue (_changeNameStatus != Success, @"change name faild");
        
        XCTAssert(_err == XAI_ERROR_LUID_INVALID, @"yes.it's not a dev");
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
}


- (void)test_2_3_ChangeName_NULL_NAME
{
    
    [self login];
    
    if (_loginStatus == Success) {
        
        [_devService changeDev:_luidDev withName:nil];
        
        _changeNameStatus = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_changeNameStatus > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_changeNameStatus != start, @"delegate did not get called");
        XCTAssertTrue (_changeNameStatus != Success, @"change name faild");
        
        XCTAssert(_err == XAI_ERROR_NULL_POINTER, @"yes. this is a null name");
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
}



- (void) test_3_FindAll{

    [self login];
    
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

- (void) test_4_FindAllOnline{
    
    [self login];
    
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





- (void)test_5_1_Del_TRUE
{
    
    [self login];
    
    //_luidDev = _luidDev + 1;  //26

    
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
        
        XCTAssert(_err == XAI_ERROR_NONE, @"YES . DELETE SUC");
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
}

- (void)test_5_2_Del_LUIDNotJOINED
{
    
    [self login];
    
    //_luidDev = _luidDev + 1;  //26
    
    
    if (_loginStatus == Success) {
        
        
        
        [_devService delDev:_luidDev];
        
        
        _delStatus = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_delStatus > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_delStatus != start, @"delegate did not get called");
        XCTAssertTrue (_delStatus != Success, @"del user faild");
        
        XCTAssert(_err == XAI_ERROR_DEVICE_NONE_EXISTED, @"YES . dev not joind");
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
}



- (void)test_5_3_Del_LUIDNotExist
{
    
    [self login];
    
    //_luidDev = _luidDev + 1;  //26
    
    
    if (_loginStatus == Success) {
        
        
        
        [_devService delDev:_luidNotExist];
        
        
        _delStatus = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_delStatus > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_delStatus != start, @"delegate did not get called");
        XCTAssertTrue (_delStatus != Success, @"del user faild");
        
        XCTAssert(_err == XAI_ERROR_LUID_INVALID, @"YES . LUID exist");
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
}



- (void) removeDev:(XAITYPELUID)luid{
    
    [self login];
    
    
    if (_loginStatus == Success) {
        
        
        
        [_devService delDev:luid];
        
        
        _delStatus = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_delStatus > start) {
                
                *done = YES;
            }
        });
    }

}

- (void) firstRemove{
    
    [self removeDev:_luidDev];
    [self removeDev:_luidDev+1];

}

-(void)testALL{
    
    [self firstRemove];

    [self test_1_1_Add_TRUE];
    [self test_1_2_Add_LUIDJOINED];
    [self test_1_3_Add_NameExist];
    [self test_1_4_Add_LUIDNotExist];
    [self test_1_5_Add_NULL_NAME];
    [self test_2_1_ChangeName_TRUE];
    [self test_2_2_ChangeName_LUIDNotExist];
    [self test_2_3_ChangeName_NULL_NAME];
    [self test_3_FindAll];
    [self test_4_FindAllOnline];
    [self test_5_1_Del_TRUE];
    [self test_5_2_Del_LUIDNotJOINED];
    [self test_5_3_Del_LUIDNotExist];
    
}


- (void) devService:(XAIDeviceService*)devService addDevice:(BOOL)isSuccess errcode:(XAI_ERROR)errcode{
    
    if (_addStatus != start) return;
    
    if (isSuccess == TRUE) {
        
        _addStatus = 1;
    }else{
        
        _addStatus = 2;
    }
    
    _err = errcode;
    
}
- (void) devService:(XAIDeviceService*)devService delDevice:(BOOL)isSuccess errcode:(XAI_ERROR)errcode{
    
    if (_delStatus != start) return;
    
    if (isSuccess == TRUE) {
        
        _delStatus = Success;
    }else{
        
        _delStatus = Fail;
    }
    
    
    _err = errcode;
    
    
}
- (void) devService:(XAIDeviceService*)devService changeDevName:(BOOL)isSuccess errcode:(XAI_ERROR)errcode{
    
    if (_changeNameStatus != start) return;
    
    if (isSuccess == TRUE) {
        
        _changeNameStatus = Success;
    }else{
        
        _changeNameStatus = Fail;
    }
    
    _err = errcode;
    
    
}

- (void) devService:(XAIDeviceService*)devService findedAllDevice:(NSArray*) devAry
             status:(BOOL)isSuccess errcode:(XAI_ERROR)errcode{

    if (_findStatus != start) return;
    
    if (isSuccess == TRUE) {
        
        _findStatus = Success;
    }else{
        
        _findStatus = Fail;
    }

    _err = errcode;

}

- (void) devService:(XAIDeviceService*)devService finddedAllOnlineDevices:(NSSet*) luidAry
             status:(BOOL)isSuccess errcode:(XAI_ERROR)errcode{

    if (_findOnlineStatus != start) return;

        _findOnlineStatus = Success;
    
    _err = errcode;


}

@end
