//
//  LightTest.m
//  XAI
//
//  Created by office on 14-5-14.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "LoginPlugin.h"
#import "XAILight.h"

@interface LightTest : LoginPlugin<XAILigthtDelegate>{

    XAILight*  _light;
    
    int _l_status;
    
    int _l_open;
    int _l_close;
    
    XAITYPELUID _err_luid;
}

@end

@implementation LightTest

- (void)setUp
{
    [super setUp];
    
    _light = [[XAILight alloc] init];
    _light.delegate = self;
    _light.apsn = [MQTT  shareMQTT].apsn;
    _light.luid= 0x0002000000000001;//0x00124B000413C85C;
    
    _err_luid = 0x0002000001000001;
    
    
    [_light startControl];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testStatus
{
    [self login];
    
    if (_loginStatus == Success) {
        
        
        
        [_light getCurStatus];
        
        
        _l_status = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_l_status > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue(_l_status != start, @"delegate did not get called");
        XCTAssertTrue(_l_status != Fail, @"no, Get light status should be suc.");
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }

}

- (void) testOpen{
    
    
    [self login];
    
    if (_loginStatus == Success) {
        
        [_light openLight];
        
        
        _l_open = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_l_open > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_l_open != start, @"delegate did not get called");
        XCTAssertTrue (_l_open != Fail, @"no, open light shoule be suc.");
        
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
}


- (void) testClose{
    
    
    [self login];
    
    if (_loginStatus == Success) {
        
        [_light closeLight];
        
        
        _l_close = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_l_close > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_l_close != start, @"delegate did not get called");
        XCTAssertTrue (_l_close != Fail, @"no, close light shoule be suc");
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
}


- (void)testStatus_err
{
    [self login];
    
    if (_loginStatus == Success) {
        
        
        _light.luid = _err_luid;
        [_light startControl];
        [_light getCurStatus];
        
        
        _l_status = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_l_status > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue(_l_status != start, @"delegate did not get called");
        XCTAssertTrue(_l_status != Success, @"no, Get light status should be fail with err luid");
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
}

- (void) testOpen_err{
    
    
    [self login];
    
    if (_loginStatus == Success) {
        
        _light.luid = _err_luid;
        [_light startControl];
        [_light openLight];
        
        
        _l_open = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_l_open > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_l_open != start, @"delegate did not get called");
        XCTAssertTrue (_l_open != Success, @"no, open light shoule be fail with err luid.");
        
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
}


- (void) testClose_err{
    
    
    [self login];
    
    if (_loginStatus == Success) {
        
        _light.luid = _err_luid;
        [_light startControl];
        [_light closeLight];
        
        
        _l_close = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_l_close > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_l_close != start, @"delegate did not get called");
        XCTAssertTrue (_l_close != Success, @"no, close light shoule be fail with err luid");
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
}



-(void)light:(XAILight *)light curStatus:(XAILightStatus)status{
    
    if (status != XAILightStatus_Unkown) {
        
        _l_status = Success;
    }else{
        
        _l_status = Fail;
    }

}

-(void)light:(XAILight *)light closeSuccess:(BOOL)isSuccess{
    
    if (isSuccess) {
        
        _l_close = Success;
    }else{
        
        _l_close = Fail;
    }

}

-(void)light:(XAILight *)light openSuccess:(BOOL)isSuccess{

    if (isSuccess) {
        
        _l_open = Success;
    }else{
        
        _l_open = Fail;
    }
}

@end
