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

- (void) testLogin_true{
    
    [self login];
    
    XCTAssertTrue (_loginStatus != 0, @"delegate did not get called");
    XCTAssertTrue (_loginStatus != 2, @"login faild");
}


- (void) testLogin_errInfo{

    [self loginWithName:@"admin" PWD:@"adminnn"];
    
    XCTAssert(_loginStatus_normal != start, @"delegate did not get called");
    XCTAssert(_loginStatus_normal != Success,@"no, login should be fail with err info");
 
}

- (void) testLogin_NameNull{

    [self loginWithName:NULL PWD:@"adminnn"];
    
    XCTAssert(_loginStatus_normal != start, @"delegate did not get called");
    XCTAssert(_loginStatus_normal != Success,@"no, login should be fail with null name");

}


- (void) testLogin_PawdNull{
    
    [self loginWithName:@"admin" PWD:NULL];
    
    XCTAssert(_loginStatus_normal != start, @"delegate did not get called");
    XCTAssert(_loginStatus_normal != Success,@"no, login should be fail with null password");
    
}


@end
