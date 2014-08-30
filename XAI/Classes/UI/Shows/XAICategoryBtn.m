//
//  XAICategoryBtn.m
//  XAI
//
//  Created by office on 14-8-13.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "XAICategoryBtn.h"
#import "MQTT.h"


@implementation XAICategoryBtn

- (id)initWithFrame:(CGRect)frame{

    if (self = [super init]) {
        
        _showBtn = [[UIButton alloc] initWithFrame:frame];
        [_showBtn setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}

- (void) dealloc{

    [_showBtn removeTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
}

- (UIView*) view{

    return _showBtn;
}

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state{

    [_showBtn setBackgroundImage:image forState:state];
}


- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 70, 20)];
    label.text = [XAICategoryTool typeToName:self.type];
    [label setTextColor:[UIColor whiteColor]];
    [_showBtn addSubview:label];
    
    self.label = label;

    _target = target;
    _action = action;
    [_showBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
}

- (void) click{

    if (_target != nil && nil != _action && [_target respondsToSelector:_action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_target performSelector:_action withObject:self];
#pragma clang diagnostic pop
    }
}


-(void)setType:(XAICategoryType)type{

    [_showBtn setImage:[UIImage imageWithFile:[XAICategoryTool norImgStrForType:type]]
              forState:UIControlStateNormal];
    [_showBtn setImage:[UIImage imageWithFile:[XAICategoryTool selImgStrForType:type]]
              forState:UIControlStateHighlighted];
    [_showBtn setImage:[UIImage imageWithFile:[XAICategoryTool selImgStrForType:type]]
              forState:UIControlStateSelected];
    
    _type = type;
}

- (void) setSelect:(BOOL)bsel{

    _showBtn.selected = bsel;
}

@end
