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

- (void) circuitOneGetSuccess:(BOOL)isSuccess curStatus:(XAIDevCircuitStatus)status{
    
    
    
}

- (void) circuitOneSetSuccess:(BOOL)isSuccess{
    
    
    
    
}

- (void) circuitTwoGetSuccess:(BOOL)isSuccess curStatus:(XAIDevCircuitStatus)status{
    
    XAILightStatus curStatus = XAILightStatus_Unkown;
    
    if (isSuccess) {
        
        curStatus = ( status == XAIDevCircuitStatusOpen) ? XAILightStatus_Open : XAILightStatus_Close;
        
    }
    
    
    if (self.delegate != nil && [self.delegate  respondsToSelector:@selector(lightCurStatus:)]) {
        
        [self.delegate lightCurStatus:curStatus];
    }

    
}
- (void) circuitTwoSetSuccess:(BOOL)isSuccess{
    
    
    if (_isOpening) {
        
        
        if (self.delegate != nil && [self.delegate  respondsToSelector:@selector(lightOpenSuccess:)]) {
            
            
            [self.delegate lightOpenSuccess:isSuccess];
        }
        
        _isOpening = false;
        
    }else if (_isClosing) {
        
        if (self.delegate != nil && [self.delegate  respondsToSelector:@selector(lightCloseSuccess:)]) {
            
            
            [self.delegate lightCloseSuccess:isSuccess];
        }
        
        _isClosing = false;
        
    }

    
}




@end
