//
//  XAITests.m
//  XAITests
//
//  Created by touchhy on 14-4-1.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XAIPacket.h"

@interface XAITests : XCTestCase

@end

@implementation XAITests

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
    NSString *from_guid = @"11111";
    NSString *to_guid = @"22222";
    NSString *flag = @"1";
    NSString *msgid = @"5";
    NSString * magic_number = @"8";
    NSString * length  = @"1";
    NSString*  oprId = @"11";
    NSString*   data_count = @"20";
    NSString*   data_len = @"100";
    NSString*  data = @"ABCDEFG";
    
    
    
#define  cStr(abc)  [(abc) cStringUsingEncoding:NSUTF8StringEncoding]
    
    
    
//    _xai_ctrl_packet*  abc =  generateControlPacket( cStr(from_guid)  //12Byte
//                                              ,cStr(to_guid)   //12Byte
//                                              ,cStr(flag)      //1Byte
//                                              ,cStr(msgid)     //2Byte
//                                              ,cStr(magic_number) //2byte
//                                              ,cStr(length)       //2byte
//                                              ,cStr(oprId)      //2byte
//                                              ,cStr(data_count) //1byte
//                                              ,cStr(data_len)   //2byte
//                                              ,cStr(data)    //.......
//                                                    );
    
    
    _xai_packet_param_normal  aP;
    aP.from_guid = "23456";
    aP.to_guid = "11111";
    
    _xai_packet*  cabc =  generateNormalPacket(&aP);
                                               

    
    
    
    _xai_packet_param_normal *param =  generateNormalParamFromPacket(cabc);
   
    param = NULL;
    
//    NSString *CC= [[NSString alloc] initWithCString:(const char*)param->from_guid encoding:NSUTF8StringEncoding];
//	
//    CC =  NULL;
//    
//	//char * 转换为 NSString
//	//char encode_buf[1024];
//	NSString *encrypted = [[NSString alloc] initWithCString:(const char*)abc->overload encoding:NSASCIIStringEncoding];
//	NSLog(@"encrypted:%@", encrypted);
    XCTAssertTrue(1 == 1, @"just a test");
    
}

@end
