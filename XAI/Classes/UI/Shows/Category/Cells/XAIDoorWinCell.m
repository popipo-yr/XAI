//
//  XAIDoorWinCell.m
//  XAI
//
//  Created by office on 14-8-15.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAIDoorWinCell.h"
#import "XAIObjectGenerate.h"

@implementation XAIDoorWinCell

- (void) window:(XAIWindow*)window curStatus:(XAIWindowStatus) status getIsSuccess:(BOOL)isSuccess{

    if (self.weakObj == nil || ![self.weakObj isKindOfClass:[XAIWindow class]]) return;
    
    if (status == XAIWindowStatus_Open) {
        [self setStatus:XAIOCST_Open];
    }else if(status == XAIWindowStatus_Close){
        
        [self setStatus:XAIOCST_Close];
    }else{
    
        [self setStatus:XAIOCST_Unkown];
    }
    
}

-(void)door:(XAIDoor *)door curStatus:(XAIDoorStatus)status getIsSuccess:(BOOL)isSuccess{

    if (self.weakObj == nil || ![self.weakObj isKindOfClass:[XAIDoor class]]) return;
    
    if (status == XAIDoorStatus_Open) {
        [self setStatus:XAIOCST_Open];
    }else if(status == XAIDoorStatus_Close){
        
        [self setStatus:XAIOCST_Close];
    }else{
        
        [self setStatus:XAIOCST_Unkown];
    }
    
}

-(void)window:(XAIWindow *)window curPower:(float)power getIsSuccess:(BOOL)isSuccess{}
-(void)door:(XAIDoor *)door curPower:(float)power getIsSuccess:(BOOL)isSuccess{}

- (void) setInfo:(XAIObject*)aObj{
    
    [self _removeWeakObj];
    
    if (aObj == nil) return;
    if (![aObj isKindOfClass:[XAIDoor class]] && ![aObj isKindOfClass:[XAIWindow class]]){
    
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
        
        if (aObj.curDevStatus == XAIDoorStatus_Open ||
            aObj.curDevStatus == XAIWindowStatus_Open) {
            
            status = XAIOCST_Open;
            
        }else if(aObj.curDevStatus == XAIDoorStatus_Close ||
                 aObj.curDevStatus == XAIWindowStatus_Close){
            status = XAIOCST_Close;
        }
    
    if ([aObj.name isEqualToString:@"门磁1"]) {
        NSLog(@"test");
    }
            
        
        [self firstStatus:status opr:[self coverForm:aObj.curOprStatus] tip:aObj.curOprtip];
            
    
    
    [self _changeWeakObj:aObj];

}

- (void) _removeWeakObj{
    
    if (self.weakObj != nil && [self.weakObj isKindOfClass:[XAIDoor class]]) {
        ((XAIDoor*)self.weakObj).delegate = nil;
        self.weakObj = nil;
        
    }else if (self.weakObj != nil && [self.weakObj isKindOfClass:[XAIWindow class]]) {
        ((XAIWindow*)self.weakObj).delegate = nil;
        self.weakObj = nil;
    }
}

- (void) _changeWeakObj:(XAIObject*)aObj{

    [self _removeWeakObj];
    
    
    if ([aObj isKindOfClass:[XAIDoor class]]) {
        
        self.weakObj = aObj;
        ((XAIDoor*)self.weakObj).delegate = self;
        
    }else if([aObj isKindOfClass:[XAIWindow class]]) {
        
        self.weakObj = aObj;
        ((XAIWindow*)self.weakObj).delegate = self;
        
    }
    
}

@end
    
    
