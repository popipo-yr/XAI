//
//  XAILight.m
//  XAI
//
//  Created by office on 14-4-21.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILight.h"

@implementation XAILight

- (void) startControl{

    _devSwitch = [[XAIDevSwitch alloc] init];
    _devSwitch.swiDelegate = self;
    _devSwitch.delegate = self;

    _devSwitch.apsn =  _apsn;
    _devSwitch.luid = _luid;
    
    _isClosing = false;
    _isOpening = false;
    
    [_devSwitch startFocusStatus];
}

- (void) endControl{
    
    [_devSwitch endFocusStatus];
    _devSwitch = nil;
    
}

- (void) openLight{

   // if (_isClosing || _isOpening) return;
    
    _isOpening = YES;
    [_devSwitch  setCircuitOneStatus:XAIDevCircuitStatusOpen];
}
- (void) closeLight{
    
   // if (_isOpening || _isClosing) return;
    
    _isClosing = YES;
    [_devSwitch setCircuitOneStatus:XAIDevCircuitStatusClose];

}
- (void) getCurStatus{
    
    [_devSwitch getCircuitOneStatus];

}

#pragma --Delegate

- (void) switch_:(XAIDevSwitch *)swi getCircuitOneStatus:(XAIDevCircuitStatus)status err:(XAI_ERROR)err{
    
    
    XAILightStatus curStatus = XAILightStatus_Unkown;
    
    if (err == XAI_ERROR_NONE) {
        
        curStatus = ( status == XAIDevCircuitStatusOpen) ? XAILightStatus_Open : XAILightStatus_Close;
        
    }
    
    
    if (_delegate != nil && [_delegate  respondsToSelector:@selector(light:curStatus:)]) {
        
        [_delegate light:self curStatus:curStatus];
    }
   
}

- (void) switch_:(XAIDevSwitch *)swi setCircuitOneErr:(XAI_ERROR)err{
    
    if (_isOpening) {
        
        _isOpening = false;
        if (_delegate != nil && [_delegate  respondsToSelector:@selector(light:openSuccess:)]) {
            
            
            [_delegate light:self openSuccess:err == XAI_ERROR_NONE];
        }
        
        
        
    }else if (_isClosing) {
        
        _isClosing = false;
        
        if (_delegate != nil && [_delegate  respondsToSelector:@selector(light:closeSuccess:)]) {
            
            
            [_delegate light:self closeSuccess:err == XAI_ERROR_NONE];
        }
        
        

    }
    
   
    
}

- (void) switch_:(XAIDevSwitch *)swi getCircuitTwoStatus:(XAIDevCircuitStatus)status err:(XAI_ERROR)err{
    
    
}
- (void) switch_:(XAIDevSwitch *)swi setCircuitTwoErr:(XAI_ERROR)err{
    
    
    
}

- (void) getStatus:(XAIDeviceStatus)status withFinish:(BOOL)finish isTimeOut:(BOOL)bTimeOut{
    
}

@end

@implementation XAILightOpr

- (NSString *)oprOnlyStr{

    if (_opr == XAILightStatus_Open) {
        
        return NSLocalizedString(@"OpenLight", nil);
        
    }else if(_opr == XAILightStatus_Close){
    
        return NSLocalizedString(@"CloseLight", nil);
    }
    
    return @"";
}

@end


