//
//  PacketACKTest.m
//  XAI
//
//  Created by office on 14-5-14.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "XAIPacketACK.h"

@interface PacketACKTest : XCTestCase

@end

@implementation PacketACKTest

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

    
    _xai_packet_param_ack* packer_ack = generateParamACKFromData(NULL, 0);
    
    XCTAssertTrue(packer_ack == NULL, @"false");
    
    packer_ack = generateParamACKFromData(NULL, 0);
    
    XCTAssertTrue(packer_ack == NULL, @"false");
    
    generatePacketFromParamACK(NULL);
    generateParamACKFromPacket(NULL);
    generateParamACKFromData(NULL, 100);
    purgePacketParamACKAndData(NULL);
    purgePacketParamACKNoData(NULL);
    getParamDataFromParamACK(NULL, 3);
    xai_param_ack_set(packer_ack, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
}


- (void)testDatasToParamFail
{
    NSString*  ABC = @"abccccccc";
    
    void* bytes = alloca(1000);
    
    [ABC getCharacters:bytes range:NSMakeRange(0, [ABC length])];
    
    _xai_packet_param_ack* packer_ack = generateParamACKFromData(bytes, 1000);
    
    XCTAssertTrue(packer_ack == NULL, @"false");
}


- (void) testParamToDatas{
    
    XAITYPEAPSN apsn = 0x00001;
    XAITYPELUID luid = 0x923884;
    
    _xai_packet_param_ack*  param_ack = generatePacketParamACK();
    
    
    _xai_packet_param_data* ack_data = generatePacketParamData();
    
    NSString *dataStr = @"一二三四五六";
    
     NSData* data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    xai_param_data_set(ack_data, XAI_DATA_TYPE_ASCII_TEXT,
                       [data length], (void*)[dataStr UTF8String],NULL);
    
    
    xai_param_ack_set(param_ack, apsn, luid, apsn, luid, 0, 0, 0, 0, 0, 1, ack_data);
    
    
    _xai_packet*  packet =  generatePacketFromParamACK(param_ack);
    
    _xai_packet_param_ack  *param =  generateParamACKFromPacket(packet);
    
    if (param != NULL){
        
        NSString*  abc = [[NSString alloc] initWithBytes:param->data->data length:param->data->data_len encoding:NSUTF8StringEncoding];
        NSString*  bbc = [[NSString alloc] initWithBytes:param_ack->data->data length:param_ack->data->data_len encoding:NSUTF8StringEncoding];
        
        XCTAssertTrue([abc isEqualToString:bbc], @"this is  right");
        XCTAssertTrue([abc isEqualToString:dataStr], @"this is  right");
        
    }else{
        
        XCTFail(@"generate is  wrong");
        
    }
    
    
    
    purgePacketParamData(ack_data);
    purgePacketParamACKAndData(param);
    purgePacket(packet);
    purgePacketParamACKNoData(param_ack);
    
    
    
}


@end
