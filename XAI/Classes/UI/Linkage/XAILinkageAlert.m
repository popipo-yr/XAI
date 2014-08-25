//
//  XAILinkageAlert.m
//  XAI
//
//  Created by office on 14-8-18.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILinkageAlert.h"

@implementation XAILinkageAlert

- (void) setLight:(NSString*)name{
    self.label.text = [NSString stringWithFormat:@"请选择%@状态",name];
    [self.leftBtn setImage:[UIImage imageWithFile:@"linkage_open_nor.png"]
                   forState:UIControlStateNormal];
    [self.leftBtn setImage:[UIImage imageWithFile:@"linkage_open_sel.png"]
                   forState:UIControlStateHighlighted];
    [self.rightBtn setImage:[UIImage imageWithFile:@"linkage_close_nor.png"]
                  forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageWithFile:@"linkage_close_sel.png"]
                  forState:UIControlStateHighlighted];
}
- (void) setDW:(NSString*)name{
    
    self.label.text = [NSString stringWithFormat:@"请选择%@状态",name];
    [self.leftBtn setImage:[UIImage imageWithFile:@"linkage_open_nor.png"]
                  forState:UIControlStateNormal];
    [self.leftBtn setImage:[UIImage imageWithFile:@"linkage_open_sel.png"]
                  forState:UIControlStateHighlighted];
    [self.rightBtn setImage:[UIImage imageWithFile:@"linkage_close_nor.png"]
                   forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageWithFile:@"linkage_close_sel.png"]
                   forState:UIControlStateHighlighted];
}
- (void) setIR:(NSString*)name{
    
    self.label.text = [NSString stringWithFormat:@"请选择%@状态",name];
    [self.leftBtn setImage:[UIImage imageWithFile:@"linkage_ir_worn_nor.png"]
                  forState:UIControlStateNormal];
    [self.leftBtn setImage:[UIImage imageWithFile:@"linkage_ir_worn_sel.png"]
                  forState:UIControlStateHighlighted];
    [self.rightBtn setImage:[UIImage imageWithFile:@"linkage_ir_work_nor.png"]
                   forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageWithFile:@"linkage_ir_work_sel.png"]
                   forState:UIControlStateHighlighted];

}

- (void) setLightOpr:(NSString*)name{

    self.label.text = [NSString stringWithFormat:@"请选择%@操作",name];
    [self.leftBtn setImage:[UIImage imageWithFile:@"linkage_open_nor.png"]
                  forState:UIControlStateNormal];
    [self.leftBtn setImage:[UIImage imageWithFile:@"linkage_open_sel.png"]
                  forState:UIControlStateHighlighted];
    [self.rightBtn setImage:[UIImage imageWithFile:@"linkage_close_nor.png"]
                   forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageWithFile:@"linkage_close_sel.png"]
                   forState:UIControlStateHighlighted];
}

@end
