//
//  XAILight.m
//  XAI
//
//  Created by office on 14-4-21.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILight.h"

@implementation XAILight

- (void) step{
    _devSwitch = [[XAIDevSwitch alloc] init];
    _devSwitch.swiDelegate = self;
    _devSwitch.delegate = self;
    
    _devSwitch.apsn =  _apsn;
    _devSwitch.luid = _luid;
    
    _isClosing = false;
    _isOpening = false;
}

- (XAIDevice*) curDevice{

    return _devSwitch;
}

- (void) startControl{
    
    [self step];
    [_devSwitch startFocusStatus];
    //[_devSwitch startDeviceStatus];
}

- (void) endControl{
    
    [_devSwitch endFocusStatus];
    //[_devSwitch stopDeviceStatus];
    _devSwitch = nil;
    
}

- (void) openLight{

   // if (_isClosing || _isOpening) return;
    [self startOpr];
    self.curOprtip = @"正在打开...";
     
    _isOpening = YES;
    [_devSwitch  setCircuitOneStatus:XAIDevCircuitStatusOpen];
}
- (void) closeLight{
    
    [self startOpr];
    self.curOprtip = @"正在关闭...";
   // if (_isOpening || _isClosing) return;
    
    _isClosing = YES;
    [_devSwitch setCircuitOneStatus:XAIDevCircuitStatusClose];

}
- (void) getCurStatus{
    
    [_devSwitch getCircuitOneStatus];

}

#pragma --Helper
- (void)updateFinish:(XAIObjectOpr *)oprInfo{
    
    //如果需要通知结果
    if (_delegate != nil && [_delegate respondsToSelector:@selector(light:curStatus:)]) {
        
        [_delegate  light:self curStatus:oprInfo.opr];
    }
}

#pragma --Delegate

-(void)switch_:(XAIDevSwitch *)swi circuitOneStatus:(XAIDevCircuitStatus)status err:(XAI_ERROR)err otherInfo:(XAIOtherInfo *)otherInfo{

    if (_devSwitch != swi) return;
    
    
    //添加otherInfo
    XAILightStatus lightStatus = XAILightStatus_Unkown;
    
    if (err == XAI_ERROR_NONE) {
        
        _DEF_XTO_TIME_End
        
        if (status == XAIDevCircuitStatusOpen) {
            
            lightStatus = XAILightStatus_Open;
            
        }else if(status == XAIDevCircuitStatusClose){
            
            lightStatus = XAILightStatus_Close;
        }
        
        XAILightOpr* opr = [[XAILightOpr alloc] init];
        opr.time = [NSDate dateWithTimeIntervalSince1970:otherInfo.time];
        opr.opr = lightStatus;
        opr.otherID = otherInfo.msgid;
        opr.oprLuid = otherInfo.fromluid;
        
        [_tmpOprs addObject:opr];
        
        _DEF_XTO_TIME_Wait
        
    }else{
        
        if (_delegate != nil && [_delegate respondsToSelector:@selector(light:curStatus:)]) {
            
            [_delegate light:self curStatus:lightStatus];
        }
        
        _DEF_XTO_TIME_End
    }
}



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
    
    NSString* tip = @"";
    
    if (_isOpening) {
        
        _isOpening = false;
        if (_delegate != nil && [_delegate  respondsToSelector:@selector(light:openSuccess:)]) {
            
            
            [_delegate light:self openSuccess:err == XAI_ERROR_NONE];
        }
        
        tip = @"打开超时";
        
    }else if (_isClosing) {
        
        _isClosing = false;
        
        if (_delegate != nil && [_delegate  respondsToSelector:@selector(light:closeSuccess:)]) {
            
            
            [_delegate light:self closeSuccess:err == XAI_ERROR_NONE];
        }
        
        
         tip = @"关闭超时";
    }
    
    if (err != XAI_ERROR_NONE) {
        self.curOprtip =  tip;
        [self showMsg];
    }else{
        [self endOpr];
    }
    
}

-(void)switch_:(XAIDevSwitch *)swi circuitTwoStatus:(XAIDevCircuitStatus)status err:(XAI_ERROR)err therInfo:(XAIOtherInfo *)otherInfo{

}

- (void) switch_:(XAIDevSwitch *)swi getCircuitTwoStatus:(XAIDevCircuitStatus)status err:(XAI_ERROR)err{
    
    
}
- (void) switch_:(XAIDevSwitch *)swi setCircuitTwoErr:(XAI_ERROR)err{
    
    
    
}

- (void) device:(XAIDevice*)device getStatus:(XAIDeviceStatus)status isSuccess:(BOOL)finish isTimeOut:(BOOL)bTimeOut{
    
}

-(BOOL)hasLinkageTiaojian{

    return true;
}

-(BOOL)hasLinkageJieGuo{

    return true;
}

-(NSArray *)getLinkageTiaojian{
    
    
    return [_devSwitch getCirculeOneLinkageStatusInfos];
}

-(NSArray*)getLinkageJieGuo{

    return [_devSwitch getCirculeOneLinkageUseInfos];
}

- (NSString*) linkageInfoMiaoShu:(XAILinkageUseInfo*)useInfo{
    
    XAIDevCircuitStatus status = [_devSwitch linkageInfoStatus:useInfo];
    if (status == XAIDevCircuitStatusClose) {
        return @"关闭";
    }else if(status == XAIDevCircuitStatusOpen){
        return @"打开";
    }
    
    return nil;
}

@end

@implementation XAILightOpr

- (NSString *)oprOnlyStr{

    if (_opr == XAILightStatus_Open) {
        
        return NSLocalizedString(@"被打开", nil);
        
    }else if(_opr == XAILightStatus_Close){
    
        return NSLocalizedString(@"被关闭", nil);
    }
    
    return @"";
}

@end


