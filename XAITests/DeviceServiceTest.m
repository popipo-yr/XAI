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
    XAIDeviceType _type;
    
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
    
    _type = XAIDeviceType_light_2;
    
    
    _name4Change = [NSString stringWithFormat:@"NAME111"];
    _name4Change_end = [NSString stringWithFormat:@"NAME112"];
    
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
    
    
    //0x69, 0xFE, 0x9A, 0x03, 0x00, 0x4B, 0x12, 0x00  开关
    _luidDev = 0x00124b00039afe69;
    //0xD6, 0xFF, 0x9A, 0x03, 0x00, 0x4B, 0x12, 0x00 门磁
   // luidstr = 0x124b00039affd6;
    
    
    _luidNotExist = 0x89375;
    
   // _name4Change = [NSString stringWithFormat:@"%@%llX",@"NAME1",_luidDev];
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

- (void)_addDev:(XAITYPELUID)luid withName:(NSString*)name type:(XAIDeviceType)type{

    [self login];
    
    _addStatus = start;
    
    if (_loginStatus == Success) {
        
        
        [_devService addDev:luid  withName:name type:type];
        
        
        _addStatus = 0;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_addStatus > start) {
                
                *done = YES;
            }
        });
    }

}


- (void)_delDev:(XAITYPELUID)luid{
    
    
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


- (void)_changeDev:(XAITYPELUID)luid name:(NSString*)name
{
    
    [self login];
    
    if (_loginStatus == Success) {
        
        
        [_devService changeDev:luid withName:name];
        
        
        _changeNameStatus = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_changeNameStatus > start) {
                
                *done = YES;
            }
        });
        
    }
}




- (void)test_1_1_Add_TRUE
{
    
    [self _delDev:_luidDev];
    [self _addDev:_luidDev withName:_name4Change type:_type];
    
    if (_loginStatus == Success) {
        
        
        XCTAssertTrue (_addStatus != start, @"delegate did not get called");
        XCTAssertTrue (_addStatus != Fail, @"no, add dev should be suc");
        XCTAssert(_err == XAI_ERROR_NONE, @"-err:%d",_err);
        
    }else{
        
        
        XCTFail(@"login faild");
    }
    
    [self _delDev:_luidDev];
    
}


- (void)test_1_2_Add_LUIDJOINED
{
    
    [self _addDev:_luidDev withName:_name4Change type:_type];
    
    
    if (_loginStatus != Success && _addStatus != Success) {
        
        XCTFail(@"Add_LUIDJOINED test faild : generate data faild");
        return;
    }
    
    [self _addDev:_luidDev withName:_name4Change type:_type];
    
    if (_loginStatus == Success) {
        
        XCTAssertTrue (_addStatus != start, @"delegate did not get called");
        XCTAssertTrue (_addStatus != Success, @"no, it should not be suc");
        XCTAssert(_err == XAI_ERROR_LUID_EXISTED, @"-err = %d",_err);
        
        
    }else{
    
        XCTFail(@"Add_LUIDJOINED test faild : login faild");
    }
    
    [self _delDev:_luidDev];
    
}



- (void)test_1_3_Add_NameExist
{
    
    [self _addDev:_luidDev withName:_name4Change type:_type];
    
    if (_loginStatus != Success && _addStatus != Success) {
        
        XCTFail(@"Add_NameExist test faild : generate data faild");
        return;
    }
    
    XAITYPELUID newLuid = _luidDev+10;
    
    [self _addDev:newLuid withName:_name4Change type:_type];
    
    if (_loginStatus == Success) {
        
        XCTAssertTrue (_addStatus != start, @"delegate did not get called");
        XCTAssertTrue (_addStatus != Success, @"no, add dev with same name should be fail");
        
        XCTAssert(_err == XAI_ERROR_NAME_EXISTED, @"-err : %d",_err);
        
    }else{
        
        XCTFail(@"Add_NameExist test faild : login faild");
    }
    
    [self _delDev:_luidDev];
    [self _delDev:newLuid];

}


- (void)test_1_4_Add_LUIDNotExist
{
    
    [self _addDev:_luidNotExist withName:_name4Change type:_type];
    
    if (_loginStatus == Success) {
        
        XCTAssertTrue (_addStatus != start, @"delegate did not get called");
        XCTAssertTrue (_addStatus != Success, @"no, it should be fail, luid not exist");
        XCTAssert(_err == XAI_ERROR_LUID_INVALID, @"-err : %d",_err);

        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
     [self _delDev:_luidNotExist];

}


- (void)test_1_5_Add_NULL_NAME
{
    

    [self _addDev:_luidDev withName:NULL type:_type];
    
    
    if (_loginStatus == Success) {
        
        
        XCTAssertTrue (_addStatus != start, @"delegate did not get called");
        XCTAssertTrue (_addStatus != Success, @"NO, it should be fail, name is null");
        
        XCTAssert(_err == XAI_ERROR_NAME_INVALID, @"-err : %d",_err);
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
    [self _delDev:_luidDev];
    
}







- (void)test_2_1_ChangeName_TRUE
{
    
    [self _addDev:_luidDev withName:_name4Change type:_type];
    
    if (_loginStatus != Success && _changeNameStatus != Success) {
        
        XCTFail(@"ChangeName_TRUE test faild : generate data faild");
        return;
    }

    
    [self _changeDev:_luidDev name:_name4Change_end];
    
    if (_loginStatus == Success) {
        
        
        XCTAssertTrue (_changeNameStatus != start, @"delegate did not get called");
        XCTAssertTrue (_changeNameStatus != Fail, @"no, it should be suc");
        XCTAssert(_err == XAI_ERROR_NONE, @"-err : %d",_err);
        
    }else{
        
        XCTFail(@"LOGIN FAILD");
    }
    
    [self _delDev:_luidDev];
    
}


- (void)test_2_2_ChangeName_LUIDNotExist
{
    [self _delDev:_luidNotExist];
    
    [self _changeDev:_luidNotExist name:_name4Change_end];
    
    if (_loginStatus == Success) {
        
        XCTAssertTrue (_changeNameStatus != start, @"delegate did not get called");
        XCTAssertTrue (_changeNameStatus != Success, @"no, change name should be fail,dev not joined");
        
        XCTAssert(_err == XAI_ERROR_LUID_INVALID, @"-err = %d",_err);
        
    }else{
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
}


- (void)test_2_3_ChangeName_NULL_NAME
{
    
    [self _addDev:_luidDev withName:_name4Change type:_type];
    
    if (_loginStatus != Success && _changeNameStatus != Success) {
        
        XCTFail(@"ChangeName_NULL_NAME test faild : generate data faild");
        return;
    }
    
    
    [self _changeDev:_luidDev name:NULL];
    
    if (_loginStatus == Success) {
        
        
        XCTAssertTrue (_changeNameStatus != start, @"delegate did not get called");
        XCTAssertTrue (_changeNameStatus != Success, @"no, change name should be fail, the name is null");
        XCTAssert(_err == XAI_ERROR_NAME_INVALID, @"-err : %d",_err);
        
    }else{
        
        XCTFail(@"LOGIN FAILD");
    }
    
    [self _delDev:_luidDev];

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
        
        
        
        [_devService findAllOnlineDevWithuseSecond:20];
        
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
    [self _addDev:_luidDev withName:_name4Change type:_type];
    
    if (_loginStatus != Success && _changeNameStatus != Success) {
        
        XCTFail(@"Del_TRUE test faild : generate data faild");
        return;
    }
    

    [self _delDev:_luidDev];
    
    
    if (_loginStatus == Success) {
        
        
        XCTAssertTrue (_delStatus != start, @"delegate did not get called");
        XCTAssertTrue (_delStatus != Fail, @"no, del dev should be true");
        
        XCTAssert(_err == XAI_ERROR_NONE, @"-err : %d", _err);
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
}

- (void)test_5_2_Del_LUIDNotJOINED
{
    
    [self _delDev:_luidDev];
    [self _delDev:_luidDev];
    
    
    if (_loginStatus == Success) {
        
        
        XCTAssertTrue (_delStatus != start, @"delegate did not get called");
        XCTAssertTrue (_delStatus != Success, @"no, del dev should be fail, it is not joined");
        
        XCTAssert(_err == XAI_ERROR_LUID_NONE_EXISTED, @"-err : %d",_err);
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
}



- (void)test_5_3_Del_LUIDNotExist
{
    
    [self _delDev:_luidNotExist];
    
    if (_loginStatus == Success) {
        
        
        XCTAssertTrue (_delStatus != start, @"delegate did not get called");
        XCTAssertTrue (_delStatus != Success, @"no, del dev should be fail, luid not exist");
        
        XCTAssert(_err == XAI_ERROR_LUID_INVALID, @"-err : %d",_err);
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
}



- (void) firstRemove{
    
    [self _delDev:_luidDev];
    [self _delDev:_luidDev+1];

}

-(void)_testALL{
    
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
