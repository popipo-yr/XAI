//
//  XAIInfBtn.m
//  XAI
//
//  Created by office on 14/11/3.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIInfBtn.h"

@implementation XAIInfBtn

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


- (void) showClose{
    
    _statusTipImgView.image = [UIImage imageWithFile:@"inf_nor.png"];
    _statusTipImgView.hidden = false;
    
    [self showWarning:false];
    [self showWorking:true];
    
    if (_weakObj != nil) {
        [self.oprTipLab setText:[_weakObj.lastOpr allStr]];
    }
}

bool _is = false;

- (void) showOpen{
    
    _statusTipImgView.image = [UIImage imageWithFile:@"inf_warn.png"];
    _statusTipImgView.hidden = false;

    if (_weakObj != nil) {
        [self.oprTipLab setText:[_weakObj.lastOpr allStr]];
    }
    
    
    [self showWarning:true];
    [self showWorking:false];
    
}

- (void) showUnkonw{
    
    _statusTipImgView.image = [UIImage imageWithFile:@"inf_unk.png"];
    _statusTipImgView.hidden = false;
    
    [self showWarning:false];
    [self showWorking:false];
}



- (void) showWarning:(BOOL)bl{

    
    if (bl) {
        
        if (_warnTimer != nil) return;
        
        
        _showWarnAlpha = 1.0;
        _showWarnIsDel = true;
        _warnTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                      target:self
                                                    selector:@selector(showArrow)
                                                    userInfo:nil
                                                     repeats:YES];

        
        [self showArrow];
        
        if (_fuckImgView == nil) {
            
            _fuckImgView = [[UIImageView alloc] initWithFrame:_statusTipImgView.frame];
            _fuckImgView.image = [UIImage imageWithFile:@"inf_unk.png"];
            [_statusTipImgView.superview insertSubview:_fuckImgView belowSubview:_statusTipImgView];
        }
        
    }else{
        
        if (_warnTimer != nil) {
            [_warnTimer invalidate];
            _warnTimer = nil;
        }
        
        self.statusTipImgView.alpha = 1;
        [self.statusTipImgView.layer removeAllAnimations];
        
        if (_fuckImgView == nil) {
            
            [_fuckImgView removeFromSuperview];
            
        }
        
    }
    
}

- (void) showWorking:(BOOL)bl{
    
    
    
    if (bl) {
        
        if (_workTimer != nil) return;
        
        
        _showWorkIndex = 0;
        _workTimer = [NSTimer scheduledTimerWithTimeInterval:0.25f
                                             target:self
                                           selector:@selector(showWorkProc:)
                                           userInfo:nil
                                            repeats:YES];
        
        
    }else{
        

        _nor1ImgView.hidden =  true;
        _nor2ImgView.hidden =  true;
        _nor3ImgView.hidden =  true;

    
        if (_workTimer != nil) {
            [_workTimer invalidate];
            _workTimer = nil;
        }
    }
    
}

-(void)showArrow{
    
    
    if (_showWarnAlpha > 1) {
        _showWarnAlpha = 1;
        _showWarnIsDel = true;
    }else if(_showWarnAlpha < 0){
    
        _showWarnAlpha = 0;
        _showWarnIsDel = false;
    }
    
    if (_showWarnIsDel) {
        _showWarnAlpha -= 0.2;
    }else{
        _showWarnAlpha += 0.6;
    }
    
    _statusTipImgView.alpha = _showWarnAlpha;
    
    
    return;
    
    [UIView beginAnimations:@"ShowArrow" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:2.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationRepeatCount:3];
    [UIView setAnimationDidStopSelector:@selector(showArrowStart)];
    [UIView commitAnimations];

}

-(void)showArrowStart{

    UIView *arrow = self.statusTipImgView;
    [UIView beginAnimations:@"ShowArrowStart" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(showArrowStop)];
    // Make the animatable changes.
    arrow.alpha = 0.3;
    // Commit the changes and perform the animation.
    [UIView commitAnimations];

}


- (void)showArrowStop{
    
    UIView *arrow = self.statusTipImgView;
    [UIView beginAnimations:@"HideArrow" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelay:1.0];
    arrow.alpha = 1.0;
    [UIView commitAnimations];
    
}





-(void)showWorkProc:(float)sec{
    
    //0不亮 1亮一个 2亮2个 。。。
    if (_showWorkIndex > 3) {
        _showWorkIndex = 0;
    }
    
    _nor1ImgView.hidden = _showWorkIndex > 0 ? false : true;
    _nor2ImgView.hidden = _showWorkIndex > 1 ? false : true;
    _nor3ImgView.hidden = _showWorkIndex > 2 ? false : true;
    
    _showWorkIndex += 1;
}



//警告显示的打开  正常显示的关闭 －－

- (void) ir:(XAIIR*)ir curStatus:(XAIIRStatus) status getIsSuccess:(BOOL)isSuccess{
    
    if (self.weakObj == nil || ![self.weakObj isKindOfClass:[XAIIR class]]) return;
    
    
    if (ir.isOnline == false) {
        
        [self setStatus:XAIOCST_Unkown];

        return;
    }
    
    if (status == XAIIRStatus_warning) {
        [self setStatus:XAIOCST_Open];
        
        
    }else if(status == XAIIRStatus_working){
        
        [self setStatus:XAIOCST_Close];
    }else{
        
        [self setStatus:XAIOCST_Unkown];
    }
    
    //[self showWorning:XAIIRStatus_warning == status];
    
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(btnStatusChange:)] ) {
        [self.delegate btnStatusChange:self];
    }
}

-(void)ir:(XAIIR *)ir curPower:(float)power getIsSuccess:(BOOL)isSuccess{

    if (!isSuccess) return;
    [self powerChange:power];
}


-(void) powerChange:(float)power{
    
    if (power == XAIDevPowerStatus_Low ||
        power == XAIDevPowerStatus_Less) {
        
        if (_bPower == false) {
         
            _powerView.hidden = false;
            _bPower = true;
        }

    }else{
        
        _bPower = false;
        _powerView.hidden = true;
    }
}

- (void) setInfo:(XAIObject*)aObj{
    
    [self _removeWeakObj];
    
    if (aObj == nil) return;
    if (![aObj isKindOfClass:[XAIIR class]]){
        
        [self  firstStatus:XAIOCST_Unkown opr:XAIOCOT_None tip:nil];
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
    
    
    
    
    XAIOCST status = XAIOCST_Unkown;
    
    if (aObj.isOnline){
        
        if (aObj.curDevStatus == XAIIRStatus_warning) {
            
            status = XAIOCST_Open;
            
        }else if(aObj.curDevStatus == XAIIRStatus_working){
            status = XAIOCST_Close;
        }
        
    }
    
    
    
    [self firstStatus:status opr:[self coverForm:aObj.curOprStatus] tip:aObj.curOprtip];
    
    
    
    [self _changeWeakObj:aObj];
    
    //[self showWorning:XAIIRStatus_warning == aObj.curDevStatus];
    
    [self powerChange:aObj.power];
    
}

- (void) _removeWeakObj{
    
    if (self.weakObj != nil && [self.weakObj isKindOfClass:[XAIIR class]]) {
        ((XAIIR*)self.weakObj).delegate = nil;
        self.weakObj = nil;
        
    }
}

- (void) _changeWeakObj:(XAIObject*)aObj{
    
    [self _removeWeakObj];
    
    
    if ([aObj isKindOfClass:[XAIIR class]]) {
        
        self.weakObj = aObj;
        ((XAIIR*)self.weakObj).delegate = self;
        
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
    
    if (_bPower) {
        _powerView.hidden = true;
    }

}

-(void)endEdit{
    [super endEdit];
    if (_bPower) {
        _powerView.hidden = false;
    }
}


#pragma mark create

- (void) _init{
    
    [super _init];
    
    [self.bgBtn addTarget:self
                   action:@selector(bgBtnClick)
         forControlEvents:UIControlEventTouchUpInside];
    
    [self setBackgroundColor:[UIColor clearColor]];
    
}


+(XAIInfBtn*)create{
    
    XAIInfBtn* obj = [[[UINib nibWithNibName:@"InfBtnView" bundle:[NSBundle mainBundle]] instantiateWithOwner:nil options:nil] lastObject];
    
    if ([obj isKindOfClass:[XAIInfBtn class]]) {
        
        [obj _init];
        return  obj;
    }
    
    return nil;
}

-(void)willMoveToWindow:(UIWindow *)newWindow{

    [super willMoveToWindow:newWindow];
    
    
    if (newWindow == (id)[NSNull null] || newWindow == nil){
    
        if (_workTimer != nil) {
            [_workTimer invalidate];
            _workTimer = nil;
        }
        
        if (_warnTimer != nil) {
            [_warnTimer invalidate];
            _warnTimer = nil;
        }
        
        [self _removeWeakObj];
    
    }
    
}

-(void)dealloc{
 
    
}

@end
