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
    
    //if (_isClosing || _isOpening) return;
    [self startOpr];
    self.curOprtip = @"正在打开...";
    
    _isOpening = YES;
    [_devSwitch  setCircuitTwoStatus:XAIDevCircuitStatusOpen];
}
- (void) closeLight{
    
    //if (_isOpening || _isClosing) return;
    [self startOpr];
    self.curOprtip = @"正在关闭...";
    
    _isClosing = YES;
    [_devSwitch setCircuitTwoStatus:XAIDevCircuitStatusClose];
    
}
- (void) getCurStatus{
    
    [_devSwitch getCircuitTwoStatus];
    
}

#pragma --Helper
- (void)updateFinish:(XAIObjectOpr *)oprInfo{
    
    //如果需要通知结果
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(light:curStatus:)]) {
        
        [self.delegate  light:self curStatus:oprInfo.opr];
    }
}

#pragma --Delegate

-(void)switch_:(XAIDevSwitch *)swi circuitOneStatus:(XAIDevCircuitStatus)status err:(XAI_ERROR)err otherInfo:(XAIOtherInfo *)otherInfo{

}

- (void) switch_:(XAIDevSwitch *)swi getCircuitOneStatus:(XAIDevCircuitStatus)status err:(XAI_ERROR)err{
    
    
    
}

- (void) switch_:(XAIDevSwitch *)swi setCircuitOneErr:(XAI_ERROR)err{
    
    
    
    
}

-(void)switch_:(XAIDevSwitch *)swi circuitTwoStatus:(XAIDevCircuitStatus)status err:(XAI_ERROR)err otherInfo:(XAIOtherInfo *)otherInfo{
    
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
        
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(light:curStatus:)]) {
            
            [self.delegate light:self curStatus:lightStatus];
        }
        
        _DEF_XTO_TIME_End
    }
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
    
    NSString* tip = @"";
    
    if (_isOpening) {
        
        
        if (self.delegate != nil && [self.delegate  respondsToSelector:@selector(light:openSuccess:)]) {
            
            
            [self.delegate light:self openSuccess:err == XAI_ERROR_NONE];
        }
        
        _isOpening = false;
        
        tip = @"打开失败";
        
    }else if (_isClosing) {
        
        if (self.delegate != nil && [self.delegate  respondsToSelector:@selector(light:closeSuccess:)]) {
            
            
            [self.delegate light:self closeSuccess:err == XAI_ERROR_NONE];
        }
        
        _isClosing = false;
        
         tip = @"关闭失败";
        
    }

    if (err != XAI_ERROR_NONE) {
        self.curOprtip =  tip;
        [self showMsg];
    }else{
        [self endOpr];
    }

    
}


-(NSArray *)getLinkageUseInfos{

    return [_devSwitch getCirculeTwoLinkageUseInfos];
}

@end
