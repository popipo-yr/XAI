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
        [self showOpen];
    }else{
        
        [self showClose];
    }
    
}

-(void)door:(XAIDoor *)door curStatus:(XAIDoorStatus)status getIsSuccess:(BOOL)isSuccess{

    if (self.weakObj == nil || ![self.weakObj isKindOfClass:[XAIDoor class]]) return;
    
    if (status == XAIDoorStatus_Open) {
        [self showOpen];
    }else{
        
        [self showClose];
    }
}

- (void) setInfo:(XAIObject*)aObj{
    
    [self _removeWeakObj];
    
    if (aObj == nil) return;
    if (![aObj isKindOfClass:[XAIDoor class]] && ![aObj isKindOfClass:[XAIWindow class]]){
    
        [self  showUnkonw];
        [self.headImageView setBackgroundColor:[UIColor clearColor]];
        [self.headImageView setImage:nil];
        [self.nameLable setText:nil];
        [self.contextLable setText:nil];
    
        return;
    }
    
    
    
    [self.headImageView setBackgroundColor:[UIColor clearColor]];
    [self.headImageView setImage:[UIImage imageNamed:[XAIObjectGenerate typeImageName:aObj.type]]];
    
    if (aObj.nickName != NULL && ![aObj.nickName isEqualToString:@""]) {
        
        [self.nameLable setText:aObj.nickName];
    }else{
        
        [self.nameLable setText:aObj.name];
    }
    
    [self.contextLable setText:[aObj.lastOpr allStr]];
    
    
    if ([aObj isKindOfClass:[XAIDoor class]]) {
        if (aObj.curStatus == XAIDoorStatus_Open) {
            [self showOpen];
        }else if(aObj.curStatus == XAIDoorStatus_Close){
            [self showClose];
        }else if(aObj.curStatus == XAIObjStatusOperStart){
            
            if (aObj.preStatus == XAIDoorStatus_Open) {
                [self setPreType:XAIObjectCellShowType_Open];
            }else if(aObj.preStatus == XAIDoorStatus_Close) {
                [self setPreType:XAIObjectCellShowType_Close];
            }else{
                [self setPreType:XAIObjectCellShowType_Unkown];
            }
            [self showStart];
            
        }else if(aObj.curStatus == XAIObjStatusErr){
            
            if (aObj.preStatus == XAIDoorStatus_Open) {
                [self setPreType:XAIObjectCellShowType_Open];
            }else if(aObj.preStatus == XAIDoorStatus_Close) {
                [self setPreType:XAIObjectCellShowType_Close];
            }else{
                [self setPreType:XAIObjectCellShowType_Unkown];
            }
            
            [self showError];
        }else{
            
            [self showUnkonw];
        }
        
    }else{
        
        if (aObj.curStatus == XAIWindowStatus_Open) {
            [self showOpen];
        }else if(aObj.curStatus == XAIWindowStatus_Close){
            [self showClose];
        }else if(aObj.curStatus == XAIObjStatusOperStart){
            
            if (aObj.preStatus == XAIDoorStatus_Open) {
                [self setPreType:XAIObjectCellShowType_Open];
            }else if(aObj.preStatus == XAIDoorStatus_Close) {
                [self setPreType:XAIObjectCellShowType_Close];
            }else{
                [self setPreType:XAIObjectCellShowType_Unkown];
            }
            [self showStart];
        }else if(aObj.curStatus == XAIObjStatusErr){
            
            if (aObj.preStatus == XAIDoorStatus_Open) {
                [self setPreType:XAIObjectCellShowType_Open];
            }else if(aObj.preStatus == XAIDoorStatus_Close) {
                [self setPreType:XAIObjectCellShowType_Close];
            }else{
                [self setPreType:XAIObjectCellShowType_Unkown];
            }
            [self showError];
        } else{
            [self showUnkonw];
        }
        
    }
    
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
    
    
