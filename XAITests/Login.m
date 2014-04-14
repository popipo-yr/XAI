//
//  Login.m
//  XAI
//
//  Created by office on 14-4-9.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XAILogin.h"

@interface Login : XCTestCase

@end

@implementation Login

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

- (void)testExample
{
    XAILogin*  login = [[XAILogin alloc] init];
    [login loginWithName:@"admin@00000001" Password:@"admin" Host:@"192.168.1.1"];
    
    
    NSDate *runUntil = [NSDate dateWithTimeIntervalSinceNow: 130.0 ];
    
    NSLog(@"about to wait");
    [[NSRunLoop currentRunLoop] runUntilDate:runUntil];
    NSLog(@"wait time is over");

    //sleep(1000*1000*600);
    
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
