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
    NSString*  oprId = @"1";
    NSString*   data_count = @"2";
    NSString*   data_len = @"10";
    
    
    
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
    
    
    free(NULL);
    
    _xai_packet_param_normal  np;
    np.from_guid = cStr(from_guid);
    np.to_guid = cStr(to_guid);
    np.flag  = cStr(flag);
    np.msgid = cStr(msgid);
    np.magic_number = cStr(magic_number);
    np.length  =  cStr(length);
    np.data = "akfkjalfkjklsjfls";
    
    
    _xai_packet*  cabc =  generatePacketNormal(&np);
    
    _xai_packet_param_normal *param =  generateParamNormalFromPacket(cabc);
    
    
    _xai_packet_param_ctrl  cp;
    cp.normal_param = &np;
    cp.oprId = cStr(oprId);
    cp.data_count = cStr(data_count);
    cp.data_len = cStr(data_len);
    cp.data = "wssssssssssssw";
    
    _xai_packet* cpkt = generatePacketCtrl(&cp);
    _xai_packet_param_ctrl*  cparam = generateParamCtrlFromPacket(cpkt);
   
    cparam = NULL;
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
