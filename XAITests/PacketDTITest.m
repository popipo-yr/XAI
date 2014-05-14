//
//  PacketDTITest.m
//  XAI
//
//  Created by office on 14-5-14.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "XAIPacketDevTypeInfo.h"

@interface PacketDTITest : XCTestCase

@end

@implementation PacketDTITest

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

- (void)testDatasToParamFail
{
    NSString*  ABC = @"abccccccc";
    
    void* bytes = alloca(1000);
    
    [ABC getCharacters:bytes range:NSMakeRange(0, [ABC length])];
    
    _xai_packet_param_dti* packer_dti = generateParamDTIFromData(bytes, 1000);
    
    XCTAssertTrue(packer_dti == NULL, @"false");
    
    packer_dti = generateParamDTIFromData(bytes, 0);
    
    XCTAssertTrue(packer_dti == NULL, @"false");
    
    generatePacketFromParamDTI(NULL);
    generateParamDTIFromPacket(NULL);
    generateParamDTIFromData(NULL, 100);
    purgePacketParamDTI(NULL);
    
    xai_param_dti_set(packer_dti, 0, 0, 0, 0, 0, 0, 0, NULL, 0, NULL, 0);
}


- (void)testDatasToParamSuc
{
    NSString*  ABC = @"abccccccc";
    
    void* bytes = alloca(1000);
    
    [ABC getCharacters:bytes range:NSMakeRange(0, [ABC length])];
    
    _xai_packet_param_dti* packer_dti = generateParamDTIFromData(bytes, 1000);
    
    XCTAssertTrue(packer_dti == NULL, @"false");
}


- (void) testParamToDatas{
    
    XAITYPEAPSN apsn = 0x00001;
    XAITYPELUID luid = 0x923884;
    
    _xai_packet_param_dti*  param_dti = generatePacketParamDTI();
    
    NSString *dataStr = @"一二三四";
    
    NSData* data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    xai_param_dti_set(param_dti, apsn, luid, apsn, luid, 0, 0, 0, (void*)[dataStr UTF8String], [data length], NULL, 0);
    
    
    _xai_packet*  packet =  generatePacketFromParamDTI(param_dti);
    
    _xai_packet_param_dti  *param =  generateParamDTIFromPacket(packet);
    
    
    
    if (param != NULL){
        
        

        NSString*  abc =  [[NSString alloc] initWithBytes:param->vender length:sizeof(param->vender) encoding:NSUTF8StringEncoding];
        NSString*  bbc = [[NSString alloc] initWithBytes:param_dti->vender length:sizeof(param->vender) encoding:NSUTF8StringEncoding];
        
        
        
        if ([data length] > sizeof(param->vender)) {
            
            XCTAssertTrue(![abc isEqualToString:dataStr], @"this is  right");
            
        }else{
            
            XCTAssertTrue([abc isEqualToString:dataStr], @"this is  right");
            XCTAssertTrue([abc isEqualToString:bbc], @"this is  right");
        
        }
        
        
    }else{
        
        XCTFail(@"generate is  wrong");
        
    }
    
    
    

    purgePacketParamDTI(param);
    purgePacket(packet);
    purgePacketParamDTI(param_dti);
    
    
    
}


@end
