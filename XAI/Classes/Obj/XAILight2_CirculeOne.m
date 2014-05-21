//
//  XAILight2.m
//  XAI
//
//  Created by office on 14-5-5.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILight2_CirculeOne.h"

@implementation XAILight2_CirculeOne

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

- (void) switch_:(XAIDevSwitch *)swi getCircuitOneStatus:(XAIDevCircuitStatus)status err:(XAI_ERROR)err{
    
    
    
}

- (void) switch_:(XAIDevSwitch *)swi setCircuitOneErr:(XAI_ERROR)err{
    
    
    
    
}

- (void) switch_:(XAIDevSwitch *)swi getCircuitTwoStatus:(XAIDevCircuitStatus)status err:(XAI_ERROR)err{
    
    XAILightStatus curStatus = XAILightStatus_Unkown;
    
    if (err == XAI_ERROR_NONE) {
        
        curStatus = ( status == XAIDevCircuitStatusOpen) ? XAILightStatus_Open : XAILightStatus_Close;
        
    }
    
    
    if (self.delegate != nil && [self.delegate  respondsToSelector:@selector(light:curStatus:)]) {
        
        [self.delegate light:self curStatus:curStatus];
    }

    
}
- (void) switch_:(XAIDevSwitch *)swi setCircuitTwoErr:(XAI_ERROR)err{
    
    
    if (_isOpening) {
        
        
        if (self.delegate != nil && [self.delegate  respondsToSelector:@selector(light:openSuccess:)]) {
            
            
            [self.delegate light:self openSuccess:err == XAI_ERROR_NONE];
        }
        
        _isOpening = false;
        
    }else if (_isClosing) {
        
        if (self.delegate != nil && [self.delegate  respondsToSelector:@selector(light:closeSuccess:)]) {
            
            
            [self.delegate light:self closeSuccess:err == XAI_ERROR_NONE];
        }
        
        _isClosing = false;
        
    }

    
}




@end
