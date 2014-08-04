//
//  XAIWindow.m
//  XAI
//
//  Created by office on 14-5-4.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIWindow.h"

@implementation XAIWindow


- (void)step{
    
    _doorContact = [[XAIDevDoorContact alloc] init];
    _doorContact.dcDelegate = self;
    _doorContact.delegate = self;
    
    _doorContact.apsn =  _apsn;
    _doorContact.luid = _luid;
}

-(XAIDevice *)curDevice{
    
    return _doorContact;
}

- (void) startControl{
    
    [self step];
    
    [_doorContact startFocusStatus];

}

- (void) endControl{
    
    [_doorContact endFocusStatus];
    _doorContact = nil;
    
}



- (void) getCurStatus{
    
    [_doorContact getDoorContactStatus];
    
}

- (void)getPower{
    
    [_doorContact getPower];
}


#pragma --Delegate

- (void)doorContact:(XAIDevDoorContact *)dc curStatus:(XAIDevDoorContactStatus)status err:(XAI_ERROR)err{
    
    if (dc != _doorContact) return;
    
    XAIWindowStatus  windowStatus = XAIWindowStatus_Unkown;
    
    if (err == XAI_ERROR_NONE) {
        
        if (status == XAIDevDoorContactStatusOpen) {
            
            windowStatus = XAIWindowStatus_Open;
            
        }else if(status == XAIDevDoorContactStatusClose){
            
            windowStatus = XAIWindowStatus_Close;
        }
    }
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(window:curStatus:getIsSuccess:)]) {
        
        [_delegate  window:self curStatus:windowStatus getIsSuccess:err == XAI_ERROR_NONE];
    }
}

-(void)doorContact:(XAIDevDoorContact *)dc curPower:(float)power err:(XAI_ERROR)err{
    
    if (dc != _doorContact) return;
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(window:curPower:getIsSuccess:)]) {
        
        [_delegate  window:self curPower:power getIsSuccess:err == XAI_ERROR_NONE];
    }
}


- (void) device:(XAIDevice*)device getStatus:(XAIDeviceStatus)status isSuccess:(BOOL)finish isTimeOut:(BOOL)bTimeOut{
    
}


@end

@implementation XAIWindowOpr

- (NSString *)oprOnlyStr{
    
    if (_opr == XAIWindowStatus_Open) {
        
        return NSLocalizedString(@"OpenWindow", nil);
        
    }else if(_opr == XAIWindowStatus_Close){
        
        return NSLocalizedString(@"CloseWindow", nil);
    }
    
    return @"";
}


@end
