//
//  XAIAlertTest.m
//  XAI
//
//  Created by office on 14-7-25.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "LoginPlugin.h"
#import "XAIAlert.h"

@interface XAIAlertTest : LoginPlugin{

    int _start;
}

@end

@implementation XAIAlertTest

- (void)setUp
{
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetAlert
{
    [self login];
    
    if (_loginStatus == Success) {
        
        
        
        [[XAIAlert shareAlert] startFocus];
        
        _start = start;
        
        
        runInMainLoop(^(BOOL * done) {
            
            if (_start > 0) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_start != start, @"delegate did not get called");
        XCTAssertTrue (_start != Fail, @"Find faild");
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }

}

@end
