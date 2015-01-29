//
//  XAIApsnView.h
//  XAI
//
//  Created by office on 15/1/27.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XAIApsnViewDelegate;
@protocol XAIApsnViewDataSource;

@interface XAIApsnView : UIView<UIGestureRecognizerDelegate,UIScrollViewDelegate>{

    UIScrollView* _scrollView;
    NSMutableArray* _apsnBtns;

}

@property (nonatomic,assign) id<XAIApsnViewDelegate> delegate;
@property (nonatomic,assign) id<XAIApsnViewDataSource> dataSource;

-(instancetype)initWithFrame:(CGRect)frame;


-(void)addViewAtIndex:(NSUInteger)index;


@end


@protocol XAIApsnViewDelegate <NSObject>

-(void)apsnView:(XAIApsnView*)apsnView curIndex:(NSUInteger)index;
-(void)apsnView:(XAIApsnView *)apsnView delIndex:(NSUInteger)index;
-(void)apsnView:(XAIApsnView *)apsnView selIndex:(NSUInteger)index;

@end


@protocol XAIApsnViewDataSource <NSObject>

-(NSUInteger)apsnViewCount:(XAIApsnView*)apsnView;
-(NSString*)apsnViewIndexStr:(NSUInteger)index;
-(BOOL)apsnViewCanDelIndex:(NSUInteger)index;


@end
