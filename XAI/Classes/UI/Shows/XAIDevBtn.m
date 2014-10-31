//
//  XAIDevBtn.m
//  XAI
//
//  Created by office on 14/10/29.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIDevBtn.h"

@implementation XAIDevBtn


- (void)showTipLable:(BOOL)bl{
    
}

#define  banjin  24.0f
#define  bian    19.f

- (void) showOprStart{
    _opr = XAIOCOT_Start;

    [self showTipLable:true];
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


- (void) showClose{
    
    [self showTipLable:false];
}
- (void) showOpen{
    
    [self showTipLable:false];
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
    
    _editBtn.enabled = false;
    _editBtn.hidden  = true;
    _delBtn.enabled = false;
    _delBtn.hidden = true;
    _bgBtn.enabled = true;

}
-(void) startEdit{

    _editBtn.enabled = true;
    _editBtn.hidden  = false;
    _delBtn.enabled = true;
    _delBtn.hidden = false;
    _bgBtn.enabled = false;
}

-(void)dealloc{
    
}

-(void)delClick:(id)sender{

    if (nil != _delegate && [_delegate respondsToSelector:@selector(btnDelClick:)] ) {
        [_delegate btnDelClick:self];
    }

}

-(void)editClick:(id)sender{
    
    if (nil != _delegate && [_delegate respondsToSelector:@selector(btnEditClick:)] ) {
        [_delegate btnEditClick:self];
    }
    
    [_nameTF becomeFirstResponder];
    _nameTF.hidden = false;
}

-(void)editWithDone{
    
    if ([_nameTF.text isEqualToString:@""]) return;

    _nameTipLab.text = _nameTF.text;
    _nameTF.text = nil;
    
    if (nil != _delegate && [_delegate respondsToSelector:@selector(btnEditOk:)] ) {
        [_delegate btnEditOk:self];
    }
}

-(void)editEnd{
    
    _nameTF.hidden = true;
    
    if (nil != _delegate && [_delegate respondsToSelector:@selector(btnEditEnd:)] ) {
        [_delegate btnEditEnd:self];
    }
}

- (void) _init{

    [self.delBtn addTarget:self action:@selector(delClick:)
          forControlEvents:UIControlEventTouchUpInside];
    
    [self.editBtn addTarget:self action:@selector(editClick:)
          forControlEvents:UIControlEventTouchUpInside];
    
    [_nameTF addTarget:self action:@selector(editWithDone) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    [_nameTF addTarget:self action:@selector(editEnd)
      forControlEvents:UIControlEventEditingDidEnd];
    
    
    _nameTF.returnKeyType = UIReturnKeyDone;
    
}


@end
