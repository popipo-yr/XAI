//
//  XAIInfListCell.m
//  XAI
//
//  Created by office on 14-8-17.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIInfListCell.h"
#import "XAIObjectGenerate.h"

@implementation XAIInfListCell

//警告显示的打开  正常显示的关闭 －－

- (void) ir:(XAIIR*)ir curStatus:(XAIIRStatus) status getIsSuccess:(BOOL)isSuccess{
    
    if (self.weakObj == nil || ![self.weakObj isKindOfClass:[XAIIR class]]) return;
    
    if (status == XAIIRStatus_warning) {
        [self setStatus:XAIOCST_Open];
    }else if(status == XAIIRStatus_working){
        
        [self setStatus:XAIOCST_Close];
    }else{
        
        [self setStatus:XAIOCST_Unkown];
    }
    
}

-(void)ir:(XAIIR *)ir curPower:(float)power getIsSuccess:(BOOL)isSuccess{}

- (void) setInfo:(XAIObject*)aObj{
    
    [self _removeWeakObj];
    
    if (aObj == nil) return;
    if (![aObj isKindOfClass:[XAIIR class]]){
        
        [self  firstStatus:XAIOCST_Unkown opr:XAIOCOT_None tip:nil];
        [self.tipImageView setBackgroundColor:[UIColor clearColor]];
        [self.tipImageView setImage:nil];
        [self.nameLable setText:nil];
        [self.contextLable setText:nil];
        [self.tipLabel setText:nil];
        
        return;
    }
    
    
    
    [self.tipImageView setBackgroundColor:[UIColor clearColor]];
    [self.tipImageView setImage:[UIImage imageNamed:[XAIObjectGenerate typeImageName:aObj.type]]];
    
    if (aObj.nickName != NULL && ![aObj.nickName isEqualToString:@""]) {
        
        [self.nameLable setText:aObj.nickName];
    }else{
        
        [self.nameLable setText:aObj.name];
    }
    
    [self.contextLable setText:[aObj.lastOpr allStr]];
    
    
    
    
    XAIOCST status = XAIOCST_Unkown;
    
    if (aObj.curDevStatus == XAIIRStatus_warning) {
        
        status = XAIOCST_Open;
        
    }else if(aObj.curDevStatus == XAIIRStatus_working){
        status = XAIOCST_Close;
    }
    
    
    
    [self firstStatus:status opr:[self coverForm:aObj.curOprStatus] tip:aObj.curOprtip];
    
    
    
    [self _changeWeakObj:aObj];
    
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

@end
