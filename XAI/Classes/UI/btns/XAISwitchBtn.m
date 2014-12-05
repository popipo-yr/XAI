//
//  XAISwitchBtn.m
//  XAI
//
//  Created by office on 14/10/29.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAISwitchBtn.h"

@implementation XAISwitchBtn

- (void)showTipLable:(BOOL)bl{
    
    
    _waitView.hidden = !bl;
    _unkownImgView.hidden = bl;
    _statusTextImgView.hidden = bl;
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
    
    _statusTipImgView.hidden = true;
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

-(void) startFadeAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endFadeAnimation)];
    _statusTipImgView.alpha = _fade;
    [UIView commitAnimations];
}

-(void)endFadeAnimation{
    
    if (_bFade) {
        
        if (_fade < 0) {
            _fade  = 0;
            _bDelFade = false;
        }else if(_fade > 1){
            _fade = 1;
            _bDelFade = true;
        }
        
        if (_bDelFade) {
            _fade -= 0.1;
        }else{
            _fade += 0.2;
        }
        
        

        [self startFadeAnimation];
    }else{
    
        _fade = 1;
        _bDelFade = true;
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
    
    _statusTipImgView.hidden = false;
}




- (void) showClose{
    
    _bgImgView.image = [UIImage imageWithFile:@"switch_nor.png"];
    _statusTextImgView.image = [UIImage imageWithFile:@"switch_off_text.png"];
    _statusTipImgView.image = [UIImage imageWithFile:@"switch_off_tip.png"];
    _statusTextImgView.hidden = false;
    _unkownImgView.hidden = true;
    
    if (_weakLight != nil) {
        [self.oprTipLab setText:[_weakLight.lastOpr allStr]];
    }
    
    if (_bFade == true) {
        _bFade = false;
        [self endFadeAnimation];
    }
}
- (void) showOpen{
    
    _bgImgView.image = [UIImage imageWithFile:@"switch_on_bg.png"];
    _statusTextImgView.image = [UIImage imageWithFile:@"switch_on_text.png"];
    _statusTipImgView.image = [UIImage imageWithFile:@"switch_on_tip.png"];
    _statusTextImgView.hidden = false;
    _unkownImgView.hidden = true;
    
    if (_weakLight != nil) {
        [self.oprTipLab setText:[_weakLight.lastOpr allStr]];
    }
    
    if (_bFade == false) {
        _bFade = true;
        [self startFadeAnimation];
    }
    
}

- (void) showUnkonw{
    
    _bgImgView.image = [UIImage imageWithFile:@"switch_nor.png"];
    _statusTextImgView.image = [UIImage imageWithFile:@"switch_off_text.png"];
    _statusTextImgView.hidden = true;
    _unkownImgView.hidden = false;
    
}




-(void)dealloc{
    
}


- (void) setInfo:(XAILight*)aObj{
    
    [self _removeWeakObj];
    
    if (aObj == nil) return;
    if (![aObj isKindOfClass:[XAILight class]] ){
        
        [self  firstStatus:XAIOCST_Unkown opr:XAIOCOT_None tip:nil];
        return;
    }
    
    
    
    //[self.bgBtn setBackgroundColor:[UIColor clearColor]];
    
    if (aObj.nickName != NULL && ![aObj.nickName isEqualToString:@""]) {
        
        [self.nameTipLab setText:aObj.nickName];
    }else{
        
        [self.nameTipLab setText:aObj.name];
    }
    
    [self.oprTipLab setText:[aObj.lastOpr allStr]];
    
    
    
    
    XAIOCST status = XAIOCST_Unkown;
    
    if (aObj.isOnline) {
        
        if (aObj.curDevStatus == XAILightStatus_Open) {
            
            status = XAIOCST_Open;
            
        }else if(aObj.curDevStatus == XAILightStatus_Close){
            status = XAIOCST_Close;
        }
    }
    
    
    [self firstStatus:status opr:[self coverForm:aObj.curOprStatus] tip:aObj.curOprtip];
    
    
    [self _changeWeakObj:aObj];
    
}

- (void) _removeWeakObj{
    
    if (self.weakLight != nil && [self.weakLight isKindOfClass:[XAILight class]]) {
        ((XAILight*)self.weakLight).delegate = nil;
        self.weakLight = nil;
        
    }
}


- (void) _changeWeakObj:(XAILight*)aObj{
    
    [self _removeWeakObj];
    
    
    if ([aObj isKindOfClass:[XAILight class]]) {
        
        self.weakLight = aObj;
        ((XAILight*)self.weakLight).delegate = self;
        
    }
    
}


-(void)bgBtnClick{
    
//    if (_bRoll) {
//        
//        _bRoll = false;
//        return;
//    }

    if (self.weakLight == nil || ![self.weakLight isKindOfClass:[XAILight class]]) return;
    
    if (self.weakLight.isOnline == false)  return;
    
    if(self.weakLight.curDevStatus == XAILightStatus_Open){
        
        [self.weakLight closeLight];
        [self showOprStart];
        
        
    }else if(self.weakLight.curDevStatus == XAILightStatus_Close){
        
        [self.weakLight openLight];
        [self showOprStart];
    }
    
    
    if (self.delegate != nil
        && [self.delegate respondsToSelector:@selector(btnBgClick:)]) {
        [self.delegate btnBgClick:self];
    }

    
}

#pragma mark  delegate
- (void) light:(XAILight *)light openSuccess:(BOOL)isSuccess{
    
    if (isSuccess) {
        
        [self showOprEnd];
        [self setStatus:XAIOCST_Open];
        
    }else{
        
        
        [self showMsg];
    }
    
    
}
- (void) light:(XAILight *)light closeSuccess:(BOOL)isSuccess{
    
    if (isSuccess) {
        
        [self showOprEnd];
        [self setStatus:XAIOCST_Close];
        
    }else{
        
        [self showMsg];
    }
}

- (void) light:(XAILight *)light curStatus:(XAILightStatus)status{
    
    if (light.isOnline == false) {
        
        [self setStatus:XAIOCST_Unkown];
        return;
    }
    
    if (status == XAILightStatus_Open) {
        [self setStatus:XAIOCST_Open];
        [self.oprTipLab  setText:[light.lastOpr allStr]];
    }else if (status == XAILightStatus_Close) {
        [self setStatus:XAIOCST_Close];
        [self.oprTipLab setText:[light.lastOpr allStr]];
    }else{
        
        [self setStatus:XAIOCST_Unkown];
    }
    
    
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(btnStatusChange:)] ) {
        [self.delegate btnStatusChange:self];
    }

}

#pragma  mark - Other

- (void)registerEffectForView:(UIView *)aView depth:(CGFloat)depth;
{
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform"];
    shake.duration = 0.13;
    shake.autoreverses = YES;
    shake.repeatCount = MAXFLOAT;
    shake.removedOnCompletion = NO;
    CGFloat rotation = 0.1;
    shake.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform,-rotation, 1.0 ,1.0 ,1.0)];
    shake.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, rotation, 1.0 ,1.0 ,1.0)];
    
    
    CALayer *layer = [aView layer];
    CGPoint oldAnchorPoint = layer.anchorPoint;
    [layer setAnchorPoint:CGPointMake(0.5, 0.8)];
    [layer setPosition:CGPointMake(layer.position.x + layer.bounds.size.width * (layer.anchorPoint.x - oldAnchorPoint.x), layer.position.y + layer.bounds.size.height * (layer.anchorPoint.y - oldAnchorPoint.y))];
    
    [aView.layer addAnimation:shake forKey:@"shakeAnimation"];
}

-(void) editNickStart{

    self.nameTF.hidden = false;
    [self registerEffectForView:self.bgView depth:20.0f];
    
}

-(void) editNickStop{
    
    self.nameTF.hidden = true;

    [self.bgView.layer removeAllAnimations];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(btnEditClick:)] ) {
        [self.delegate btnEditClick:self];
    }
    return YES;
}



#pragma mark create

- (void) _init{

    [super _init];
    
    [self.bgBtn addTarget:self
                   action:@selector(bgBtnClick)
         forControlEvents:UIControlEventTouchUpInside];
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    self.nameTF.delegate = self;

}


+(XAISwitchBtn*)create{

    XAISwitchBtn* obj = [[[UINib nibWithNibName:@"SwitchBtnView" bundle:[NSBundle mainBundle]] instantiateWithOwner:nil options:nil] lastObject];
    
    if ([obj isKindOfClass:[XAISwitchBtn class]]) {
    
        [obj _init];
        return  obj;
    }

    return nil;
}

@end
