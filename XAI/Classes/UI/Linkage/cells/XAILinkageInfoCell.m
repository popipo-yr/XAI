//
//  XAILinkageInfoCell.m
//  XAI
//
//  Created by office on 14-8-19.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAILinkageInfoCell.h"

@implementation XAILinkageInfoCell


- (void) setJieGuo:(NSString*)str{
    self.label.text = str;
    self.label.textColor = [UIColor whiteColor];
    self.label.textAlignment = NSTextAlignmentLeft;
    self.tipView.image = [UIImage imageWithFile:@"linkage_jieguo.png"];
}
- (void) setTiaojian:(NSString*)str{
    self.label.text = str;
    self.label.textColor = [UIColor blackColor];
    self.label.textAlignment = NSTextAlignmentLeft;
    self.tipView.image = [UIImage imageWithFile:@"linkage_tiaojan.png"];
}


- (void) setJieGuoTip:(NSString*)str{
    self.label.text = str;
    self.label.textColor = [UIColor greenColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.tipView.image = [UIImage imageWithFile:@"linkage_jieguo.png"];
}
- (void) setTiaojianTip:(NSString*)str{
    self.label.text = str;
    self.label.textColor = [UIColor greenColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.tipView.image = [UIImage imageWithFile:@"linkage_tiaojan.png"];
}


@end
