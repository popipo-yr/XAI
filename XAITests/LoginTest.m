//
//  LoginTest.m
//  XAI
//
//  Created by office on 14-5-14.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "LoginPlugin.h"

@interface LoginTest : LoginPlugin

@end

@implementation LoginTest

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

- (void) testLogin{
    
    [self login];
    
    XCTAssertTrue (_loginStatus != 0, @"delegate did not get called");
    XCTAssertTrue (_loginStatus != 2, @"login faild");
}


@end
