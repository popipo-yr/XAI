//
//  IPGetTest.m
//  XAI
//
//  Created by office on 14-6-9.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XAIIPHelper.h"
#import "LoginPlugin.h"


@interface IPGetTest : XCTestCase<XAIIPHelperDelegate>{

    int  _getStatus;
}

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


//static  inline void runInMainLoop(void(^block)(BOOL *done)) {
//    __block BOOL done = NO;
//    
//    while (!done) {
//        
//        block(&done);
//        [[NSRunLoop mainRunLoop] runUntilDate:
//         [NSDate dateWithTimeIntervalSinceNow:.1]];
//    }
//}

- (void)testGetIp
{
    XAIIPHelper* helper =  [[XAIIPHelper alloc] init];
    //[helper getApserverIp:&ip host:[@"192.168.0.33" UTF8String]];
    
    helper.delegate = self;
    [helper getApserverIpWithApsn:_K_APSN fromRoute:@"www.xai.so"];
    
    _getStatus = 0;
    
    runInMainLoop(^(BOOL * done) {
        
        if (_getStatus > 0) {
            
            *done = YES;
        }
    });
    
    
    
    XCTAssertTrue (_getStatus != 0, @"delegate did not get called");
    XCTAssertTrue (_getStatus != 2, @"Find faild");
    
}

-(void)xaiIPHelper:(XAIIPHelper *)helper getIp:(NSString *)ip errcode:(_err)rc{
    
    if (rc == _err_none) {
        
        _getStatus = 1;
        
        NSLog(@"%@",ip);
        
    }else{
    
        _getStatus = 2;
    }
}

@end
