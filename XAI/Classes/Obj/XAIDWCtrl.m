//
//  XAIDWCtrl.m
//  XAI
//
//  Created by office on 15/4/1.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import "XAIDWCtrl.h"

@implementation XAIDWCtrl


-(instancetype)init{

    if (self = [super init]) {
        _weat = [[XAIDWCtrlWeat alloc] init];
        _weat.delegate = self;
    }
    
    return self;
}

-(id)initWithDevice:(XAIDevice *)dev{

    if (self = [super initWithDevice:dev]) {
        _weat = [[XAIDWCtrlWeat alloc] initWithDevice:dev];
        _weat.delegate = self;
    }
    
    return self;
}

-(void)setInfoFromDevice:(XAIDevice *)dev{

    [super setInfoFromDevice:dev];
    
    [_weat setInfoFromDevice:dev];
}
/////////////////////////////

- (void)step{
    
    _devDWCtrl = [[XAIDevDWCtrl alloc] init];
    _devDWCtrl.dwcDelegate = self;
    _devDWCtrl.delegate = self;
    
    _devDWCtrl.apsn =  _apsn;
    _devDWCtrl.luid = _luid;
    
   
    [_weat step];
    
}

-(XAIDevice *)curDevice{
    
    return _devDWCtrl;
}

- (void) startControl{
    
    [self step];
    
    [_devDWCtrl startFocusStatus];
    
    [_weat startControl];
    
}

- (void) endControl{
    
    [_devDWCtrl endFocusStatus];
    _devDWCtrl = nil;
    
    [_weat endControl];
    
}

- (void) getCurStatus{
    
    [_devDWCtrl getDwcStatus];
    
}

- (void) getWeatherStatus{

    if (_weat != nil) {
        [_weat getWeatherStatus];
    }
}

- (BOOL) isRain{

    return  _weat.lastOpr == XAIDWCtrlWeather_Rain;
}

#pragma mark - operate
-(void)open{
    
    [self startOpr];
    self.curOprtip = @"正在打开...";
    
    _curOpr = XAIDWCtrlOpr_open;
    [_devDWCtrl  startOpr:XAIDevDWCtrlOprOpen];
}

-(void)close{
    
    [self startOpr];
    self.curOprtip = @"正在关闭...";
    
    _curOpr = XAIDWCtrlOpr_close;
    [_devDWCtrl  startOpr:XAIDevDWCtrlOprClose];
}

-(void)stop{
    
    [self startOpr];
    self.curOprtip = @"正在停止...";
    
    _curOpr = XAIDWCtrlOpr_stop;
    [_devDWCtrl  startOpr:XAIDevDWCtrlOprStop];
}

#define _Key_LastStatus  @"_Key_LastStatus"
-(NSDictionary *)writeToDIC{
    
    
    NSDictionary* superInfo = [super writeToDIC];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithDictionary:superInfo];
        
    [dic setObject:[NSNumber numberWithInt:_lastStatus] forKey:_Key_LastStatus];

    return dic;
}

- (void)readFromDIC:(NSDictionary *)dic{
    
    [super readFromDIC:dic];
    
    _lastStatus = [[dic objectForKey:_Key_LastStatus] intValue];

}

/*添加一个操作记录 更新最后一次操作和操作列表*/
- (BOOL) addOpr:(XAIObjectOpr*)aOpr{
    
    if ([super addOpr:aOpr]) {
        
        if (aOpr.opr == XAIDWCtrlStatus_Closed
            || aOpr.opr == XAIDWCtrlStatus_Opened) {
            
            _lastStatus = aOpr.opr;
        }
        
        return true;
    }
    
    return false;
}


#pragma mark -  weather
-(void)weat:(XAIDWCtrlWeat *)weat weatherStatus:(XAIDWCtrlWeather)weather getIsSuccess:(BOOL)isSuccess{

    if (weat != _weat) return;
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(dwc:weatherStatus:getIsSuccess:)]) {
        
        [_delegate  dwc:self weatherStatus:weather getIsSuccess:isSuccess];
    }
}


#pragma --Helper
- (void)updateFinish:(XAIObjectOpr *)oprInfo{
    
    //如果需要通知结果
    if (_delegate != nil && [_delegate respondsToSelector:@selector(dwc:curStatus:getIsSuccess:)]) {
        
        [_delegate  dwc:self curStatus:oprInfo.opr getIsSuccess:true];
    }
}


#pragma --Delegate

-(void)devDWCtrl:(XAIDevDWCtrl *)dwc curStatus:(XAIDevDWCtrlStatus)status err:(XAI_ERROR)err otherInfo:(XAIOtherInfo *)otherInfo{
    
    if (dwc != _devDWCtrl) return;
    
    
    //添加otherInfo
    XAIDWCtrlStatus dwcStatus = XAIDWCtrlStatus_Unkown;
    
    if (err == XAI_ERROR_NONE) {
        
        _DEF_XTO_TIME_End
        
        if (status == XAIDevDWCtrlStatusOpen) {
            
            dwcStatus = XAIDWCtrlStatus_Opened;
            
        }else if(status == XAIDevDWCtrlStatusClose){
            
            dwcStatus = XAIDWCtrlStatus_Closed;
            
        }else if(status == XAIDevDWCtrlStatusClosing){
            
            dwcStatus = XAIDWCtrlStatus_Closing;
            
        }else if(status == XAIDevDWCtrlStatusOpening){
            
            dwcStatus = XAIDWCtrlStatus_Opening;
        }
        
        XADWCOpr* opr = [[XADWCOpr alloc] init];
        opr.time = [NSDate dateWithTimeIntervalSince1970:otherInfo.time];
        opr.opr = dwcStatus;
        opr.otherID = otherInfo.msgid;
        opr.oprLuid = otherInfo.fromluid;
        
        [_tmpOprs addObject:opr];
        
        _DEF_XTO_TIME_Wait
        
    }else{
        
        if (_delegate != nil && [_delegate respondsToSelector:@selector(dwc:curStatus:getIsSuccess:)]) {
            
            [_delegate  dwc:self curStatus:dwcStatus getIsSuccess:err == XAI_ERROR_NONE];
        }
        
        _DEF_XTO_TIME_End
    }
    
}


-(void)devDWCtrl:(XAIDevDWCtrl *)dwc curStatus:(XAIDevDWCtrlStatus)status err:(XAI_ERROR)err{
    
    if (dwc != _devDWCtrl) return;
    
    XAIDWCtrlStatus dwcStatus = XAIDWCtrlStatus_Unkown;
    
    
    if (err == XAI_ERROR_NONE) {
        
        if (status == XAIDevDWCtrlStatusOpen) {
            
            dwcStatus = XAIDWCtrlStatus_Opened;
            
        }else if(status == XAIDevDWCtrlStatusClose){
            
            dwcStatus = XAIDWCtrlStatus_Closed;
            
        }else if(status == XAIDevDWCtrlStatusClosing){
            
            dwcStatus = XAIDWCtrlStatus_Closing;
            
        }else if(status == XAIDevDWCtrlStatusOpening){
            
            dwcStatus = XAIDWCtrlStatus_Opening;
        }
    }
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(dwc:curStatus:getIsSuccess:)]) {
        
        [_delegate  dwc:self curStatus:dwcStatus getIsSuccess:err == XAI_ERROR_NONE];
    }
    
}


-(void)devDWCtrl:(XAIDevDWCtrl *)dwc weatherStatus:(XAIDevDWCtrlWeatherStatus)status err:(XAI_ERROR)err otherInfo:(XAIOtherInfo *)otherInfo{}

-(void)devDWCtrl:(XAIDevDWCtrl *)dwc weatherStatus:(XAIDevDWCtrlWeatherStatus)status err:(XAI_ERROR)err{}



-(void)devDWCtrl:(XAIDevDWCtrl *)dwc setOpr:(XAIDevDWCtrlOpr)opr err:(XAI_ERROR)err{
    
    NSString* errTip = @"";
    
    if (_curOpr == XAIDWCtrlOpr_open) {
        
        if (_delegate != nil && [_delegate  respondsToSelector:@selector(dwc:openSuccess:)]) {
            
            [_delegate dwc:self openSuccess:err == XAI_ERROR_NONE];
        }
        
        errTip = @"打开出现异常";
        
    }else if (_curOpr == XAIDWCtrlOpr_close) {
        
        
        if (_delegate != nil && [_delegate  respondsToSelector:@selector(dwc:closeSuccess:)]) {
            
            [_delegate dwc:self closeSuccess:err == XAI_ERROR_NONE];
        }
        
        
        errTip = @"关闭出现异常";
    }else if (_curOpr == XAIDWCtrlOpr_stop) {
        
        
        if (_delegate != nil && [_delegate  respondsToSelector:@selector(dwc:stopSuccess:)]) {
            
            [_delegate dwc:self stopSuccess:err == XAI_ERROR_NONE];
        }
        
        
        errTip = @"暂停出现异常";
    }
    
    _curOpr = XAIDWCtrlOpr_none;
    
    if (err != XAI_ERROR_NONE) {
        self.curOprtip =  errTip;
        [self showMsg];
    }else{
        [self endOpr];
    }
    
}




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

@implementation XADWCOpr

- (NSString*) allStr{
    
    if (_time == nil) {
        
        return @"";
    }
    
    NSDateFormatter *format =[[NSDateFormatter alloc] init];
    
    [format setTimeZone:[NSTimeZone localTimeZone]];
    
    [format setDateFormat:@"MM/dd HH:mm"];
    

    return [NSString stringWithFormat:@"%@ %@%@",[format stringFromDate:_time],_name,[self oprOnlyStr]];
}


- (NSString *)oprOnlyStr{
    
    if (_opr == XAIDWCtrlStatus_Opened) {
        
        return NSLocalizedString(@"被打开", nil);
        
    }else if(_opr == XAIDWCtrlStatus_Closed){
        
        return NSLocalizedString(@"被关闭", nil);
    }else if(_opr == XAIDWCtrlStatus_Closing){
        
        return NSLocalizedString(@"开始关闭", nil);
    }else if(_opr == XAIDWCtrlStatus_Opening){
        
        return NSLocalizedString(@"开始打开", nil);
    }else{
    
        return @"";
    }
    
    return @"";
}

-(BOOL)isWorn{
    
    return _opr == XAIDWCtrlStatus_Opened;
}



@end
