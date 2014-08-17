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

- (void) showOprStart:(NSString *)tip{
    _opr = XAIOCOT_Start;
    [self.tipImageView setImage:[UIImage imageNamed:@"cell_opr.png"]];
    
    [self.tipLabel setText:tip];
    [self showTipLable:true];
}
- (void) showMsg:(NSString *)msg{
    _opr = XAIOCOT_Msg;
    [self.tipImageView setImage:[UIImage imageNamed:@"cell_err.png"]];
    
    [self.tipLabel setText:msg];
    [self showTipLable:true];
    
    [self performSelector:@selector(showOprEnd) withObject:nil afterDelay:3.0f];
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
    
    [self.tipImageView setImage:[UIImage imageNamed:@"cell_close.png"]];
    [self showTipLable:false];
}
- (void) showOpen{
    
    [self.tipImageView setImage:[UIImage imageNamed:@"cell_open.png"]];
    [self showTipLable:false];
}

- (void) showUnkonw{

    [self.tipImageView setImage:[UIImage imageNamed:@"cell_unkown.png"]];
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

@end
