//
//  XAIDCBtn.m
//  XAI
//
//  Created by office on 14/11/3.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIDCBtn.h"

@implementation XAIDCBtn

- (void)showTipLable:(BOOL)bl{
    
    
    _waitView.hidden = !bl;
    _statusTipImgView.hidden = bl;
}

#define  banjin  24.0f
#define  bian    19.f

- (void) showOprStart{
    _opr = XAIOCOT_Start;
    
    
    if (_bRoll == false) {
        
        _bRoll = true;
        [self startAnimation];
    }
    
    
    [self showTipLable:true];
}



-(void) startAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.01];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    _waitRollImageView.transform = CGAffineTransformMakeRotation(_angle * (M_PI / 180.0f));
    [UIView commitAnimations];
}

-(void)endAnimation
{
    if (_bRoll) {
        _angle += 10;
        [self startAnimation];
    }
    
}


- (void) showMsg{
    _opr = XAIOCOT_Msg;
    
    [self showTipLable:true];
    
    [self performSelector:@selector(showErrEnd) withObject:nil afterDelay:3.0f];
}

- (void) showErrEnd{
    
    if (_opr != XAIOCOT_Msg) {
        return;
    }
    
    [self showOprEnd];
}


- (void) showOprEnd{
    
    _opr = XAIOCOT_None;
    
    _bRoll = false;
    
    [self showTipLable:false];
    
    [self setStatus:_status];
}


-(void)setStatusCB:(XAICBTYPE)type{
    
    XAIDoorStatus status = (XAIDoorStatus)type;
    switch (status) {
        case XAIDoorStatus_Open:
            [self showOpen];
            break;
        case XAIDoorStatus_Close:
            [self showClose];
            break;
        default:
            [self showUnkonw];
            break;
    }
    
}


- (void) showClose{
    
    _statusTipImgView.image = [UIImage imageWithFile:@"dc_close.png"];
    _statusTipImgView.hidden = false;
    
    if (_weakObj != nil) {
        [self.oprTipLab setText:[_weakObj.lastOpr allStr]];
    }
}

- (void) showOpen{
    
    _statusTipImgView.image = [UIImage imageWithFile:@"dc_open.png"];
    _statusTipImgView.hidden = false;
    
    if (_weakObj != nil) {
        [self.oprTipLab setText:[_weakObj.lastOpr allStr]];
    }
    
}

- (void) showUnkonw{
    
    _statusTipImgView.image = [UIImage imageWithFile:@"dc_unk.png"];
    _statusTipImgView.hidden = false;
}




-(void)dealloc{
    
}




-(void)door:(XAIDoor *)door curStatus:(XAIDoorStatus)status getIsSuccess:(BOOL)isSuccess{
    
    if (self.weakObj == nil || ![self.weakObj isKindOfClass:[XAIDoor class]]) return;
    
    if (door.isOnline == false) {
        
        [self setStatus:XAIDoorStatus_Unkown];
       
        return;
    }
    
    if (status == XAIDoorStatus_Open) {
        [self setStatus:XAIDoorStatus_Open];
        [self.oprTipLab setText:[door.lastOpr allStr]];
    }else if(status == XAIDoorStatus_Close){
        
        [self setStatus:XAIDoorStatus_Close];
        [self.oprTipLab setText:[door.lastOpr allStr]];
    }else{
        
        [self setStatus:XAIDoorStatus_Unkown];
    }
    
    
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(btnStatusChange:)] ) {
        [self.delegate btnStatusChange:self];
    }
}

-(void)door:(XAIDoor *)door curPower:(float)power getIsSuccess:(BOOL)isSuccess{
    
    [self powerChange:power];

}

-(void) powerChange:(float)power{

    if (power == XAIDevPowerStatus_Low ||
        power == XAIDevPowerStatus_Less) {
        
        _powerView.hidden = false;
        _bPower = true;
    }else{
        
        _bPower = false;
        _powerView.hidden = true;
    }
}

- (void) setInfo:(XAIObject*)aObj{
    
    [self _removeWeakObj];
    
    if (aObj == nil) return;
    if (![aObj isKindOfClass:[XAIDoor class]]){
        
        [self  firstStatus:XAIDoorStatus_Unkown opr:XAIOCOT_None tip:nil];
        [self.statusTipImgView setBackgroundColor:[UIColor clearColor]];
        [self.statusTipImgView setImage:nil];
        [self.nameTipLab setText:nil];
        [self.oprTipLab setText:nil];
        
        return;
    }
    
    
    
    [self.statusTipImgView setBackgroundColor:[UIColor clearColor]];
    
    if (aObj.nickName != NULL && ![aObj.nickName isEqualToString:@""]) {
        
        [self.nameTipLab setText:aObj.nickName];
    }else{
        
        [self.nameTipLab setText:aObj.name];
    }
    
    [self.oprTipLab setText:[aObj.lastOpr allStr]];
    
    
    
    
    XAICBTYPE status = XAIDoorStatus_Unkown;
    
    if (aObj.isOnline){
        
        if (aObj.curDevStatus == XAIDoorStatus_Open) {
            
            status = XAIDoorStatus_Open;
            
        }else if(aObj.curDevStatus == XAIDoorStatus_Close){
            status = XAIDoorStatus_Open;
        }
        
        
    }else{
        
    }
    
    
    
    
    
    [self firstStatus:status opr:[self coverForm:aObj.curOprStatus] tip:aObj.curOprtip];
    
    
    [self _changeWeakObj:aObj];
    
    [self powerChange:aObj.power];
    
}

- (void) _removeWeakObj{
    
    if (self.weakObj != nil && [self.weakObj isKindOfClass:[XAIDoor class]]) {
        ((XAIDoor*)self.weakObj).delegate = nil;
    }
    self.weakObj = nil;
}

- (void) _changeWeakObj:(XAIObject*)aObj{
    
    [self _removeWeakObj];
    
    
    if ([aObj isKindOfClass:[XAIDoor class]]) {
        
        self.weakObj = aObj;
        ((XAIDoor*)self.weakObj).delegate = self;
        
    }
}


-(void)bgBtnClick{
    
    
    if (self.delegate != nil
        && [self.delegate respondsToSelector:@selector(btnBgClick:)]) {
        [self.delegate btnBgClick:self];
    }
    
}

-(void)startEdit{
    
    [super startEdit];
    
    [self powerChange:-1];
}

-(void)endEdit{
    [super endEdit];
    [self powerChange:_weakObj.power];
}




#pragma mark create

- (void) _init{
    
    [super _init];
    
    [self.bgBtn addTarget:self
                   action:@selector(bgBtnClick)
         forControlEvents:UIControlEventTouchUpInside];
    
    [self setBackgroundColor:[UIColor clearColor]];
    
}


+(XAIDCBtn*)create{
    
    XAIDCBtn* obj = [[[UINib nibWithNibName:@"DCBtnView" bundle:[NSBundle mainBundle]] instantiateWithOwner:nil options:nil] lastObject];
    
    if ([obj isKindOfClass:[XAIDCBtn class]]) {
        
        [obj _init];
        return  obj;
    }
    
    return nil;
}


@end
