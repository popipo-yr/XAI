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
    
    
    //_nameTF.delegate = self;
    
}


NSInteger  prewTag ;  //编辑上一个UITextField的TAG,需要在XIB文件中定义或者程序中添加，不能让两个控件的TAG相同
float prewMoveY; //编辑的时候移动的高度

// 下面两个方法是为了防止TextFiled让键盘挡住的方法
/**
 开始编辑UITextField的方法
 */
-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    
    CGPoint Point =  [[_nameTF superview] convertPoint:_nameTF.frame.origin toView:self.superview];
    
    float textY = Point.y;
    float bottomY = self.superview.frame.size.height-textY;
    float keyboardHeight = 240;
    if(bottomY>=keyboardHeight)  //判断当前的高度是否已经有216，如果超过了就不需要再移动主界面的View高度
    {
        prewTag = -1;
        return;
    }
    prewTag = textField.tag;
    float moveY = keyboardHeight-bottomY;
    prewMoveY = moveY;
    
    NSTimeInterval animationDuration = 1.0f;
    CGRect frame = self.superview.frame;
    frame.origin.y -=moveY;//view的Y轴上移
    frame.size.height +=moveY; //View的高度增加
    self.superview.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.superview.frame = frame;
    [UIView commitAnimations];//设置调整界面的动画效果
}

/**
 结束编辑UITextField的方法，让原来的界面还原高度
 */
-(void) textFieldDidEndEditing:(UITextField *)textField
{
    if(prewTag == -1) //当编辑的View不是需要移动的View
    {
        return;
    }
    float moveY ;
    NSTimeInterval animationDuration = 1.0f;
    CGRect frame = self.superview.frame;
    if(prewTag == textField.tag) //当结束编辑的View的TAG是上次的就移动
    {   //还原界面
        moveY =  prewMoveY;
        frame.origin.y +=moveY;
        frame.size. height -=moveY;
        self.superview.frame = frame;
    }
    //self.view移回原位置
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.superview.frame = frame;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    
    
}



@end
