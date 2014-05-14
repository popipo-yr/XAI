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
    
    int _status;
    
    int _open;
    int _close;
}

@end

@implementation LightTest

- (void)setUp
{
    [super setUp];
    
    _light = [[XAILight alloc] init];
    _light.delegate = self;
    _light.apsn = 0x1;
    _light.luid= 0x00124B000413CDCF;//0x00124B000413C85C;
    
    
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
        
        
        _status = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_status > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue(_status != start, @"delegate did not get called");
        XCTAssertTrue(_status != Fail, @"get switch one status faild");
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }

}

- (void) testOpen{
    
    
    [self login];
    
    if (_loginStatus == Success) {
        
        
        
        [_light openLight];
        
        
        _open = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_open > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_open != start, @"delegate did not get called");
        XCTAssertTrue (_open != Fail, @"set switch one open status faild");
        
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
}


- (void) testClose{
    
    
    [self login];
    
    if (_loginStatus == Success) {
        
        
        
        [_light closeLight];
        
        
        _close = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_close > start) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_close != start, @"delegate did not get called");
        XCTAssertTrue (_close != Fail, @"set switch one open status faild");
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
}


-(void)lightCurStatus:(XAILightStatus)status{
    
    if (status != XAILightStatus_Unkown) {
        
        _status = Success;
    }else{
        
        _status = Fail;
    }

}

-(void)lightCloseSuccess:(BOOL)isSuccess{
    
    if (isSuccess) {
        
        _close = Success;
    }else{
        
        _close = Fail;
    }

}

-(void)lightOpenSuccess:(BOOL)isSuccess{

    if (isSuccess) {
        
        _open = Success;
    }else{
        
        _open = Fail;
    }
}

@end
