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
    
}

@end
