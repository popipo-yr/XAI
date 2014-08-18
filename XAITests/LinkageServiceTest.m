//
//  LinkageServiceTest.m
//  XAI
//
//  Created by office on 14-6-4.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XAILinkageService.h"


#import "XAILight.h"
#import "XAIDoor.h"
#import "LoginPlugin.h"


@interface LinkageServiceTest  : LoginPlugin <XAILinkageServiceDelegate> {
    
    
    XAILinkageService*  _service;
    
    
    int _addStatus;
    int _delStatus;
    
    int _findStatus;
    
    int _getDetail;
    
    
    NSString* _name4Change;
    
    NSString* _name4Change_end;
    
    
    XAILight* _light;
    XAIDoor* _door;

    
    
    XAI_ERROR _err;
    
}


@end

@implementation LinkageServiceTest

- (void)setUp
{
        [super setUp];
    
    _service = [[XAILinkageService alloc] init];
    
    
    _service.apsn = [MQTT shareMQTT].apsn;
    _service.luid = MQTTCover_LUID_Server_03;
    _service.linkageServiceDelegate = self;
    
    
    
    _name4Change = [NSString stringWithFormat:@"NAME111"];
    _name4Change_end = [NSString stringWithFormat:@"NAME112"];
    
    //    _luidDev = 0x124b0003d430b6 ;
    
    //    _luidDev = 0x124b000257d985 ;
    //    _luidDev = 0x124b0002d5786f ;
    //    _luidDev = 0x124b0002623bed ;
    //    _luidDev = 0x124b000229251c ;
    
    
    //    _luidDev = 0x124b000413c8d8 ;
    
    //    _luidDev = 0x124b0003d4317c;
    //    _luidDev = 0x124b0003d430b7;
    //    _luidDev = 0x124b0002292580;
    //    _luidDev = 0x124b00023f0c6c;
    //    _luidDev = 0x124b000257d991;
    
    
    //开关
    //    _luidDev = 0x00124B000413C85C;  //21
    //     _luidDev = 0x00124B000413C931;
    //_luidDev = 0x00124B000413CCC2;
    
    
    _light = [[XAILight alloc] init];
    _light.apsn = [MQTT shareMQTT].apsn;
    _light.luid =  0x00124b00039afe69;
    
    [_light startControl];
    
    _door = [[XAIDoor alloc] init];
    _door.apsn = [MQTT shareMQTT].apsn;
    _door.luid = 0x124b00039affd6;
    
    [_door startControl];
    

    
    // _name4Change = [NSString stringWithFormat:@"%@%llX",@"NAME1",_luidDev];
    _name4Change_end = @"NAME2";
    
    
    
    
    

    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//static inline void runInMainLoop(void(^block)(BOOL *done)) {
//    __block BOOL done = NO;
//
//    while (!done) {
//
//        block(&done);
//        [[NSRunLoop mainRunLoop] runUntilDate:
//         [NSDate dateWithTimeIntervalSinceNow:.1]];
//    }
//}

- (void)_addLinkageParams:(NSArray *)ary ctrlInfo:(XAILinkageUseInfoCtrl *)ctrlInfo
                   status:(XAILinkageStatus)status name:(NSString *)name{
    
    [self login];
    
    _addStatus = start;
    
    if (_loginStatus == Success) {
        
        
        [_service addLinkageParams:ary ctrlInfo:ctrlInfo status:status name:name];
        
        
        _addStatus = 0;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_addStatus > start) {
                
                *done = YES;
            }
        });
    }
    
}


- (void)_delLinkage:(XAILinkageNum)num{
    
    
    [self login];
    
    if (_loginStatus == Success) {
        
        [_service delLinkage:num];
        
        
        _delStatus = start;
        
        runInMainLoop(^(BOOL * done) {
            
            if (_delStatus > start) {
                
                *done = YES;
            }
        });
        
    }
}

//
//- (void)_changeDev:(XAITYPELUID)luid name:(NSString*)name
//{
//    
//    [self login];
//    
//    if (_loginStatus == Success) {
//        
//        
//        [_devService changeDev:luid withName:name];
//        
//        
//        _changeNameStatus = start;
//        
//        runInMainLoop(^(BOOL * done) {
//            
//            if (_changeNameStatus > start) {
//                
//                *done = YES;
//            }
//        });
//        
//    }
//}




- (void)test_Add_TRUE_D_U
{
    XAITYPEAPSN apsn = [MQTT shareMQTT].apsn;
    
    XAITYPELUID  doorLuid = 0x00124b0004e8369b;
    int doorstatus = 1;
    XAITYPELUID  usLuid = 0x3;
    int usAdd = 1;
    
    
    XAILinkageUseInfoCtrl* open = [[XAILinkageUseInfoCtrl alloc] init];
    
    _xai_packet_param_data* open_data = generatePacketParamData();
    XAITYPEBOOL typeopen =  XAITYPEBOOL_TRUE;
    xai_param_data_set(open_data, XAI_DATA_TYPE_BIN_BOOL, sizeof(XAITYPEBOOL), &typeopen, NULL);
    
    [open setApsn:apsn Luid:doorLuid ID:doorstatus Datas:open_data];
    
    
    XAILinkageUseInfoStatus* us_add = [[XAILinkageUseInfoStatus alloc] init];
    
    _xai_packet_param_data* apsn_data = generatePacketParamData();
    _xai_packet_param_data* username_data = generatePacketParamData();
    _xai_packet_param_data* password_data = generatePacketParamData();
    
    xai_param_data_set(apsn_data, XAI_DATA_TYPE_BIN_APSN , sizeof(XAITYPEAPSN), &apsn, username_data);
    
    
    NSData* data = [@"联动" dataUsingEncoding:NSUTF8StringEncoding];
    xai_param_data_set(username_data, XAI_DATA_TYPE_ASCII_TEXT,
                       [data length], (void*)[@"联动" UTF8String],password_data);
    
    NSData* paswddata = [@"PAWD" dataUsingEncoding:NSUTF8StringEncoding];
    xai_param_data_set(password_data, XAI_DATA_TYPE_ASCII_TEXT,
                       [paswddata length], (void*)[@"PAWD" UTF8String],NULL);
    
    
    [us_add setApsn:[MQTT shareMQTT].apsn Luid:usLuid ID:usAdd Datas:apsn_data];
    
    
    [self _addLinkageParams:[NSArray arrayWithObjects:us_add, nil]
                   ctrlInfo:open
                     status:XAILinkageStatus_Active
                       name:@"ls_test2"];
    
    if (_loginStatus == Success) {
        
        
        XCTAssertTrue (_addStatus != start, @"delegate did not get called");
        XCTAssertTrue (_addStatus != Fail, @"no, add dev should be suc");
        XCTAssert(_err == XAI_ERROR_NONE, @"-err:%d",_err);
        
    }else{
        
        
        XCTFail(@"login faild");
    }
    
}


- (void)test_Add_TRUE
{
    
    [self _addLinkageParams:[NSArray arrayWithObjects:[[_door getLinkageTiaojian] objectAtIndex:0], nil]
                   ctrlInfo:[[_light getLinkageTiaojian] objectAtIndex:0]
                     status:XAILinkageStatus_Active
                       name:_name4Change];
    
    if (_loginStatus == Success) {
        
        
        XCTAssertTrue (_addStatus != start, @"delegate did not get called");
        XCTAssertTrue (_addStatus != Fail, @"no, add dev should be suc");
        XCTAssert(_err == XAI_ERROR_NONE, @"-err:%d",_err);
        
    }else{
        
        
        XCTFail(@"login faild");
    }
    
}

- (void) testFindAll{
    
    [self login];
    
    if (_loginStatus == Success) {
        
        
        
        [_service findAllLinkages];
        
        _findStatus = start;
        
        
        runInMainLoop(^(BOOL * done) {
            
            if (_findStatus > 0) {
                
                *done = YES;
            }
        });
        
        
        XCTAssertTrue (_findStatus != start, @"delegate did not get called");
        XCTAssertTrue (_findStatus != Fail, @"Find faild");
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
}


- (void)testDel_TRUE
{
//    [self _addLinkageParams:[NSArray arrayWithObjects:[[_door getLinkageUseInfos] objectAtIndex:0], nil]
//                   ctrlInfo:[[_light getLinkageUseInfos] objectAtIndex:0]
//                     status:XAILinkageStatus_Active
//                       name:_name4Change];
//    
//    if (_loginStatus != Success && _addStatus != Success) {
//        
//        XCTFail(@"Del_TRUE test faild : generate data faild");
//        return;
//    }
//    
    [self login];
    
    [self _delLinkage:0x1];
    
    
    if (_loginStatus == Success) {
        
        
        XCTAssertTrue (_delStatus != start, @"delegate did not get called");
        XCTAssertTrue (_delStatus != Fail, @"no, del dev should be true");
        
        XCTAssert(_err == XAI_ERROR_NONE, @"-err : %d", _err);
        
    }else{
        
        
        XCTFail(@"LOGIN FAILD");
    }
    
    
}

- (void)testGetDetail_TRUE
{
    [self _addLinkageParams:[NSArray arrayWithObjects:[[_door getLinkageTiaojian] objectAtIndex:0], nil]
                   ctrlInfo:[[_light getLinkageTiaojian] objectAtIndex:0]
                     status:XAILinkageStatus_Active
                       name:_name4Change];
    
    if (_loginStatus != Success && _addStatus != Success) {
        
        XCTFail(@"Del_TRUE test faild : generate data faild");
        return;
    }
    
    
    XAILinkage* linkage = [[XAILinkage alloc] init];
    linkage.num = 0x1;
    [_service getLinkageDetail:linkage];
    
    
    _getDetail = start;
    
    
    runInMainLoop(^(BOOL * done) {
        
        if (_getDetail > 0) {
            
            *done = YES;
        }
    });
    
    
    XCTAssertTrue (_getDetail != start, @"delegate did not get called");
    XCTAssertTrue (_getDetail != Fail, @"Find faild");
    
    
}




- (void)linkageService:(XAILinkageService *)service addStatusCode:(XAI_ERROR)errcode{

    if (_addStatus != start) return;
    
    if (errcode == XAI_ERROR_NONE) {
        
        _addStatus = Success;
    }else{
        
        _addStatus = Fail;
    }

    
    _err = errcode;
}

- (void)linkageService:(XAILinkageService *)service delStatusCode:(XAI_ERROR)errcode{

    if (_delStatus != start) return;
    
    if (errcode == XAI_ERROR_NONE) {
        
        _delStatus = Success;
    }else{
        
        _delStatus = Fail;
    }
    
    
    _err = errcode;
    
}

-(void)linkageService:(XAILinkageService *)service findedAllLinkage:(NSArray *)linkageAry errcode:(XAI_ERROR)errcode{

    
    if (_findStatus != start) return;
    
    if (errcode == XAI_ERROR_NONE) {
        
        _findStatus = Success;
    }else{
        
        _findStatus = Fail;
    }
    
    _err = errcode;
}


-(void)linkageService:(XAILinkageService *)service getLinkageDetail:(XAILinkage *)linkage statusCode:(XAI_ERROR)errcode{

    if (_getDetail != start) return;
    
    if (errcode == XAI_ERROR_NONE) {
        
        _getDetail = Success;
    }else{
        
        _getDetail = Fail;
    }
    
    _err = errcode;

}

@end
