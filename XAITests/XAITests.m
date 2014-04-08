//
//  XAITests.m
//  XAITests
//
//  Created by touchhy on 14-4-1.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XAIPacket.h"
#import "XAIPacketCtrl.h"
#import "MosquittoMessage.h"

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

-(void)testPacketCtrl{
    
    NSString *from_guid = @"AAAAA";
    NSString *to_guid = @"22222";
    
    
    _xai_packet_param_ctrl*  param_ctrl = generatePacketParamCtrl();
    

    
    copybyteArray(param_ctrl->normal_param->from_guid, [from_guid UTF8String],
                  sizeof(param_ctrl->normal_param->from_guid), [from_guid length]);
    copybyteArray(param_ctrl->normal_param->to_guid, [to_guid UTF8String],
                  sizeof(param_ctrl->normal_param->to_guid), [to_guid length]);
    
    param_ctrl->normal_param->flag  = 0x2;
    param_ctrl->normal_param->msgid = 0x23;
    param_ctrl->normal_param->magic_number = 0x45;
    param_ctrl->normal_param->length  =  0x20;
    param_ctrl->normal_param->data = "akfkjalfkjklsjfls";
    
    param_ctrl->oprId = 0x11;
    param_ctrl->time = 0x888888;
    param_ctrl->data = "csfsfsagllllllg";
    param_ctrl->data_len = 0x20;
    
    
    
    _xai_packet*  packet =  generatePacketCtrl(param_ctrl);
    
    _xai_packet_param_ctrl  *param =  generateParamCtrlFromPacket(packet);
    
    
    NSString*  abc = [[NSString alloc] initWithBytes:param->data length:param->data_len encoding:NSUTF8StringEncoding];
    NSString*  bbc = [[NSString alloc] initWithBytes:param_ctrl->data length:param_ctrl->data_len encoding:NSUTF8StringEncoding];
    

    XCTAssertTrue([abc isEqualToString:bbc], @"just a test");
    
    
    purgePacketParamCtrl(param);
    purgePacket(packet);
    purgePacketParamCtrl(param_ctrl);
    

}

- (void)testPacket

{
    NSString *from_guid = @"AAAAA";
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
    
    void*  bbb;
    //uint8_t*  s = 12314124;
    uint8_t   ss[20];
    
    
    _xai_packet_param_normal*  np = generatePacketParamNormal();
    NSLog(@"%lu,%lu,%lu",sizeof(np->from_guid),sizeof(bbb),sizeof(ss));
    
    copybyteArray(np->from_guid, [from_guid UTF8String], sizeof(np->from_guid), [from_guid length]);
    copybyteArray(np->to_guid, [to_guid UTF8String], sizeof(np->to_guid), [to_guid length]);
    
    np->flag  = 0x2;
    np->msgid = 0x23;
    np->magic_number = 0x45;
    np->length  =  0x20;
    np->data = "akfkjalfkjklsjfls";
    
    
    _xai_packet*  cabc =  generatePacketNormal(np);
    
    purgePacketParamNormal(np);
    
    _xai_packet_param_normal *param =  generateParamNormalFromPacket(cabc);
    
    
//    _xai_packet_param_ctrl  cp;
//    cp.normal_param = &np;
//    cp.oprId = cStr(oprId);
//    cp.data_count = cStr(data_count);
//    cp.data_len = cStr(data_len);
//    cp.data = "wssssssssssssw";
//    
//    _xai_packet* cpkt = generatePacketCtrl(&cp);
//    _xai_packet_param_ctrl*  cparam = generateParamCtrlFromPacket(cpkt);
//
//    cparam = NULL;
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
    
    
     from_guid = @"11111";
     to_guid = @"22222";
     flag = @"1";
     msgid = @"5";
     magic_number = @"8";
      length  = @"1";
    
    
      oprId = @"1";
       data_count = @"2";
       data_len = @"10";
    
}

- (void) helper{

    MosquittoMessage* aM = [[MosquittoMessage alloc] init];
    aM = nil;
}
- (void) testARC {
   
    [self helper];
    
    XCTAssertTrue( 1 == 1);
    
}

@end
