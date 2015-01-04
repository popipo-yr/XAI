//
//  XAILinkageListCell.m
//  XAI
//
//  Created by office on 14-8-18.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILinkageListCell.h"

@implementation XAILinkageListCell

- (void) setInfo:(XAILinkage*)linkage{
    
    if (linkage == nil) return;
    if (![linkage isKindOfClass:[XAILinkage  class]]){
        
        [self  firstStatus:XAIOCST_Unkown opr:XAIOCOT_None tip:nil];
        [self.statusImgV setBackgroundColor:[UIColor clearColor]];
        [self.statusImgV setImage:nil];
        [self.nameLable setText:nil];
        
        return;
    }
    
    
    
    [self.nameLable setText:linkage.name];
    
    
    
    XAIOCST status = XAIOCST_Unkown;
    
    if (linkage.status == XAILinkageStatus_Active) {
        status = XAIOCST_Open;
    }else if(linkage.status == XAILinkageStatus_DisActive){
        status = XAIOCST_Close;
    }
    
    
    [self firstStatus:status opr:[self coverForm:linkage.curOprStatus] tip:linkage.curOprtip];


}

-(void) isEidt:(BOOL)isEdit{

    if (isEdit) {
        [self startEdit];
    }else{
        [self endEdit];
    }
}

-(IBAction)statusClick:(id)sender{

    if (nil != _delegate &&
        [_delegate respondsToSelector:@selector(linkListCellClickStatusClick:)] ) {
        
        [_delegate linkListCellClickStatusClick:self];
    }
}
-(IBAction)delClick:(id)sender{

    if (nil != _delegate && [_delegate respondsToSelector:@selector(linkListCellClickDel:)] ) {
        [_delegate linkListCellClickDel:self];
    }

}


//----------------------

- (void)showTipLable:(BOOL)bl{
    
}

- (void) showOprStart{
    _opr = XAIOCOT_Start;
    
    [self showTipLable:true];
    
    _oprRollImgV.hidden = false;
    _statusImgV.hidden = true;
    
    [self endAnimation];
    
    if (_oprTimer != nil) return;
    _oprTimer = [NSTimer scheduledTimerWithTimeInterval:0.05f
                                                  target:self
                                                selector:@selector(oprProc)
                                                userInfo:nil repeats:YES];
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
    
    _oprRollImgV.hidden = true;
    _statusImgV.hidden = false;
    
    if (_oprTimer != nil) {
        [_oprTimer invalidate];
        _oprTimer = nil;
    }
    
    [self setStatus:_status];
}


- (void) setStatus:(XAIOCST)type{
    
    _status = type;
    
    if (_opr != XAIOCOT_None) {
        return;
    }
    
    switch (type) {
        case XAIOCST_Open:
            [self showOpen];
            break;
        case XAIOCST_Close:
            [self showClose];
            break;
        case XAIOCST_Unkown:
            [self showUnkonw];
            break;
        default:
            break;
    }
    
}

- (void) firstStatus:(XAIOCST)staus opr:(XAIOCOT)opr tip:(NSString *)tip{
    
    _opr = opr;
    _status = staus;
    
    [self endEdit];
    
    switch (opr) {
        case XAIOCOT_None:
            [self showOprEnd];
            break;
        case XAIOCOT_Start:
            [self showOprStart];
            break;
        case XAIOCOT_Msg:
            [self showMsg];
            break;
        default:
            break;
    }
    
}

-(void) startAnimation
{
    if (_roleTimer != nil) return;
    _roleTimer = [NSTimer scheduledTimerWithTimeInterval:0.04f
                                                  target:self
                                                selector:@selector(roleProc)
                                                userInfo:nil repeats:YES];
    
     
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.01];
//        [UIView setAnimationDelegate:self];
//        [UIView setAnimationDidStopSelector:@selector(endAnimation)];
//        [UIView commitAnimations];
}

-(void)endAnimation
{
//    if (_bRoll) {
//        _angle += 10;
//        [self startAnimation];
//    }
    
    if (_roleTimer != nil) {
        [_roleTimer invalidate];
        _roleTimer = nil;
    }
    
    self.statusRollImgV.transform = CGAffineTransformMakeRotation(0);
}

-(void)roleProc{

    if (self.superview != nil) {
        
        
        self.statusRollImgV.transform = CGAffineTransformMakeRotation(_angle * (M_PI / 180.0f));
        _angle += 5;
    
    }
}

-(void)oprProc{

    if (self.superview != nil) {
        self.oprRollImgV.transform = CGAffineTransformMakeRotation(_angle * (M_PI / 180.0f));
        _angle += 20;
    }
}

- (void) showClose{
    
    [self endAnimation];
    
    //[self.statusImgV setBackgroundColor:[UIColor blackColor]];
    //self.statusImgV.image = [UIImage imageWithFile:@"link_s_stop.png"];
    [self.statusBtn setImage:[UIImage imageWithFile:@"link_s_btn_off.png"]
                    forState:UIControlStateNormal];
    
    self.statusRollImgV.transform = CGAffineTransformMakeRotation(0);
    
    [self showTipLable:false];
}
- (void) showOpen{
    

    //[self.statusImgV setBackgroundColor:[UIColor blackColor]];
    //self.statusImgV.image = [UIImage imageWithFile:@"link_s_run.png"];
    [self.statusBtn setImage:[UIImage imageWithFile:@"link_s_btn_on.png"]
                    forState:UIControlStateNormal];
    
    self.statusRollImgV.transform = CGAffineTransformMakeRotation(0);
    
    [self showTipLable:false];
    
    [self startAnimation];

}


- (void) showUnkonw{
    
    [self showTipLable:false];
}





-(XAIOCOT)coverForm:(XAIObjectOprStatus)objOprStatus{
    
    XAIOCOT opr = XAIOCOT_None;
    
    if(objOprStatus == XAIObjectOprStatus_showMsg){
        opr = XAIOCOT_Msg;
        
    }else if (objOprStatus == XAIObjectOprStatus_start) {
        opr = XAIOCOT_Start;
    }
    
    return opr;
    
}


-(void) endEdit{
    

    _delBtn.hidden = true;
    _delBtn.enabled = false;
    
}
-(void) startEdit{
    

    _delBtn.hidden = false;
    _delBtn.enabled = true;
}

-(void)willMoveToSuperview:(UIView *)newWindow{
    
    [super willMoveToSuperview:newWindow];
    
    
    if (newWindow == (id)[NSNull null] || newWindow == nil){
        
        if (_roleTimer != nil) {
            [_roleTimer invalidate];
            _roleTimer = nil;
        }
        
        if (_oprTimer != nil) {
            [_oprTimer invalidate];
            _oprTimer = nil;
        }
    }
    
}

-(void)dealloc{
    
}


@end