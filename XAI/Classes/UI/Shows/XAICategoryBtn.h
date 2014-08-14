//
//  XAICategoryBtn.h
//  XAI
//
//  Created by office on 14-8-13.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XAICategoryTool.h"

@interface XAICategoryBtn : NSObject{

    UIButton* _showBtn;
    
    id _target;
    SEL _action;

}

@property(nonatomic,assign) XAICategoryType type;

- (id)initWithFrame:(CGRect)frame;
- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state;
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

- (UIView*) view;

@end
