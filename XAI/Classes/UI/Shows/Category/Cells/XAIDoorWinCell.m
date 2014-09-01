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
    
    if (window.isOnline == false) {
        
        [self setStatus:XAIOCST_Unkown];
        [self changeHead:XAIObjectType_light status:XAIOCST_Unkown];
        return;
    }
    
    if (status == XAIWindowStatus_Open) {
        [self setStatus:XAIOCST_Open];
        [self.contextLable setText:[window.lastOpr allStr]];
    }else if(status == XAIWindowStatus_Close){
        [self.contextLable setText:[window.lastOpr allStr]];
        [self setStatus:XAIOCST_Close];
    }else{
    
        [self setStatus:XAIOCST_Unkown];
    }
    
    [self changeHead:XAIObjectType_window status:status];
}

-(void)door:(XAIDoor *)door curStatus:(XAIDoorStatus)status getIsSuccess:(BOOL)isSuccess{

    if (self.weakObj == nil || ![self.weakObj isKindOfClass:[XAIDoor class]]) return;
    
    if (door.isOnline == false) {
        
        [self setStatus:XAIOCST_Unkown];
        [self changeHead:XAIObjectType_light status:XAIOCST_Unkown];
        return;
    }
    
    if (status == XAIDoorStatus_Open) {
        [self setStatus:XAIOCST_Open];
        [self.contextLable setText:[door.lastOpr allStr]];
    }else if(status == XAIDoorStatus_Close){
        
        [self setStatus:XAIOCST_Close];
        [self.contextLable setText:[door.lastOpr allStr]];
    }else{
        
        [self setStatus:XAIOCST_Unkown];
    }
    
    [self changeHead:XAIObjectType_door status:status];
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
    
    if (aObj.nickName != NULL && ![aObj.nickName isEqualToString:@""]) {
        
        [self.nameLable setText:aObj.nickName];
    }else{
        
        [self.nameLable setText:aObj.name];
    }
    
    [self.contextLable setText:[aObj.lastOpr allStr]];
    
    
    
        
    XAIOCST status = XAIOCST_Unkown;
    
    if (aObj.isOnline){
        
        if (aObj.curDevStatus == XAIDoorStatus_Open ||
            aObj.curDevStatus == XAIWindowStatus_Open) {
            
            status = XAIOCST_Open;
            
        }else if(aObj.curDevStatus == XAIDoorStatus_Close ||
                 aObj.curDevStatus == XAIWindowStatus_Close){
            status = XAIOCST_Close;
        }
        
        [self changeHead:aObj.type status:aObj.curDevStatus];
        
    }else{
        
        [self changeHead:aObj.type status:XAIObjStatusUnkown];
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

- (void)changeHead:(XAIObjectType)type status:(int)status{
    
    if (_headView == nil) {
        
        float height = 46;
        float y = (self.frame.size.height-height)*0.5f;
        _headView = [[UIImageView alloc] initWithFrame:CGRectMake(15
                                                                  ,y
                                                                  ,46
                                                                  ,height)];
        
        [self.contentView addSubview:_headView];
    }
    
    UIImage* head = [UIImage imageWithFile:[XAIObjectGenerate typeImageName:type]];
    
    if (status == XAIDoorStatus_Open || status == XAIWindowStatus_Open) {
        head = [UIImage imageWithFile:[XAIObjectGenerate typeImageOpenName:type]];
    }
    
    [_headView setImage:head];
}


@end
    
    
