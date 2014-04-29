//
//  XAILight.m
//  XAI
//
//  Created by office on 14-4-21.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILight.h"

@implementation XAILight

- (void) initDev{

    _devSwitch = [[XAIDevSwitch alloc] init];
    _devSwitch.swiDelegate = self;
    _devSwitch.delegate = self;

    _devSwitch.apsn =  _apsn;
    _devSwitch.luid = _luid;
    
    _isClosing = false;
    _isOpening = false;
}

- (void) openLight{

    if (_isClosing || _isOpening) return;
    
    _isOpening = YES;
    [_devSwitch  setCircuitOneStatus:XAIDevCircuitStatusOpen];
}
- (void) closeLight{
    
    if (_isOpening || _isClosing) return;
    
    _isClosing = YES;
    [_devSwitch setCircuitOneStatus:XAIDevCircuitStatusClose];

}
- (void) getCurStatus{
    
    [_devSwitch getCircuitOneStatus];

}

#pragma --Delegate

- (void) circuitOneGetSuccess:(BOOL)isSuccess curStatus:(XAIDevCircuitStatus)status{
    
    
    XAILightStatus curStatus = XAILightStatus_Unkown;
    
    if (isSuccess) {
        
        curStatus = ( status == XAIDevCircuitStatusOpen) ? XAILightStatus_Open : XAILightStatus_Close;
        
    }
    
    
    if (_delegate != nil && [_delegate  respondsToSelector:@selector(lightCurStatus:)]) {
        
        [_delegate lightCurStatus:curStatus];
    }
   
}

- (void) circuitOneSetSuccess:(BOOL)isSuccess{
    
    if (_isOpening) {
        
        
        if (_delegate != nil && [_delegate  respondsToSelector:@selector(lightOpenSuccess:)]) {
            
            
            [_delegate lightOpenSuccess:isSuccess];
        }
        
        _isOpening = false;
        
    }else if (_isClosing) {
        
        if (_delegate != nil && [_delegate  respondsToSelector:@selector(lightCloseSuccess:)]) {
            
            
            [_delegate lightCloseSuccess:isSuccess];
        }
        
        _isClosing = false;

    }
    
   
    
}

- (void) circuitTwoGetSuccess:(BOOL)isSuccess curStatus:(XAIDevCircuitStatus)status{
    
    
}
- (void) circuitTwoSetSuccess:(BOOL)isSuccess{
    
    
    
}

- (void) getStatus:(XAIDeviceStatus)status withFinish:(BOOL)finish{
    
}

@end

@implementation XAILightOpr

- (NSString *)oprOnlyStr{

    if (_opr == XAILightStatus_Open) {
        
        return @"开了灯";
        
    }else if(_opr == XAILightStatus_Close){
    
        return @"关了灯";
    }
    
    return nil;
}

@end


