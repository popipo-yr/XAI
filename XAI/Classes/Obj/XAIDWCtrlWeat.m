//
//  XAIDWCtrlWeather.m
//  XAI
//
//  Created by office on 15/4/1.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import "XAIDWCtrlWeat.h"

@implementation XAIDWCtrlWeat


- (void)step{
    
    _devDWCtrl = [[XAIDevDWCtrl alloc] init];
    _devDWCtrl.dwcDelegate = self;
    _devDWCtrl.delegate = self;
    
    _devDWCtrl.apsn =  _apsn;
    _devDWCtrl.luid = _luid;
}

-(XAIDevice *)curDevice{
    
    return _devDWCtrl;
}

- (void) startControl{
    
    [self step];
    
    [_devDWCtrl startFocusStatus];
    
}

- (void) endControl{
    
    [_devDWCtrl endFocusStatus];
    _devDWCtrl = nil;
    
}


#pragma mark - operate

- (void) getWeatherStatus{

    [_devDWCtrl getWeatherStatus];
}




#pragma --Helper
- (void)updateFinish:(XAIObjectOpr *)oprInfo{
    
    //如果需要通知结果
    if (_delegate != nil &&
        [_delegate respondsToSelector:@selector(weat:weatherStatus:getIsSuccess:)]) {
        
        [_delegate  weat:self weatherStatus:oprInfo.opr getIsSuccess:true];
    }
}


#pragma --Delegate



-(void)devDWCtrl:(XAIDevDWCtrl *)dwc weatherStatus:(XAIDevDWCtrlWeatherStatus)status err:(XAI_ERROR)err otherInfo:(XAIOtherInfo *)otherInfo{
    
    if (dwc != _devDWCtrl) return;
    
    
    //添加otherInfo
    XAIDWCtrlWeather weather = XAIDWCtrlWeather_Unknow;
    
    if (err == XAI_ERROR_NONE) {
        
        _DEF_XTO_TIME_End
        
        if (status == XAIDevDWCtrlWeatherStatus_Rain) {
            
            weather = XAIDWCtrlWeather_Rain;
            
        }else if(status == XAIDevDWCtrlWeatherStatus_Sun){
            
            weather = XAIDWCtrlWeather_Sun;
            
        }
        
        XADWCWeatherOpr* opr = [[XADWCWeatherOpr alloc] init];
        opr.time = [NSDate dateWithTimeIntervalSince1970:otherInfo.time];
        opr.opr = weather;
        opr.otherID = otherInfo.msgid;
        opr.oprLuid = otherInfo.fromluid;
        
        [_tmpOprs addObject:opr];
        
        _DEF_XTO_TIME_Wait
        
    }else{
        
        if (_delegate != nil && [_delegate respondsToSelector:@selector(weat:weatherStatus:getIsSuccess:)]) {
            
            [_delegate  weat:self weatherStatus:weather getIsSuccess:err == XAI_ERROR_NONE];
        }
        
        _DEF_XTO_TIME_End
    }
    
}

-(void)devDWCtrl:(XAIDevDWCtrl *)dwc weatherStatus:(XAIDevDWCtrlWeatherStatus)status err:(XAI_ERROR)err{
    
    if (dwc != _devDWCtrl) return;
    
    XAIDWCtrlWeather weather = XAIDWCtrlWeather_Unknow;
    
    
    
    if (err == XAI_ERROR_NONE) {
        
        if (status == XAIDevDWCtrlWeatherStatus_Rain) {
            
            weather = XAIDWCtrlWeather_Rain;
            
        }else if(status == XAIDevDWCtrlWeatherStatus_Sun){
            
            weather = XAIDWCtrlWeather_Sun;
        }
    }
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(weat:weatherStatus:getIsSuccess:)]) {
        
        [_delegate  weat:self weatherStatus:weather getIsSuccess:err == XAI_ERROR_NONE];
    }
    
}


-(void)devDWCtrl:(XAIDevDWCtrl *)dwc curStatus:(XAIDevDWCtrlStatus)status err:(XAI_ERROR)err{}
-(void)devDWCtrl:(XAIDevDWCtrl *)dwc curStatus:(XAIDevDWCtrlStatus)status err:(XAI_ERROR)err otherInfo:(XAIOtherInfo *)otherInfo{};
-(void)devDWCtrl:(XAIDevDWCtrl *)dwc setOpr:(XAIDevDWCtrlOpr)opr err:(XAI_ERROR)err{};



- (void) device:(XAIDevice*)device getStatus:(XAIDeviceStatus)status isSuccess:(BOOL)finish isTimeOut:(BOOL)bTimeOut{
    
}

-(BOOL)hasLinkageTiaojian{
    
    return true;
}

- (BOOL) linkageInfoIsEqual:(XAILinkageUseInfo*)useInfo index:(int)index{
    
    return [_devDWCtrl linkageInfoIsEqual:useInfo index:index];
}

-(NSArray *)getLinkageTiaojian{
    
    
    return [_devDWCtrl getLinkageUseStatusInfos];
}


- (NSString*) linkageInfoMiaoShu:(XAILinkageUseInfo*)useInfo{
    
    XAIDevDWCtrlStatus status = [_devDWCtrl linkageInfoStatus:useInfo];
    if (status == XAIDevDWCtrlStatusClose) {
        return @"关闭";
    }else if(status == XAIDevDWCtrlStatusOpen){
        return @"打开";
    }
    
    return nil;
}


@end

@implementation XADWCWeatherOpr

- (NSString *)oprOnlyStr{
    
    return @"";
}

-(BOOL)isWorn{
    
    return false;
}


@end
