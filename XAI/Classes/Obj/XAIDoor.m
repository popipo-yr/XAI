//
//  XAIDoor.m
//  XAI
//
//  Created by office on 14-5-4.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIDoor.h"

@implementation XAIDoor


- (void) startControl{
    
    _doorContact = [[XAIDevDoorContact alloc] init];
    _doorContact.dcDelegate = self;
    _doorContact.delegate = self;
    
    _doorContact.apsn =  _apsn;
    _doorContact.luid = _luid;
    
}

- (void) getCurStatus{
    
    [_doorContact getDoorContactStatus];
    
}

- (void)getPower{

    [_doorContact getPower];
}

#pragma --Delegate

- (void)doorContact:(XAIDevDoorContact *)dc statusGetSuccess:(BOOL)isSuccess curStatus:(XAIDevDoorContactStatus)status{

    if (dc != _doorContact) return;
    
    XAIDoorStatus  doorStatus = XAIDoorStatus_Unkown;
    
    if (isSuccess) {
        
        if (status == XAIDevDoorContactStatusOpen) {
        
            doorStatus = XAIDoorStatus_Open;
            
        }else if(status == XAIDevDoorContactStatusClose){
            
            doorStatus = XAIDoorStatus_Close;
        }
    }
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(door:curStatus:getIsSuccess:)]) {

        [_delegate  door:self curStatus:doorStatus getIsSuccess:isSuccess];
    }
}

-(void)doorContact:(XAIDevDoorContact *)dc powerGetSuccess:(BOOL)isSuccess curPower:(float)power{

    if (dc != _doorContact) return;
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(door:curPower:getIsSuccess:)]) {
        
        [_delegate  door:self curPower:power getIsSuccess:isSuccess];
    }
}


- (void) getStatus:(XAIDeviceStatus)status withFinish:(BOOL)finish{
    
}

@end

@implementation XAIDoorOpr

- (NSString *)oprOnlyStr{
    
    if (_opr == XAIDoorStatus_Open) {
        
        return @"开了门";
        
    }else if(_opr == XAIDoorStatus_Close){
        
        return @"关了门";
    }
    
    return @"";
}


@end
