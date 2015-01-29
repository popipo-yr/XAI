//
//  XAIApsnView.m
//  XAI
//
//  Created by office on 15/1/27.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import "XAIApsnView.h"

@implementation XAIApsnView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        frame.origin = CGPointZero;
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.pagingEnabled = true;
        _scrollView.delegate = self;
        
        _apsnBtns = [[NSMutableArray alloc] init];
        
        [self addSubview:_scrollView];
        
        _scrollView.clipsToBounds = false;
        _scrollView.showsHorizontalScrollIndicator = false;
        
        
        
    }
    
    return self;
}

-(void)setDataSource:(id<XAIApsnViewDataSource>)dataSource{
    
    
    _dataSource = dataSource;
    [self  drawApsnBtns];
    
}

-(void)drawApsnBtns{
    
    if (_dataSource == nil ||
        ![_dataSource respondsToSelector:@selector(apsnViewCount:)]) return;
    
    NSUInteger count = [_dataSource apsnViewCount:self];
    
    
    for (int i = 0; i < count; i++) {
        
        UIView* apsnBtn =  [self geneBtnAtIndex:i];
        [_apsnBtns addObject:apsnBtn];
        [_scrollView addSubview:apsnBtn];

    }
    
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width*count,
                                         _scrollView.frame.size.height);
    
    if (_delegate != nil &&
        [_delegate respondsToSelector:@selector(apsnView:curIndex:)]) {
        
        [_delegate apsnView:self curIndex:0];
    }
    
    _scrollView.contentOffset = CGPointMake(0, _scrollView.frame.origin.y);


}


-(void)panGestureFinish:(UIPanGestureRecognizer*) recognizer{

    UIButton* btn = (UIButton*)recognizer.view;
    if (![btn isKindOfClass:[UIButton class]]) return;
    NSUInteger index = [_apsnBtns indexOfObject:btn];
    if (NSNotFound == index) return;
    
    if (btn.frame.origin.y < 0) { //是移除
        
        [_apsnBtns removeObjectAtIndex:index];
        recognizer.delegate = nil;
        
        for (int i = index; i < _apsnBtns.count; i++) {//调整后面的位置
            UIButton* aBtn = [_apsnBtns objectAtIndex:i];
            CGRect oldFrame = aBtn.frame;
            oldFrame.origin.x -= self.bounds.size.width;
            aBtn.frame = oldFrame;
        }
        
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width*_apsnBtns.count, self.bounds.size.height);
        
    
        if (_delegate != nil &&
            [_delegate respondsToSelector:@selector(apsnView:delIndex:)]) {
            [_delegate apsnView:self delIndex:index];
        }
        
        if (_delegate != nil &&
            [_delegate respondsToSelector:@selector(apsnView:curIndex:)]) {
            
            NSUInteger newIndex = index;//如果后面有补位
            if (newIndex >= _apsnBtns.count ) newIndex = index - 1;
            
            [_delegate apsnView:self curIndex:newIndex];
        }
        
        [btn removeFromSuperview];
    }
    

}


float _Z_oldY = 0;
- (void) handlePanGesture:(UIPanGestureRecognizer*) recognizer
{
    
    CGPoint translation = [recognizer translationInView:self];
    
    
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            _Z_oldY = recognizer.view.center.y;
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            
            recognizer.view.center = CGPointMake(recognizer.view.center.x ,
                                                 recognizer.view.center.y + translation.y);
            if (recognizer.view.center.y > _Z_oldY) {
                CGPoint  oldCenter = recognizer.view.center;
                oldCenter.y = _Z_oldY;
                recognizer.view.center = oldCenter;
            }
            
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            BOOL bRemove = false;
            
            CGPoint velocity = [recognizer velocityInView:self];
            CGPoint finalPoint = CGPointMake(recognizer.view.center.x, _Z_oldY);//设置为原点
            
            /*移除2个条件
             1.向上加速度超过制定值,直接移除
             2.向上正常加速,现在位置高于指定值
             */
            if (velocity.y < - 200 //向上加速度超过制定值,直接移除
                || (velocity.y < 0 && recognizer.view.center.y < _Z_oldY - 100)){
                
                finalPoint = CGPointMake(recognizer.view.center.x, -200);
                bRemove = true;
            }
            
            CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
            CGFloat slideMult = magnitude / 200;
            //NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult);
            
            float slideFactor = 0.1 * slideMult; // Increase for more of a slide
            
            if (bRemove) {
                slideFactor = 0.2;
            }
            
            [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                recognizer.view.center = finalPoint;
            } completion:^(BOOL bl){
                if (bl) {
                    [self panGestureFinish:recognizer];
                }
            }];
            
            
            break;
        }
            
        default:
            break;
    }
    
    
    [recognizer setTranslation:CGPointZero inView:self];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    UIPanGestureRecognizer* pan = (UIPanGestureRecognizer*)gestureRecognizer;
    if (![pan isKindOfClass:[UIPanGestureRecognizer class]]) return false;
    
    CGPoint translation = [pan translationInView:self];
    
    BOOL canDel = true;
    if (_dataSource != nil &&
        [_dataSource respondsToSelector:@selector(apsnViewCanDelIndex:)]) {
        
        do {
            
            UIButton* btn = (UIButton*)gestureRecognizer.view;
            if (![btn isKindOfClass:[UIButton class]]) break;
            NSUInteger index = [_apsnBtns indexOfObject:btn];
            if (NSNotFound == index) break;
            
            canDel = [_dataSource apsnViewCanDelIndex:index];
            
        } while (0);
        

    }
    
    if (translation.y > 0 || translation.x != 0 || !canDel) { //向下左右滑动不允许
        pan.enabled = false;
        pan.enabled = true;
        return true;
    }
    
    
    return false;
}



-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    CGPoint offset = scrollView.contentOffset;
    NSUInteger page = offset.x / scrollView.frame.size.width;
    
    if (_delegate != nil &&
        [_delegate respondsToSelector:@selector(apsnView:curIndex:)]) {
        [_delegate apsnView:self curIndex:page];
    }
}


-(void)btnClick:(id)sender{

    
    UIButton* btn = (UIButton*)sender;
    if (![btn isKindOfClass:[UIButton class]]) return;
    NSUInteger index = [_apsnBtns indexOfObject:btn];
    if (NSNotFound == index) return;
    
    if (_delegate != nil &&
        [_delegate respondsToSelector:@selector(apsnView:selIndex:)]) {
        [_delegate apsnView:self selIndex:index];
    }
    

}

-(void)addViewAtIndex:(NSUInteger)index{

    
    if (index >= _apsnBtns.count) {
        index = _apsnBtns.count;
    }
    
    
    

    UIView* apsnBtn = [self geneBtnAtIndex:index];
    
    [_apsnBtns insertObject:apsnBtn atIndex:index];
    [_scrollView addSubview:apsnBtn];
    
    
    for (int i = index + 1; i < _apsnBtns.count; i++) {//调整后面的位置
        UIButton* aBtn = [_apsnBtns objectAtIndex:i];
        CGRect oldFrame = aBtn.frame;
        oldFrame.origin.x += self.bounds.size.width;
        aBtn.frame = oldFrame;
    }
    
    _scrollView.contentSize = CGSizeMake(self.bounds.size.width*_apsnBtns.count, self.bounds.size.height);
    
    
    _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width*index,
                                            _scrollView.frame.origin.y);
    
    if (_delegate != nil &&
        [_delegate respondsToSelector:@selector(apsnView:curIndex:)]) {
        
        [_delegate apsnView:self curIndex:index];
    }
    
    
}

-(UIView*)geneBtnAtIndex:(NSUInteger)index{

    UIImage* norImg = [UIImage imageWithFile:@"xai_icon_nor.png"];
    UIImage* selImg = [UIImage imageWithFile:@"xai_icon_sel.png"];
    CGSize imgSize = norImg.size;
    imgSize = CGSizeMake(147, 147);
    CGSize viewSize = self.bounds.size;
    
    
    CGRect frame = CGRectZero;
    frame.size = imgSize;
    frame.origin = CGPointMake(viewSize.width*(index + 0.5f) - imgSize.width* 0.5f,
                               (viewSize.height - imgSize.height)*0.5f);
    
    
    UIButton* apsnBtn = [[UIButton alloc] initWithFrame:frame];
    [apsnBtn setImage:norImg forState:UIControlStateNormal];
    [apsnBtn setImage:selImg forState:UIControlStateHighlighted];
    
    
    UIPanGestureRecognizer * panTap = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
    panTap.delegate = self;
    [apsnBtn addGestureRecognizer:panTap];
    
    
    [apsnBtn addTarget:self action:@selector(btnClick:)
      forControlEvents:UIControlEventTouchUpInside];
    
    
    if ([_dataSource respondsToSelector:@selector(apsnViewIndexStr:)]) {
        
        CGRect frame =  CGRectMake(0, 0, 100, 20);
        
        UILabel* label = [[UILabel alloc] initWithFrame:frame];
        label.text = [_dataSource apsnViewIndexStr:index];
        
        label.center = CGPointMake(imgSize.width*0.5f, imgSize.height + 8);
        label.textColor = [UIColor colorWithHue:0 saturation:0 brightness:0.6 alpha:1];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13];
        
        [apsnBtn addSubview:label];
    }

    return apsnBtn;

}

@end
