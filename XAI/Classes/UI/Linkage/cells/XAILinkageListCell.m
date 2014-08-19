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
        [self.tipImageView setBackgroundColor:[UIColor clearColor]];
        [self.tipImageView setImage:nil];
        [self.nameLable setText:nil];
        [self.contextLable setText:nil];
        [self.tipLabel setText:nil];
        
        return;
    }
    
    
    
    [self.tipImageView setBackgroundColor:[UIColor clearColor]];
    
    [self.nameLable setText:linkage.name];
    
    
    
    
    
    
    XAIOCST status = XAIOCST_Unkown;
    
    if (linkage.status == XAILinkageStatus_Active) {
        status = XAIOCST_Open;
    }else if(linkage.status == XAILinkageStatus_DisActive){
        status = XAIOCST_Close;
    }
    
    
    [self firstStatus:status opr:[self coverForm:linkage.curOprStatus] tip:linkage.curOprtip];


}

-  (void) setAdd{
    
    
    [self firstStatus:XAIOCST_Open opr:XAIOCOT_None tip:nil];
    [self.tipImageView setBackgroundColor:[UIColor clearColor]];
    [self.tipImageView setImage:nil];
    [self.nameLable setText:@"添加联动"];
    [self.contextLable setText:nil];
    [self.tipLabel setText:nil];


}

@end