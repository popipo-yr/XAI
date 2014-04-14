//
//  APServerTest.m
//  XAI
//
//  Created by office on 14-4-10.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "APServerNode.h"
#import "MQTTCover.h"

@interface APServerTest : XCTestCase

@end

@implementation APServerTest

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
    
    NSLog(@"%@",[MQTTCover nodeDevTableTopicWithAPNS:0x11111111 luid:0x4444]);
    
    
    APServerNode* node = [[APServerNode alloc] init];
    [node addUser:@"testname" Password:@"testname"];
    
    
    
     XCTAssertTrue( 1 == 1, @"APServer");
}

@end
