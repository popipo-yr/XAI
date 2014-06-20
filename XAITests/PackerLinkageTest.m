//
//  PackerLinkageTest.m
//  XAI
//
//  Created by office on 14-6-4.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <XCTest/XCTest.h>
#include "XAIPacketLinkage.h"

@interface PackerLinkageTest : XCTestCase

@end

@implementation PackerLinkageTest

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
    
    
    _xai_packet_param_linkage* packer_linkage = generateParamLinkageFromData(NULL, 0);
    
    XCTAssertTrue(packer_linkage == NULL, @"false");
    
    packer_linkage = generateParamLinkageFromData(NULL, 100);
    
    XCTAssertTrue(packer_linkage == NULL, @"false");
    
    generatePacketFromeDataOne(NULL);
    generatePacketFromParamLinkage(NULL);
    generateParamLinkageFromPacket(NULL);
    generateParamLinkageFromData(NULL, 100);
    purgePacketParamLinkage(NULL);
    xai_param_Linkage_set(NULL, 0, 0, 0, 0, NULL);
}


- (void)testDatasToParamFail
{
    NSString*  ABC = @"abccccccc";
    
    void* bytes = alloca(1000);
    
    [ABC getCharacters:bytes range:NSMakeRange(0, [ABC length])];
    
    _xai_packet_param_linkage* packer_link = generateParamLinkageFromData(((void*)[ABC UTF8String]), [ABC length]);
    
    XCTAssertTrue(packer_link == NULL, @"false");
}


- (void) testParamToDatas{
    
    XAITYPEAPSN apsn = 0x00001;
    XAITYPELUID luid = 0x923884;
    
    _xai_packet_param_linkage*  param_link = generatePacketParamLinkage();
    
    
    _xai_packet_param_data* link_data = generatePacketParamData();
    
    NSString *dataStr = @"一二三四五六";
    
    NSData* data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    xai_param_data_set(link_data, XAI_DATA_TYPE_ASCII_TEXT,
                       [data length], (void*)[dataStr UTF8String],NULL);
    
    
    xai_param_Linkage_set(param_link, apsn, luid, 0, 0, link_data);
    
    
    _xai_packet*  packet =  generatePacketFromParamLinkage(param_link);
    
    _xai_packet_param_linkage  *param =  generateParamLinkageFromPacket(packet);
    
    if (param != NULL){
        
        NSString*  abc = [[NSString alloc] initWithBytes:param->data->data length:param->data->data_len encoding:NSUTF8StringEncoding];
        NSString*  bbc = [[NSString alloc] initWithBytes:param_link->data->data length:param_link->data->data_len encoding:NSUTF8StringEncoding];
        
        XCTAssertTrue([abc isEqualToString:bbc], @"this is  right");
        XCTAssertTrue([abc isEqualToString:dataStr], @"this is  right");
        
    }else{
        
        XCTFail(@"generate is  wrong");
        
    }
    
    
    
    purgePacketParamData(link_data);
    purgePacketParamLinkage(param_link);
    purgePacket(packet);
    purgePacketParamLinkage(param);
    
    
    
}


@end
