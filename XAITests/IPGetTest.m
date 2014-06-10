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


static  inline void runInMainLoop(void(^block)(BOOL *done)) {
    __block BOOL done = NO;
    
    while (!done) {
        
        block(&done);
        [[NSRunLoop mainRunLoop] runUntilDate:
         [NSDate dateWithTimeIntervalSinceNow:.1]];
    }
}

- (void)testExample
{
    XAIIPHelper* helper =  [[XAIIPHelper alloc] init];
    //[helper getApserverIp:&ip host:[@"192.168.0.33" UTF8String]];
    
    [helper getApserverIp:@"www.xai.so"];
    
    int  _addStatus = 0;
    
    runInMainLoop(^(BOOL * done) {
        
        if (_addStatus > 1) {
            
            *done = YES;
        }
    });
    
    
}

@end
