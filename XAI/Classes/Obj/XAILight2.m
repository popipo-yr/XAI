//
//  XAILight2.m
//  XAI
//
//  Created by office on 14-5-5.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILight2.h"

@implementation XAILight2

- (void) openLight{
    
    if (_isClosing || _isOpening) return;
    
    _isOpening = YES;
    [_devSwitch  setCircuitTwoStatus:XAIDevCircuitStatusOpen];
}
- (void) closeLight{
    
    if (_isOpening || _isClosing) return;
    
    _isClosing = YES;
    [_devSwitch setCircuitTwoStatus:XAIDevCircuitStatusClose];
    
}
- (void) getCurStatus{
    
    [_devSwitch getCircuitTwoStatus];
    
}

- (void) circuitOneGetCurStatus:(XAIDevCircuitStatus)status err:(XAIDevSwitchErr)err{
    
    
    
}

- (void) circuitOneSetErr:(XAIDevSwitchErr)err{
    
    
    
    
}

- (void) circuitTwoGetCurStatus:(XAIDevCircuitStatus)status err:(XAIDevSwitchErr)err{
    
    XAILightStatus curStatus = XAILightStatus_Unkown;
    
    if (err == XAIDevSwitchErr_NONE) {
        
        curStatus = ( status == XAIDevCircuitStatusOpen) ? XAILightStatus_Open : XAILightStatus_Close;
        
    }
    
    
    if (self.delegate != nil && [self.delegate  respondsToSelector:@selector(lightCurStatus:)]) {
        
        [self.delegate lightCurStatus:curStatus];
    }

    
}
- (void) circuitTwoSetErr:(XAIDevSwitchErr)err{
    
    
    if (_isOpening) {
        
        
        if (self.delegate != nil && [self.delegate  respondsToSelector:@selector(lightOpenSuccess:)]) {
            
            
            [self.delegate lightOpenSuccess:err == XAIDevSwitchErr_NONE];
        }
        
        _isOpening = false;
        
    }else if (_isClosing) {
        
        if (self.delegate != nil && [self.delegate  respondsToSelector:@selector(lightCloseSuccess:)]) {
            
            
            [self.delegate lightCloseSuccess:err == XAIDevSwitchErr_NONE];
        }
        
        _isClosing = false;
        
    }

    
}




@end
