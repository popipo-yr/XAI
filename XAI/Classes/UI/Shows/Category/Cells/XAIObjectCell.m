//
//  XAIObjectCell.m
//  XAI
//
//  Created by office on 14-8-15.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIObjectCell.h"

@implementation XAIObjectCell

- (void)showTipLable:(BOOL)bl{

    self.tipLabel.hidden = !bl;
    self.nameLable.hidden = bl;
    self.contextLable.hidden = bl;
}

#define  banjin  24.0f
#define  bian    19.f

- (void) showOprStart:(NSString *)tip{
    _opr = XAIOCOT_Start;
    [self.tipImageView setImage:[UIImage imageWithFile:@"cell_opr.png"]];
    
    if (_moves != nil) {
        _moves.hidden = false;
        
        _moves.frame = CGRectMake(bian-2,
                                  _moves.frame.size.height*-0.5,
                                  _moves.frame.size.width,
                                  _moves.frame.size.height);

        
    }else{
        _moves = [[UIImageView alloc]initWithImage:[UIImage imageWithFile:@"animal_move.png"]];
        [self.tipImageView addSubview:_moves];
        
        _moves.frame = CGRectMake(bian-2,
                                  _moves.frame.size.height*-0.5,
                                  _moves.frame.size.width,
                                  _moves.frame.size.height);
    }
    
    [self oneloop];
    
    [self.tipLabel setText:tip];
    [self showTipLable:true];
}


- (void) oneloop{

    CGSize size = self.tipImageView.frame.size;
    
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, bian, 0);
    CGPathAddLineToPoint(path, NULL, size.width - bian, 0);
    CGPathAddArc(path, NULL, size.width - banjin, size.height/2,banjin, M_PI*-80/180, M_PI*80/180, NO);
    CGPathAddLineToPoint(path, NULL, size.width - bian, size.height);
    CGPathAddLineToPoint(path, NULL, bian, size.height);
    CGPathAddArc(path, NULL, banjin, size.height/2, banjin, M_PI*90/180, M_PI*270/180, NO);
    CGPathAddLineToPoint(path, NULL, bian, 0);
    
    
    
    CAKeyframeAnimation *leafAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    leafAnimation.duration = 2.0;
    leafAnimation.path =path;/* your CGPathRef */;
    [leafAnimation setValue:@"toViewValue" forKey:@"toViewKey"];
    leafAnimation.calculationMode = kCAAnimationLinear;
    leafAnimation.keyTimes = [NSArray
                              arrayWithObjects:
                              [NSNumber numberWithFloat:0],
                              [NSNumber numberWithFloat:0.3],  //shangmianyidong
                              [NSNumber numberWithFloat:0.3], //JIRU
                              [NSNumber numberWithFloat:0.46], //SHANGBANQUAN
                              [NSNumber numberWithFloat:0.60], //XIABANQUAN
                              [NSNumber numberWithFloat:0.6], //CHU
                              [NSNumber numberWithFloat:0.81], //YIDONG
                              [NSNumber numberWithFloat:0.81], //XIABANQUAN
                              [NSNumber numberWithFloat:0.90], //SHANGBANQUAN
                              [NSNumber numberWithFloat:1.0], //SHANGBANQUAN
                              [NSNumber numberWithFloat:1.0],
                              nil];
    leafAnimation.delegate = self;
    [_moves.layer addAnimation:leafAnimation forKey:@"leafAnimation"];

}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{

    if ([[anim valueForKey:@"toViewKey"] isEqualToString:@"toViewValue"]
        && flag == true
        && _moves.hidden == false) {
        
        [self oneloop];
        //CGPoint S = _moves.frame.origin;
    }
    
    //anim.delegate = nil;

}

- (void) showMsg:(NSString *)msg{
    
    if (_moves != nil) {
        _moves.hidden = true;
    }
    _opr = XAIOCOT_Msg;
    [self.tipImageView setImage:[UIImage imageWithFile:@"cell_err.png"]];
    
    [self.tipLabel setText:msg];
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
    
    if (_moves != nil) {
        _moves.hidden = true;
    }
    
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
    
    if (_moves != nil) {
        _moves.hidden = true;
    }
    
    switch (opr) {
        case XAIOCOT_None:
            [self showOprEnd];
            break;
        case XAIOCOT_Start:
            [self showOprStart:tip];
            break;
        case XAIOCOT_Msg:
            [self showMsg:tip];
            break;
        default:
            break;
    }
    
    
    [_input addTarget:self action:@selector(keyReturn:)
     forControlEvents:UIControlEventEditingDidEndOnExit];

}


- (void) showClose{
    
    [self.tipImageView setImage:[UIImage imageWithFile:@"cell_close.png"]];
    [self showTipLable:false];
}
- (void) showOpen{
    
    [self.tipImageView setImage:[UIImage imageWithFile:@"cell_open.png"]];
    [self showTipLable:false];
}

- (void) showUnkonw{

    [self.tipImageView setImage:[UIImage imageWithFile:@"cell_unkown.png"]];
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

-(void)keyReturn:(id)sender{
    
    if (self.delegate != nil &&
        [self.delegate respondsToSelector:@selector(swipeableTableViewCellCancelEdit:)]) {
        
        [self.delegate swipeableTableViewCellCancelEdit:self];
    }

    [self hideUtilityButtonsAnimated:true];
}

-(void)dealloc{

}

@end
