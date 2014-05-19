//
//  SwitchTest.m
//  XAI
//
//  Created by office on 14-4-17.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LoginPlugin.h"
#import "XAIDevSwitch.h"

@interface SwitchTest : LoginPlugin <XAIDevSwitchDelegate>{

    
    XAIDevSwitch* _devSwitch;
    
    int _getOne;
    int _getTwo;
    int _getStatus;
    
    int _setOne;
    int _setTwo;
    
    
    XAITYPELUID _err_luid;
    
    XAI_ERROR _err;
    

}



@end

@implementation SwitchTest

- (void)setUp
{
    _devSwitch = [[XAIDevSwitch alloc] init];
    _devSwitch.swiDelegate = self;
    _devSwitch.apsn = 0x1;
    _devSwitch.luid= 0x00124B000413CDCF;//0x00124B000413C85C;
    
    _err_luid = 0x0013434335998aad;
                     
    
    [_devSwitch startFocusStatus];
    //    _luidDev = 0x124b0003d4317c;
    //    _luidDev = 0x124b0003d430b7;
    //    _luidDev = 0x124b0002292580;
    //    _luidDev = 0x124b00023f0c6c;
    
//    0x124b0003d431
//    0x124b00023f0c
//    0x124b0003d430
//    0x124b00022925
    
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    
    [_devSwitch endFocusStatus];
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testGetCircuitOneStatus
{
    
    [self login];
    
    if (_loginStatus == Success) {
        
        [_devSwitch getCircuitOneStatus];
        
        
        _getOne = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_getOne > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_getOne != start, @"delegate did not get called");
        XCTAssertTrue (_getOne != Fail, @"no, get switch circuit one should be suc.");
        XCTAssertTrue(_err == XAI_ERROR_NONE, @"err : %d",_err);
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
}


- (void) testGetCircuitTwoStatus{
    
    [self login];
    
    if (_loginStatus == Success) {
        
        
        
        [_devSwitch getCircuitTwoStatus];
        
        
        _getTwo = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_getTwo > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_getTwo != start, @"delegate did not get called");
        XCTAssertTrue (_getTwo != Fail, @"no, get switch circuit two should be suc.");
        XCTAssertTrue(_err == XAI_ERROR_NONE, @"err : %d",_err);
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }

    
}


- (void) testsetCircuitOneOpen{
    
    
    [self login];
    
    if (_loginStatus == Success) {
        
        
        
        [_devSwitch setCircuitOneStatus:XAIDevCircuitStatusOpen];
        
        
        _setOne = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_setOne > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_setOne != start, @"delegate did not get called");
        XCTAssertTrue (_setOne != Fail, @"no, set switch circuit one open should be suc.");
        XCTAssertTrue(_err == XAI_ERROR_NONE, @"err : %d",_err);
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }

}


- (void) testsetCircuitOneClose{
    
    
    [self login];
    
    if (_loginStatus == Success) {
        
        
        [_devSwitch setCircuitOneStatus:XAIDevCircuitStatusClose];
        
        
        _setOne = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_setOne > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_setOne != start, @"delegate did not get called");
        XCTAssertTrue (_setOne != Fail, @"no, set switch circuit one close should be suc.");
        XCTAssertTrue(_err == XAI_ERROR_NONE, @"err : %d",_err);
        
        
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
}

- (void) testsetCircuitTwoOpen{
    
    [self login];
    
    if (_loginStatus == Success) {
        
        
        [_devSwitch setCircuitTwoStatus:XAIDevCircuitStatusOpen];
        
        _setTwo = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_setTwo > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_setTwo != start, @"delegate did not get called");
        XCTAssertTrue (_setTwo != Fail, @"no, set switch circuit two open should be suc.");
        XCTAssertTrue(_err == XAI_ERROR_NONE, @"err : %d",_err);
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
}


- (void) testsetCircuitTwoClose{
    
    [self login];
    
    if (_loginStatus == Success) {
        
        [_devSwitch setCircuitTwoStatus:XAIDevCircuitStatusClose];
        
        
        _setTwo = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_setTwo > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_setTwo != start, @"delegate did not get called");
        XCTAssertTrue (_setTwo != Fail, @"no, set switch circuit two close should be suc.");
        XCTAssertTrue(_err == XAI_ERROR_NONE, @"err : %d",_err);
        
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
}



- (void)testGetCircuitOneStatus_err
{
    
    [self login];
    
    if (_loginStatus == Success) {
        
        _devSwitch.luid = _err_luid;
        [_devSwitch getCircuitOneStatus];
        
        
        _getOne = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_getOne > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_getOne != start, @"delegate did not get called");
        XCTAssertTrue (_getOne != Success, @"no, get switch circuit one should be fail with err luid.");
        XCTAssertTrue(_err != XAI_ERROR_NONE, @"err : %d",_err);
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
}


- (void) testGetCircuitTwoStatus_err{
    
    [self login];
    
    if (_loginStatus == Success) {
        
        
        _devSwitch.luid = _err_luid;
        [_devSwitch getCircuitTwoStatus];
        
        
        _getTwo = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_getTwo > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_getTwo != start, @"delegate did not get called");
        XCTAssertTrue (_getTwo != Fail, @"no, get switch circuit two should be fail with err luid.");
        XCTAssertTrue(_err != XAI_ERROR_NONE, @"err : %d",_err);
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
}


- (void) testsetCircuitOneOpen_err{
    
    
    [self login];
    
    if (_loginStatus == Success) {
        
        
        _devSwitch.luid = _err_luid;
        [_devSwitch setCircuitOneStatus:XAIDevCircuitStatusOpen];
        
        
        _setOne = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_setOne > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_setOne != start, @"delegate did not get called");
        XCTAssertTrue (_setOne != Fail, @"no, set switch circuit one open should be fail with err luid.");
        XCTAssertTrue(_err == XAI_ERROR_LUID_NONE_EXISTED, @"err : %d",_err);
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
}


- (void) testsetCircuitOneClose_err{
    
    
    [self login];
    
    if (_loginStatus == Success) {
        
        _devSwitch.luid = _err_luid;
        [_devSwitch setCircuitOneStatus:XAIDevCircuitStatusClose];
        
        
        _setOne = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_setOne > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_setOne != start, @"delegate did not get called");
        XCTAssertTrue (_setOne != Fail, @"no, set switch circuit one close should be fail with err luid.");
        XCTAssertTrue(_err == XAI_ERROR_LUID_NONE_EXISTED, @"err : %d",_err);
        
        
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
}

- (void) testsetCircuitTwoOpen_err{
    
    [self login];
    
    if (_loginStatus == Success) {
        
        _devSwitch.luid = _err_luid;
        [_devSwitch setCircuitTwoStatus:XAIDevCircuitStatusOpen];
        
        _setTwo = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_setTwo > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_setTwo != start, @"delegate did not get called");
        XCTAssertTrue (_setTwo != Fail, @"no, set switch circuit two open should be fail with err luid.");
        XCTAssertTrue(_err == XAI_ERROR_LUID_NONE_EXISTED, @"err : %d",_err);
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
}


- (void) testsetCircuitTwoClose_err{
    
    [self login];
    
    if (_loginStatus == Success) {
        
        _devSwitch.luid = _err_luid;
        [_devSwitch setCircuitTwoStatus:XAIDevCircuitStatusClose];
        
        
        _setTwo = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_setTwo > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_setTwo != start, @"delegate did not get called");
        XCTAssertTrue (_setTwo != Fail, @"no, set switch circuit two close should be fail with err luid.");
        XCTAssertTrue(_err == XAI_ERROR_LUID_NONE_EXISTED, @"err : %d",_err);
        
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
}





- (void) switch_:(XAIDevSwitch *)swi getCircuitOneStatus:(XAIDevCircuitStatus)status err:(XAI_ERROR)err{

    if (err == XAI_ERROR_NONE) {
        
        _getOne = Success;
    }else{
    
        _getOne = Fail;
    }
}
- (void) switch_:(XAIDevSwitch *)swi setCircuitOneErr:(XAI_ERROR)err{
    
    if (err == XAI_ERROR_NONE) {
        
        _setOne = Success;
    }else{
        
        _setOne = Fail;
    }

}

- (void) switch_:(XAIDevSwitch *)swi getCircuitTwoStatus:(XAIDevCircuitStatus)status err:(XAI_ERROR)err{
    
    if (err == XAI_ERROR_NONE) {
        
        _getTwo = Success;
    }else{
        
        _getTwo = Fail;
    }

}
- (void) switch_:(XAIDevSwitch *)swi setCircuitTwoErr:(XAI_ERROR)err{

    if (err == XAI_ERROR_NONE) {
        
        _setTwo = Success;
        
    }else{
        
        _setTwo = Fail;
    }


}



@end
