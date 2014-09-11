//
//  XAIUserServerListCell.m
//  XAI
//
//  Created by office on 14-8-17.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIUserServerListCell.h"

@implementation XAIUserServerListCell

- (void) setInfo:(XAIUser*)aUser{
    
    if (aUser == nil) return;
    if (![aUser isKindOfClass:[XAIUser class]]){
        
        [self  firstStatus:XAIOCST_Unkown opr:XAIOCOT_None tip:nil];
        [self.tipImageView setBackgroundColor:[UIColor clearColor]];
        [self.tipImageView setImage:nil];
        [self.nameLable setText:nil];
        [self.contextLable setText:nil];
        [self.tipLabel setText:nil];
        
        return;
    }
    
    
    
    [self.tipImageView setBackgroundColor:[UIColor clearColor]];
    

        
    [self.nameLable setText:aUser.name];
    
    
    [self.contextLable setText:nil];
    
    
    
    
    XAIOCST status = XAIOCST_Open;
    
    
    [self firstStatus:status opr:[self coverForm:aUser.curOprStatus] tip:aUser.curOprtip];
    
    [self changeHead:aUser];
}

-(void)dealloc{

}

- (void)changeHead:(XAIUser*)aUser{
    
    
    XAIUser* curUser = [MQTT shareMQTT].curUser;
    int number = [XAIUser countOfOneNotReadIMCount:curUser.luid apsn:curUser.apsn withLuid:aUser.luid apsn:aUser.apsn];
    
    
    if (_headView == nil) {
        
        
        UIImage* msgNumImg = [UIImage imageWithFile:@"msgNum2.png"];
        CGSize numSize = msgNumImg.size;
        
        float y = (self.frame.size.height-numSize.height)*0.5f;
        _headView = [[UIImageView alloc] initWithFrame:CGRectMake(15
                                                                  ,y
                                                                  ,numSize.width
                                                                  ,numSize.height)];
        
        
        [_headView setImage:msgNumImg];
        
        _label = [[UILabel alloc] init];
        _label.frame = CGRectMake(0, 0, numSize.width, numSize.height);
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
        [_label setText:@"88"];
        
        [_headView addSubview:_label];

        
        [self.contentView addSubview:_headView];
    }
    
    
    if (number > 99) {
        number = 99;
    }
    
    [_label setText:[NSString stringWithFormat:@"%d",number]];
    [_headView setHidden: number <=0 ? true : false];
    [_label setHidden:number <=0 ? true : false];

}



@end
