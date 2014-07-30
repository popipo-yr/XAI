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

#pragma --Helper
- (void)updateFinish:(XAIObjectOpr *)oprInfo{

    //如果需要通知结果
    if (_delegate != nil && [_delegate respondsToSelector:@selector(door:curStatus:getIsSuccess:)]) {
        
        [_delegate  door:self curStatus:oprInfo.opr getIsSuccess:true];
    }
}


#pragma --Delegate

- (void)doorContact:(XAIDevDoorContact *)dc status:(XAIDevDoorContactStatus)status err:(XAI_ERROR)err
          otherInfo:(XAIOtherInfo*)otherInfo{
    
    if (dc != _doorContact) return;
    
    
    //添加otherInfo
    XAIDoorStatus  doorStatus = XAIDoorStatus_Unkown;
    
    if (err == XAI_ERROR_NONE) {
        
        _DEF_XTO_TIME_End
        
        if (status == XAIDevDoorContactStatusOpen) {
            
            doorStatus = XAIDoorStatus_Open;
            
        }else if(status == XAIDevDoorContactStatusClose){
            
            doorStatus = XAIDoorStatus_Close;
        }
        
        XAIDoorOpr* opr = [[XAIDoorOpr alloc] init];
        opr.time = [NSDate dateWithTimeIntervalSince1970:otherInfo.time];
        opr.opr = status;
        opr.otherID = otherInfo.msgid;
        
        [_tmpOprs addObject:opr];
        
        _DEF_XTO_TIME_Wait
        
    }else{
        
        if (_delegate != nil && [_delegate respondsToSelector:@selector(door:curStatus:getIsSuccess:)]) {
            
            [_delegate  door:self curStatus:doorStatus getIsSuccess:err == XAI_ERROR_NONE];
        }
   
        _DEF_XTO_TIME_End
    }
    
}

- (void)doorContact:(XAIDevDoorContact *)dc curStatus:(XAIDevDoorContactStatus)status err:(XAI_ERROR)err{

    if (dc != _doorContact) return;
    
    XAIDoorStatus  doorStatus = XAIDoorStatus_Unkown;
    
    if (err == XAI_ERROR_NONE) {
        
        if (status == XAIDevDoorContactStatusOpen) {
        
            doorStatus = XAIDoorStatus_Open;
            
        }else if(status == XAIDevDoorContactStatusClose){
            
            doorStatus = XAIDoorStatus_Close;
        }
    }
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(door:curStatus:getIsSuccess:)]) {

        [_delegate  door:self curStatus:doorStatus getIsSuccess:err == XAI_ERROR_NONE];
    }
}

-(void)doorContact:(XAIDevDoorContact *)dc curPower:(float)power err:(XAI_ERROR)err{

    if (dc != _doorContact) return;
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(door:curPower:getIsSuccess:)]) {
        
        [_delegate  door:self curPower:power getIsSuccess:err == XAI_ERROR_NONE];
    }
}


- (void) device:(XAIDevice*)device getStatus:(XAIDeviceStatus)status isSuccess:(BOOL)finish isTimeOut:(BOOL)bTimeOut{
    
}

-(NSArray *)getLinkageUseInfos{
    
    
    return [_doorContact getLinkageUseInfos];
}


@end

@implementation XAIDoorOpr

- (NSString *)oprOnlyStr{
    
    if (_opr == XAIDoorStatus_Open) {
        
        return NSLocalizedString(@"OpenDoor", nil);
        
    }else if(_opr == XAIDoorStatus_Close){
        
        return NSLocalizedString(@"CloseDoor", nil);
    }
    
    return @"";
}


@end
