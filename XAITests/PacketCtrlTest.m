//
//  CtrlPacketTest.m
//  XAI
//
//  Created by office on 14-5-13.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XAIPacketCtrl.h"


@interface PacketCtrlTest : XCTestCase

@end

@implementation PacketCtrlTest

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

    
    _xai_packet_param_ctrl* packer_ctrl = generateParamCtrlFromData(NULL, 0);
    
    XCTAssertTrue(packer_ctrl == NULL, @"false");
    
    packer_ctrl = generateParamCtrlFromData(NULL, 100);
    
    XCTAssertTrue(packer_ctrl == NULL, @"false");
    
    generatePacketFromParamCtrl(NULL);
    generateParamCtrlFromPacket(NULL);
    generateParamCtrlFromData(NULL, 100);
    purgePacketParamCtrlAndData(NULL);
    purgePacketParamCtrlNoData(NULL);
    getParamDataFromParamCtrl(NULL, 3);
    xai_param_ctrl_set(NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
}


- (void)testDatasToParamFail
{
    NSString*  ABC = @"abccccccc";
    
    void* bytes = alloca(1000);
    
    [ABC getCharacters:bytes range:NSMakeRange(0, [ABC length])];
    
    _xai_packet_param_ctrl* packer_ctrl = generateParamCtrlFromData(bytes, 1000);
    
    XCTAssertTrue(packer_ctrl == NULL, @"false");
}


- (void) testParamToDatas{

    XAITYPEAPSN apsn = 0x00001;
    XAITYPELUID luid = 0x923884;
    
    _xai_packet_param_ctrl*  param_ctrl = generatePacketParamCtrl();
    
    
    _xai_packet_param_data* ctrl_data = generatePacketParamData();
    
    NSString *dataStr = @"电饭锅里高考顺利";
     NSData* data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    xai_param_data_set(ctrl_data, XAI_DATA_TYPE_ASCII_TEXT,
                       [data length], (void*)[dataStr UTF8String],NULL);
    

    xai_param_ctrl_set(param_ctrl,apsn, luid, apsn, luid, XAI_PKT_TYPE_CONTROL,
                       0, 0, 1,[[NSDate new] timeIntervalSince1970],1, ctrl_data);
    
    
    _xai_packet*  packet =  generatePacketFromParamCtrl(param_ctrl);
    
    _xai_packet_param_ctrl  *param =  generateParamCtrlFromPacket(packet);
    
    
    if (param != NULL){
    
        NSString*  abc = [[NSString alloc] initWithBytes:param->data->data length:param->data->data_len encoding:NSUTF8StringEncoding];
        NSString*  bbc = [[NSString alloc] initWithBytes:param_ctrl->data->data length:param_ctrl->data->data_len encoding:NSUTF8StringEncoding];
        
        XCTAssertTrue([abc isEqualToString:bbc], @"this is  right");
        XCTAssertTrue([abc isEqualToString:dataStr], @"this is  right");
    
    }else{
    
        XCTFail(@"generate is  wrong");
    
    }
    
    
    
    purgePacketParamData(ctrl_data);
    purgePacketParamCtrlAndData(param);
    purgePacket(packet);
    purgePacketParamCtrlNoData(param_ctrl);

    

}




@end
