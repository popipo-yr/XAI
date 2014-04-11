//
//  APServerTest.m
//  XAI
//
//  Created by office on 14-4-10.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "APServerNode.h"

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
    uint32_t   APNS =99;
    
    NSString*  s = [[NSString alloc] initWithBytes:&APNS length:4 encoding:NSUTF8StringEncoding];
    
    
    uint16_t cover = 0x8877;
    
    uint16_t  cover1 =  CFSwapInt16HostToBig(cover);
    uint16_t  cover2 =  CFSwapInt16BigToHost(cover);
    
    APServerNode* node = [[APServerNode alloc] init];
    [node addUser:@"testname" Password:@"testname"];
    
    
    
     XCTAssertTrue( 1 == 1, @"APServer");
}

@end
