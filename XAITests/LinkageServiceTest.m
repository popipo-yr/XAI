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
    _service = [[XAILinkageService alloc] init];
    
    [MQTT shareMQTT].apsn = 0x1;
    
    _service.apsn = 0x1;
    _service.luid = MQTTCover_LUID_Server_03;
    _service.linkageServiceDelegate = self;
    
    
    
    _name4Change = [NSString stringWithFormat:@"NAME1"];
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
    
    
    
    
    
    [super setUp];
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


//- (void)_delDev:(XAITYPELUID)luid{
//    
//    
//    [self login];
//    
//    if (_loginStatus == Success) {
//        
//        [_devService delDev:luid];
//        
//        
//        _delStatus = start;
//        
//        runInMainLoop(^(BOOL * done) {
//            
//            if (_delStatus > start) {
//                
//                *done = YES;
//            }
//        });
//        
//    }
//}
//
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




- (void)test_Add_TRUE
{
    
    [_light getLinkageUseInfos];
    
    [self _addLinkageParams:[NSArray arrayWithObjects:[[_door getLinkageUseInfos] objectAtIndex:0], nil]
                   ctrlInfo:[[_light getLinkageUseInfos] objectAtIndex:0]
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


- (void)linkageService:(XAILinkageService *)service addStatusCode:(XAI_ERROR)errcode{

    if (_addStatus != start) return;
    
    if (errcode == XAI_ERROR_NONE) {
        
        _addStatus = Success;
    }else{
        
        _addStatus = Fail;
    }

    
    _err = errcode;
}

@end
