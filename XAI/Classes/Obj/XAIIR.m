//
//  XAIIR.m
//  XAI
//
//  Created by office on 14-7-15.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIIR.h"

@implementation XAIIR

-(void)step{
    _infrared = [[XAIDevInfrared alloc] init];
    _infrared.infDelegate = self;
    _infrared.delegate = self;
    
    _infrared.apsn =  _apsn;
    _infrared.luid = _luid;
}

-(XAIDevice *)curDevice{

    return _infrared;
}

- (void) startControl{
    
    [self step];
    
    [_infrared startFocusStatus];
    //[_infrared startDeviceStatus];
}

- (void) endControl{
    
    [_infrared endFocusStatus];
    //[_infrared stopDeviceStatus];
    _infrared = nil;
    
}



- (void) getCurStatus{
    
    [_infrared getInfraredStatus];
    
}

- (void)getPower{
    
    [_infrared getPower];
}

- (BOOL) linkageInfoIsEqual:(XAILinkageUseInfo*)useInfo index:(int)index{
    
    return [_infrared linkageInfoIsEqual:useInfo index:index];
}

-(BOOL)hasLinkageTiaojian{
    
    return true;
}


-(NSArray *)getLinkageTiaojian{
    
    return [_infrared getLinkageStatusInfos];
}

- (NSString*) linkageInfoMiaoShu:(XAILinkageUseInfo*)useInfo{
    
    XAIDevInfraredStatus status = [_infrared linkageInfoStatus:useInfo];
    if (status == XAIDevInfraredStatusDetectorNothing) {
        return @"正常状态";
    }else if(status == XAIDevInfraredStatusDetectorThing){
        return @"发出警告";
    }
    
    return nil;
}


- (void)updateFinish:(XAIObjectOpr *)oprInfo{
    
    //如果需要通知结果
    if (_delegate != nil && [_delegate respondsToSelector:@selector(ir:curStatus:getIsSuccess:)]) {
        
        [_delegate ir:self curStatus:oprInfo.opr getIsSuccess:true];
    }
}


#pragma --Delegate

-(void)infrared:(XAIDevInfrared *)inf status:(XAIDevInfraredStatus)status err:(XAI_ERROR)err otherInfo:(XAIOtherInfo *)otherInfo{

    if (inf != _infrared) return;
    
    
    //添加otherInfo
    XAIIRStatus  iRStatus = XAIIRStatus_Unkown;
    
    if (err == XAI_ERROR_NONE) {
        
        _DEF_XTO_TIME_End
        
        if (status == XAIDevInfraredStatusDetectorNothing) {
            
            iRStatus = XAIIRStatus_working;
            
        }else if(status == XAIDevInfraredStatusDetectorThing){
            
            iRStatus = XAIIRStatus_warning;
        }
        
        XAIIROpr* opr = [[XAIIROpr alloc] init];
        opr.time = [NSDate dateWithTimeIntervalSince1970:otherInfo.time];
        opr.opr = iRStatus;
        opr.otherID = otherInfo.msgid;
        opr.oprLuid = otherInfo.fromluid;
        
        [_tmpOprs addObject:opr];
        
        _DEF_XTO_TIME_Wait
        
    }else{
        
        if (_delegate != nil && [_delegate respondsToSelector:@selector(ir:curStatus:getIsSuccess:)]) {
            
            [_delegate ir:self curStatus:iRStatus getIsSuccess:err == XAI_ERROR_NONE];
        }
        
        _DEF_XTO_TIME_End
    }

}

-(void)infrared:(XAIDevInfrared *)inf curStatus:(XAIDevInfraredStatus)status err:(XAI_ERROR)err{
    
    if (inf != _infrared) return;
    
    XAIIRStatus  iRStatus = XAIIRStatus_Unkown;
    
    if (err == XAI_ERROR_NONE) {
        
        if (status == XAIDevInfraredStatusDetectorNothing) {
            
            iRStatus = XAIIRStatus_working;
            
        }else if(status == XAIDevInfraredStatusDetectorThing){
            
            iRStatus = XAIIRStatus_warning;
        }
    }
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(ir:curStatus:getIsSuccess:)]) {
        
        [_delegate  ir:self curStatus:iRStatus getIsSuccess:err == XAI_ERROR_NONE];
    }
}

-(void)infrared:(XAIDevInfrared *)inf curPower:(float)power err:(XAI_ERROR)err{
    
    if (inf != _infrared) return;
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(ir:curPower:getIsSuccess:)]) {
        
        [_delegate ir:self curPower:power getIsSuccess:err == XAI_ERROR_NONE];
    }
    
    self.power = power;
}


- (void) device:(XAIDevice*)device getStatus:(XAIDeviceStatus)status isSuccess:(BOOL)finish isTimeOut:(BOOL)bTimeOut{
    
}


@end

@implementation XAIIROpr

- (NSString *)oprOnlyStr{
    
    if (_opr == XAIIRStatus_working) {
        
        return NSLocalizedString(@"正常工作", nil);
        
    }else if(_opr == XAIIRStatus_warning){
        
        return NSLocalizedString(@"发出警告", nil);
    }
    
    return @"";
}



@end
