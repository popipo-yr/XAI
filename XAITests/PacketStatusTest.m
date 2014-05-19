//
//  PacketStatusTest.m
//  XAI
//
//  Created by office on 14-5-14.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "XAIPacketStatus.h"

@interface PacketStatusTest : XCTestCase

@end

@implementation PacketStatusTest

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

- (void)testDatasToParamNULL
{
    
    _xai_packet_param_status* packer_status = generateParamStatusFromData(NULL, 1000);
    
    XCTAssertTrue(packer_status == NULL, @"false");
    
    packer_status = generateParamStatusFromData(NULL, 0);
    
    XCTAssertTrue(packer_status == NULL, @"false");
    
    generatePacketFromParamStatus(NULL);
    generateParamStatusFromPacket(NULL);
    generateParamStatusFromData(NULL, 100);
    purgePacketParamStatusAndData(NULL);
    purgePacketParamStatusNoData(NULL);
    getParamDataFromParamStatus(NULL, 3);
    xai_param_status_set(NULL, 0, 0, 0, 0, 0, 0, 0, 0, NULL, 0, NULL, 0, 0, 0, NULL);
}


- (void)testDatasToParamFail
{
    NSString*  ABC = @"abccccccc";
    
    void* bytes = alloca(1000);
    
    [ABC getCharacters:bytes range:NSMakeRange(0, [ABC length])];
    
    _xai_packet_param_status* packer_status = generateParamStatusFromData(bytes, 1000);
    
    XCTAssertTrue(packer_status == NULL, @"false");
}


- (void) testParamToDatas{
    
    XAITYPEAPSN apsn = 0x00001;
    XAITYPELUID luid = 0x923884;
    
    _xai_packet_param_status*  param_status = generatePacketParamStatus();
    
    
    _xai_packet_param_data* status_data = generatePacketParamData();
    
    NSString *dataStr = @"而公司经过了递归";
    
       NSData* data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    xai_param_data_set(status_data, XAI_DATA_TYPE_ASCII_TEXT,
                       [data length], (void*)[dataStr UTF8String],NULL);
    
    xai_param_status_set(param_status, apsn, luid, apsn, luid, 0, 0, 0, 0
                         , NULL, 0, NULL, 0,[[NSDate new] timeIntervalSince1970],1, status_data);
    
    
    _xai_packet*  packet =  generatePacketFromParamStatus(param_status);
    
    _xai_packet_param_status  *param =  generateParamStatusFromPacket(packet);
    
    if (param != NULL){
        
        NSString*  abc = [[NSString alloc] initWithBytes:param->data->data length:param->data->data_len encoding:NSUTF8StringEncoding];
        NSString*  bbc = [[NSString alloc] initWithBytes:param_status->data->data length:param_status->data->data_len encoding:NSUTF8StringEncoding];
        
        XCTAssertTrue([abc isEqualToString:bbc], @"this is  right");
        XCTAssertTrue([abc isEqualToString:dataStr], @"this is  right");
        
    }else{
        
        XCTFail(@"generate is  wrong");
        
    }
    
    
    
    purgePacketParamData(status_data);
    purgePacketParamStatusAndData(param);
    purgePacket(packet);
    purgePacketParamStatusNoData(param_status);
    
    
    
}


@end
