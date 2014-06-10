//
//  IPGetTest.m
//  XAI
//
//  Created by office on 14-6-9.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XAIIPHelper.h"


@interface IPGetTest : XCTestCase

@end

@implementation IPGetTest

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
    XAIIPHelper* helper =  [[XAIIPHelper alloc] init];
    [helper getApserverIp:[@"192.168.0.33" UTF8String]];
    
    in_addr_t  addr ;
    getdefaultgateway(&addr);
    

    printf("");
}

@end
