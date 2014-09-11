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

    UIView*  _showView;
    UIButton* _showBtn;
    
    __weak id _target;
    SEL _action;
    
    UILabel* _label;
    UIImageView* _labelIV;

}

@property(nonatomic,assign) XAICategoryType type;
@property (nonatomic,readonly) UIButton* showBtn;
@property (nonatomic,strong) UIImageView* imgView;

- (id)initWithFrame:(CGRect)frame;
- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state;
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void) setSelect:(BOOL)bsel;
- (void) setNumber:(int)number;

- (UIView*) view;

@end
