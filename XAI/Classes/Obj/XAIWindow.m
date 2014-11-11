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
    //[_doorContact startDeviceStatus];

}

- (void) endControl{
    
    [_doorContact endFocusStatus];
    //[_doorContact stopDeviceStatus];
    _doorContact = nil;
    
}



- (void) getCurStatus{
    
    [_doorContact getDoorContactStatus];
    
}

- (void)getPower{
    
    [_doorContact getPower];
}

-(BOOL)hasLinkageTiaojian{

    return true;
}

- (BOOL) linkageInfoIsEqual:(XAILinkageUseInfo*)useInfo index:(int)index{
    
    return [_doorContact linkageInfoIsEqual:useInfo index:index];
}

-(NSArray *)getLinkageTiaojian{
    return [_doorContact getLinkageUseStatusInfos];
}

- (NSString*) linkageInfoMiaoShu:(XAILinkageUseInfo*)useInfo{
    
    XAIDevDoorContactStatus status = [_doorContact linkageInfoStatus:useInfo];
    if (status == XAIDevDoorContactStatusClose) {
        return @"关闭";
    }else if(status == XAIDevDoorContactStatusOpen){
        return @"打开";
    }
    
    return nil;
}

#pragma --Helper
- (void)updateFinish:(XAIObjectOpr *)oprInfo{
    
    //如果需要通知结果
    if (_delegate != nil && [_delegate respondsToSelector:@selector(window:curStatus:getIsSuccess:)]) {
        
        [_delegate window:self curStatus:oprInfo.opr getIsSuccess:true];
    }
}


#pragma --Delegate

-(void)doorContact:(XAIDevDoorContact *)dc status:(XAIDevDoorContactStatus)status err:(XAI_ERROR)err otherInfo:(XAIOtherInfo *)otherInfo{

    if (dc != _doorContact) return;
    
    
    //添加otherInfo
    XAIWindowStatus  winStatus = XAIWindowStatus_Unkown;
    
    if (err == XAI_ERROR_NONE) {
        
        _DEF_XTO_TIME_End
        
        if (status == XAIDevDoorContactStatusOpen) {
            
            winStatus = XAIWindowStatus_Open;
            
        }else if(status == XAIDevDoorContactStatusClose){
            
            winStatus = XAIWindowStatus_Close;
        }
        
        XAIWindowOpr* opr = [[XAIWindowOpr alloc] init];
        opr.time = [NSDate dateWithTimeIntervalSince1970:otherInfo.time];
        opr.opr = winStatus;
        opr.otherID = otherInfo.msgid;
        opr.oprLuid = otherInfo.fromluid;
        
        [_tmpOprs addObject:opr];
        
        _DEF_XTO_TIME_Wait
        
    }else{
        
        if (_delegate != nil && [_delegate respondsToSelector:@selector(window:curStatus:getIsSuccess:)]) {
            
            [_delegate window:self curStatus:winStatus getIsSuccess:err == XAI_ERROR_NONE];
        }
        
        _DEF_XTO_TIME_End
    }
    
}

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
        
        return NSLocalizedString(@"被打开", nil);
        
    }else if(_opr == XAIWindowStatus_Close){
        
        return NSLocalizedString(@"被关闭", nil);
    }
    
    return @"";
}


@end
