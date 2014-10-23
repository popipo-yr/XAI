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
        
        _showView = [[UIView alloc] initWithFrame:frame];
        
        _showBtn = [[UIButton alloc] init];
        [_showBtn setBackgroundColor:[UIColor clearColor]];
        
        _imgView = [[UIImageView alloc] init];
        //[_imgView setBackgroundColor:[UIColor clearColor]];
        
        _label = [[UILabel alloc] init];
        _labelIV = [[UIImageView alloc] init];
        [_labelIV setBackgroundColor:[UIColor clearColor]];
        [_labelIV setHidden:true];
        [_labelIV addSubview:_label];
        
        [_showView addSubview:_showBtn];
        [_showView addSubview:_imgView];
        [_showView addSubview:_labelIV];
        
    }
    
    return self;
}

- (void) dealloc{

    [_showBtn removeTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
}

- (UIView*) view{

    return _showView;
//    return _showBtn;
}

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state{

    [_showBtn setBackgroundImage:image forState:state];
}


- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    
//    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 70, 20)];
//    label.text = [XAICategoryTool typeToName:self.type];
//    [label setTextColor:[UIColor whiteColor]];
//    [_showBtn addSubview:label];
//    
//    self.label = label;
    

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

    UIImage* norImg = [UIImage imageWithFile:[XAICategoryTool norImgStrForType:type]];
    CGSize btnSize = norImg.size;
    
    [_showBtn setImage:norImg
              forState:UIControlStateNormal];
    [_showBtn setImage:[UIImage imageWithFile:[XAICategoryTool selImgStrForType:type]]
              forState:UIControlStateHighlighted];
    [_showBtn setImage:[UIImage imageWithFile:[XAICategoryTool selImgStrForType:type]]
              forState:UIControlStateSelected];
    
    
    CGRect topFrame = _showView.frame;
    float centerx = topFrame.size.width*0.5f;
    
    float moveB = 0;
    float moveI = 0;
    float moveN = 0;
    if ([UIScreen is_35_Size]) {
        moveB = -10;
        moveI = -30;
        moveN = 10;
    }
    
    _showBtn.frame = CGRectMake(centerx - btnSize.width*0.5f,
                                5 + moveB,
                                btnSize.width,
                                btnSize.height);
    
    
    UIImage* image = [UIImage imageWithFile:[XAICategoryTool typeToName:type]];
    CGSize fontSize = image.size;
    [_imgView setImage:image];
    _imgView.frame = CGRectMake(centerx - fontSize.width*0.5f,
                                btnSize.height + 25 + moveI,
                                fontSize.width,
                                fontSize.height);
    

    UIImage* msgNumImg = [UIImage imageWithFile:@"msgNum1.png"];
    CGSize numSize = msgNumImg.size;
    [_labelIV setImage:msgNumImg];
    _labelIV.frame = CGRectMake(_showBtn.frame.origin.x + btnSize.width - 5,
                              _showBtn.frame.origin.y - 10 + moveN,
                              numSize.width,
                              numSize.height);
    
    _label.frame = CGRectMake(0, -2, numSize.width, numSize.height);
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = [UIColor whiteColor];
    
    
    _type = type;
}

- (void) setSelect:(BOOL)bsel{

    _showBtn.selected = bsel;
}

- (void) setNumber:(int)number{

    if (number > 99) {
        number = 99;
    }
    
    [_label setText:[NSString stringWithFormat:@"%d",number]];
    [_labelIV setHidden: number <=0 ? true : false];
    
}

@end
